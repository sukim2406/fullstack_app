# Generated by Django 4.0.4 on 2022-05-26 04:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tweetapp', '0004_alter_tweet_username'),
    ]

    operations = [
        migrations.AddField(
            model_name='tweet',
            name='retweetSlug',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
