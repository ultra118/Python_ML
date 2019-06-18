from django.urls import path
from . import views

app_name = 'boards'

urlpatterns = [
    path('', views.index, name='index'),
    path('<int:board_pk>/', views.detail, name='detail'), # boards/3/
    path('create/', views.create, name='create'),
    path('<int:board_pk>/delete/', views.delete, name='delete'), # boards/3/delete/
    path('<int:board_pk>/update/', views.update, name='update'),
]