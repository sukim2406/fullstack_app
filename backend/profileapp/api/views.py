from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.pagination import PageNumberPagination
from rest_framework.generics import ListAPIView
from rest_framework.authentication import TokenAuthentication

from accountapp.models import Account
from profileapp.models import Profile
from profileapp.api.serializers import ProfileSerializer, ProfileUpdateSerializer


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def api_detail_profile_view(request, slug):
    try:
        profile = Profile.objects.get(slug=slug)
    except Profile.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = ProfileSerializer(profile)
        return Response(serializer.data)


@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def api_update_profile_view(request, slug):
    try:
        profile = Profile.objects.get(slug=slug)
    except Profile.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    user = request.user
    if profile.user != user:
        return Response({'response': "You don't have permission to edit this tweet."})

    if request.method == 'PUT':
        print('comes here')
        print(request.data)
        serializer = ProfileSerializer(profile, data=request.data)
        print('serializer check')
        print(serializer)
        data = {}
        if serializer.is_valid():
            serializer.save()
            data["success"] = "update successful"
            return Response(data=data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)