import datetime
from distutils.command.upload import upload
import django
from django.db import models

# Create your models here.
from django.db.models.signals import pre_save, post_delete
from django.utils.text import slugify
from django.conf import settings
from django.dispatch import receiver

def upload_location(instance, filename, **kwargs):
    file_path = 'tweetapp/{author_id}/{author}-{filename}'.format(
        author_id = str(instance.author.id),
        author = str(instance.author),
        filename = filename
    )

    return file_path


class Tweet(models.Model):
    body = models.CharField(max_length=500, null=False, blank=False)
    image = models.ImageField(upload_to=upload_location, null=True, blank=True)
    date_created = models.DateTimeField(auto_now_add=True, verbose_name="date created")
    date_updated = models.DateTimeField(auto_now=True, verbose_name="date updated")
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE) 
    slug = models.SlugField(blank=True, unique=True)

    def __str__(self):
        return self.slug
    

@receiver(post_delete, sender=Tweet)
def submission_delete(sender, instance, **kwargs):
    instance.image.delete(False)

def pre_save_tweet_receiver(sender, instance, *args, **kwargs):
    now = datetime.datetime.now()
    if not instance.slug:
        instance.slug = slugify(instance.author.username + "-" + now.strftime('%Y%m%d%H%M%S'))
    
pre_save.connect(pre_save_tweet_receiver, sender=Tweet)