# 게시판 만들기 - Django

## CRUD(startproject)

- `startproject` - crud라는 이름으로 현재 디렉토리에 생성

```bash
$ django-admin startproject crud .
```

- `startapp`

```bash
$ python manage.py startapp boards
```

- `crud/settings.py`

```python
INSTALLED_APPS = [
    'boards',
	...
]
...
LANGUAGE_CODE = 'ko-kr'
TIME_ZONE = 'Asia/Seoul'
```

- `.gitignore.io`추가
  - python, pycharm, django, windows
- `crud/urls.py`

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('boards/', include('boards.urls')),
    path('admin/', admin.site.urls),
]
```

## boards(startapp)

### migrate 작업

- `boards/models.py`

```python
from django.db import models

# Create your models here.
class Board(models.Model):
    title = models.CharField(max_length=20)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

- `makemigrations`

```bash
$ python manage.py makemigrations
```

- `migrate`

```bash
$ python manage.py migrate
```

### 사용자한테 입력받고 db저장 + 페이지에 출력

- `boards/urls.py`

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),  # www.mulcam.com/boards/
    path('new/', views.new), # 사용자의 입력을 받아서 게시글 작성
    path('create/', views.create), # 사용자가 입력한 데이터를 전송받고 실제 DB에 작성 및 사용자 피드백]
```

- `boards/views.py`

```python
from django.shortcuts import render
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
    title = request.GET.get('title')
    content = request.GET.get('content')
    print(f'title : {title} content : {content}')
    # 1
    # board = Board(title=title, content=content)
    # board.save()
    # 2
    # board = Board()
    # board.title = title
    # board.content = content
    # board.save()
    # 3
    Board.objects.create(title=title, content=content)

    return render(request, 'boards/create.html')
```



- `boards/templates/boards/base.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title>CRUD</title>
</head>
<body>
    <div class="container">
        {% block body %}
        {% endblock %}
    </div>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
```

- `boards/templates/boards/new.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
    <h1> NEW </h1>
    <form action="/boards/create/">
        <label for="title">Title</label><br/>
        <input name="title" id="title" type="text"><br/>
        <label for="content">Content</label><br/>
        <textarea name="content" id="content"></textarea><br/>
        <input type="submit">
    </form>
    <a href="/boards/">back</a>
{% endblock %}
```

- `boards/templates/boards/index.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
    <h1>Welcome to boards</h1>
    <hr/>
    {% for board in boards %}
        <p>글 번호 : {{ board.id}}</p>
        <p>글 제목 : {{ board.title }}</p>
        <p>글 내용 : {{ board.content }}</p>
        <hr/>
    {% endfor %}
    <a href="/boards/new/">새로운 글 작성</a>

{% endblock %}
```

## POST method 사용

- `boards/templates/boards/new.html`의 `form`수정

```html
<form action="/boards/create/" method="post">
```

### 여러 method

- `GET` : /boards/3/ .. 가져오기
- `POST` : /boards/ .. 생성
- `PATCH`: /boards/3/ .. 수정
- `DELETE` : /boards/3/ .. 삭제

### CSRF Forbidden

- [사이트 간 요청 위조]([https://itstory.tk/entry/CSRF-%EA%B3%B5%EA%B2%A9%EC%9D%B4%EB%9E%80-%EA%B7%B8%EB%A6%AC%EA%B3%A0-CSRF-%EB%B0%A9%EC%96%B4-%EB%B0%A9%EB%B2%95](https://itstory.tk/entry/CSRF-공격이란-그리고-CSRF-방어-방법))
- POST방식으로 그냥 URL로 넘겨버려서 사용자가 원하지 않는 글을 게시하게 하는 등 악용할 수 있기때문에 사용자에게 `token`을 주고 사용자의 token을 확인하고 글을 쓸 수 있는지 확인
- 방지하기위해 아래처럼 `form`밑에 `csrf_token`을 추가해줌

```html
<form action="/boards/create/" method="post">
	{% csrf_token %}
