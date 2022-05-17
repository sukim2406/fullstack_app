from django.db import models
from django.conf import settings
from django.dispatch import receiver
from django.db.models.signals import post_delete, pre_save
from django.utils.text import slugify
# Create your models here.

def upload_location(instance, filename, **kwargs):
    file_path = 'profileapp/{user_id}-{filename}'.format(
        user_id = str(instance.user.id),
        filename = filename
    )

    return file_path

class Profile(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    image = models.ImageField(upload_to=upload_location, null=True, blank=True)
    nickname = models.CharField(max_length=20, unique=True, null=True)
    message = models.CharField(max_length=200, null=True)
    slug =  models.SlugField(blank=True, unique=True)

@receiver(post_delete, sender=Profile)
def submission_delete(sender, instance, **kwargs):
    instance.image.delete(False)

def pre_save_tweet_receiver(sender, instance, *args, **kwargs):
    if not instance.slug:
        instance.slug = slugify(instance.user.username)
    
pre_save.connect(pre_save_tweet_receiver, sender=Profile)