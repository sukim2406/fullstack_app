from rest_framework import serializers
from profileapp.models import Profile

class ProfileSerializer(serializers.ModelSerializer):

    username = serializers.SerializerMethodField('get_username_from_user')

    class Meta:
        model = Profile
        fields = ['image', 'nickname', 'message', 'username']

    def get_username_from_user(self, profile):
        username = profile.user.username
        return username