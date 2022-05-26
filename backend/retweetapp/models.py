from django.db import models
from django.conf import settings
from tweetapp.models import Tweet
from django.utils.text import slugify
from django.db.models.signals import pre_save
from accountapp.models import Account

# Create your models here.

class RetweetRecord(models.Model):
    userSlug = models.CharField(max_length=30, blank=True)
    tweetSlug = models.CharField(max_length=50, blank=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, related_name='retweet_record', null=True, blank=True)
    tweet = models.ForeignKey(Tweet, on_delete=models.CASCADE, related_name='retweet_record', blank=True)
    slug = models.SlugField(blank=True, unique=True)

    def __str__(self):
        return self.slug

def pre_save_retweet_receiver(sender, instance, *args, **kwargs):
    if not instance.slug:
        instance.user = Account.objects.get(username=instance.userSlug)
        instance.tweet = Tweet.objects.get(slug=instance.tweetSlug)
        instance.slug = slugify(instance.user.username + "-" + instance.tweet.slug)

pre_save.connect(pre_save_retweet_receiver, sender=RetweetRecord)