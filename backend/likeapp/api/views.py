from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from profileapp.models import Profile
from tweetapp.models import Tweet
from likeapp.models import LikeRecord
from likeapp.api.serializers import LikeRecordSerializer
from rest_framework.generics import ListAPIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.pagination import PageNumberPagination

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def api_like_tweet_view(request):
    if request.method == "POST":
        serializer = LikeRecordSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def api_get_likes_user_view(request, slug):
    try:
        like = LikeRecord.objects.get(slug=slug)
    except LikeRecord.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = LikeRecordSerializer(like)
        return Response(serializer.data)


@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
def api_unlike_view(request, slug):
    try:
        like = LikeRecord.objects.get(slug=slug)
    except LikeRecord.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    user = request.user
    if like.user != user:
        return Response({'response': "You don't have permission to delete this tweet."})

    if request.method == 'DELETE':
        operation = like.delete()
        data = {}
        if operation:
            data["success"] = "delete successful"
        else:
            data["failure"] = "delete failed"
        return Response(data=data)

class ApiLikedTweetListView(ListAPIView):
    serializer_class = LikeRecordSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    pagination_class = PageNumberPagination
    def get_queryset(self):
        username = self.kwargs['slug']
        queryset = LikeRecord.objects.all().filter(userSlug = username)
        return queryset


