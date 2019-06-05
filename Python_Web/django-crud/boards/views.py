from django.shortcuts import render
from .models import Board

# Create your views here.

def index(request):
    return render(request, 'boards/index.html')

def new(request):
    return render(request, 'boards/new.html')

def create(request):
    title = request.GET.get('title')
    content = request.GET.get('content')
    print(f'title : {title}\n content : {content}')

    Board.objects.create(title=title, content=content)

    return render(request, 'boards/create.html' )