```

- `crud/settings.py`의 `MIDDLEWARE`의 `'django.middleware.csrf.CsrfViewMiddleware'`가 요청이 view에 들어오기전에 알아서 csrf의 token이 들어있는지 확인해줌
- `boards/view.py` 수정

```python
def create(request):
    title = request.POST.get('title')
    content = request.POST.get('content')
    print(request.POST)
    print(f'title : {title} content : {content}')
    # 1
    # board = Board(title=title, content=content)
    # board.save()
    # 2
    # board = Board()
    # board.title = title
    # board.content = content
    # board.save()
    # 3
    Board.objects.create(title=title, content=content)

    return render(request, 'boards/create.html')
```

### redirect

- 로그인을 성공하면 원래의 페이지로 되돌려주듯 모든 데이터작성이 끝나면 `index` page로 `redirect`시켜 줌

```python
from django.shortcuts import render, redirect

#return render(request, 'boards/create.html')
return redirect('/boards/')
```

### id를 동적으로 입력받아 db select

- `boards/urls.py`의 `urlpatterns`에 추가

```python
path('<int:id>/', views.detail), # /boards/<id>/
```

- `boards/views.py`에 `detail`추가

```python
# 특정 게시글 하나를 가지고옴
def detail(request, id):
    board = Board.objects.get(id=id)
    # pk를 가지고올 때는 get을 사용
    # return 되는 boards는 indexing이 안됨
    context = {'board' : board}
    
    return render(request, 'boards/detail.html', context)
```

- 다른 방식으로 해결

```python
# 특정 게시글 하나를 가지고옴
def detail(request, id):
    boards = Board.objects.filter(id=id)
    # filter를 통해서는 복수의 값을 query set으로 리턴하는데
    # indexing이 가능함
    context = {'boards' : boards}
    
    return render(request, 'boards/detail.html', context)
```

- `boards/templates/boards/detail.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
<h1>DETAIL PAGE</h1>
    <p> board id : {{ board.id }}</p>
    <p> board title : {{ board.title }}</p>
    <p> board content : {{ board.content }}</p>

{% endblock %}
혹은
{% extends 'boards/base.html' %}

{% block body %}
<h1>DETAIL PAGE</h1>
{% for board in boards %}
    <p> board id : {{ board.id }}</p>
    <p> board title : {{ board.title }}</p>
    <p> board content : {{ board.content }}</p>
{% endfor %}
{% endblock %}
```

### index의 lsit목록 href 만들기

- `templates/boards/index.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
    <h1>Welcome to boards</h1>
    <hr/>
    {% for board in boards %}
        <p>글 번호 : {{ board.id}}</p>
        <p>글 제목 : {{ board.title }}</p>
        <a href="/boards/{{ board.id }}">[상세 글 보러가기]</a>
        <hr/>
    {% endfor %}
    <a href="/boards/new/">새로운 글 작성</a>

{% endblock %}
```

- django가 알아서 {{ }} 를 해석해줌

### 글 삭제하기(Delete)

- `boards/urls.py`

```python
path('<int:id>/delete/', views.delete),
```

- `boards/views.py`

```python
# 특정 게시글 하나를 지움
def delete(request, id):
    board = Board.objects.get(id=id)
    board.delete()
    return redirect('/boards/')
```

- `borads/templates/boards/detail.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
<h1>DETAIL PAGE</h1>
    <p> board id : {{ board.id }}</p>
    <p> board title : {{ board.title }}</p>
    <p> board created at: {{ board.created_at}}</p>
    <hr/>
    <p> board content : {{ board.content }}</p>
    <hr/>
    <a href="/boards/{{ board.id }}/delete/">[글 삭제하기]</a><br>
    <a href="/boards/">BACK</a>

{% endblock %}
```

- 그런데 글의 수정은 반드시 `post`방식으로 처리해줘야 함

## [bootstrap 활용](<https://www.w3schools.com/bootstrap4/bootstrap_ref_js_dropdown.asp>)

