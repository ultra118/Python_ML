from django.shortcuts import render, redirect
from .models import Board

# Create your views here.
def index(request):
    # Board의 전체 데이터를 불러옴 - QuerySet
    boards = Board.objects.all()
    context = {'boards' : boards}
    return render(request, 'boards/index.html', context)

# 사용자 입력을 받음
def new(request):
    return render(request, 'boards/new.html')

# 사용자가 입력한 데이터로 DB작성
def create(request):
    title = request.POST.get('title')
    content = request.POST.get('content')
    print(request.POST)
    print(f'title : {title} content : {content}')
    # 1
    # board = Board(title=title, content=content)
    # board.save()
    # 2
    board = Board()
    board.title = title
    board.content = content
    board.save()
    # 3
    print('new board id : ', board.id)
    return redirect(f'/boards/{board.id}/')

# 특정 게시글 하나를 가지고옴
def detail(request, id):
    #boards = Board.objects.filter(id=id)
    # print(f'boards type : {type(boards)}')
    # print(f'boards len : {len(boards)}')
    # pk가지고 올때는 get 사용
    board = Board.objects.get(id=id)
    context = {'board' : board}
    return render(request, 'boards/detail.html', context)

# 특정 게시글 하나를 지움
def delete(request, id):
    board = Board.objects.get(id=id)
    board.delete()
    return redirect('/boards/')
