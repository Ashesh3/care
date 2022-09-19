# Generated by Django 2.2.11 on 2022-09-19 12:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('facility', '0318_merge_20220918_1241'),
    ]

    operations = [
        migrations.RunSQL(
            sql="UPDATE facility_fileupload SET upload_completed = TRUE;",
            reverse_sql="UPDATE facility_fileupload SET upload_completed = FALSE;",
        ),
    ]
