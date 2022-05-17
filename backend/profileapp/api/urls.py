from django.urls import path
from profileapp.api.views import api_detail_profile_view

app_name = "profileapp"

urlpatterns = [
    path('<slug>/detail/', api_detail_profile_view, name="detail")
]