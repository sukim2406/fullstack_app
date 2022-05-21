from django.urls import path
from accountapp.api.views import registeration_view, logout_view, CustomAuthToken, account_details_view, account_update_view
from rest_framework.authtoken.views import obtain_auth_token

app_name = "accountapp"

urlpatterns = [
    path('register/', registeration_view, name="register"),
    # path('login/', obtain_auth_token, name="login"),
    path('login/', CustomAuthToken.as_view(), name="login"),
    path('logout/', logout_view, name="logout"),
    path('detail/', account_details_view, name="detail"),
    path('update/', account_update_view, name="update"),
]