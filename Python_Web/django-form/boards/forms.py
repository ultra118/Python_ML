from django import forms
from .models import Board, Comment

# class BoardForm(forms.Form):
#     title = forms.CharField(
#         max_length=20,
#         label='제목',
#         widget=forms.TextInput(
#             attrs={
#                 'class': 'title',
#                 'placeholder': 'Enter the title'
#             }
#         )
#     )
#     content = forms.CharField(
#         label='내용',
#         widget=forms.Textarea(
#             attrs={
#                 'rows': 5,
#                 'cols': 50,
#                 'placeholder': 'Enter the content',
#                 'class': 'content-type',
#             }
#         )
#     )


class BoardForm(forms.ModelForm):
    title = forms.CharField(
        max_length=20,
        label='제목',
        widget=forms.TextInput(
            attrs={
                'class': 'title',
                'placeholder': 'Enter the title'
            }
        )
    )
    content = forms.CharField(
        label='내용',
        widget=forms.Textarea(
            attrs={
                'rows': 5,
                'cols': 50,
                'placeholder': 'Enter the content',
                'class': 'content-type',
            }
        )
    )

    # 어느 model로 form을 만들지 지정해줘야함
    class Meta:
        model = Board
        fields = ('title', 'content', )


class CommentForm(forms.ModelForm):
    content = forms.CharField(label=False)
    class Meta:
        model = Comment
        fields = ('content', )
