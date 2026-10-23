from rest_framework import serializers

from .models import DistrictCompetitionSubmission, Result, ResultDetail, ResultPromotion, SchoolCompetitionSubmission, ZoneCompetitionSubmission


class SchoolCompetitionSubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = SchoolCompetitionSubmission
        fields = '__all__'
        read_only_fields = ['submitted_by', 'submitted_at', 'approved_by', 'approved_at']


class DistrictCompetitionSubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = DistrictCompetitionSubmission
        fields = '__all__'
        read_only_fields = ['district', 'submitted_by', 'submitted_at']


class ZoneCompetitionSubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ZoneCompetitionSubmission
        fields = '__all__'
        read_only_fields = ['zone', 'submitted_by', 'submitted_at']


class ResultDetailSerializer(serializers.ModelSerializer):
    talent_name = serializers.CharField(source='talent.talent.name', read_only=True)
    student_name = serializers.SerializerMethodField(read_only=True)
    student_username = serializers.SerializerMethodField(read_only=True)
    status = serializers.SerializerMethodField(read_only=True)
    award_status = serializers.SerializerMethodField(read_only=True)
    remark = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = ResultDetail
        fields = [
            'id',
            'result',
            'talent',
            'talent_name',
            'student_name',
            'student_username',
            'raw_score',
            'percentage_score',
            'passed',
            'status',
            'award_status',
            'remark',
            'promoted_to',
            'promotion_status',
            'notes',
            'recorded_at',
        ]
        read_only_fields = ['promotion_status']

    def get_student_name(self, obj):
        student = obj.result.participation.student
        return f"{student.first_name} {student.last_name}"

    def get_student_username(self, obj):
        return obj.result.participation.student.student_id

    def _score(self, obj):
        if obj.percentage_score is not None:
            return obj.percentage_score

        # Promoted students initially arrive at district level without marks.
        # Do not interpret the placeholder raw_score=0 as an actual failure.
        competition = obj.result.participation.competition
        if (
            competition.level == 'district'
            and obj.promotion_status == 'promoted'
            and not obj.promoted_to
        ):
            return None

        return obj.raw_score

    def get_status(self, obj):
        score = self._score(obj)

        if score is None:
            return 'pending'

        # Failed scores always remain FAIL, regardless of promotion status.
        if score < 50:
            return 'fail'

        if obj.promotion_status == 'promoted':
            return 'promoted'

        if obj.promotion_status == 'not_promoted':
            return 'not_promoted'

        return 'pending'

    def get_award_status(self, obj):
        score = self._score(obj)

        if score is not None and score >= 50:
            return 'awarded'

        return 'none'

    def get_remark(self, obj):
        score = self._score(obj)

        if score is None:
            return ''

        if score >= 90:
            return 'Excellent'

        if score >= 75:
            return 'Very Good'

        if score >= 50:
            return 'Good'

        return 'Poor'

    def validate(self, attrs):
        attrs = super().validate(attrs)

        for field_name in ('raw_score', 'percentage_score'):
            score = attrs.get(
                field_name,
                getattr(self.instance, field_name, None)
            )

            if score is not None and not 0 <= score <= 100:
                raise serializers.ValidationError({
                    field_name: 'Score must be between 0 and 100.'
                })

        result = attrs.get('result', getattr(self.instance, 'result', None))
        talent = attrs.get('talent', getattr(self.instance, 'talent', None))

        if result is not None and talent is not None:
            competition = result.participation.competition
            selected_talent_id = getattr(competition, 'talent_id', None)

            if (
                selected_talent_id is not None
                and talent.talent_id != selected_talent_id
            ):
                raise serializers.ValidationError({
                    'talent': (
                        'Talent must match the talent selected '
                        'for this competition.'
                    )
                })

        return attrs


class ResultSerializer(serializers.ModelSerializer):
    participation_details = serializers.SerializerMethodField(read_only=True)
    competition_name = serializers.CharField(source='participation.competition.name', read_only=True)
    competition_level = serializers.CharField(source='participation.competition.level', read_only=True)
    student_name = serializers.SerializerMethodField(read_only=True)
    student_username = serializers.SerializerMethodField(read_only=True)
    status = serializers.SerializerMethodField(read_only=True)
    award_status = serializers.SerializerMethodField(read_only=True)
    remark = serializers.SerializerMethodField(read_only=True)
    details = ResultDetailSerializer(many=True, read_only=True)
    promotions = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Result
        fields = [
            'id',
            'participation',
            'participation_details',
            'competition_name',
            'competition_level',
            'student_name',
            'student_username',
            'score',
            'grade',
            'grade_points',
            'status',
            'award_status',
            'award',
            'remark',
            'rank',
            'venue',
            'competition_date',
            'details',
            'recorded_at',
            'updated_at',
            'approval_status',
            'approved_by',
            'approved_at',
            'promotions',
        ]
        read_only_fields = ['grade', 'grade_points', 'approved_by', 'approved_at', 'promotions']

    def validate(self, attrs):
        participation = attrs.get('participation', getattr(self.instance, 'participation', None))
        score = attrs.get('score', getattr(self.instance, 'score', None))
        award = attrs.get('award', getattr(self.instance, 'award', 'none'))
        if score is not None and not 0 <= score <= 100:
            raise serializers.ValidationError({'score': 'Score must be between 0 and 100.'})
        derived_grade = Result(participation=participation, score=score).calculate_grade() if score is not None else None
        if award != 'none' and derived_grade and derived_grade not in {'A+', 'A', 'A-', 'B+'}:
            raise serializers.ValidationError('Awards require a B+ grade or higher.')
        if participation and participation.status != 'finished':
            raise serializers.ValidationError('A result can only be recorded for a finished participation.')
        return attrs

    def get_participation_details(self, obj):
        return f"{obj.participation.student} – {obj.participation.competition}"

    def get_student_name(self, obj):
        student = obj.participation.student
        return f"{student.first_name} {student.last_name}"

    def get_student_username(self, obj):
        return obj.participation.student.student_id

    def get_status(self, obj):
        if obj.score is None:
            return 'pending'
        return 'pending' if obj.score >= 50 else 'fail'

    def get_award_status(self, obj):
        if obj.score is not None and obj.score >= 50:
            return 'awarded'
        return 'none'

    def get_remark(self, obj):
        if obj.score is None:
            return ''
        if obj.score >= 90:
            return 'Excellent'
        if obj.score >= 75:
            return 'Very Good'
        if obj.score >= 50:
            return 'Good'
        return 'Poor'


class ResultPromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultPromotion
        fields = ['id', 'result', 'result_detail', 'from_level', 'to_level', 'promoted_by', 'promoted_at', 'notes']
        read_only_fields = ['promoted_by', 'promoted_at']

    def validate(self, attrs):
        allowed = {
            'school': 'district',
            'district': 'zone',
            'zone': 'country',
        }
        if attrs.get('from_level') not in allowed or attrs.get('to_level') != allowed.get(attrs.get('from_level')):
            raise serializers.ValidationError('Results must progress from school to district to zone to country.')
        if attrs.get('result_detail'):
            if not attrs['result_detail'].passed:
                raise serializers.ValidationError('Only passed talent results can be promoted.')
            if attrs['result_detail'].result_id != attrs['result'].id:
                raise serializers.ValidationError('Talent result must belong to the selected result.')
        if not attrs['result'].approval_status == 'approved':
            raise serializers.ValidationError('Only approved results can be promoted.')
        if attrs['result'].grade and attrs['result'].grade not in {'A+', 'A', 'A-', 'B+'}:
            raise serializers.ValidationError('Only B+ or higher results can be promoted.')
        return attrs

