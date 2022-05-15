from django.urls import path
from accountapp.api.views import registeration_view

app_name = "accountapp"

urlpatterns = [
    path('register/', registeration_view, name="register")
]