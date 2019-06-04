from django.urls import path
from . import views


urlpatterns= [
    path('static_example', views.static_example),
    path('artii/', views.artii),
    path('result/', views.result),
    path('throw/', views.throw),
    path('catch/', views.catch),
    path('isitbirthday/', views.isitbirthday),
    path('template_language/', views.template_language),
    path('introduce/<str:name>/<int:age>', views.introduce),
    path('greeting/<str:name>/', views.greeting),
    path('dinner/', views.dinner),
    # index로 들어오면 views.index로 연결
    path('index/', views.index),

]