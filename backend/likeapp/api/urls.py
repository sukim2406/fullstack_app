from django.urls import path
from likeapp.api.views import api_like_tweet_view, api_get_likes_user_view,api_unlike_view, ApiLikedTweetListView

app_name = "likeapp"

urlpatterns = [
    path('create/', api_like_tweet_view, name='liked'),
    path('<slug>/detail/',api_get_likes_user_view, name='userliked'),
    path('<slug>/unlike/', api_unlike_view, name='unlike'),
    path('<slug>/list/', ApiLikedTweetListView.as_view(), name='list'),
]