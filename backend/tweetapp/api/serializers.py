from rest_framework import serializers
from tweetapp.models import Tweet

class TweetSerializer(serializers.ModelSerializer):

    username = serializers.SerializerMethodField('get_username_from_author')
    
    class Meta:
        model = Tweet
        fields = ['title', 'body', 'image', 'date_updated', 'username']
    
    def get_username_from_author(self, tweet):
        username = tweet.author.username
        return username