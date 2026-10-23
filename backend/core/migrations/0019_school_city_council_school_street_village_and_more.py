from django.db import migrations, models
import django.db.models.deletion


def repair_school_schema(apps, schema_editor):
    connection = schema_editor.connection
    qn = schema_editor.quote_name

    table = "core_school"
    columns = {
        col.name: col
        for col in connection.introspection.get_table_description(
            connection.cursor(), table
        )
    }

    with connection.cursor() as cursor:
        # Add address fields only if they do not already exist.
        for name in ("city_council", "street_village"):
            if name not in columns:
                cursor.execute(
                    f"ALTER TABLE {qn(table)} "
                    f"ADD COLUMN {qn(name)} varchar(150) NOT NULL DEFAULT ''"
                )

        # Remove the existing foreign keys before aligning column types.
        constraints = connection.introspection.get_constraints(cursor, table)
        fields = {
            "ward_id": "core_ward",
            "zone_id": "core_zone",
            "district_id": "core_district",
            "region_id": "core_region",
        }

        for field in fields:
            for constraint_name, info in list(constraints.items()):
                if (
                    info.get("foreign_key")
                    and field in info.get("columns", [])
                ):
                    cursor.execute(
                        f"ALTER TABLE {qn(table)} "
                        f"DROP FOREIGN KEY {qn(constraint_name)}"
                    )

        # Match each FK column to the actual referenced primary-key type.
        for field, target_table in fields.items():
            target_columns = {
                col.name: col
                for col in connection.introspection.get_table_description(
                    cursor, target_table
                )
            }
            target_id = target_columns["id"]
            field_type = connection.introspection.get_field_type(
                target_id.type_code, target_id
            )

            type_map = {
                "AutoField": "INT",
                "IntegerField": "INT",
                "BigAutoField": "BIGINT",
                "BigIntegerField": "BIGINT",
                "SmallAutoField": "SMALLINT",
                "SmallIntegerField": "SMALLINT",
            }

            sql_type = type_map.get(field_type)
            if sql_type is None:
                raise RuntimeError(
                    f"Unsupported primary-key type for "
                    f"{target_table}.id: {field_type}"
                )

            cursor.execute(
                f"ALTER TABLE {qn(table)} "
                f"MODIFY COLUMN {qn(field)} {sql_type} NULL"
            )

        # Recreate missing foreign keys after type alignment.
        constraints = connection.introspection.get_constraints(cursor, table)
        for field, target_table in fields.items():
            exists = any(
                info.get("foreign_key")
                and info.get("columns") == [field]
                and info.get("foreign_key")[0] == target_table
                for info in constraints.values()
            )
            if not exists:
                constraint_name = f"repair_school_{field}_fk"
                cursor.execute(
                    f"ALTER TABLE {qn(table)} "
                    f"ADD CONSTRAINT {qn(constraint_name)} "
                    f"FOREIGN KEY ({qn(field)}) "
                    f"REFERENCES {qn(target_table)} ({qn('id')})"
                )


class Migration(migrations.Migration):
    dependencies = [
        ("core", "0018_user_created_by_alter_user_role"),
    ]

    operations = [
        migrations.SeparateDatabaseAndState(
            database_operations=[
                migrations.RunPython(
                    repair_school_schema,
                    reverse_code=migrations.RunPython.noop,
                ),
            ],
            state_operations=[
                migrations.AddField(
                    model_name="school",
                    name="city_council",
                    field=models.CharField(blank=True, default="", max_length=150),
                ),
                migrations.AddField(
                    model_name="school",
                    name="street_village",
                    field=models.CharField(blank=True, default="", max_length=150),
                ),
                migrations.AlterField(
                    model_name="school",
                    name="district",
                    field=models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.PROTECT,
                        related_name="schools",
                        to="core.district",
                    ),
                ),
                migrations.AlterField(
                    model_name="school",
                    name="region",
                    field=models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.PROTECT,
                        related_name="schools",
                        to="core.region",
                    ),
                ),
                migrations.AlterField(
                    model_name="school",
                    name="ward",
                    field=models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.PROTECT,
                        related_name="schools",
                        to="core.ward",
                    ),
                ),
                migrations.AlterField(
                    model_name="school",
                    name="zone",
                    field=models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.PROTECT,
                        related_name="schools",
                        to="core.zone",
                    ),
                ),
            ],
        ),
    ]
