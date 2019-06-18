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