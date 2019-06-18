from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST, require_GET, require_http_methods
from django.contrib.auth.decorators import login_required
from .models import Board
from .forms import BoardForm
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
    context = {'board': board}
    return render(request, 'boards/detail.html', context)


# @login_required
# 필요하긴한데 어차피 GET요청으로 redirect하게되기떄문에 POST에서 막힘
@require_POST
def delete(request, board_pk):
    # 특정 보드를 불러와서 삭제
    board = get_object_or_404(Board, pk=board_pk)
    board.delete()
    return redirect('boards:index')

@login_required
@require_http_methods(['GET', 'POST'])
def update(request, board_pk):
    board = get_object_or_404(Board, pk=board_pk)
    if request.method == 'POST':
        # 수정하고자하는 기존의 board값을 알려주기위해 instance속성에 board값을 넣어줌
        form = BoardForm(request.POST, instance=board)
        if form.is_valid():
            # board.title = form.cleaned_data.get('title')
            # board.content =form.cleaned_data.get('content')
            # board.save()
            board = form.save()
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
