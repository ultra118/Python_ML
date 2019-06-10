from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),  # www.mulcam.com/boards/
    path('new/', views.new), # 사용자의 입력을 받아서 게시글 작성
    path('create/', views.create), # 사용자가 입력한 데이터를 전송받고 실제 DB에 작성 및 사용자 피드백
    path('<int:id>/', views.detail), # /boards/<id>/
    path('<int:id>/delete/', views.delete), # /boards/<id>/

]