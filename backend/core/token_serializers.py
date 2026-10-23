from rest_framework.exceptions import AuthenticationFailed
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


User = get_user_model()


class StudentAwareTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Custom JWT serializer.

    Allows students to log in using either:
    1. Their actual username, e.g. s4965
    2. Their Student ID, e.g. s4965

    For non-student users, normal username/password login
    continues to work.
    """

    def validate(self, attrs):
        username = attrs.get(self.username_field)

        if username:
            student_user = (
                User.objects
                .filter(
                    student__student_id=username,
                    role='student'
                )
                .first()
            )

            if student_user:
                attrs[self.username_field] = student_user.username

        data = super().validate(attrs)

        user = getattr(self, 'user', None)
        school = None
        if user is not None:
            if getattr(user, 'school_id', None):
                school = user.school
            elif (
                getattr(user, 'role', None) == 'student'
                and getattr(user, 'student_id', None)
            ):
                school = user.student.school

        if school is not None and not school.is_active:
            raise AuthenticationFailed(
                'This school is suspended. Contact the District Manager.'
            )

        return data
