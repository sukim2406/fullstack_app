from rest_framework import serializers
from retweetapp.models import RetweetRecord

class RetweetRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = RetweetRecord
        fields = ['user', 'tweet', 'userSlug', 'tweetSlug']