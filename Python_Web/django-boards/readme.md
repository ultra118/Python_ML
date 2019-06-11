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

### POST method 사용

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

### [bootstrap 활용](<https://www.w3schools.com/bootstrap4/bootstrap_ref_js_dropdown.asp>)

### udpate

- `boards/urls.py`

```python
path('<int:id>/edit/', views.edit), # 게시글 수정 페이지 렌더링
```

- `boards/views.py`

```python
# 게시글 수정 페이지 렌더링
def edit(request, id):
    board = Board.objects.get(id=id)
    context = {'board' : board}
    return render(request, 'boards/edit.html', context)
```

- `boards/templates/boards/edit.html`
  - `input`의 `value`를 채워서 값을 넣어줌
  - `textarea`는 그 안에 text를 채워줘서 값을 채울 수 있음

```html
{% extends 'boards/base.html' %}

{% block body %}
    <h1> EDIT </h1>
    <form action="/boards/create/" method="post">
        {% csrf_token %}
        <label for="title">Title</label><br/>
        <input name="title" id="title" type="text" value="{{ board.title}}"><br/>
        <label for="content">Content</label><br/>
        <textarea name="content" id="content">{{ board.content }}</textarea><br/>
        <input type="submit">
    </form>
    <a href="/boards/">BACK</a>
{% endblock %}
```

- edit의 채워진 값을 통해 update하기 위한 함수 랜더링 `urls.py`

```python
path('<int:id>/update/', views.update), # 게시글 수정 값을 받아서 업데이트해주는 부분
```

- `edit.html`로 부터 게시글의 수정정보를 받아옴 `POST`

```python
# 게시글 수정 정보 받아서 update
def update(request, id):
    title = request.POST.get('title')
    content = request.POST.get('content')
    board = Board.objects.get(id=id)
    board.title = title
    board.content = content
    board.save()
    return redirect(f'/boards/{id}/')
```

- `edit.html`의 action을 update로 보내주도록 한다

```html
{% extends 'boards/base.html' %}

{% block body %}
    <h1> EDIT </h1>
    <form action="/boards/{{ board.id }}/update/" 
          ...
          <input class="btn btn-danger" type="submit" value="수정하기">
    </form>
    <a href="/boards/">BACK</a>
{% endblock %}
```

- `detail.html`에 수정하기 href를 추가해준다

```html
<a href="/boards/{{ board.id }}/edit">[수정하기]</a>
```

### urls 이름지정

- app_name을 지정해주고 각 path의 name을 `app_name:name`으로 주면 해당 페이지로 이동할 수 있게 해줌
- `redirect`부분이나 form의 `action`부분에 대해서 코드간 의존성을 낮춰줄 수 있음

```python
from django.urls import path
from . import views

app_name = 'boards'

urlpatterns = [
    path('', views.index, name='index'),  # www.mulcam.com/boards/
    path('new/', views.new, name='new'), # 사용자의 입력을 받아서 게시글 작성
    path('create/', views.create, name='create'), # 사용자가 입력한 데이터를 전송받고 실제 DB에 작성 및 사용자 피드백
    path('<int:id>/', views.detail, name='detail'), # /boards/<id>/
    path('<int:id>/delete/', views.delete, name='delete'), # /boards/<id>/
    path('<int:id>/edit/', views.edit, name='edit'), # 게시글 수정 페이지 렌더링
    path('<int:id>/update/', views.update, name='update') # 사용자가 수정한 값 받아서 update

]
```

- 다음과 같은 `views.py`의 `update`를

```python
return redirect(f'/boards/{id}')
# 아래와 같이 수정
return redirect('boards:detail', id)
```

- html의 태그들은 다음과 같이 바꿔 줌

```html
<!--<form action="/boards/{{ board.id }}/delete/" method="post">-->
    <form action="{% url 'boards:delete' board.id %}" method="post">
```

### admin

- 계정 만들기

```bash
$ python manage.py createsuperuser
사용자 이름 (leave blank to use 'student'): ultra118
이메일 주소:
Password:
Password (again):
Superuser created successfully.
```

- `boards/admin.py `등록

```python
from django.contrib import admin
from .models import Board

# Register your models here.

admin.site.register(Board)
```

