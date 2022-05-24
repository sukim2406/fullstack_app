
from django.db import models
from profileapp.models import Profile
from tweetapp.models import Tweet
from django.utils.text import slugify
from django.db.models.signals import pre_save

# Create your models here.

class LikeRecord(models.Model):
    user = models.ForeignKey(Profile, on_delete=models.SET_NULL, related_name='like_record', null=True)
    tweet = models.ForeignKey(Tweet, on_delete=models.CASCADE, related_name='likes_record')
    slug = models.SlugField(blank=True, unique=True)

    def __str__(self):
        return self.slug

def pre_save_like_receiver(sender, instance, *args, **kwargs):
    instance.slug = slugify(instance.user.username + "-" + instance.tweet.slug)

pre_save.connect(pre_save_like_receiver, sender=LikeRecord)