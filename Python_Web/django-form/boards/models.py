from django.db import models
from django.conf import settings


# Create your models here.
class Board(models.Model):
    title = models.CharField(max_length=20)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # 참조하고있는유저, on_delte=유저가 삭제되면 board를 어떻게 할지(CASCADE는 다 지워줌)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    # django usermodel - settings.AUTH_USER_MODEL
    like_users = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        # 역참조 할 수 있게
        related_name='like_boards',
        # 반드시 필요한건 아님
        blank=True,
    )

    def __str__(self):
        return f'{self.pk}. {self.title}'


class Comment(models.Model):
    content = models.CharField(max_length=100)
    # auto=자동 now=현시점 add=add되는 시점으로
    created_at = models.DateTimeField(auto_now_add=True)

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    board = models.ForeignKey(Board, on_delete=models.CASCADE)

    def __str__(self):
        return self.content