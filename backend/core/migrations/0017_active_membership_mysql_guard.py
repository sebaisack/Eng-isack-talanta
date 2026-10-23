from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("core", "0016_announcement_audience"),
    ]

    operations = [
        migrations.SeparateDatabaseAndState(
            database_operations=[
                migrations.RunSQL(
                    sql=[
                        "ALTER TABLE core_studentclubmembership ADD COLUMN active_student_id BIGINT GENERATED ALWAYS AS (CASE WHEN is_active = 1 THEN student_id ELSE NULL END) STORED",
                        "CREATE UNIQUE INDEX one_active_club_per_student ON core_studentclubmembership (active_student_id)",
                    ],
                    reverse_sql=[
                        "DROP INDEX one_active_club_per_student ON core_studentclubmembership",
                        "ALTER TABLE core_studentclubmembership DROP COLUMN active_student_id",
                    ],
                ),
            ],
            state_operations=[
                migrations.RemoveConstraint(
                    model_name="studentclubmembership",
                    name="one_active_club_per_student",
                ),
            ],
        ),
    ]
