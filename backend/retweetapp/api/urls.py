from django.urls import path
from retweetapp.api.views import api_retweet_view, api_get_retweet_user_view, api_undo_retweet, ApiRetweetListView

app_name = "retweetapp"

urlpatterns = [
    path('create/', api_retweet_view, name='retweet'),
    path('<slug>/detail/', api_get_retweet_user_view, name="detail"),
    path('<slug>/delete/', api_undo_retweet, name="delete"),
    path('<slug>/list/', ApiRetweetListView.as_view(), name="list"),
]