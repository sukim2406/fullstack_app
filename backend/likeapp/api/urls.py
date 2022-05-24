from django.urls import path
from likeapp.api.views import api_like_tweet_view

app_name = "likeapp"

urlpatterns = [
    path('create/', api_like_tweet_view, name='liked'),
]