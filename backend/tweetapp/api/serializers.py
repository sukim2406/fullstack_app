from rest_framework import serializers
from tweetapp.models import Tweet

class TweetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tweet
        fields = ['title', 'body', 'image', 'date_updated']