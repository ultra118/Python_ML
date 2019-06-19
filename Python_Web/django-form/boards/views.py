from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST, require_GET, require_http_methods
from django.contrib.auth.decorators import login_required
from .models import Board, Comment
from .forms import BoardForm, CommentForm
from IPython import embed

# Create your views here.

@require_GET
def index(request):
    # 역순으로 가져오게
    boards = Board.objects.order_by('-pk')
    context = {'boards':boards}
    print(boards)
    return render(request, 'boards/index.html', context)

@login_required
@require_http_methods(['GET', 'POST'])
def create(request):
    if request.method == 'POST':
        # title = request.POST.get('title')
        # content = request.POST.get('content')
        # board = Board(title=title, content=content)
        # board.save()
        form = BoardForm(request.POST)

        # form이 유효하다면
        if form.is_valid():
            # title = form.cleaned_data.get('title')
            # content = form.cleaned_data.get('content')
            # board = Board.objects.create(title=title, content=content)
            board = form.save(commit=False)
            board.user = request.user
            board.save()
            return redirect('boards:detail', board.pk)
    else:
        form = BoardForm()
    context = {'form': form}
    return render(request, 'boards/form.html', context)


@require_GET
def detail(request, board_pk):
    # object가 있으면 가져오고 없으면 404페이지
    # 어떤 모델에서 꺼내올 건지, 어떤 값을 꺼내올건지
    board = get_object_or_404(Board, pk=board_pk)
    # Board를 참조하고 있는 모든 댓글
    comments = board.comment_set.order_by('-pk')
    comment_form = CommentForm()
    context = {
        'board': board,
        'comment_form': comment_form,
        'comments': comments
    }
    return render(request, 'boards/detail.html', context)


# @login_required
# 필요하긴한데 어차피 GET요청으로 redirect하게되기떄문에 POST에서 막힘
@require_POST
def delete(request, board_pk):
    # 특정 보드를 불러와서 삭제
    board = get_object_or_404(Board, pk=board_pk)
    if request.user != board.user:
        redirect('boards:detail', board_pk)
    board.delete()
    return redirect('boards:index')


@login_required
@require_http_methods(['GET', 'POST'])
def update(request, board_pk):
    board = get_object_or_404(Board, pk=board_pk)
    if request.user != board.user:
        return redirect('boards:detail', board_pk)
    if request.method == 'POST':
        # 수정하고자하는 기존의 board값을 알려주기위해 instance속성에 board값을 넣어줌
        form = BoardForm(request.POST, instance=board)
        if form.is_valid():
            # board.title = form.cleaned_data.get('title')
            # board.content =form.cleaned_data.get('content')
            # board.save()
            # 바로 저장하지않고 user값을 대입 하고 저장
            board = form.save(commit=False)
            board.user = request.user
            board.save()
            return redirect('boards:detail', board.pk)
    else:
        # form을 사용하고나서 form안에 데이터를 채워서보내면 update가 되는거고
        # form안에 데이터를 안채우고 보내면 create가 되는거기때문에 create.html에 넘겨줌
        # board 데이터 할당
        print(board.__dict__)
        # form = BoardForm(initial=board.__dict__)
        # 마찬가지로 어떤 instacne를 바라보게할지 넣어줄 수 있음
        form = BoardForm(instance=board)
    context = {'form': form, 'board_pk': board_pk,}
    return render(request, 'boards/form.html', context)


@require_POST
def comments_create(request, board_pk):
    # 사용자가 로그인 되어있지 않으면
    if not request.user.is_authenticated:
        return redirect('accounts:login')

    # 댓글 작성
    # model form에 사용자 입력을 받음
    comment_form = CommentForm(request.POST)
    # 유효성검사
    if comment_form.is_valid():
        comment = comment_form.save(commit=False)
    # user 정보 할당,  board 정보 할당
        # comment_user_id = request.user_id와 동일함
        # 인스턴스를 바로 할당할 수도이쏙 primary key를 바로 할당할 수 있음
        comment.user = request.user
        comment.board_id = board_pk
    # comment.save()
        comment.save()
    return redirect('boards:detail', board_pk)


@require_POST
def comments_delete(request, board_pk, comment_pk):

    comment = get_object_or_404(Comment, pk=comment_pk)
    if comment.user == request.user:
        comment.delete()
    # 댓글 삭제
    return redirect('boards:detail', board_pk)


def like(request, board_pk):
    board = get_object_or_404(Board, pk=board_pk)
    user = request.user

    # 보드 좋아유 누른 사람중에 user 있으면
    if user in board.like_users.all():
        # 좋아요 취소
        board.like_users.remove(user)
    # 보드를 좋아요 누른 모든 사람중에서 user가 없다면
    else:
        # 좋아요
        board.like_users.add(user)

    return redirect('boards:detail', board_pk)