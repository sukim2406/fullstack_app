# Generated by Django 4.0.4 on 2022-05-15 06:18

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('accountapp', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='account',
            old_name='date_joind',
            new_name='date_joined',
        ),
    ]
