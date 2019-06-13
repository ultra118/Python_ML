from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_http_methods
from .models import Board, Comment

# Create your views here.
@require_http_methods(['GET'])
def index(request):
    # Board의 전체 데이터를 불러옴 - QuerySet
    boards = Board.objects.all()
    context = {'boards' : boards}
    return render(request, 'boards/index.html', context)


# 사용자 입력을 받음
@require_http_methods(['GET','POST'])
def new(request):
    # GET - 전달의 행위를 하는 부분
    # POST - 직접 db를 작성하는 부분
    if request.method == 'GET':
        # new-GET
        return render(request, 'boards/new.html')
    else:
        # create-POST
        title = request.POST.get('title')
        content = request.POST.get('content')
        image= request.FILES.get('image')
        board = Board(title=title, content=content, image=image)
        board.save()
        return redirect('boards:detail', board.id)

# # 사용자가 입력한 데이터로 DB작성
# def create(request):
#     title = request.POST.get('title')
#     content = request.POST.get('content')
#     print(request.POST)
#     print(f'title : {title} content : {content}')
#     # 1
#     # board = Board(title=title, content=content)
#     # board.save()
#     # 2
#     board = Board()
#     board.title = title
#     board.content = content
#     board.save()
#     # 3
#     print('new board id : ', board.id)
#     # return redirect(f'/boards/{board.id}/')
#     return redirect('boards:detail', board.id)

# 특정 게시글 하나를 가지고옴
@require_http_methods(['GET'])
def detail(request, board_id):
    #boards = Board.objects.filter(id=id)
    # print(f'boards type : {type(boards)}')
    # print(f'boards len : {len(boards)}')
    # pk가지고 올때는 get 사용
    #board = Board.objects.get(id=id)
    board = get_object_or_404(Board, id=board_id)
    # 댓글들을 id의 역순으로 가지고옴
    comments = board.comment_set.order_by('-id').all()
    context = {'board' : board, 'comments': comments}
    return render(request, 'boards/detail.html', context)

# 특정 게시글 하나를 지움
@require_http_methods(['POST'])
def delete(request, board_id):
    # if request.method == 'GET':
    #     # GET - detail page로 redirect
    #     return redirect('boards:detail', id)
    # else:
    # POST - 정상 삭제
    # board = Board.objects.get(id=id)
    board = get_object_or_404(Board, id=board_id)
    board.delete()
    return redirect('boards:index')


# 게시글 수정 페이지 렌더링
@require_http_methods(['GET','POST'])
def edit(request, board_id):
    #board = Board.objects.get(id=id)
    board = get_object_or_404(Board, id=board_id)
    if request.method == 'GET':
        # GET - edit
        context = {'board': board}
        return render(request, 'boards/edit.html', context)
    else:
        # POST - update
        title = request.POST.get('title')
        content = request.POST.get('content')
        image = request.FILES.get('image')
        board.title = title
        board.content = content
        board.image = image
        board.save()
        return redirect('boards:detail', board_id)


# 게시글 수정 정보 받아서 update
# def update(request, id):
#     title = request.POST.get('title')
#     content = request.POST.get('content')
#     board = Board.objects.get(id=id)
#     board.title = title
#     board.content = content
#     board.save()
#     # return redirect(f'/boards/{id}')
#     return redirect('boards:detail', id)

@require_http_methods(['POST'])
def comment_create(request, board_id):
    content = request.POST.get('content')
    comment = Comment(content=content, board_id=board_id)
    comment.save()
    print(comment)


    # 댓글 생성하는 로직
    return redirect('boards:detail', board_id)

@require_http_methods(['POST'])
def comment_delete(request, board_id, comment_id):
    comment = Comment.objects.get(pk = comment_id)
    comment.delete()
    return redirect('boards:detail', board_id)