
from django.conf import settings
from django.core.mail import send_mail
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import (
    urlsafe_base64_encode,
    urlsafe_base64_decode,
)
from django.utils.encoding import force_bytes, force_str
from urllib.parse import urlencode

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from django.db import transaction
from django.db.models import Q
from django.db.models.deletion import ProtectedError
from django.db.models import Count
from django.utils import timezone

from .models import (
    Country,
    Zone,
    Region,
    District,
    Ward,
    School,
    SchoolOwnershipType,
    User,
    Talent,
    TalentCategory,
    StudentTalent,
    Announcement,
    CountryClub,
    SchoolClub,
    ClubTeacher,
    StudentClubMembership,
    EvaluationCriterion,
    TalentEvaluation,
    EvaluationScore,
    TalentSubmission,
    SubmissionFeedback,
    Message,
    Notification,
    AuditLog,
)

from .serializers import (
    CountrySerializer,
    ZoneSerializer,
    RegionSerializer,
    DistrictSerializer,
    WardSerializer,
    SchoolSerializer,
    SchoolOwnershipTypeSerializer,
    UserSerializer,
    TalentSerializer,
    TalentCategorySerializer,
    StudentTalentSerializer,
    AnnouncementSerializer,
    CountryClubSerializer,
    SchoolClubSerializer,
    ClubTeacherSerializer,
    StudentClubMembershipSerializer,
    EvaluationCriterionSerializer,
    TalentEvaluationSerializer,
    EvaluationScoreSerializer,
    TalentSubmissionSerializer,
    SubmissionFeedbackSerializer,
    MessageSerializer,
    NotificationSerializer,
    AuditLogSerializer,
)

from .permissions import (
    AuthenticatedReadOnly,
    ConfigurationPermission,
    StudentDataPermission,
    SubmissionPermission,
    ScopedQuerysetMixin,
    PublicSchoolRegistrationPermission,
)


class CountryViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer
    permission_classes = [PublicSchoolRegistrationPermission]
    scope_paths = {'country': 'id'}


class ZoneViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = Zone.objects.select_related('country').all()
    serializer_class = ZoneSerializer
    permission_classes = [ConfigurationPermission]
    scope_paths = {
        'country': 'country_id',
        'zone': 'id',
    }


class RegionViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = Region.objects.select_related('zone').all()
    serializer_class = RegionSerializer
    permission_classes = [ConfigurationPermission]
    scope_paths = {
        'country': 'zone__country_id',
        'zone': 'zone_id',
        'region': 'id',
    }


class DistrictViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = District.objects.select_related('region').all()
    serializer_class = DistrictSerializer
    permission_classes = [ConfigurationPermission]
    scope_paths = {
        'country': 'region__zone__country_id',
        'zone': 'region__zone_id',
        'region': 'region_id',
        'district': 'id',
    }


class WardViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = Ward.objects.select_related('district').all()
    serializer_class = WardSerializer
    permission_classes = [ConfigurationPermission]
    scope_paths = {
        'country': 'district__region__zone__country_id',
        'zone': 'district__region__zone_id',
        'region': 'district__region_id',
        'district': 'district_id',
        'ward': 'id',
    }


class SchoolOwnershipTypeViewSet(viewsets.ModelViewSet):
    queryset = SchoolOwnershipType.objects.filter(
        is_active=True
    ).order_by('name')
    serializer_class = SchoolOwnershipTypeSerializer
    permission_classes = [PublicSchoolRegistrationPermission]


class SchoolViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    public_registration = True

    queryset = School.objects.filter(
        is_approved=True,
        is_active=True,
    ).select_related(
        'country',
        'zone',
        'region',
        'district',
        'ward',
    )

    serializer_class = SchoolSerializer
    permission_classes = [ConfigurationPermission]

    scope_paths = {
        'country': 'country_id',
        'zone': 'zone_id',
        'region': 'region_id',
        'district': 'district_id',
        'ward': 'ward_id',
        'school': 'id',
    }

    def get_permissions(self):
        if self.action == 'create':
            return [PublicSchoolRegistrationPermission()]

        # District Managers may manage schools only through their
        # district-scoped queryset. Other writes retain admin permissions.
        if (
            self.request.user.is_authenticated
            and self.request.user.role == 'district_manager'
            and self.action in {
                'update', 'partial_update', 'suspend', 'activate'
            }
        ):
            return [IsAuthenticated()]

        return [ConfigurationPermission()]

    def get_queryset(self):
        qs = super().get_queryset()

        # Super Admin / Talent Admin can see ALL schools,
        # including pending schools.
        if (
            self.request.user
            and self.request.user.is_authenticated
            and (
                self.request.user.is_staff
                or self.request.user.is_superuser
                or self.request.user.role in {'talent_admin'}
            )
        ):
            return School.objects.select_related(
                'country',
                'zone',
                'region',
                'district',
                'ward',
            ).all()

        # District Managers can see approved and pending schools
        # in their assigned district only.
        if (
            self.request.user
            and self.request.user.is_authenticated
            and self.request.user.role == 'district_manager'
        ):
            if not self.request.user.district_id:
                return School.objects.none()

            return School.objects.select_related(
                'country',
                'zone',
                'region',
                'district',
                'ward',
            ).filter(district_id=self.request.user.district_id)

        # Other users see approved schools only.
        return qs

    def perform_create(self, serializer):
        # Every newly registered school starts as PENDING.
        # Super Admin approval is required before club access.
        serializer.save(
            is_approved=False
        )

    def perform_update(self, serializer):
        # The queryset already limits District Managers to their own district.
        # The serializer also makes geographic parent fields read-only.
        serializer.save()

    @action(detail=True, methods=['post'], url_path='suspend')
    def suspend(self, request, pk=None):
        school = self.get_object()
        if not school.is_active:
            return Response({
                'detail': 'School is already suspended.',
                'school': SchoolSerializer(school).data,
            })
        school.is_active = False
        school.save(update_fields=['is_active'])
        return Response({
            'detail': 'School suspended successfully.',
            'school': SchoolSerializer(school).data,
        })

    @action(detail=True, methods=['post'], url_path='activate')
    def activate(self, request, pk=None):
        school = self.get_object()
        if school.is_active:
            return Response({
                'detail': 'School is already active.',
                'school': SchoolSerializer(school).data,
            })
        school.is_active = True
        school.save(update_fields=['is_active'])
        return Response({
            'detail': 'School activated successfully.',
            'school': SchoolSerializer(school).data,
        })

    def destroy(self, request, *args, **kwargs):
        if not (request.user.is_superuser or request.user.role == 'admin'):
            return Response(
                {'detail': 'Only Admin can delete schools.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        school = self.get_object()
        dependencies = []

        if school.students.exists():
            dependencies.append('students')
        if school.users.exists():
            dependencies.append('user accounts')
        if school.competitions.exists():
            dependencies.append('competitions')

        if dependencies:
            return Response({
                'detail': (
                    'This school has related data and cannot be safely deleted. '
                    'Suspend it instead, or remove its dependent records first.'
                ),
                'dependencies': dependencies,
            }, status=status.HTTP_409_CONFLICT)

        return super().destroy(request, *args, **kwargs)

    @action(
        detail=True,
        methods=['post'],
        url_path='approve',
        permission_classes=[IsAuthenticated],
    )
    def approve(self, request, pk=None):
        # Only Super Admin / Talent Admin can approve schools.
        if not (
            request.user.is_superuser
            or request.user.role == 'talent_admin'
        ):
            return Response(
                {
                    'detail': (
                        'Only a Super Admin can approve schools.'
                    )
                },
                status=status.HTTP_403_FORBIDDEN
            )

        school = self.get_object()

        if school.is_approved:
            return Response(
                {
                    'detail': 'This school is already approved.',
                    'school': SchoolSerializer(school).data,
                },
                status=status.HTTP_200_OK
            )

        school.is_approved = True

        school.save(
            update_fields=['is_approved']
        )

        return Response(
            {
                'detail': 'School approved successfully.',
                'school': SchoolSerializer(school).data,
            },
            status=status.HTTP_200_OK
        )


class RegistrationLocationsView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            'countries': CountrySerializer(
                Country.objects.all(),
                many=True
            ).data,

            'zones': ZoneSerializer(
                Zone.objects.all(),
                many=True
            ).data,

            'regions': RegionSerializer(
                Region.objects.all(),
                many=True
            ).data,

            'districts': DistrictSerializer(
                District.objects.all(),
                many=True
            ).data,

            'wards': WardSerializer(
                Ward.objects.all(),
                many=True
            ).data,
        })


class UserViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = User.objects.select_related(
        'school',
        'student',
        'district'
    ).all()

    serializer_class = UserSerializer
    permission_classes = [ConfigurationPermission]

    scope_paths = {
        'school': 'school_id',
        'country': 'country_id',
        'zone': 'zone_id',
        'region': 'region_id',
        'district': 'district_id',
        'ward': 'ward_id',
    }

    def get_queryset(self):
        queryset = super().get_queryset()
        user = self.request.user

        # Admins must not see Super Admins or Admin accounts
        # created by somebody else. The filtered queryset also
        # protects direct API access by account ID.
        if (
            user
            and user.is_authenticated
            and user.role == 'admin'
            and not user.is_superuser
        ):
            queryset = queryset.filter(is_superuser=False).filter(
                Q(role__in=[
                    'talent_admin', 'region_manager', 'zone_manager',
                    'district_manager', 'ward_manager', 'head_teacher',
                    'sport_teacher', 'student', 'parent',
                ])
                | Q(created_by_id=user.pk)
                | Q(pk=user.pk)
            )

        if self.action == 'list':
            queryset = queryset.filter(is_active=True).order_by('id')

        return queryset

    def get_permissions(self):
        if self.action in {'update', 'partial_update'}:
            return [IsAuthenticated()]

        return super().get_permissions()

    def get_object(self):
        target = super().get_object()
        requester = self.request.user

        if self.action in {'update', 'partial_update'}:
            allowed = (
                requester.is_superuser
                or requester.role == 'talent_admin'
                or target.pk == requester.pk
            )

            # Admin has broad access, but may only edit Admin accounts
            # that they personally created.
            if requester.role == 'admin' and not requester.is_superuser:
                allowed = (
                    target.role != 'admin'
                    or target.created_by_id == requester.pk
                    or target.pk == requester.pk
                )

            if not allowed:
                from rest_framework.exceptions import PermissionDenied
                raise PermissionDenied(
                    'You are not allowed to update this account.'
                )

        return target

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        if instance.pk == request.user.pk:
            return Response(
                {'detail': 'You cannot delete your own account.'},
                status=400
            )

        requester = request.user
        if instance.role == 'admin' and not requester.is_superuser:
            if not (
                requester.role == 'admin'
                and instance.created_by_id == requester.pk
            ):
                return Response(
                    {'detail': 'Only Super Admin can manage this Admin account.'},
                    status=status.HTTP_403_FORBIDDEN
                )

        if instance.is_superuser and not requester.is_superuser:
            return Response(
                {'detail': 'Only Super Admin can manage Super Admin accounts.'},
                status=status.HTTP_403_FORBIDDEN
            )

        try:
            instance.delete()

        except ProtectedError as error:
            protected_objects = [
                str(obj)
                for obj in error.protected_objects
            ]

            return Response(
                {
                    'detail': (
                        f"Cannot delete user "
                        f"'{instance.username} "
                        f"({instance.get_role_display()})' "
                        'because protected records still reference '
                        'this account.'
                    ),
                    'protected_objects': protected_objects,
                },
                status=status.HTTP_409_CONFLICT
            )

        return Response(
            status=status.HTTP_204_NO_CONTENT
        )

    @action(
        detail=False,
        methods=['get'],
        permission_classes=[IsAuthenticated]
    )
    def current(self, request):
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)

    @action(
        detail=False,
        methods=['get'],
        permission_classes=[IsAuthenticated]
    )
    def stats(self, request):
        """Return counts of schools and users by role."""

        return Response({
            'schools': School.objects.count(),
            'region_managers': User.objects.filter(
                role='region_manager'
            ).count(),
            'zone_managers': User.objects.filter(
                role='zone_manager'
            ).count(),
            'sport_teachers': User.objects.filter(
                role='sport_teacher'
            ).count(),
            'district_managers': User.objects.filter(
                role='district_manager'
            ).count(),
            'ward_managers': User.objects.filter(
                role='ward_manager'
            ).count(),
            'head_teachers': User.objects.filter(
                role='head_teacher'
            ).count(),
            'admins': User.objects.filter(
                is_staff=True,
                is_superuser=True
            ).count(),
        })


