from django.db import models

# Create your models here.
class Board(models.Model):
    title = models.CharField(max_length=20)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.id}. {self.title}'

# 댓글 db
class Comment(models.Model):
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # comment는 board에 여러개 귀속되기 때문에 1:N
    # 게시글이 지워졌을때 그 게시글에 귀속되어있는 댓글을 다 지울지, 아니면 어떤식으로든 저장할지
    # on_delte 통해 지정해줌 CASCADE -> 지울 때 같이 지움 DO_NOTHING -> 안 지움
    board = models.ForeignKey(Board, on_delete=models.CASCADE)

    def __str__(self):
        return f'<Board({self.board_id}) : Comment : {self.id} - {self.content}>'
