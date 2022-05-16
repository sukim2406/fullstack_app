from django.urls import path
from accountapp.api.views import registeration_view, logout_view
from rest_framework.authtoken.views import obtain_auth_token

app_name = "accountapp"

urlpatterns = [
    path('register/', registeration_view, name="register"),
    path('login/', obtain_auth_token, name="login"),
    path('logout/', logout_view, name="logout"),
]