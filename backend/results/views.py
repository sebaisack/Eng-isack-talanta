from django.db import transaction
from django.db.models import Q
from django.utils import timezone
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from competitions.models import Competition, CompetitionParticipation
from django.contrib.contenttypes.models import ContentType
from core.models import Country, District, School, Zone
from students.models import Student

from .models import DistrictCompetitionSubmission, Result, ResultDetail, ResultPromotion, SchoolCompetitionSubmission, ZoneCompetitionSubmission
from .serializers import DistrictCompetitionSubmissionSerializer, ResultSerializer, ResultDetailSerializer, ResultPromotionSerializer, SchoolCompetitionSubmissionSerializer, ZoneCompetitionSubmissionSerializer
from core.permissions import AuthenticatedReadOnly, StudentDataPermission, ScopedQuerysetMixin

from core.permissions import IsSportTeacher


def remove_empty_result_chain(result, participation):
    if result.details.exists():
        return
    result.delete()
    participation.delete()


def ensure_school_result_editable(result):
    """Prevent school results from changing after the school submits them."""
    if SchoolCompetitionSubmission.objects.filter(
        school_id=result.participation.student.school_id,
        competition_id=result.participation.competition_id,
        status__in={'submitted', 'approved'},
    ).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted or approved school results are locked.')


def ensure_result_detail_editable(result_detail):
    """Prevent promoted talents from being edited after they advance to a higher competition level."""
    if (
        getattr(result_detail, 'promoted_to', '') in {'district', 'zone', 'country'}
        or ResultPromotion.objects.filter(result_detail_id=result_detail.id, to_level__in={'district', 'zone', 'country'}).exists()
        or ResultPromotion.objects.filter(result_id=result_detail.result_id, to_level__in={'district', 'zone', 'country'}).exists()
    ):
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Promoted competition results are locked.')
    if DistrictCompetitionSubmission.objects.filter(
        district_id=result_detail.result.participation.student.school.district_id,
        competition_id=result_detail.result.participation.competition_id,
        status='submitted',
    ).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted district results are locked.')
    if ZoneCompetitionSubmission.objects.filter(
        zone_id=result_detail.result.participation.student.school.zone_id,
        competition_id=result_detail.result.participation.competition_id,
        status='submitted',
    ).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted zone results are locked.')
    ensure_school_result_editable(result_detail.result)


def ensure_result_editable(result):
    """Prevent a result from changing while any talent has advanced."""
    if ResultPromotion.objects.filter(result=result, to_level__in={'district', 'zone', 'country'}).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted competition results are locked until they are returned to draft.')
    if DistrictCompetitionSubmission.objects.filter(
        district_id=result.participation.student.school.district_id,
        competition_id=result.participation.competition_id,
        status='submitted',
    ).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted district results are locked.')
    if ZoneCompetitionSubmission.objects.filter(
        zone_id=result.participation.student.school.zone_id,
        competition_id=result.participation.competition_id,
        status='submitted',
    ).exists():
        from rest_framework.exceptions import ValidationError
        raise ValidationError('Submitted zone results are locked.')
    ensure_school_result_editable(result)

class ResultViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = Result.objects.select_related('participation__student', 'participation__competition').prefetch_related('details').all()
    serializer_class = ResultSerializer
    filterset_fields = ['award', 'participation__competition', 'participation__student']
    search_fields = ['participation__student__first_name', 'participation__student__last_name', 'participation__competition__name']
    ordering_fields = ['competition_date', 'rank', 'recorded_at']
    ordering = ['-competition_date', 'rank']
    permission_classes = [StudentDataPermission]

    scope_paths = {
        'student': 'participation__student_id', 'school': 'participation__student__school_id',
        'country': 'participation__student__school__country_id', 'zone': 'participation__student__school__zone_id',
        'region': 'participation__student__school__region_id', 'district': 'participation__student__school__district_id',
        'ward': 'participation__student__school__ward_id',
    }

    def perform_create(self, serializer):
        ensure_school_result_editable(Result(participation=serializer.validated_data['participation']))
        serializer.save()

    def perform_update(self, serializer):
        ensure_result_editable(self.get_object())
        serializer.save()

    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        result = self.get_object()
        result.approval_status = 'approved'
        result.approved_by = request.user
        result.approved_at = timezone.now()
        result.save(update_fields=['approval_status', 'approved_by', 'approved_at', 'updated_at'])
        return Response(self.get_serializer(result).data)


class ResultDetailViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = ResultDetail.objects.select_related('result', 'talent').all()
    serializer_class = ResultDetailSerializer
    filterset_fields = ['result', 'talent__talent__category']
    search_fields = ['result__participation__student__first_name', 'result__participation__student__last_name']
    ordering_fields = ['recorded_at']
    ordering = ['-recorded_at']
    permission_classes = [AuthenticatedReadOnly]
    scope_paths = {
        'student': 'result__participation__student_id', 'school': 'result__participation__student__school_id',
        'country': 'result__participation__student__school__country_id', 'zone': 'result__participation__student__school__zone_id',
        'region': 'result__participation__student__school__region_id', 'district': 'result__participation__student__school__district_id',
        'ward': 'result__participation__student__school__ward_id',
    }

    def perform_create(self, serializer):
        ensure_school_result_editable(serializer.validated_data['result'])
        serializer.save()

    def perform_update(self, serializer):
        ensure_result_detail_editable(self.get_object())
        serializer.save()


class DistrictCompetitionSubmissionViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = DistrictCompetitionSubmission.objects.select_related('district', 'competition').order_by('-submitted_at', '-id')
    serializer_class = DistrictCompetitionSubmissionSerializer
    permission_classes = [AuthenticatedReadOnly]
    scope_paths = {
        'district': 'district_id',
        'zone': 'district__region__zone_id',
    }

    def perform_create(self, serializer):
        user = self.request.user
        if user.role != 'district_manager' or not user.district_id:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied('Only an assigned district manager can create this submission.')
        competition = serializer.validated_data['competition']
        if competition.level != 'district':
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'competition': 'Only district competitions can be submitted.'})
        if not Competition.objects.filter(
            pk=competition.pk,
            level='district',
        ).filter(
            Q(content_type=ContentType.objects.get_for_model(District), object_id=user.district_id)
            | Q(schools__district_id=user.district_id)
        ).exists():
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'competition': 'This competition does not belong to your district.'})
        serializer.save(district_id=user.district_id)

    @action(detail=True, methods=['post'])
    def submit(self, request, pk=None):
        submission = self.get_object()
        user = request.user

        if user.role != 'district_manager' or submission.district_id != user.district_id:
            return Response(
                {'detail': 'Only the assigned district manager can submit these results.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        if not user.zone_id:
            return Response(
                {'error': 'District managers must be assigned to a zone.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        district_type = ContentType.objects.get_for_model(District)
        source_competition = Competition.objects.filter(
            pk=submission.competition_id,
            level='district',
        ).filter(
            Q(content_type=district_type, object_id=submission.district_id)
            | Q(schools__district_id=submission.district_id)
        ).first()

        if not source_competition:
            return Response(
                {'error': 'This district competition does not belong to your district.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        details = ResultDetail.objects.filter(
            result__participation__competition=source_competition,
            result__participation__student__school__district_id=submission.district_id,
        )

        with transaction.atomic():
            for detail in details:
                score = (
                    detail.percentage_score
                    if detail.percentage_score is not None
                    else detail.raw_score
                )

                if score is None:
                    ResultDetail.objects.filter(pk=detail.pk).update(
                        promotion_status='pending',
                        promoted_to='',
                        passed=False,
                    )
                elif score < 50:
                    ResultDetail.objects.filter(pk=detail.pk).update(
                        promotion_status='not_promoted',
                        promoted_to='',
                        passed=False,
                    )
                else:
                    # Eligible district results wait for the Zone Manager.
                    ResultDetail.objects.filter(pk=detail.pk).update(
                        promotion_status='pending',
                        promoted_to='',
                        passed=True,
                    )

            submission.status = 'submitted'
            submission.submitted_by = user
            submission.submitted_at = timezone.now()
            submission.save(
                update_fields=['status', 'submitted_by', 'submitted_at']
            )

        return Response(self.get_serializer(submission).data)

    @action(detail=True, methods=['post'])
    def reopen(self, request, pk=None):
        submission = self.get_object()
        if request.user.role != 'zone_manager' or submission.district.region.zone_id != request.user.zone_id:
            return Response({'detail': 'Only the assigned zone manager can return these results to draft.'}, status=status.HTTP_403_FORBIDDEN)

        demoted_count = 0
        with transaction.atomic():
            promotions = ResultPromotion.objects.select_related(
                'result_detail',
                'result__participation__student',
            ).filter(
                result__participation__competition=submission.competition,
                to_level='zone',
                result__participation__student__school__district_id=submission.district_id,
            )
            for promotion in promotions:
                source_detail = promotion.result_detail
                if source_detail:
                    ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='')

                student_id = promotion.result.participation.student_id
                talent_id = source_detail.talent_id if source_detail else None
                zone_details = ResultDetail.objects.select_related('result__participation').filter(
                    result__participation__student_id=student_id,
                    result__participation__competition__level='zone',
                    talent_id=talent_id,
                )
                if promotion.target_competition_id:
                    zone_details = zone_details.filter(
                        result__participation__competition_id=promotion.target_competition_id
                    )
                else:
                    zone_details = zone_details.filter(
                        Q(
                            result__participation__competition__content_type=ContentType.objects.get_for_model(Zone),
                            result__participation__competition__object_id=submission.district.region.zone_id,
                        )
                        | Q(
                            result__participation__competition__schools__zone_id=submission.district.region.zone_id
                        )
                    ).distinct()
                for zone_detail in zone_details:
                    zone_result = zone_detail.result
                    zone_participation = zone_result.participation
                    zone_detail.delete()
                    remove_empty_result_chain(zone_result, zone_participation)

                promotion.delete()
                demoted_count += 1

            submission.status = 'draft'
            submission.save(update_fields=['status'])

        data = self.get_serializer(submission).data
        data['demoted'] = demoted_count
        return Response(data)


class ZoneCompetitionSubmissionViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = ZoneCompetitionSubmission.objects.select_related('zone', 'competition').all()
    serializer_class = ZoneCompetitionSubmissionSerializer
    permission_classes = [AuthenticatedReadOnly]
    scope_paths = {
        'zone': 'zone_id',
        'country': 'zone__country_id',
    }

    def perform_create(self, serializer):
        user = self.request.user
        if user.role != 'zone_manager' or not user.zone_id:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied('Only an assigned zone manager can create this submission.')
        competition = serializer.validated_data['competition']
        if competition.level != 'zone':
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'competition': 'Only zone competitions can be submitted.'})
        if not Competition.objects.filter(
            pk=competition.pk,
            level='zone',
        ).filter(
            Q(content_type=ContentType.objects.get_for_model(Zone), object_id=user.zone_id)
            | Q(schools__zone_id=user.zone_id)
        ).exists():
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'competition': 'This competition does not belong to your zone.'})
        serializer.save(zone_id=user.zone_id)

    @action(detail=True, methods=['post'])
    def submit(self, request, pk=None):
        submission = self.get_object()
        if request.user.role != 'zone_manager' or submission.zone_id != request.user.zone_id:
            return Response({'detail': 'Only the assigned zone manager can submit these results.'}, status=status.HTTP_403_FORBIDDEN)
        submission.status = 'submitted'
        submission.submitted_by = request.user
        submission.submitted_at = timezone.now()
        submission.save(update_fields=['status', 'submitted_by', 'submitted_at'])
        return Response(self.get_serializer(submission).data)

    @action(detail=True, methods=['post'])
    def reopen(self, request, pk=None):
        submission = self.get_object()
        is_zone_manager = request.user.role == 'zone_manager' and submission.zone_id == request.user.zone_id
        is_talent_admin = request.user.role == 'talent_admin'
        if not (is_zone_manager or is_talent_admin):
            return Response({'detail': 'Only the assigned zone manager or talent admin can return these results to draft.'}, status=status.HTTP_403_FORBIDDEN)

        demoted_count = 0
        with transaction.atomic():
            promotions = ResultPromotion.objects.select_related(
                'result_detail',
                'result__participation__student',
            ).filter(
                result__participation__competition=submission.competition,
                to_level='country',
                result__participation__student__school__zone_id=submission.zone_id,
            )
            for promotion in promotions:
                source_detail = promotion.result_detail
                if source_detail:
                    ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='')

                student_id = promotion.result.participation.student_id
                talent_id = source_detail.talent_id if source_detail else None
                country_details = ResultDetail.objects.select_related('result__participation').filter(
                    result__participation__student_id=student_id,
                    result__participation__competition__level='country',
                    talent_id=talent_id,
                )
                for country_detail in country_details:
                    country_result = country_detail.result
                    country_participation = country_result.participation
                    country_detail.delete()
                    remove_empty_result_chain(country_result, country_participation)

                promotion.delete()
                demoted_count += 1

            submission.status = 'draft'
            submission.save(update_fields=['status'])

        data = self.get_serializer(submission).data
        data['demoted'] = demoted_count
        return Response(data)


