from pathlib import Path
import shutil

serializer_path = Path("core/serializers.py")
views_path = Path("core/views.py")

serializer_old = """class TalentSerializer(serializers.ModelSerializer):
    student_count = serializers.SerializerMethodField()
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Talent
        fields = ['id', 'name', 'category', 'category_name', 'description', 'student_count', 'created_at']

    def get_student_count(self, obj):
        return obj.students.count()
"""

serializer_new = """class TalentSerializer(serializers.ModelSerializer):
    student_count = serializers.IntegerField(read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Talent
        fields = ['id', 'name', 'category', 'category_name', 'description', 'student_count', 'created_at']
"""

views_old = """class TalentViewSet(viewsets.ModelViewSet):
    queryset = Talent.objects.select_related(
        'category'
    ).all()
"""

views_new = """class TalentViewSet(viewsets.ModelViewSet):
    queryset = Talent.objects.select_related(
        'category'
    ).annotate(
        student_count=Count('students')
    )
"""

serializer_text = serializer_path.read_text(encoding="utf-8")
views_text = views_path.read_text(encoding="utf-8")

if serializer_old not in serializer_text:
    raise SystemExit(
        "STOP: TalentSerializer haijalingana na code inayotarajiwa. "
        "Hakuna faili lililobadilishwa."
    )

if views_old not in views_text:
    raise SystemExit(
        "STOP: TalentViewSet haijalingana na code inayotarajiwa. "
        "Hakuna faili lililobadilishwa."
    )

if "from django.db.models import Count, Q" not in views_text:
    if "from django.db.models import Q" not in views_text:
        raise SystemExit(
            "STOP: Import ya Q haijapatikana. Hakuna faili lililobadilishwa."
        )

shutil.copy2(
    serializer_path,
    "core/serializers.py.backup-before-talent-optimization"
)
shutil.copy2(
    views_path,
    "core/views.py.backup-before-talent-optimization"
)

serializer_path.write_text(
    serializer_text.replace(serializer_old, serializer_new, 1),
    encoding="utf-8"
)

if "from django.db.models import Count, Q" not in views_text:
    views_text = views_text.replace(
        "from django.db.models import Q",
        "from django.db.models import Count, Q",
        1
    )

views_path.write_text(
    views_text.replace(views_old, views_new, 1),
    encoding="utf-8"
)

print("SUCCESS: Mabadiliko yamefanyika.")
print("Backups zimehifadhiwa kwenye core/.")
