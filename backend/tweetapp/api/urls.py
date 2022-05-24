from django.urls import path
from tweetapp.api.views import api_detail_tweet_view, api_create_tweet_view, api_delete_tweet_view, api_update_tweet_view, ApiTweetListView, ApiTweetAuthorListView

app_name = "tweetapp"

urlpatterns = [
    path('<slug>/detail/', api_detail_tweet_view, name="detail"),
    path('<slug>/update/', api_update_tweet_view, name="update"),
    path('<slug>/delete/', api_delete_tweet_view, name="delete"),
    path('create/', api_create_tweet_view, name="create"),
    path('list/', ApiTweetListView.as_view(), name="list"),
    path('<slug>/tweets/', ApiTweetAuthorListView.as_view(), name ="usertweets"),
    # path()
]