class ResultPromotionViewSet(viewsets.ModelViewSet):
    queryset = ResultPromotion.objects.select_related('result', 'promoted_by').all()
    serializer_class = ResultPromotionSerializer
    permission_classes = [AuthenticatedReadOnly]

    def perform_create(self, serializer):
        serializer.save(promoted_by=self.request.user)

    @action(detail=False, methods=['post'], permission_classes=[AuthenticatedReadOnly])
    def return_district_to_draft(self, request):
        if request.user.role != 'zone_manager' or not request.user.zone_id:
            return Response({'error': 'Only the assigned zone manager can return district results to draft.'}, status=status.HTTP_403_FORBIDDEN)

        competition_id = request.data.get('competition_id')
        zone_competition_id = request.data.get('zone_competition_id')
        if not competition_id:
            return Response({'error': 'competition_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

        source_competition = Competition.objects.filter(
            id=competition_id,
            level='district',
            schools__zone_id=request.user.zone_id,
        ).first()
        if not source_competition:
            return Response({'error': 'The selected district competition does not belong to your zone.'}, status=status.HTTP_404_NOT_FOUND)

        promotions = ResultPromotion.objects.select_related(
            'result_detail',
            'result__participation__student',
        ).filter(
            result__participation__competition=source_competition,
            to_level='zone',
        )
        if not promotions.exists():
            return Response({'error': 'This district competition is already in draft.'}, status=status.HTTP_400_BAD_REQUEST)

        with transaction.atomic():
            for promotion in promotions:
                source_detail = promotion.result_detail
                student_id = promotion.result.participation.student_id
                talent_id = source_detail.talent_id if source_detail else None

                if zone_competition_id and talent_id:
                    target_participation = CompetitionParticipation.objects.filter(
                        competition_id=zone_competition_id,
                        student_id=student_id,
                    ).first()
                    if target_participation:
                        target_result = Result.objects.filter(participation=target_participation).first()
                        if target_result:
                            ResultDetail.objects.filter(result=target_result, talent_id=talent_id).delete()
                            if not target_result.details.exists():
                                target_result.delete()
                        if not CompetitionParticipation.objects.filter(pk=target_participation.pk, result__isnull=False).exists():
                            target_participation.delete()

                if source_detail:
                    ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='')
                promotion.delete()

        return Response({'draft': True, 'competition_id': int(competition_id)})

    @action(detail=False, methods=['post'], permission_classes=[AuthenticatedReadOnly])
    def demote(self, request):
        if request.user.role == 'zone_manager' and request.user.zone_id:
            detail_ids = request.data.get('result_detail_ids', [])
            if not detail_ids:
                return Response({'error': 'result_detail_ids are required.'}, status=status.HTTP_400_BAD_REQUEST)

            promotions = ResultPromotion.objects.select_related(
                'result_detail',
                'result__participation__student',
            ).filter(
                result_detail_id__in=detail_ids,
                to_level='country',
                result__participation__competition__level='zone',
                result__participation__student__school__zone_id=request.user.zone_id,
            )
            if not promotions.exists():
                return Response({'error': 'No country promotions were found for the selected records.'}, status=status.HTTP_404_NOT_FOUND)

            demoted_ids = []
            with transaction.atomic():
                for promotion in promotions:
                    source_detail = promotion.result_detail
                    country_type = ContentType.objects.get_for_model(Country)
                    target_participation = CompetitionParticipation.objects.filter(
                        competition__level='country',
                        student_id=promotion.result.participation.student_id,
                    ).filter(
                        Q(competition__content_type=country_type, competition__object_id=request.user.country_id)
                        | Q(competition__schools__country_id=request.user.country_id),
                    ).first()
                    if target_participation:
                        target_result = Result.objects.filter(participation=target_participation).first()
                        if target_result and source_detail:
                            ResultDetail.objects.filter(result=target_result, talent_id=source_detail.talent_id).delete()
                            if not target_result.details.exists():
                                target_result.delete()
                        if not CompetitionParticipation.objects.filter(pk=target_participation.pk, result__isnull=False).exists():
                            target_participation.delete()

                    if source_detail:
                        source_detail.promoted_to = ''
                        source_detail.save(update_fields=['promoted_to'])
                        demoted_ids.append(int(source_detail.id))
                    promotion.delete()
            return Response({'demoted': len(demoted_ids), 'result_detail_ids': demoted_ids})

        if request.user.role != 'district_manager' or not request.user.district_id:
            return Response({'error': 'Only a district manager can remove a district promotion.'}, status=status.HTTP_403_FORBIDDEN)
        target_detail_ids = request.data.get('result_detail_ids', [])
        if not target_detail_ids:
            target_detail_id = request.data.get('target_detail_id')
            target_detail_ids = [target_detail_id] if target_detail_id else []
        if not target_detail_ids:
            return Response({'error': 'result_detail_ids are required.'}, status=status.HTTP_400_BAD_REQUEST)

        target_details = ResultDetail.objects.select_related(
            'result__participation__student',
        ).filter(
            id__in=target_detail_ids,
            result__participation__competition__level='district',
            result__participation__student__school__district_id=request.user.district_id,
        )
        if not target_details.exists():
            return Response({'error': 'No district talent results were found for the selected records.'}, status=status.HTTP_404_NOT_FOUND)

        demoted_ids = []
        with transaction.atomic():
            for target_detail in target_details:
                promotion = ResultPromotion.objects.filter(
                    to_level='district',
                    result_detail__talent_id=target_detail.talent_id,
                    result_detail__result__participation__student_id=target_detail.result.participation.student_id,
                    result_detail__result__participation__student__school__district_id=request.user.district_id,
                ).first()
                if not promotion:
                    continue
                demoted_detail_id = int(target_detail.pk)
                ResultDetail.objects.filter(pk=promotion.result_detail_id).update(promoted_to='')
                promotion.delete()
                target_result = target_detail.result
                target_participation = target_result.participation
                target_detail.delete()
                if not target_result.details.exists():
                    target_result.delete()
                    if not Result.objects.filter(pk=target_result.pk).exists():
                        target_participation.delete()
                demoted_ids.append(demoted_detail_id)
        return Response({'demoted': len(demoted_ids), 'result_detail_ids': demoted_ids})

    @action(detail=False, methods=['post'], permission_classes=[AuthenticatedReadOnly])
    def promote(self, request):
        """Promote students to next competition level."""
        detail_ids = request.data.get('result_detail_ids', [])
        student_ids = request.data.get('student_ids', [])
        competition_id = request.data.get('competition_id')
        from_level = request.data.get('from_level', 'school')
        to_level = request.data.get('to_level')  # district, zone, country
        
        if not competition_id or not to_level:
            return Response({
                'error': 'competition_id and to_level are required'
            }, status=status.HTTP_400_BAD_REQUEST)

        if not (detail_ids or student_ids):
            allowed_auto_submit_roles = {'district_manager', 'zone_manager'}
            if request.user.role not in allowed_auto_submit_roles:
                return Response({
                    'error': 'student_ids or result_detail_ids are required'
                }, status=status.HTTP_400_BAD_REQUEST)

        valid_levels = ['district', 'zone', 'country']
        if to_level not in valid_levels:
            return Response({
                'error': f'to_level must be one of: {valid_levels}'
            }, status=status.HTTP_400_BAD_REQUEST)

        if request.user.role == 'district_manager':
            if to_level == 'district':
                if not request.user.district_id:
                    return Response(
                        {'error': 'District managers must be assigned to a district.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                target_competition_id = request.data.get('district_competition_id')
                if not target_competition_id:
                    return Response(
                        {'error': 'district_competition_id is required.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                district_type = ContentType.objects.get_for_model(District)
                target_competition = Competition.objects.filter(
                    id=target_competition_id,
                    level='district',
                ).filter(
                    Q(content_type=district_type, object_id=request.user.district_id)
                    | Q(schools__district_id=request.user.district_id)
                ).distinct().first()

                if not target_competition:
                    return Response(
                        {'error': 'The selected district competition does not belong to your district.'},
                        status=status.HTTP_404_NOT_FOUND,
                    )

                if DistrictCompetitionSubmission.objects.filter(
                    district_id=request.user.district_id,
                    competition_id=target_competition.id,
                    status='submitted',
                ).exists():
                    return Response(
                        {
                            'error': (
                                'This district competition has already been submitted to the zone. '
                                'Choose a district competition that is still open, or return its results to draft first.'
                            )
                        },
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                # Keep every eligible source talent in the district-wide pool.
                # When promoting, route each result to the district competition
                # matching its talent. A talent-neutral district competition may
                # be used as a fallback.
                district_target_competitions = list(
                    Competition.objects.filter(level='district').filter(
                        Q(content_type=district_type, object_id=request.user.district_id)
                        | Q(schools__district_id=request.user.district_id)
                    ).distinct()
                )

                def target_for_detail(detail):
                    talent_id = detail.talent.talent_id

                    if target_competition.talent_id == talent_id:
                        return target_competition

                    matching_talent_competition = next(
                        (
                            item for item in district_target_competitions
                            if item.talent_id == talent_id
                        ),
                        None,
                    )
                    if matching_talent_competition is not None:
                        return matching_talent_competition

                    if target_competition.talent_id is None:
                        return target_competition

                    return next(
                        (
                            item for item in district_target_competitions
                            if item.talent_id is None
                        ),
                        None,
                    )

                # Accept multiple submitted school competitions in one request.
                raw_competition_ids = request.data.get('competition_ids')
                if raw_competition_ids is None:
                    raw_competition_ids = [competition_id]

                if not isinstance(raw_competition_ids, (list, tuple)):
                    return Response(
                        {'error': 'competition_ids must be a list of school competition IDs.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                try:
                    source_competition_ids = {
                        int(value) for value in raw_competition_ids
                    }
                except (TypeError, ValueError):
                    return Response(
                        {'error': 'competition_ids must contain valid IDs.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                if not source_competition_ids:
                    return Response(
                        {'error': 'Select at least one submitted school competition.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                source_competitions = list(
                    Competition.objects.filter(
                        id__in=source_competition_ids,
                        level='school',
                        schools__district_id=request.user.district_id,
                    ).distinct()
                )

                if len(source_competitions) != len(source_competition_ids):
                    return Response(
                        {'error': 'One or more school competitions do not belong to your district.'},
                        status=status.HTTP_404_NOT_FOUND,
                    )

                submitted_ids = set(
                    SchoolCompetitionSubmission.objects.filter(
                        competition_id__in=source_competition_ids,
                        school__district_id=request.user.district_id,
                        status='submitted',
                    ).values_list('competition_id', flat=True).distinct()
                )

                if not source_competition_ids.issubset(submitted_ids):
                    return Response(
                        {'error': 'All selected school competitions must have submitted results.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                try:
                    total_students = int(request.data.get('total_students'))
                    if total_students < 1:
                        raise ValueError
                except (TypeError, ValueError):
                    return Response(
                        {'error': 'Enter a valid total_students greater than zero.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                try:
                    # Validate supplied IDs, but calculate final selection on
                    # the server using the district-wide quota and actual scores.
                    {int(value) for value in request.data.get('result_detail_ids', [])}
                except (TypeError, ValueError):
                    return Response(
                        {'error': 'result_detail_ids must contain valid IDs.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                with transaction.atomic():
                    all_source_details = list(
                        ResultDetail.objects.select_related(
                            'result__participation__student__school',
                            'talent__talent',
                        ).filter(
                            result__participation__competition_id__in=source_competition_ids,
                            result__participation__student__school__district_id=request.user.district_id,
                        ).order_by('pk')
                    )

                    # The district-wide pool includes all submitted school
                    # results in this district. Talent is preserved when mapping
                    # selected students to their district-level competition.
                    source_details = all_source_details

                    best_detail_by_student = {}
                    for detail in source_details:
                        score = (
                            detail.percentage_score
                            if detail.percentage_score is not None
                            else detail.raw_score
                        )

                        if (
                            score is None
                            or score < 50
                            or detail.promoted_to
                            or detail.promotion_status != 'pending'
                        ):
                            continue

                        existing_promotion = ResultPromotion.objects.filter(
                            result=detail.result,
                            result_detail=detail,
                            to_level='district',
                        ).first()

                        if (
                            existing_promotion is not None
                            and existing_promotion.target_competition_id is not None
                        ):
                            continue

                        student_id = detail.result.participation.student_id
                        current = best_detail_by_student.get(student_id)
                        current_score = (
                            current.percentage_score
                            if current and current.percentage_score is not None
                            else current.raw_score if current else None
                        )

                        if (
                            current is None
                            or score > current_score
                            or (score == current_score and detail.pk < current.pk)
                        ):
                            best_detail_by_student[student_id] = detail

                    candidates_by_school = {}
                    for detail in best_detail_by_student.values():
                        school_id = detail.result.participation.student.school_id
                        candidates_by_school.setdefault(school_id, []).append(detail)

                    def promotion_score(detail):
                        value = (
                            detail.percentage_score
                            if detail.percentage_score is not None
                            else detail.raw_score
                        )
                        return float(value)

                    for school_candidates in candidates_by_school.values():
                        school_candidates.sort(
                            key=lambda detail: (
                                -promotion_score(detail),
                                detail.result.participation.student_id,
                                detail.pk,
                            )
                        )

                    # Allocate a fair initial quota to each school, then fill
                    # any unused places from the highest-scoring remaining students.
                    school_ids = sorted(candidates_by_school)
                    selected_detail_ids = set()

                    if school_ids:
                        base_quota, extra_places = divmod(
                            total_students, len(school_ids)
                        )
                        remaining_by_school = {}

                        for index, school_id in enumerate(school_ids):
                            quota = base_quota + (1 if index < extra_places else 0)
                            school_candidates = candidates_by_school[school_id]
                            chosen = school_candidates[:quota]

                            selected_detail_ids.update(
                                detail.pk for detail in chosen
                            )
                            remaining_by_school[school_id] = school_candidates[len(chosen):]

                        remaining_places = total_students - len(selected_detail_ids)
                        overflow_candidates = [
                            detail
                            for remaining in remaining_by_school.values()
                            for detail in remaining
                        ]
                        overflow_candidates.sort(
                            key=lambda detail: (
                                -promotion_score(detail),
                                detail.result.participation.student.school_id,
                                detail.result.participation.student_id,
                                detail.pk,
                            )
                        )

                        selected_detail_ids.update(
                            detail.pk for detail in overflow_candidates[:remaining_places]
                        )

                    if not selected_detail_ids:
                        return Response({
                            'promoted': 0,
                            'errors': [
                                'No eligible unpromoted students with scores of at least 50% were found for the selected district competition.'
                            ],
                            'data': [],
                        })

                    promoted = []
                    errors = []

                    missing_target_details = [
                        detail for detail in source_details
                        if detail.pk in selected_detail_ids
                        and target_for_detail(detail) is None
                    ]
                    if missing_target_details:
                        missing_talents = sorted({
                            detail.talent.talent.name
                            for detail in missing_target_details
                        })
                        return Response(
                            {
                                'error': (
                                    'Create a district competition for these selected talents first: '
                                    + ', '.join(missing_talents)
                                )
                            },
                            status=status.HTTP_400_BAD_REQUEST,
                        )

                    for source_detail in source_details:
                        source_result = source_detail.result
                        source_participation = source_result.participation
                        source_score = (
                            source_detail.percentage_score
                            if source_detail.percentage_score is not None
                            else source_detail.raw_score
                        )

                        detail_target_competition = target_for_detail(source_detail)
                        promotion = ResultPromotion.objects.filter(
                            result=source_result,
                            result_detail=source_detail,
                            to_level='district',
                        ).first()

                        # Scores below 50% stay at school level and cannot
                        # be promoted to district.
                        if source_score is None or source_score < 50:
                            ResultDetail.objects.filter(
                                pk=source_detail.pk,
                                promotion_status='pending',
                                promoted_to='',
                            ).update(promotion_status='not_promoted')
                            continue

                        # Finalize eligible students not chosen for this
                        # district-wide promotion, while preserving prior decisions.
                        if source_detail.pk not in selected_detail_ids:
                            if promotion is None or promotion.target_competition_id is None:
                                ResultDetail.objects.filter(
                                    pk=source_detail.pk,
                                    promotion_status='pending',
                                    promoted_to='',
                                ).update(promotion_status='not_promoted')
                            continue

                        if (
                            promotion
                            and promotion.target_competition_id
                            not in (None, detail_target_competition.id)
                        ):
                            errors.append(
                                f'{source_detail.talent.talent.name} is already assigned to a different district competition.'
                            )
                            continue

                        target_participation, _ = CompetitionParticipation.objects.get_or_create(
                            competition=detail_target_competition,
                            student_id=source_participation.student_id,
                            defaults={'status': 'finished', 'score': None},
                        )
                        if target_participation.status != 'finished':
                            target_participation.status = 'finished'
                            target_participation.save(update_fields=['status'])

                        target_result, _ = Result.objects.get_or_create(
                            participation=target_participation,
                            defaults={'score': None, 'approval_status': 'pending'},
                        )

                        target_detail, _ = ResultDetail.objects.get_or_create(
                            result=target_result,
                            talent=source_detail.talent,
                            defaults={
                                'raw_score': 0,
                                'percentage_score': None,
                                'promotion_status': 'promoted',
                            },
                        )

                        if target_detail.promotion_status != 'promoted':
                            ResultDetail.objects.filter(
                                pk=target_detail.pk
                            ).update(promotion_status='promoted')
                            target_detail.promotion_status = 'promoted'

                        if promotion is None:
                            promotion = ResultPromotion.objects.create(
                                result=source_result,
                                result_detail=source_detail,
                                from_level='school',
                                to_level='district',
                                target_competition=detail_target_competition,
                                promoted_by=request.user,
                                notes=(
                                    f'Promoted talent to district competition '
                                    f'{detail_target_competition.name}'
                                ),
                            )
                        elif promotion.target_competition_id is None:
                            ResultPromotion.objects.filter(
                                pk=promotion.pk
                            ).update(target_competition=detail_target_competition)

                        ResultDetail.objects.filter(
                            pk=source_detail.pk
                        ).update(
                            promoted_to='district',
                            promotion_status='promoted',
                        )

                        promoted.append({
                            'student_id': int(source_participation.student_id),
                            'result_id': target_result.id,
                            'result_detail_id': target_detail.id,
                            'competition_id': detail_target_competition.id,
                            'promotion_id': promotion.id,
                        })

                return Response({
                    'promoted': len(promoted),
                    'requested': total_students,
                    'source_competitions': len(source_competition_ids),
                    'errors': errors,
                    'data': promoted,
                })

            if to_level == 'zone':
                if not request.user.district_id or not request.user.zone_id:
                    return Response(
                        {'error': 'District managers must be assigned to a district and zone.'},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                district_type = ContentType.objects.get_for_model(District)
                source_competition = Competition.objects.filter(
                    id=competition_id,
                    level='district',
                ).filter(
                    Q(content_type=district_type, object_id=request.user.district_id)
                    | Q(schools__district_id=request.user.district_id)
                ).first()

                if not source_competition:
                    return Response(
                        {'error': 'The selected district competition does not belong to your district.'},
                        status=status.HTTP_404_NOT_FOUND,
                    )

                submission, _ = DistrictCompetitionSubmission.objects.get_or_create(
                    district_id=request.user.district_id,
                    competition=source_competition,
                )

                with transaction.atomic():
                    details = ResultDetail.objects.filter(
                        result__participation__competition=source_competition,
                        result__participation__student__school__district_id=request.user.district_id,
                    )

                    for detail in details:
                        score = (
                            detail.percentage_score
                            if detail.percentage_score is not None
                            else detail.raw_score
                        )

                        if score is None:
                            ResultDetail.objects.filter(pk=detail.pk).update(
                                promotion_status='pending',
                                promoted_to='',
                                passed=False,
                            )
                        elif score < 50:
                            ResultDetail.objects.filter(pk=detail.pk).update(
                                promotion_status='not_promoted',
                                promoted_to='',
                                passed=False,
                            )
                        else:
                            ResultDetail.objects.filter(pk=detail.pk).update(
                                promotion_status='pending',
                                promoted_to='',
                                passed=True,
                            )

                    submission.status = 'submitted'
                    submission.submitted_by = request.user
                    submission.submitted_at = timezone.now()
                    submission.save(
                        update_fields=['status', 'submitted_by', 'submitted_at']
                    )

                return Response({
                    'submitted': True,
                    'promoted': 0,
                    'errors': [],
                    'data': [],
                })

            return Response({'error': 'District managers can promote only to district or zone level.'}, status=status.HTTP_400_BAD_REQUEST)

        if request.user.role == 'zone_manager':
            if to_level == 'zone':
                target_competition_id = request.data.get('zone_competition_id') or request.data.get('district_competition_id')
                if not request.user.zone_id:
                    return Response({'error': 'Zone managers must be assigned to a zone.'}, status=status.HTTP_400_BAD_REQUEST)
                if not target_competition_id:
                    return Response({'error': 'zone_competition_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

                zone_type = ContentType.objects.get_for_model(Zone)
                target_competition = Competition.objects.filter(
                    id=target_competition_id,
                    level='zone',
                ).filter(
                    Q(content_type=zone_type, object_id=request.user.zone_id)
                    | Q(schools__zone_id=request.user.zone_id)
                ).first()
                if not target_competition:
                    return Response({'error': 'The selected zone competition does not belong to your zone.'}, status=status.HTTP_404_NOT_FOUND)

                district_type = ContentType.objects.get_for_model(District)
                source_competition = Competition.objects.filter(
                    id=competition_id,
                    level='district',
                ).filter(
                    Q(content_type=district_type, object_id__in=District.objects.filter(region__zone_id=request.user.zone_id).values_list('id', flat=True))
                    | Q(schools__zone_id=request.user.zone_id)
                ).first()
                if not source_competition:
                    return Response({'error': 'The selected district competition does not belong to your zone.'}, status=status.HTTP_404_NOT_FOUND)

                if not detail_ids:
                    source_details = ResultDetail.objects.select_related('result__participation__student').filter(
                        result__participation__competition=source_competition,
                        result__participation__student__school__zone_id=request.user.zone_id,
                    )
                    detail_ids = [
                        detail.id for detail in source_details
                        if (detail.percentage_score if detail.percentage_score is not None else detail.raw_score) is not None
                        and (detail.percentage_score if detail.percentage_score is not None else detail.raw_score) >= 50
                    ]

                if not detail_ids:
                    return Response({'error': 'No qualifying district results were found to submit.'}, status=status.HTTP_400_BAD_REQUEST)

                promoted = []
                errors = []
                with transaction.atomic():
                    source_details = ResultDetail.objects.select_related('result__participation__student').filter(
                        id__in=detail_ids,
                        result__participation__competition=source_competition,
                        result__participation__student__school__zone_id=request.user.zone_id,
                    )
                    for source_detail in source_details:
                        source_result = source_detail.result
                        source_participation = source_result.participation
                        source_score = source_detail.percentage_score if source_detail.percentage_score is not None else source_detail.raw_score
                        if source_score is None or source_score < 50:
                            errors.append(f'{source_detail.talent.talent.name} for student {source_participation.student_id} must have a score of at least 50%.')
                            continue

                        target_participation, _ = CompetitionParticipation.objects.get_or_create(
                            competition=target_competition,
                            student_id=source_participation.student_id,
                            defaults={'status': 'finished', 'score': None},
                        )
                        target_participation.status = 'finished'
                        target_participation.score = source_score
                        target_participation.save(update_fields=['status', 'score'])
                        target_result, _ = Result.objects.get_or_create(
                            participation=target_participation,
                            defaults={'score': source_score, 'approval_status': 'pending'},
                        )
                        target_detail, _ = ResultDetail.objects.get_or_create(
                            result=target_result,
                            talent=source_detail.talent,
                            defaults={'raw_score': source_score, 'percentage_score': source_score},
                        )
                        promotion, _ = ResultPromotion.objects.get_or_create(
                            result=source_result,
                            result_detail=source_detail,
                            to_level='zone',
                            defaults={'from_level': 'district', 'promoted_by': request.user, 'target_competition': target_competition, 'notes': f'Promoted talent to zone competition {target_competition.name}'},
                        )
                        ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='zone')
                        source_detail.promoted_to = 'zone'
                        promoted.append({'student_id': int(source_participation.student_id), 'result_id': target_result.id, 'result_detail_id': target_detail.id, 'competition_id': target_competition.id, 'promotion_id': promotion.id})

                return Response({'promoted': len(promoted), 'errors': errors, 'data': promoted})

            if to_level != 'country' or not request.user.zone_id:
                return Response({'error': 'Zone managers can promote only to the zone or country level for their assigned zone.'}, status=status.HTTP_400_BAD_REQUEST)

            target_competition_id = request.data.get('country_competition_id')
            if not target_competition_id:
                return Response({'error': 'country_competition_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

            country_type = ContentType.objects.get_for_model(Country)
            target_competition = Competition.objects.filter(
                id=target_competition_id,
                level='country',
            ).filter(
                Q(content_type=country_type, object_id=request.user.country_id)
                | Q(schools__country_id=request.user.country_id)
            ).first()
            if not target_competition:
                return Response({'error': 'The selected country competition does not belong to your country.'}, status=status.HTTP_404_NOT_FOUND)

            source_competition = Competition.objects.filter(
                id=competition_id,
                level='zone',
            ).filter(
                Q(content_type=ContentType.objects.get_for_model(Zone), object_id=request.user.zone_id)
                | Q(schools__zone_id=request.user.zone_id)
            ).first()
            if not source_competition:
                return Response({'error': 'The selected zone competition does not belong to your zone.'}, status=status.HTTP_404_NOT_FOUND)

            submission, _ = ZoneCompetitionSubmission.objects.get_or_create(
                zone_id=request.user.zone_id,
                competition=source_competition,
            )
            submission.status = 'submitted'
            submission.submitted_by = request.user
            submission.submitted_at = timezone.now()
            submission.save(update_fields=['status', 'submitted_by', 'submitted_at'])

            if not detail_ids:
                source_details = ResultDetail.objects.select_related('result__participation__student').filter(
                    result__participation__competition=source_competition,
                    result__participation__student__school__zone_id=request.user.zone_id,
                )
                detail_ids = [
                    detail.id for detail in source_details
                    if (detail.percentage_score if detail.percentage_score is not None else detail.raw_score) is not None
                    and (detail.percentage_score if detail.percentage_score is not None else detail.raw_score) >= 50
                ]

            if not detail_ids:
                return Response({'error': 'No qualifying zone results were found to submit.'}, status=status.HTTP_400_BAD_REQUEST)

            promoted = []
            errors = []
            with transaction.atomic():
                source_details = ResultDetail.objects.select_related('result__participation__student').filter(
                    id__in=detail_ids,
                    result__participation__competition=source_competition,
                    result__participation__student__school__zone_id=request.user.zone_id,
                )
                for source_detail in source_details:
                    source_result = source_detail.result
                    source_participation = source_result.participation
                    source_score = source_detail.percentage_score if source_detail.percentage_score is not None else source_detail.raw_score
                    if source_score is None or source_score < 50:
                        errors.append(f'{source_detail.talent.talent.name} for student {source_participation.student_id} must have a score of at least 50%.')
                        continue

                    target_participation, _ = CompetitionParticipation.objects.get_or_create(
                        competition=target_competition,
                        student_id=source_participation.student_id,
                        defaults={'status': 'finished', 'score': None},
                    )
                    target_participation.status = 'finished'
                    target_participation.score = source_score
                    target_participation.save(update_fields=['status', 'score'])
                    target_result, _ = Result.objects.get_or_create(
                        participation=target_participation,
                        defaults={'score': source_score, 'approval_status': 'pending'},
                    )
                    target_detail, _ = ResultDetail.objects.get_or_create(
                        result=target_result,
                        talent=source_detail.talent,
                        defaults={'raw_score': source_score, 'percentage_score': source_score},
                    )
                    promotion, _ = ResultPromotion.objects.get_or_create(
                        result=source_result,
                        result_detail=source_detail,
                        to_level='country',
                        defaults={'from_level': 'zone', 'promoted_by': request.user, 'notes': f'Promoted talent to country competition {target_competition.name}'},
                    )
                    ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='country')
                    source_detail.promoted_to = 'country'
                    promoted.append({'student_id': int(source_participation.student_id), 'result_id': target_result.id, 'result_detail_id': target_detail.id, 'competition_id': target_competition.id, 'promotion_id': promotion.id})

            return Response({'promoted': len(promoted), 'errors': errors, 'data': promoted, 'submission': ZoneCompetitionSubmissionSerializer(submission).data})

        # Verify competition exists and belongs to school
        competition = Competition.objects.filter(
            id=competition_id,
            schools=request.user.school
        ).first()
        
        if not competition:
            return Response({
                'error': 'Competition not found or not associated with your school'
            }, status=status.HTTP_404_NOT_FOUND)
        
        promotions = []
        errors = []
        
        with transaction.atomic():
            if detail_ids:
                details = ResultDetail.objects.select_related('result__participation__student').filter(
                    id__in=detail_ids,
                    result__participation__competition_id=competition_id,
                    result__participation__student__school=request.user.school,
                    passed=True,
                )
                for detail in details:
                    promotion = ResultPromotion.objects.create(
                        result=detail.result,
                        result_detail=detail,
                        to_level=to_level,
                        from_level=from_level,
                        promoted_by=request.user,
                        promoted_at=timezone.now(),
                    )
                    detail.promoted_to = to_level
                    detail.save(update_fields=['promoted_to'])
                    if to_level == 'district':
                        district = detail.result.participation.student.school.district
                        district_type = ContentType.objects.get_for_model(District)
                        next_competition = Competition.objects.filter(
                            level='district',
                            content_type=district_type,
                            object_id=district.pk,
                            status__in=('approved', 'pending_approval'),
                        ).order_by('start_date').first()
                        if next_competition:
                            next_participation, _ = CompetitionParticipation.objects.get_or_create(
                                competition=next_competition,
                                student=detail.result.participation.student,
                                defaults={'status': 'registered', 'score': None},
                            )
                            next_result, _ = Result.objects.get_or_create(participation=next_participation, defaults={'score': None})
                            ResultDetail.objects.get_or_create(
                                result=next_result,
                                talent=detail.talent,
                                defaults={'raw_score': detail.percentage_score or detail.raw_score, 'percentage_score': detail.percentage_score or detail.raw_score},
                            )
                    promotions.append(promotion)
            for student_id in student_ids:
                try:
                    # Check if student exists in school
                    student = Student.objects.get(id=student_id, school=request.user.school)
                    
                    # Check participation exists
                    participation = CompetitionParticipation.objects.filter(
                        competition_id=competition_id,
                        student=student
                    ).first()
                    
                    if not participation:
                        errors.append(f"Student {student_id} not registered for this competition")
                        continue
                    
                    # Create promotion
                    source_result = Result.objects.filter(participation=participation).first()
                    if not source_result:
                        errors.append(f'No result found for student {student_id} in this competition')
                        continue

                    promotion = ResultPromotion.objects.create(
                        result=source_result,
                        to_level=to_level,
                        from_level=from_level,
                        promoted_by=request.user,
                        promoted_at=timezone.now()
                    )
                    promotions.append(promotion)
                    
                except Student.DoesNotExist:
                    errors.append(f"Student {student_id} not found in your school")
                except Exception as e:
                    errors.append(str(e))
        
        serializer = self.get_serializer(promotions, many=True)
        return Response({
            'promoted': len(promotions),
            'errors': errors,
            'data': serializer.data
        })


class SchoolCompetitionSubmissionViewSet(ScopedQuerysetMixin, viewsets.ModelViewSet):
    queryset = SchoolCompetitionSubmission.objects.select_related('school', 'competition').all()
    serializer_class = SchoolCompetitionSubmissionSerializer
    permission_classes = [AuthenticatedReadOnly]
    scope_paths = {'school': 'school_id', 'country': 'school__country_id', 'zone': 'school__zone_id', 'region': 'school__region_id', 'district': 'school__district_id', 'ward': 'school__ward_id'}

    def perform_create(self, serializer):
        user = self.request.user
        school = serializer.validated_data.get('school')
        competition = serializer.validated_data['competition']

        if user.role in {'head_teacher', 'sport_teacher'}:
            if not user.school_id:
                from rest_framework.exceptions import PermissionDenied
                raise PermissionDenied('Only a school teacher can create this submission.')
            if competition.level != 'school' or not competition.schools.filter(pk=user.school_id).exists():
                from rest_framework.exceptions import ValidationError
                raise ValidationError({'competition': 'This competition is not available to your school.'})
            serializer.save(school=user.school)
            return

        if user.role == 'district_manager':
            if not user.district_id:
                from rest_framework.exceptions import PermissionDenied
                raise PermissionDenied('District managers must be assigned to a district.')
            if school is None or school.district_id != user.district_id:
                from rest_framework.exceptions import ValidationError
                raise ValidationError({'school': 'This school is not in your district.'})
            if competition.level != 'school' or not competition.schools.filter(pk=school.pk).exists():
                from rest_framework.exceptions import ValidationError
                raise ValidationError({'competition': 'This competition is not available to the selected school.'})
            serializer.save(school=school)
            return

        from rest_framework.exceptions import PermissionDenied
        raise PermissionDenied('Only school teachers or district managers can create this submission.')

    @action(detail=True, methods=['post'])
    def submit(self, request, pk=None):
        submission = self.get_object()
        is_school_teacher = request.user.role in {'head_teacher', 'sport_teacher'} and submission.school_id == request.user.school_id
        is_district_manager = request.user.role == 'district_manager' and submission.school.district_id == request.user.district_id
        if not (is_school_teacher or is_district_manager):
            return Response({'detail': 'Only the school teacher or assigned district manager can submit these results.'}, status=status.HTTP_403_FORBIDDEN)
        submission.status = 'submitted'
        submission.submitted_by = request.user
        submission.submitted_at = timezone.now()
        submission.save(update_fields=['status', 'submitted_by', 'submitted_at'])
        return Response(self.get_serializer(submission).data)

    @action(detail=True, methods=["post"])
    def finalize_promotion(self, request, pk=None):
        submission = self.get_object()

        if (
            request.user.role != "district_manager"
            or not request.user.district_id
            or submission.school.district_id != request.user.district_id
        ):
            return Response(
                {"detail": "Only the assigned district manager can finalize this decision."},
                status=status.HTTP_403_FORBIDDEN,
            )

        if submission.status != "submitted":
            return Response(
                {"detail": "Only submitted school results can be finalized."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        target_id = request.data.get("district_competition_id")
        if not target_id:
            return Response(
                {"district_competition_id": "This field is required."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        district_type = ContentType.objects.get_for_model(District)
        target = Competition.objects.filter(
            id=target_id,
            level="district",
        ).filter(
            Q(content_type=district_type, object_id=request.user.district_id)
            | Q(schools__district_id=request.user.district_id)
        ).distinct().first()

        if target is None:
            return Response(
                {"detail": "District competition not found in your district."},
                status=status.HTTP_404_NOT_FOUND,
            )

        details = ResultDetail.objects.filter(
            result__participation__competition=submission.competition,
            result__participation__student__school_id=submission.school_id,
        )

        promotions = ResultPromotion.objects.filter(
            result_detail__in=details,
            to_level="district",
        )

        if promotions.exclude(
            target_competition=target
        ).filter(target_competition__isnull=False).exists():
            return Response(
                {"detail": "Some talents are assigned to another district competition."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            ResultPromotion.objects.filter(
                result_detail__in=details,
                to_level="district",
                target_competition__isnull=True,
            ).update(target_competition=target)

            selected_ids = ResultPromotion.objects.filter(
                result_detail__in=details,
                to_level="district",
                target_competition=target,
            ).values_list("result_detail_id", flat=True)

            promoted_count = details.filter(
                pk__in=selected_ids
            ).update(promotion_status="promoted")

            not_promoted_count = details.exclude(
                pk__in=selected_ids
            ).update(promotion_status="not_promoted")

        return Response({
            "detail": "Promotion decision finalized successfully.",
            "competition_id": target.id,
            "promoted": promoted_count,
            "not_promoted": not_promoted_count,
        })

    @action(detail=True, methods=['post'])
    def reopen(self, request, pk=None):
        submission = self.get_object()
        if request.user.role != 'district_manager' or submission.school.district_id != request.user.district_id:
            return Response({'detail': 'Only the assigned district manager can reopen this submission.'}, status=status.HTTP_403_FORBIDDEN)
        district_promotions = ResultPromotion.objects.select_related(
            'result_detail',
            'result__participation__student',
        ).filter(
            result__participation__competition=submission.competition,
            to_level='district',
            result__participation__student__school_id=submission.school_id,
        )

        demoted_count = 0
        with transaction.atomic():
            ResultDetail.objects.filter(
                result__participation__competition=submission.competition,
                result__participation__student__school_id=submission.school_id,
            ).update(promotion_status='pending')
            for promotion in district_promotions:
                source_detail = promotion.result_detail
                if source_detail:
                    ResultDetail.objects.filter(pk=source_detail.pk).update(promoted_to='', promotion_status='pending')

                student_id = promotion.result.participation.student_id
                talent_id = source_detail.talent_id if source_detail else None
                district_details = ResultDetail.objects.select_related('result__participation').filter(
                    result__participation__student_id=student_id,
                    result__participation__competition__level='district',
                    talent_id=talent_id,
                )
                if promotion.target_competition_id:
                    district_details = district_details.filter(
                        result__participation__competition_id=promotion.target_competition_id
                    )
                else:
                    district_details = district_details.filter(
                        Q(
                            result__participation__competition__content_type=ContentType.objects.get_for_model(District),
                            result__participation__competition__object_id=submission.school.district_id,
                        )
                        | Q(
                            result__participation__competition__schools__district_id=submission.school.district_id
                        )
                    ).distinct()
                for district_detail in district_details:
                    district_result = district_detail.result
                    district_participation = district_result.participation
                    downstream_promotions = ResultPromotion.objects.filter(
                        result=district_result,
                        to_level='zone',
                    )
                    for downstream_promotion in downstream_promotions:
                        zone_details = ResultDetail.objects.select_related('result__participation').filter(
                            result__participation__student_id=student_id,
                            result__participation__competition__level='zone',
                            talent_id=talent_id,
                        )
                        if downstream_promotion.target_competition_id:
                            zone_details = zone_details.filter(
                                result__participation__competition_id=downstream_promotion.target_competition_id
                            )
                        else:
                            zone_details = zone_details.filter(
                                Q(
                                    result__participation__competition__content_type=ContentType.objects.get_for_model(Zone),
                                    result__participation__competition__object_id=submission.school.district.region.zone_id,
                                )
                                | Q(
                                    result__participation__competition__schools__zone_id=submission.school.district.region.zone_id
                                )
                            ).distinct()
                        for zone_detail in zone_details:
                            zone_result = zone_detail.result
                            zone_participation = zone_result.participation
                            zone_detail.delete()
                            remove_empty_result_chain(zone_result, zone_participation)
                        downstream_promotion.delete()

                    district_detail.delete()
                    remove_empty_result_chain(district_result, district_participation)

                promotion.delete()
                demoted_count += 1

            submission.status = 'draft'
            submission.save(update_fields=['status'])

        data = self.get_serializer(submission).data
        data['demoted'] = demoted_count
        return Response(data)