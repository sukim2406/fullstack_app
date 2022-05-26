from django.urls import path
from retweetapp.api.views import api_retweet_view

app_name = "retweetapp"

urlpatterns = [
    path('create/', api_retweet_view, name='retweet'),
]