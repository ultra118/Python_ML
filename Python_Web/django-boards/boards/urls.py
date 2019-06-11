from django.urls import path
from . import views

app_name = 'boards'

urlpatterns = [
    path('', views.index, name='index'),  # www.mulcam.com/boards/
    path('new/', views.new, name='new'), # 사용자의 입력을 받아서 게시글 작성
    # path('create/', views.create, name='create'), # 사용자가 입력한 데이터를 전송받고 실제 DB에 작성 및 사용자 피드백
    path('<int:id>/', views.detail, name='detail'), # /boards/<id>/
    path('<int:id>/delete/', views.delete, name='delete'), # /boards/<id>/
    path('<int:id>/edit/', views.edit, name='edit'), # 게시글 수정 페이지 렌더링
    # path('<int:id>/update/', views.update, name='update'), # 사용자가 수정한 값 받아서 update\
]