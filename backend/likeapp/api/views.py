from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from profileapp.models import Profile
from tweetapp.models import Tweet
from likeapp.api.serializers import LikeRecordSerializer

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def api_like_tweet_view(request, profileSlug, tweetSlug):
    try:
        user = Profile.objects.get(slug=profileSlug)
    except Profile.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    try:
        tweet = Tweet.objects.get(slug=tweetSlug)
    except Tweet.DoesNotExist:
        return Response(statsu=status.HTTP_404_NOT_FOUND)

    if request.method == "POST":
        serializer = LikeRecordSerializer(user, tweet)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)