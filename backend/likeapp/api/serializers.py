from rest_framework import serializers
from likeapp.models import LikeRecord

class LikeRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = LikeRecord
        fields = ['user', 'tweet']