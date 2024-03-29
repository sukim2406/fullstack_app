# Generated by Django 4.0.4 on 2022-05-25 04:55

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('tweetapp', '0004_alter_tweet_username'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('likeapp', '0002_likerecord_tweetslug_likerecord_userslug_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='likerecord',
            name='tweet',
            field=models.ForeignKey(blank=True, on_delete=django.db.models.deletion.CASCADE, related_name='likes_record', to='tweetapp.tweet'),
        ),
        migrations.AlterField(
            model_name='likerecord',
            name='user',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='like_record', to=settings.AUTH_USER_MODEL),
        ),
    ]
