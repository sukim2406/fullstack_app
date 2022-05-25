from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.pagination import PageNumberPagination
from rest_framework.generics import ListAPIView
from rest_framework.authentication import TokenAuthentication

from accountapp.models import Account
from tweetapp.models import Tweet
from tweetapp.api.serializers import TweetSerializer


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def api_detail_tweet_view(request, slug):
    try:
        tweet = Tweet.objects.get(slug=slug)
    except Tweet.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = TweetSerializer(tweet)
        return Response(serializer.data)


@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def api_update_tweet_view(request, slug):
    try:
        tweet = Tweet.objects.get(slug=slug)
    except Tweet.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    user = request.user
    if tweet.author != user:
        return Response({'response': "You don't have permission to edit this tweet."})

    if request.method == 'PUT':
        serializer = TweetSerializer(tweet, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            data["success"] = "update successful"
            return Response(data=data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
def api_delete_tweet_view(request, slug):
    try:
        tweet = Tweet.objects.get(slug=slug)
    except Tweet.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    user = request.user
    if tweet.author != user:
        return Response({'response': "You don't have permission to delete this tweet."})

    if request.method == 'DELETE':
        operation = tweet.delete()
        data = {}
        if operation:
            data["success"] = "delete successful"
        else:
            data["failure"] = "delete failed"
        return Response(data=data)


@api_view(['POST',])
@permission_classes((IsAuthenticated,))
def api_create_tweet_view(request):
    account = request.user
    tweet = Tweet(author=account)

    if request.method == "POST":
        serializer = TweetSerializer(tweet, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ApiTweetListView(ListAPIView):
    queryset = Tweet.objects.all().order_by('-date_updated')
    serializer_class = TweetSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    pagination_class = PageNumberPagination


class ApiTweetAuthorListView(ListAPIView):
    serializer_class = TweetSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    pagination_class = PageNumberPagination
    def get_queryset(self):
        username = self.kwargs['slug']
        queryset = Tweet.objects.all().filter(username = username)
        return queryset.order_by('-date_updated')
