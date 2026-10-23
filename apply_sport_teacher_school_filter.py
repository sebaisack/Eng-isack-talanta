from pathlib import Path
from datetime import datetime
import shutil

frontend = Path("frontend/src/pages/TalentAdminPage.jsx")
backend = Path("backend/core/serializers.py")

f = frontend.read_text(encoding="utf-8")
b = backend.read_text(encoding="utf-8")

old_f = """  const filteredUserSchools = schools.filter((school) => {
    if (
      userForm.country &&
      Number(school.country) !== Number(userForm.country)
    ) {
      return false;
    }

    if (
      userForm.zone &&
      Number(school.zone) !== Number(userForm.zone)
    ) {
      return false;
    }

    if (
      userForm.region &&
      Number(school.region) !== Number(userForm.region)
    ) {
      return false;
    }

    if (
      userForm.district &&
      Number(school.district) !== Number(userForm.district)
    ) {
      return false;
    }

    if (
      userForm.ward &&
      Number(school.ward) !== Number(userForm.ward)
    ) {
      return false;
    }

    return true;
  });"""

new_f = """  const filteredUserSchools = schools.filter((school) => {
    if (
      userForm.country &&
      Number(school.country) !== Number(userForm.country)
    ) return false;

    if (
      userForm.zone &&
      Number(school.zone) !== Number(userForm.zone)
    ) return false;

    if (
      userForm.region &&
      Number(school.region) !== Number(userForm.region)
    ) return false;

    if (
      userForm.district &&
      Number(school.district) !== Number(userForm.district)
    ) return false;

    if (
      userForm.ward &&
      Number(school.ward) !== Number(userForm.ward)
    ) return false;

    if (userForm.role === 'sport_teacher') {
      if (
        !userForm.ward ||
        Number(school.ward) !== Number(userForm.ward)
      ) return false;

      const assignedToAnotherSportTeacher = users.some(
        (user) =>
          user.role === 'sport_teacher' &&
          Number(user.school) === Number(school.id) &&
          Number(user.id) !== Number(selectedUser?.id)
      );

      if (assignedToAnotherSportTeacher) return false;
    }

    return true;
  });"""

old_b = """    def validate(self, attrs):
        role = attrs.get('role', getattr(self.instance, 'role', None))
        if role == 'student' and not attrs.get('school', getattr(self.instance, 'school', None)):
            raise serializers.ValidationError({'school': 'A student account must be assigned to a school.'})
        if role in {'sport_teacher', 'head_teacher'} and not attrs.get('school', getattr(self.instance, 'school', None)):
            raise serializers.ValidationError({'school': 'A sport teacher or head teacher account must be assigned to a school.'})
        return attrs
"""

new_b = """    def validate(self, attrs):
        role = attrs.get('role', getattr(self.instance, 'role', None))
        school = attrs.get('school', getattr(self.instance, 'school', None))

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
"""

if f.count(old_f) != 1:
    raise SystemExit("STOP: Frontend code haifanani na tulichokagua. Hakuna mabadiliko yaliyofanywa.")
if b.count(old_b) != 1:
    raise SystemExit("STOP: Backend code haifanani na tulichokagua. Hakuna mabadiliko yaliyofanywa.")

stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
for path in (frontend, backend):
    backup = path.with_name(path.name + f".backup_sport_teacher_{stamp}")
    shutil.copy2(path, backup)
    print("Backup created:", backup)

frontend.write_text(f.replace(old_f, new_f), encoding="utf-8")
backend.write_text(b.replace(old_b, new_b), encoding="utf-8")
print("SUCCESS: Frontend na backend zimebadilishwa.")