class TalentCategoryViewSet(viewsets.ModelViewSet):
    queryset = TalentCategory.objects.all()
    serializer_class = TalentCategorySerializer
    filterset_fields = ['is_active']
    search_fields = ['name', 'description']
    permission_classes = [ConfigurationPermission]


class TalentViewSet(viewsets.ModelViewSet):
    queryset = Talent.objects.select_related(
        'category'
    ).annotate(
        student_count=Count('students')
    ).order_by('id')

    serializer_class = TalentSerializer
    filterset_fields = ['category']
    search_fields = ['name', 'description']
    permission_classes = [ConfigurationPermission]


class StudentTalentViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = StudentTalent.objects.select_related(
        'student',
        'talent'
    ).all()

    serializer_class = StudentTalentSerializer
    filterset_fields = [
        'talent__category',
        'proficiency_level',
        'student'
    ]
    search_fields = [
        'student__first_name',
        'student__last_name',
        'talent__name'
    ]

    permission_classes = [StudentDataPermission]

    scope_paths = {
        'student': 'student_id',
        'school': 'student__school_id',
        'country': 'student__school__country_id',
        'zone': 'student__school__zone_id',
        'region': 'student__school__region_id',
        'district': 'student__school__district_id',
        'ward': 'student__school__ward_id',
    }


