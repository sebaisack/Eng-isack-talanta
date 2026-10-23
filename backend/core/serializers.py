import re

from rest_framework import serializers

from students.models import Student

from .models import (
    Country, Zone, Region, District, Ward, School, SchoolOwnershipType, User,
    Talent, TalentCategory, StudentTalent, Announcement, CountryClub, SchoolClub, ClubTeacher,
    StudentClubMembership, EvaluationCriterion, TalentEvaluation, EvaluationScore,
    TalentSubmission, SubmissionFeedback, Message, Notification, AuditLog,
)


class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Country
        fields = ['id', 'name', 'code']


class ZoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = Zone
        fields = ['id', 'country', 'name']


class RegionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Region
        fields = ['id', 'zone', 'name']


class DistrictSerializer(serializers.ModelSerializer):
    class Meta:
        model = District
        fields = ['id', 'region', 'name']


class WardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ward
        fields = ['id', 'district', 'name']


class SchoolOwnershipTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SchoolOwnershipType
        fields = ['id', 'name', 'is_active', 'created_at']


class SchoolSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = [
            'id',
            'registry_number',
            'name',
            'ownership_type',
            'country',
            'zone',
            'region',
            'district',
            'ward',
            'city_council',
            'street_village',
            'phone',
            'physical_address',
            'email',
            'is_approved',
            'is_active',
            'created_at',
        ]
        read_only_fields = ['is_approved', 'is_active', 'created_at']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        request = self.context.get('request')
        user = getattr(request, 'user', None) if request else None

        if getattr(user, 'role', None) == 'district_manager':
            for field_name in ('country', 'zone', 'region', 'district'):
                self.fields[field_name].read_only = True

    def create(self, validated_data):
        request = self.context.get('request')
        user = getattr(request, 'user', None) if request else None
        validated_data['is_approved'] = bool(user and getattr(user, 'role', None) == 'talent_admin')
        return super().create(validated_data)

    def validate_name(self, value):
        value = value.strip()
        if not value or not value.istitle():
            raise serializers.ValidationError(
                "Use title case for every word, e.g. Azania Secondary School."
            )
        return value

    def validate_registry_number(self, value):
        value = value.strip()
        if not re.fullmatch(r"[A-Za-z]\.?[0-9]{3,4}", value):
            raise serializers.ValidationError(
                "Use a valid registry number, e.g. S2047, S703, p0655 or s.0677."
            )
        return value

    def validate_phone(self, value):
        if not value:
            return value

        country_id = self.initial_data.get(
            'country',
            getattr(self.instance, 'country_id', None)
        )
        country = Country.objects.filter(pk=country_id).first()
        country_code = (
            (country.code or '').strip().upper()
            if country else ''
        )
        is_tanzania = (
            country_code in {'TZ', 'TZA'}
            or (
                country is not None
                and country.name.strip().lower() == 'tanzania'
            )
        )

        if is_tanzania:
            if not re.fullmatch(r"\+255[0-9]{9}", value):
                raise serializers.ValidationError(
                    "Enter +255 followed by exactly 9 digits, without spaces."
                )
        elif not re.fullmatch(r"[0-9]+", value):
            raise serializers.ValidationError(
                "For countries outside Tanzania, enter digits only."
            )

        duplicates = School.objects.filter(phone=value)
        if self.instance:
            duplicates = duplicates.exclude(pk=self.instance.pk)
        if duplicates.exists():
            raise serializers.ValidationError(
                "This phone number is already registered to another school."
            )
        return value

    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None) if request else None

        country = attrs.get(
            'country',
            getattr(self.instance, 'country', None)
        )
        zone = attrs.get('zone')
        region = attrs.get('region')
        district = attrs.get('district')
        ward = attrs.get('ward')
        ownership_type = attrs.get('ownership_type')

        # Restrict District Managers to their assigned district.
        if getattr(user, 'role', None) == 'district_manager':
            assigned_district = getattr(user, 'district', None)

            if assigned_district is None:
                raise serializers.ValidationError({
                    'district': 'Your account is not assigned to a district. Contact the Talent Admin.'
                })

            if district and district.pk != assigned_district.pk:
                raise serializers.ValidationError({
                    'district': 'You can register schools only in your assigned district.'
                })

            district = assigned_district
            attrs['district'] = district

            region = district.region
            zone = region.zone
            country = zone.country

            for field_name, submitted, expected in (
                ('country', attrs.get('country'), country),
                ('zone', attrs.get('zone'), zone),
                ('region', attrs.get('region'), region),
            ):
                if submitted and submitted.pk != expected.pk:
                    raise serializers.ValidationError({
                        field_name: 'This location must match your assigned district.'
                    })
                attrs[field_name] = expected

        # Validate the location fields according to the selected country.
        # District Manager restrictions above remain in force.
        country_code = (
            (getattr(country, 'code', '') or '').strip().upper()
        )
        is_tanzania = (
            country_code in {'TZ', 'TZA'}
            or (
                country is not None
                and getattr(country, 'name', '').strip().lower() == 'tanzania'
            )
        )

        if is_tanzania:
            required_locations = {
                'zone': zone if zone is not None else getattr(self.instance, 'zone', None),
                'region': region if region is not None else getattr(self.instance, 'region', None),
                'district': district if district is not None else getattr(self.instance, 'district', None),
                'ward': ward if ward is not None else getattr(self.instance, 'ward', None),
            }
            missing = [
                field for field, value in required_locations.items()
                if value is None
            ]
            if missing:
                raise serializers.ValidationError({
                    field: 'This field is required for schools in Tanzania.'
                    for field in missing
                })
        else:
            city_council = (
                attrs.get('city_council')
                if 'city_council' in attrs
                else getattr(self.instance, 'city_council', '')
            )
            street_village = (
                attrs.get('street_village')
                if 'street_village' in attrs
                else getattr(self.instance, 'street_village', '')
            )

            if not (city_council or '').strip():
                raise serializers.ValidationError({
                    'city_council': 'City / Council is required outside Tanzania.'
                })
            if not (street_village or '').strip():
                raise serializers.ValidationError({
                    'street_village': 'Street / Village is required outside Tanzania.'
                })

            attrs['zone'] = None
            attrs['region'] = None
            attrs['district'] = None
            attrs['ward'] = None

        if ownership_type:
            active_names = set(
                SchoolOwnershipType.objects.filter(
                    is_active=True
                ).values_list('name', flat=True)
            )
            if ownership_type not in active_names:
                raise serializers.ValidationError({
                    'ownership_type': 'Choose a valid school ownership type.'
                })

        if zone and country and zone.country_id != country.pk:
            raise serializers.ValidationError({
                'zone': 'Choose a zone belonging to the selected country.'
            })
        if region and zone and region.zone_id != zone.pk:
            raise serializers.ValidationError({
                'region': 'Choose a region belonging to the selected zone.'
            })
        if district and region and district.region_id != region.pk:
            raise serializers.ValidationError({
                'district': 'Choose a district belonging to the selected region.'
            })
        if ward and district and ward.district_id != district.pk:
            raise serializers.ValidationError({
                'ward': 'Choose a ward belonging to the selected district.'
            })
        if ward and region and ward.district.region_id != region.pk:
            raise serializers.ValidationError({
                'ward': 'Choose a ward belonging to the selected region.'
            })

        return attrs


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)
    school_name = serializers.CharField(source='school.name', read_only=True, allow_null=True)
    district_name = serializers.CharField(source='district.name', read_only=True, allow_null=True)
    student_id = serializers.CharField(source='student.student_id', read_only=True, allow_null=True)

    class Meta:
        model = User
        fields = [
            'id', 'username', 'password', 'first_name', 'last_name', 'email', 'phone',
            'role', 'school', 'school_name', 'student', 'student_id', 'country', 'zone', 'region', 'district', 'district_name', 'ward', 'city_council', 'street_village',
        ]

    def validate_phone(self, value):
        if value and not re.fullmatch(r'(?:0\d{9}|\+255\d{9})', value):
            raise serializers.ValidationError('Use 10 digits starting with 0 or 13 characters starting with +255.')
        return value

    def validate(self, attrs):
        country = attrs.get("country", getattr(self.instance, "country", None))
        if country is not None:
            country_name = str(getattr(country, "name", "") or "").strip().lower()
            country_code = str(getattr(country, "code", "") or "").strip().lower()
            is_tanzania = (
                country_name == "tanzania"
                or country_code in {"tz", "tza"}
            )

            if is_tanzania:
                attrs["city_council"] = ""
                attrs["street_village"] = ""
            else:
                city_council = attrs.get(
                    "city_council",
                    getattr(self.instance, "city_council", ""),
                )
                street_village = attrs.get(
                    "street_village",
                    getattr(self.instance, "street_village", ""),
                )

                if not str(city_council or "").strip():
                    raise serializers.ValidationError({
                        "city_council": "City/Council is required outside Tanzania."
                    })
                if not str(street_village or "").strip():
                    raise serializers.ValidationError({
                        "street_village": "Street/Village is required outside Tanzania."
                    })

                attrs["zone"] = None
                attrs["region"] = None
                attrs["district"] = None
                attrs["ward"] = None

        role = attrs.get('role', getattr(self.instance, 'role', None))
        school = attrs.get('school', getattr(self.instance, 'school', None))

        request = self.context.get('request')
        requester = getattr(request, 'user', None)

        is_super_admin = bool(
            requester
            and requester.is_authenticated
            and requester.is_superuser
        )
        is_admin = bool(
            requester
            and requester.is_authenticated
            and requester.role == 'admin'
            and not requester.is_superuser
        )

        # Only Super Admin and Admin may create new Admin accounts.
        if (
            self.instance is None
            and role == 'admin'
            and not (is_super_admin or is_admin)
        ):
            raise serializers.ValidationError({
                'role': 'Only Super Admin or Admin can create Admin accounts.'
            })

        # A regular Admin may not promote an existing account to Admin,
        # change another Admin's role, or change their own role.
        if is_admin and self.instance is not None and 'role' in attrs:
            requested_role = attrs['role']

            if requested_role != self.instance.role:
                raise serializers.ValidationError({
                    'role': 'Admin cannot change their own role or change another account role.'
                })

        # Allow only one manager of each role per geographic area.
        manager_scope = {
            'region_manager': ('region', 'region_id'),
            'zone_manager': ('zone', 'zone_id'),
            'district_manager': ('district', 'district_id'),
            'ward_manager': ('ward', 'ward_id'),
        }

        if role in manager_scope:
            field, lookup = manager_scope[role]
            area = attrs.get(field, getattr(self.instance, field, None))

            if area is not None:
                existing = User.objects.filter(
                    role=role,
                    **{lookup: area.pk},
                )

                if self.instance is not None:
                    existing = existing.exclude(pk=self.instance.pk)

                if existing.exists():
                    raise serializers.ValidationError({
                        field: f'This {dict(region="region", zone="zone", district="district", ward="ward").get(field, "area")} already has a {dict(region="Region", zone="Zone", district="District", ward="Ward").get(field, "Area")} Manager. You cannot register another manager for this {dict(region="region", zone="zone", district="district", ward="ward").get(field, "area")}.'
                    })

        if role == 'student' and not school:
            raise serializers.ValidationError({
                'school': 'A student account must be assigned to a school.'
            })

        if role in {'sport_teacher', 'head_teacher'} and not school:
            raise serializers.ValidationError({
                'school': 'A sport teacher or head teacher account must be assigned to a school.'
            })

        if role == 'sport_teacher' and school:
            assigned_teachers = User.objects.filter(
                role='sport_teacher',
                school=school,
            )

            if self.instance is not None:
                assigned_teachers = assigned_teachers.exclude(
                    pk=self.instance.pk
                )

            if assigned_teachers.exists():
                raise serializers.ValidationError({
                    'school': 'This school already has a sport teacher assigned. Choose another school.'
                })

            ward = attrs.get('ward', getattr(self.instance, 'ward', None))
            if ward and school.ward_id != ward.pk:
                raise serializers.ValidationError({
                    'school': 'Choose a school belonging to the selected ward.'
                })

        return attrs

    def _ensure_student_link(self, user, validated_data):
        if user.role != 'student':
            return user

        if user.student_id:
            return user

        school = validated_data.get('school') or user.school
        if isinstance(school, int):
            school = School.objects.filter(pk=school).first()
        if school is None:
            raise serializers.ValidationError({'school': 'A student account must be assigned to a school.'})

        student = Student.objects.filter(
            first_name=user.first_name,
            last_name=user.last_name,
            school=school,
        ).order_by('-id').first()

        if student is None:
            student = Student.objects.create(
                first_name=user.first_name or '',
                last_name=user.last_name or '',
                gender='O',
                school=school,
                date_of_birth=None,
            )

        user.student = student
        user.school = school
        user.save(update_fields=['student', 'school'])
        return user

    def create(self, validated_data):
        password = validated_data.pop('password', None)

        for field_name in ['school', 'country', 'zone', 'region', 'district', 'ward']:
            value = validated_data.get(field_name)
            if isinstance(value, int):
                model_map = {
                    'school': School,
                    'country': Country,
                    'zone': Zone,
                    'region': Region,
                    'district': District,
                    'ward': Ward,
                }
                model_class = model_map[field_name]
                validated_data[field_name] = model_class.objects.filter(pk=value).first()

        user = User(**validated_data)
        if password:
            user.set_password(password)
        user.save()
        self._ensure_student_link(user, validated_data)
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for field_name in ['school', 'country', 'zone', 'region', 'district', 'ward']:
            value = validated_data.get(field_name)
            if isinstance(value, int):
                model_map = {
                    'school': School,
                    'country': Country,
                    'zone': Zone,
                    'region': Region,
                    'district': District,
                    'ward': Ward,
                }
                model_class = model_map[field_name]
                validated_data[field_name] = model_class.objects.filter(pk=value).first()
        for field, value in validated_data.items():
            setattr(instance, field, value)
        if password:
            instance.set_password(password)
        instance.save()
        self._ensure_student_link(instance, validated_data)
        return instance


class TalentCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = TalentCategory
        fields = ['id', 'name', 'description', 'is_active', 'created_at']


class TalentSerializer(serializers.ModelSerializer):
    student_count = serializers.IntegerField(read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Talent
        fields = ['id', 'name', 'category', 'category_name', 'description', 'student_count', 'created_at']


class StudentTalentSerializer(serializers.ModelSerializer):
    talent_name = serializers.CharField(source='talent.name', read_only=True)
    talent_category = serializers.CharField(source='talent.category.name', read_only=True)
    student_name = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = StudentTalent
        fields = [
            'id',
            'student',
            'student_name',
            'talent',
            'talent_name',
            'talent_category',
            'proficiency_level',
            'notes',
            'added_at',
        ]

    def validate(self, attrs):
        student = attrs.get('student', getattr(self.instance, 'student', None))
        if student is None and self.initial_data.get('student'):
            student = StudentTalent._meta.get_field('student').remote_field.model.objects.get(pk=self.initial_data['student'])
        if student:
            existing = StudentTalent.objects.filter(student=student).exclude(pk=getattr(self.instance, 'pk', None)).count()
            if existing >= 5:
                raise serializers.ValidationError('A student may have at most five talents.')
        return attrs

    def get_student_name(self, obj):
        return f"{obj.student.first_name} {obj.student.last_name}"


class AnnouncementSerializer(serializers.ModelSerializer):
    scope_display = serializers.CharField(source='get_scope_display', read_only=True)

    class Meta:
        model = Announcement
        fields = [
            'id',
            'title',
            'content',
            'scope',
            'scope_display',
            'audience',
            'country',
            'zone',
            'region',
            'district',
            'school',
            'is_active',
            'published_at',
            'expires_at',
            'created_at',
            'updated_at',
        ]

    def validate(self, attrs):
        scope = attrs.get('scope', getattr(self.instance, 'scope', None))
        target_fields = {
            'zone': 'zone',
            'region': 'region',
            'district': 'district',
            'school': 'school',
        }
        target_field = target_fields.get(scope)
        target = attrs[target_field] if target_field in attrs else getattr(self.instance, f'{target_field}_id', None)
        if target_field and not target:
            raise serializers.ValidationError({target_field: f'{target_field.title()} is required for {scope} announcements.'})

        published_at = attrs.get(
            'published_at',
            getattr(self.instance, 'published_at', None),
        )
        expires_at = attrs.get(
            'expires_at',
            getattr(self.instance, 'expires_at', None),
        )
        if published_at and expires_at and expires_at <= published_at:
            raise serializers.ValidationError({
                'expires_at': 'Expire date and time must be later than the starting date and time.'
            })
        return attrs


class CountryClubSerializer(serializers.ModelSerializer):
    class Meta:
        model = CountryClub
        fields = ['id', 'name', 'focus', 'description', 'country', 'is_active', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']


class SchoolClubSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source='country_club.name', read_only=True)
    focus = serializers.CharField(source='country_club.focus', read_only=True)
    description = serializers.CharField(source='country_club.description', read_only=True)
    country = serializers.IntegerField(source='country_club.country_id', read_only=True)

    class Meta:
        model = SchoolClub
        fields = ['id', 'name', 'focus', 'description', 'school', 'country_club', 'country', 'is_active', 'selected_at']
        read_only_fields = ['selected_at']

    def validate(self, attrs):
        school = attrs.get('school', getattr(self.instance, 'school', None))
        country_club = attrs.get('country_club', getattr(self.instance, 'country_club', None))
        if school and country_club and school.country_id != country_club.country_id:
            raise serializers.ValidationError('A school can only select clubs from its country.')
        if school and attrs.get('is_active', getattr(self.instance, 'is_active', True)):
            existing = SchoolClub.objects.filter(school=school, is_active=True).exclude(pk=getattr(self.instance, 'pk', None)).count()
            if existing >= school.recommended_club_count:
                raise serializers.ValidationError('This school has reached its maximum club limit.')
        return attrs


class ClubTeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = ClubTeacher
        fields = '__all__'


class StudentClubMembershipSerializer(serializers.ModelSerializer):
    club_name = serializers.CharField(source='club.country_club.name', read_only=True)

    class Meta:
        model = StudentClubMembership
        fields = ['id', 'student', 'club', 'club_name', 'joined_at', 'left_at', 'is_active', 'transfer_reason']
        read_only_fields = ['joined_at']

    def validate(self, attrs):
        student = attrs.get('student', getattr(self.instance, 'student', None))
        club = attrs.get('club', getattr(self.instance, 'club', None))
        is_active = attrs.get('is_active', getattr(self.instance, 'is_active', True))
        if student and club and student.school_id != club.school_id:
            raise serializers.ValidationError('A student can only join a club in their school.')
        if student and is_active:
            existing = StudentClubMembership.objects.filter(student=student, is_active=True).exclude(pk=getattr(self.instance, 'pk', None)).exists()
            if existing:
                raise serializers.ValidationError('A student can only have one active club membership.')
        return attrs


class EvaluationCriterionSerializer(serializers.ModelSerializer):
    class Meta:
        model = EvaluationCriterion
        fields = '__all__'

    def validate_weight(self, value):
        if value < 0 or value > 100:
            raise serializers.ValidationError('Weight must be between 0 and 100.')
        return value


class EvaluationScoreSerializer(serializers.ModelSerializer):
    class Meta:
        model = EvaluationScore
        fields = '__all__'

    def validate_score(self, value):
        if value < 0 or value > 100:
            raise serializers.ValidationError('Score must be between 0 and 100.')
        return value

    def validate(self, attrs):
        evaluation = attrs.get('evaluation', getattr(self.instance, 'evaluation', None))
        criterion = attrs.get('criterion', getattr(self.instance, 'criterion', None))
        if evaluation and criterion and criterion.talent_id != evaluation.student_talent.talent_id:
            raise serializers.ValidationError('Criterion must belong to the evaluated talent.')
        return attrs


class TalentEvaluationSerializer(serializers.ModelSerializer):
    scores = EvaluationScoreSerializer(many=True, read_only=True)

    class Meta:
        model = TalentEvaluation
        fields = '__all__'
        read_only_fields = ['total_score', 'grade', 'passed', 'evaluated_at', 'updated_at', 'evaluator']


class TalentSubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TalentSubmission
        fields = '__all__'
        read_only_fields = ['status', 'submitted_at', 'reviewed_at', 'reviewed_by']


class SubmissionFeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubmissionFeedback
        fields = '__all__'
        read_only_fields = ['author', 'created_at']


class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = '__all__'
        read_only_fields = ['sender', 'created_at', 'read_at']


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'
        read_only_fields = ['recipient', 'created_at', 'read_at']


class AuditLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = AuditLog
        fields = '__all__'
        read_only_fields = ['actor', 'created_at']