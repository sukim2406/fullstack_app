from django.urls import path
from profileapp.api.views import api_detail_profile_view, api_update_profile_view

app_name = "profileapp"

urlpatterns = [
    path('<slug>/detail/', api_detail_profile_view, name="detail"),
    path('<slug>/update/', api_update_profile_view, name="update"),
]