### HTTP 기본속성

- Sateless
  - 상태정보가 저장되지 않음, 요청 사이에는 연결고리가 없음, 클라이언트가 서버와 상호작용하기 위해 HTTP 쿠키 만들고, 상태가 있는 세션을 활용할 수 있도록 보완
- Connectless
  - 서버에 요청을 하고 응답을 한 이후에 연결은 끊어짐
- URL(자원의 위치) vs URI(자원의 위치 + 쿼리 스트링)

### HTTP Method

- GET : 지정 리소스의 표시를 요청, 오직 데이터를 받기만 함
- POST : 클라이언트 데이터를 서버로 보냄
- PUT/PATCH : 서버로 보낸 데이터를 저장/지정 리소스의 부분만을 수정
- DELETE : 지정 리소스 삭제

### RESTful(Representational State Transfer)

- REST의 구성

  - 자원(URI)
  - 행위(HTTP Method) : GET/POST/PUT/DELETE
  - 표현(Representations)

- REST 중심 규칙

  - URI는 오직 정보의 자원만을 표현해야함
    - `GET /users/read/1` 는 행위가 표현 됨 X
    - `GET /users/1`처럼 오직 자원만 표현

  

  

  - 자원에 대한 행위는 HTTP Method로 표현



어떻게 할지는 method에서 정의

URI는 자원을 표현하는데에만 중점을 둬야함

어떤 행위를 하는지는 -> method

명확하게 URI는 자원의 위치만 명시

거기에 대한 행위는 HTTP method로 구별

HTML에서 공식적인 지원은 GET/POST



## RESTful하게 코드 짜기

- `new, create`의 통합 `method(GET/POST)`로 분기
- 사용자의 요청을 확인하면 method를 확인할 수 있음

- `new` + `create`
  - `create.html`의 form에서의 action또한 수정해줌

```python
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
        board = Board(title=title, content=content)
        board.save()
        return redirect('boards:detail', board.id)
```

- `edit`+`update`
  - create.html`의 form에서의 action또한 수정해줌

```python
def edit(request, id):
    board = Board.objects.get(id=id)
    if request.method == 'GET':
        # GET - edit
        context = {'board': board}
        return render(request, 'boards/edit.html', context)
    else:
        # POST - update
        title = request.POST.get('title')
        content = request.POST.get('content')
        board.title = title
        board.content = content
        board.save()
        return redirect('boards:detail', id)
```

- `delete`
  - `GET`으로 들어오면 `redirect` `boards:edit`
  - `POST`로 들어오면 정상적으로 삭제

```python
def delete(request, id):
    if request.method == 'GET':
        # GET - detail page로 redirect
        return redirect('boards:detail', id)
    else:
        # POST - 정상 삭제
        board = Board.objects.get(id=id)
        board.delete()
        return redirect('boards:index')
```

- `http method`허용여부를 명시할 수 있음

```python
from django.views.decorators.http import require_http_methods

@require_http_methods(['POST'])
def delete(request, id):
    # if request.method == 'GET':
    #     # GET - detail page로 redirect
    #     return redirect('boards:detail', id)
    # else:
    # POST - 정상 삭제
    board = Board.objects.get(id=id)
    board.delete()
    return redirect('boards:index')
```

- `get_object_or_404`
  - object를 가지고 오는데 없으면 `404` return

```python
from django.shortcuts import render, redirect, get_object_or_404

board = get_object_or_404(Board, id=id)
```

### 댓글 추가

- 댓글 DB를 추가 해줌
- `models.py`에`Comment` class 추가

```python
# 댓글 db
class Comment(models.Model):
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # comment는 board에 여러개 귀속되기 때문에 1:N
    # 게시글이 지워졌을때 그 게시글에 귀속되어있는 댓글을 다 지울지, 아니면 어떤식으로든 저장할지
    # on_delte 통해 지정해줌 CASCADE -> 지울 때 같이 지움 DO_NOTHING -> 안 지움
    board = models.ForeignKey(Board, on_delete=models.CASCADE)
```

- `makemigrations`

```bash
$ python manage.py makemigrations
```

- `migrate`(db에 적용)

```bash
$ python manage.py migrate
```

