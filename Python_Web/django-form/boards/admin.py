from django.contrib import admin
from .models import Board, Comment


# Register your models here.
@admin.register(Board)
class BoardAdmin(admin.ModelAdmin):
    list_display = ('title', 'content', 'created_at', 'updated_at', )
    # 수정할 수 없는 필드영역 지정
    readonly_fields = ['created_at', 'updated_at', ]


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('pk', 'content', 'created_at', )
    readonly_fields = ['created_at', ]