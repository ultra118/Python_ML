from django.contrib import admin
from django.urls import path
from . import views

app_name = 'movies'

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.index, name='index'),
    path('<int:movie_id>/', views.detail, name='detail'),
    path('create/', views.create, name='create'),
    path('<int:movie_id>/update/', views.update, name='update'),
    path('<int:movie_id>/delete/', views.delete, name='delete'),
]
