from django.db import models

# Create your models here.

class Board(models.Model): # model로서 사용할 수 있음
    # id는 기본적으로 처음 테이블 생성시 자동으로 만들어 짐
    # id = models.AutoField(primary_key=True)
    # 클래스 변수 => DB에서의 필드를 나타냄
    title = models.CharField(max_length=10)
    content = models.TextField()
    # auto_now_add -> 객체를 하나 생성할 때의 시점에 저장
    created_at = models.DateTimeField(auto_now_add=True)
    # auto_now -> 지금 작업을 할 때를 기준으로 저장
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.id}번째 글 - {self.title} : {self.content}'
