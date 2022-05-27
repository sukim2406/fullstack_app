from os import stat
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from retweetapp.api.serializers import RetweetRecordSerializer
from rest_framework.response import Response
from rest_framework import status
from retweetapp.models import RetweetRecord
from rest_framework.generics import ListAPIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.pagination import PageNumberPagination

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def api_retweet_view(request):
    if request.method == "POST":
        serializer = RetweetRecordSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def api_get_retweet_user_view(request, slug):
    try:
        retweet = RetweetRecord.objects.get(slug=slug)
    except RetweetRecord.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = RetweetRecordSerializer(retweet)
        return Response(serializer.data)


@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
def api_undo_retweet(request, slug):
    try:
        retweet = RetweetRecord.objects.get(slug=slug)
    except RetweetRecord.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    user = request.user
    if retweet.user != user:
        return Response({'response': "You don't have permission to undo retweet"})
    
    if request.method == 'DELETE':
        operation = retweet.delete()
        data = {}
        if operation:
            data["success"] = "undo successful"
        else:
            data["failure"] = "undo failed"
        return Response(data=data)


class ApiRetweetListView(ListAPIView):
    serializer_class = RetweetRecordSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    pagination_class = PageNumberPagination
    def get_queryset(self):
        username = self.kwargs['slug']
        queryset = RetweetRecord.objects.all().filter(userSlug = username)
        return queryset