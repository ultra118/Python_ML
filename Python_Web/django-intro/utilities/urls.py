from django.urls import path
from . import views


urlpatterns= [
    # index로 들어오면 views.index로 연결
    path('index/', views.index),

]