class AnnouncementViewSet(viewsets.ModelViewSet):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer

    filterset_fields = [
        'scope',
        'is_active'
    ]

    search_fields = [
        'title',
        'content'
    ]

    ordering_fields = [
        'created_at',
        'published_at'
    ]

    ordering = ['-created_at']

    permission_classes = [AuthenticatedReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()
        now = timezone.now()
        queryset = queryset.filter(
            is_active=True
        ).filter(
            Q(published_at__isnull=True) | Q(published_at__lte=now)
        ).filter(
            Q(expires_at__isnull=True) | Q(expires_at__gte=now)
        )
        user = self.request.user

        if user.role == 'sport_teacher':
            if not user.school_id:
                return queryset.none()

            school = School.objects.filter(
                pk=user.school_id
            ).values('district_id').first()
            district_id = school['district_id'] if school else None

            school_announcements = queryset.filter(
                school_id=user.school_id,
                scope='school'
            )

            if not district_id:
                return school_announcements

            district_announcements = queryset.filter(
                scope='district',
                district_id=district_id,
                audience__in=['sport_teachers', 'both']
            )

            return (school_announcements | district_announcements).distinct()

        if user.role == 'head_teacher':
            return (
                queryset.filter(school_id=user.school_id, scope='school')
                if user.school_id
                else queryset.none()
            )

        if user.role == 'student':
            if not user.school_id:
                return queryset.none()

            school = School.objects.filter(
                pk=user.school_id
            ).values('district_id').first()
            district_id = school['district_id'] if school else None

            if not district_id:
                return queryset.none()

            return queryset.filter(
                ~Q(scope='district')
                | Q(
                    scope='district',
                    district_id=district_id,
                    audience__in=['students', 'both']
                )
            )

        return queryset

    def perform_create(self, serializer):
        user = self.request.user

        if user.role == 'sport_teacher':
            if not user.school_id:
                from rest_framework.exceptions import ValidationError

                raise ValidationError({
                    'school': (
                        'Your account is not assigned to a school.'
                    )
                })

            serializer.save(
                scope='school',
                school_id=user.school_id,
                is_active=True
            )
            return

        if user.role == 'district_manager':
            if not user.district_id:
                from rest_framework.exceptions import ValidationError

                raise ValidationError({
                    'district': (
                        'Your account is not assigned to a district.'
                    )
                })

            serializer.save(
                scope='district',
                district_id=user.district_id,
                school=None,
                is_active=True
            )
            return

        serializer.save()

    def perform_update(self, serializer):
        user = self.request.user

        if user.role == 'sport_teacher':
            serializer.save(
                scope='school',
                school_id=user.school_id,
                is_active=True
            )
            return

        if user.role == 'district_manager':
            announcement = self.get_object()

            if (
                announcement.scope != 'district'
                or announcement.district_id != user.district_id
            ):
                from rest_framework.exceptions import PermissionDenied

                raise PermissionDenied(
                    'You can edit only your district announcements.'
                )

            serializer.save(
                scope='district',
                district_id=user.district_id,
                school=None
            )
            return

        serializer.save()

    def perform_destroy(self, instance):
        user = self.request.user

        if (
            user.role == 'district_manager'
            and (
                instance.scope != 'district'
                or instance.district_id != user.district_id
            )
        ):
            from rest_framework.exceptions import PermissionDenied

            raise PermissionDenied(
                'You can delete only your district announcements.'
            )

        super().perform_destroy(instance)


class CountryClubViewSet(viewsets.ModelViewSet):
    queryset = CountryClub.objects.select_related(
        'country'
    ).all()

    serializer_class = CountryClubSerializer
    permission_classes = [ConfigurationPermission]

    def get_queryset(self):
        queryset = super().get_queryset()

        country_id = self.request.query_params.get('country')

        if country_id:
            queryset = queryset.filter(
                country_id=country_id
            )

        return queryset


class SchoolClubViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = SchoolClub.objects.select_related(
        'school',
        'country_club'
    ).all()

    serializer_class = SchoolClubSerializer
    permission_classes = [AuthenticatedReadOnly]

    scope_paths = {
        'student': 'memberships__student_id',
        'school': 'school_id',
        'country': 'school__country_id',
        'zone': 'school__zone_id',
        'region': 'school__region_id',
        'district': 'school__district_id',
        'ward': 'school__ward_id',
    }

    def get_queryset(self):
        queryset = super().get_queryset()

        user = self.request.user

        # A school that is not approved must not have club access.
        if (
            user.is_authenticated
            and user.role in {
                'head_teacher',
                'sport_teacher'
            }
        ):
            if not user.school_id:
                return queryset.none()

            if not user.school.is_approved:
                return queryset.none()

        return queryset

    def perform_update(self, serializer):
        school_club = self.get_object()

        if serializer.validated_data.get(
            'is_active',
            school_club.is_active
        ) is False:

            with transaction.atomic():
                serializer.save()

                school_club.memberships.filter(
                    is_active=True
                ).update(
                    is_active=False,
                    left_at=timezone.now(),
                )

            return

        serializer.save()

    @action(
        detail=False,
        methods=['post'],
        url_path='register'
    )
    def register(self, request):

        if request.user.role not in {
            'head_teacher',
            'sport_teacher'
        }:
            return Response(
                {
                    'detail': (
                        'Only school teachers can register clubs.'
                    )
                },
                status=403
            )

        school = request.user.school

        country_club_ids = list(
            dict.fromkeys(
                request.data.get('country_club_ids') or []
            )
        )

        if school is None:
            return Response(
                {
                    'detail': (
                        'This teacher has no assigned school.'
                    )
                },
                status=400
            )

        # School must be approved before registering clubs.
        if not school.is_approved:
            return Response(
                {
                    'detail': (
                        'Your school must be approved by the '
                        'Super Admin before accessing clubs.'
                    )
                },
                status=status.HTTP_403_FORBIDDEN
            )

        allowed_total = school.recommended_club_count

        try:
            country_club_ids = [
                int(club_id)
                for club_id in country_club_ids
            ]

        except (TypeError, ValueError):
            return Response(
                {
                    'detail': (
                        'Club IDs must be valid numbers.'
                    )
                },
                status=400
            )

        if len(country_club_ids) > allowed_total:
            return Response(
                {
                    'detail': (
                        f'This school can register up to '
                        f'{allowed_total} active clubs.'
                    )
                },
                status=400
            )

        country_clubs = list(
            CountryClub.objects.filter(
                id__in=country_club_ids,
                country_id=school.country_id,
                is_active=True
            )
        )

        if len(country_clubs) != len(country_club_ids):
            return Response(
                {
                    'detail': (
                        'Choose active clubs from your school country.'
                    )
                },
                status=400
            )

        with transaction.atomic():

            existing_clubs = {
                school_club.country_club_id: school_club
                for school_club in SchoolClub.objects.select_for_update().filter(
                    school=school
                )
            }

            for country_club_id, school_club in existing_clubs.items():

                should_be_active = (
                    country_club_id in country_club_ids
                )

                if school_club.is_active != should_be_active:

                    school_club.is_active = should_be_active

                    school_club.save(
                        update_fields=['is_active']
                    )

                    if not should_be_active:
                        school_club.memberships.filter(
                            is_active=True
                        ).update(
                            is_active=False,
                            left_at=timezone.now(),
                        )

            SchoolClub.objects.bulk_create([
                SchoolClub(
                    school=school,
                    country_club=country_club,
                    is_active=True
                )
                for country_club in country_clubs
                if country_club.id not in existing_clubs
            ])

        return Response({
            'selected': len(country_club_ids)
        })


class ClubTeacherViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = ClubTeacher.objects.select_related(
        'club',
        'teacher'
    ).all()

    serializer_class = ClubTeacherSerializer
    permission_classes = [AuthenticatedReadOnly]

    scope_paths = {
        'school': 'club__school_id',
        'country': 'club__school__country_id',
        'zone': 'club__school__zone_id',
        'region': 'club__school__region_id',
        'district': 'club__school__district_id',
        'ward': 'club__school__ward_id',
    }


class StudentClubMembershipViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = StudentClubMembership.objects.select_related(
        'student',
        'club'
    ).all()

    serializer_class = StudentClubMembershipSerializer
    permission_classes = [StudentDataPermission]

    scope_paths = {
        'student': 'student_id',
        'school': 'student__school_id',
        'country': 'student__school__country_id',
        'zone': 'student__school__zone_id',
        'region': 'student__school__region_id',
        'district': 'student__school__district_id',
        'ward': 'student__school__ward_id',
    }


class EvaluationCriterionViewSet(
    viewsets.ModelViewSet
):
    queryset = EvaluationCriterion.objects.select_related(
        'talent'
    ).all()

    serializer_class = EvaluationCriterionSerializer
    permission_classes = [ConfigurationPermission]


class TalentEvaluationViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = TalentEvaluation.objects.select_related(
        'student_talent',
        'evaluator'
    ).prefetch_related(
        'scores'
    ).all()

    serializer_class = TalentEvaluationSerializer
    permission_classes = [AuthenticatedReadOnly]

    scope_paths = {
        'student': 'student_talent__student_id',
        'school': 'student_talent__student__school_id',
        'country': 'student_talent__student__school__country_id',
        'zone': 'student_talent__student__school__zone_id',
        'region': 'student_talent__student__school__region_id',
        'district': 'student_talent__student__school__district_id',
        'ward': 'student_talent__student__school__ward_id',
    }

    def perform_create(self, serializer):
        serializer.save(
            evaluator=self.request.user
        )


class EvaluationScoreViewSet(
    viewsets.ModelViewSet
):
    queryset = EvaluationScore.objects.select_related(
        'evaluation',
        'criterion'
    ).all()

    serializer_class = EvaluationScoreSerializer
    permission_classes = [AuthenticatedReadOnly]


class TalentSubmissionViewSet(
    ScopedQuerysetMixin,
    viewsets.ModelViewSet
):
    queryset = TalentSubmission.objects.select_related(
        'student',
        'talent',
        'club'
    ).all()

    serializer_class = TalentSubmissionSerializer
    permission_classes = [SubmissionPermission]

    scope_paths = {
        'student': 'student_id',
        'school': 'student__school_id',
        'country': 'student__school__country_id',
        'zone': 'student__school__zone_id',
        'region': 'student__school__region_id',
        'district': 'student__school__district_id',
        'ward': 'student__school__ward_id',
    }

    def perform_create(self, serializer):
        if self.request.user.role == 'student':
            serializer.save(
                student_id=self.request.user.student_id
            )
        else:
            serializer.save()


class SubmissionFeedbackViewSet(
    viewsets.ModelViewSet
):
    queryset = SubmissionFeedback.objects.select_related(
        'submission',
        'author'
    ).all()

    serializer_class = SubmissionFeedbackSerializer
    permission_classes = [AuthenticatedReadOnly]

    def perform_create(self, serializer):
        serializer.save(
            author=self.request.user
        )


class MessageViewSet(viewsets.ModelViewSet):
    queryset = Message.objects.select_related(
        'sender',
        'recipient'
    ).all()

    serializer_class = MessageSerializer
    permission_classes = [AuthenticatedReadOnly]

    def get_queryset(self):
        return (
            self.queryset.filter(
                sender=self.request.user
            )
            | self.queryset.filter(
                recipient=self.request.user
            )
        )

    def perform_create(self, serializer):
        serializer.save(
            sender=self.request.user
        )


class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.select_related(
        'recipient'
    ).all()

    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(
            recipient=self.request.user
        )


class AuditLogViewSet(
    viewsets.ReadOnlyModelViewSet
):
    queryset = AuditLog.objects.select_related(
        'actor'
    ).all()

    serializer_class = AuditLogSerializer
    permission_classes = [ConfigurationPermission]


# ============================================================
# PASSWORD RESET
# ============================================================

class RequestPasswordResetView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        username = str(
            request.data.get('username', '') or ''
        ).strip()

        email = str(
            request.data.get('email', '') or ''
        ).strip()

        if not username and not email:
            return Response(
                {
                    'detail': (
                        'Please provide a username or email.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        user = None

        if username:
            user = User.objects.filter(
                username__iexact=username,
                is_active=True
            ).first()

        elif email:
            user = User.objects.filter(
                email__iexact=email,
                is_active=True
            ).first()

        # Do not reveal whether an account exists.
        if user and user.email:

            uid = urlsafe_base64_encode(
                force_bytes(user.pk)
            )

            reset_token = default_token_generator.make_token(
                user
            )

            print('')
            print('========================================')
            print('PASSWORD RESET BACKEND DEBUG')
            print('========================================')
            print('USER ID:', user.pk)
            print('USERNAME:', user.username)
            print('EMAIL:', user.email)
            print('UID:', uid)
            print('GENERATED TOKEN:', reset_token)
            print('TOKEN LENGTH:', len(reset_token))
            print(
                'TOKEN CHECK:',
                default_token_generator.check_token(
                    user,
                    reset_token
                )
            )
            print('TOKEN CONTAINS "=":', '=' in reset_token)
            print('TOKEN CONTAINS ":":', ':' in reset_token)
            print('========================================')
            print('')

            frontend_url = getattr(
                settings,
                'FRONTEND_URL',
                'http://localhost:5173'
            ).rstrip('/')

            query_string = urlencode({
                'token': uid + ':' + reset_token
            })

            reset_link = (
                frontend_url
                + '/reset-password?'
                + query_string
            )

            print('========================================')
            print('RESET LINK GENERATED BY BACKEND')
            print('========================================')
            print(reset_link)
            print('========================================')
            print('')

            subject = (
                'Talanta Management System - Password Reset'
            )

            message = (
                'Hello '
                + user.username
                + ',\n\n'
                'We received a request to reset your '
                'Talanta Management System password.\n\n'
                'Use the link below to create a new password:\n\n'
                + reset_link
                + '\n\n'
                'If you did not request this password reset, '
                'you can ignore this email.\n\n'
                'Talanta Management System'
            )

            send_mail(
                subject,
                message,
                getattr(
                    settings,
                    'DEFAULT_FROM_EMAIL',
                    'noreply@talantaz.local'
                ),
                [user.email],
                fail_silently=False,
            )

        return Response({
            'detail': (
                'If an account exists with the provided '
                'information, a password reset link will '
                'be sent to the registered email.'
            )
        })


class ResetPasswordView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):

        token_value = str(
            request.data.get('token', '') or ''
        ).strip()

        new_password = str(
            request.data.get('new_password', '') or ''
        )

        if not token_value:
            return Response(
                {
                    'detail': (
                        'Password reset token is required.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        if not new_password:
            return Response(
                {
                    'detail': (
                        'New password is required.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        if len(new_password) < 8:
            return Response(
                {
                    'detail': (
                        'Password must be at least 8 '
                        'characters long.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        if ':' not in token_value:
            return Response(
                {
                    'detail': (
                        'Invalid or expired password '
                        'reset token.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        uid_value, reset_token = token_value.split(
            ':',
            1
        )

        uid_value = uid_value.strip()
        reset_token = reset_token.strip()

        if not uid_value or not reset_token:
            return Response(
                {
                    'detail': (
                        'Invalid or expired password '
                        'reset token.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            user_id = force_str(
                urlsafe_base64_decode(uid_value)
            )

            user = User.objects.get(
                pk=user_id,
                is_active=True
            )

        except (
            TypeError,
            ValueError,
            OverflowError,
            User.DoesNotExist,
        ):
            return Response(
                {
                    'detail': (
                        'Invalid or expired password '
                        'reset token.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        print('')
        print('========================================')
        print('PASSWORD RESET CONFIRM DEBUG')
        print('========================================')
        print('USER ID:', user.pk)
        print('USERNAME:', user.username)
        print('UID VALUE:', uid_value)
        print('RESET TOKEN:', reset_token)
        print('TOKEN LENGTH:', len(reset_token))
        print(
            'TOKEN CHECK:',
            default_token_generator.check_token(
                user,
                reset_token
            )
        )
        print('TOKEN CONTAINS "=":', '=' in reset_token)
        print('TOKEN CONTAINS ":":', ':' in reset_token)
        print('========================================')
        print('')

        if not default_token_generator.check_token(
            user,
            reset_token
        ):
            return Response(
                {
                    'detail': (
                        'Invalid or expired password '
                        'reset token.'
                    )
                },
                status=status.HTTP_400_BAD_REQUEST
            )

        user.set_password(new_password)

        user.save(
            update_fields=['password']
        )

        return Response(
            {
                'detail': (
                    'Password reset successfully.'
                )
            },
            status=status.HTTP_200_OK
        )

