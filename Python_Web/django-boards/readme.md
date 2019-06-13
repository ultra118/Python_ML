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
## 댓글 추가
### 댓글 db 추가

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

### django-extensions

```bash
$ pip install django-extensions
```

### shell_plus

- 다음과 같이 django shell을 사용할 수 있는데

```bash
$ python manage.py shell
```

- django-extensions를 받으면 `shell_plus`를 사용할 수 있음
- project 파일 `seeting.py`의  `INSTALLED_APPS`에 app추가해 줘야함

```python
INSTALLED_APPS = [
    # Local Apps
    'boards',
    # 3rd party Apps
    'django_extensions',
	...

```

- `shell_plus`쓰면 model들을 알아서 import 해줌

```bash
$ python manage.py shell_plus
# Shell Plus Model Imports
from boards.models import Board, Comment
from django.contrib.admin.models import LogEntry
from django.contrib.auth.models import Group, Permission, User
from django.contrib.contenttypes.models import ContentType
from django.contrib.sessions.models import Session
# Shell Plus Django Imports
from django.core.cache import cache
from django.conf import settings
from django.contrib.auth import get_user_model
from django.db import transaction
from django.db.models import Avg, Case, Count, F, Max, Min, Prefetch, Q, Sum, When, Exi
sts, OuterRef, Subquery
from django.utils import timezone
from django.urls import reverse
```

- `model`들을 `import`하지 않았는데 알아서 로드되는걸 볼 수 있음

```bash
In [2]: boards = Board.objects.all()

In [3]: boards
Out[3]: <QuerySet [<Board: 9. title9sdfsdf>, <Board: 13. sdgsdgsg>, <Board: 15. post_ne
w>, <Board: 16. ttwet>]>
In [4]: comment = Comment.objects.all()

In [5]: comment
Out[5]: <QuerySet []>

```

### 댓글 등록하기

```python
board = Board.objects.get(pk=16)
comment = Comment()
comment.content = '첫 번째 댓글'
# 댓글 fk까지 등록하고 세이브
comment.board = board
comment.save()
comment
Out[18]: <Comment: Comment object (1)>
comment.board
Out[19]: <Board: 16. ttwet>
# fk의 key값은 _id로 가지고올 수 있음
comment.board_id
Out[20]: 16
# fk에 대한 다른 attr로 접근 가능
comment.board.title
Out[25]: 'ttwet'
comment.board.content
Out[23]: 'ssdgsdg'

# id를 직접 줘서 저장할 수 있음
board = Board.objects.get(pk=9)
comment = Commnet()
comment.content = '두 번째 댓글'
# comment.board_id = 9
comment.board_id = baord.id
comment.board
Out[51]: <Board: 9. title9sdfsdf>
comment.save()

# 생성하면서 할당
board = Board.objects.get(pk=13)
comment = Comment(board_id = board.id, content = '네 번째 댓글')
comment.save()
```

### board에서 댓글가져오기

```python
board = Board.objects.get(pk=13)
comments = board.comment_set.all()
comments
Out[24]: <QuerySet [<Comment: <Board(16) : Comment : 1 - 첫 번째 댓글...>>]>
```

### admin에 등록

- `admin.py`

```python
from django.contrib import admin
from .models import Board, Comment

# Register your models here.

admin.site.register(Board)
admin.site.register(Comment)
```

- admin 접속 - `/admin`

```bash
$ python manage.py runserver
```

### 댓글 등록하기

- `urls.py`에 path 등록

```python
urlpatterns = [
    ...
    # Comments
    path('<int:board_id>/comment/', views.comment_create, name='comment_create')
]
```

- `views.py`에 

```python
from .models import Board, Comment

def comment_create(request, board_id):
    content = request.POST.get('content')
    comment = Comment(content=content, board_id=board_id)
    comment.save()
    print(comment)
    return redirect('boards:detail', board_id)
```

### detail page에 댓글등록

- `views.py`에서

```python
@require_http_methods(['GET'])
def detail(request, board_id):
    ...
    board = get_object_or_404(Board, id=board_id)
    # 댓글들을 id의 역순으로 가지고옴
    comments = board.comment_set.order_by('-id').all()
    context = {'board' : board, 'comments': comments}
    return render(request, 'boards/detail.html', context)

@require_http_methods(['POST'])
def comment_create(request, board_id):
    content = request.POST.get('content')
    comment = Comment(content=content, board_id=board_id)
    comment.save()
    print(comment)


    # 댓글 생성하는 로직
    return redirect('boards:detail', board_id)
```

- `detail.html`

```html
{% extends 'boards/base.html' %}

{% block body %}
<h1>DETAIL PAGE</h1>
    ...
    <form action="{% url 'boards:comment_create' board.id %}" method="post">
        {% csrf_token %}
        <input type="text" name="content" placeholder="댓글을 입력해주세요">
        <input type="submit" value="댓글쓰기">
    </form>
    ...
    <hr/>
    {% for comment in comments %}
        <li>{{ comment.content }}</li>
	{% empty %}
        <p> 댓글이 하나도 없습니다. </p>
    {% endfor %}

{% endblock %}
```

## image 추가

- `boards/models.py`에 `ImageField()`추가
- 이미지는 있어도 되고 없어도 되기때문에 `blank=True`

```python
image = models.ImageField(blank=True)
```

- `make migrations`

  ```bash
  python manage.py makemigrations
  ```

- `migrate`

  ```bash
  python manage.py migrate
  ```

- `Pillow`받아줘야함

  ```bash
  pip install Pillow
  ```

- `views.py `수정

  ```python
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
  ```

  



- `new.html` 수정

  - 이미지 타입이 들어올 수 있게 html에서 필터링 - 완전히 막지는 못함
  - 파일들까지 form에서 같이 보내기때문에 `multipart/form-data`
    - application-...는 기본 default
    - text-plain은 문자 그대로를 보내줌

  ```html
  {% extends 'boards/base.html' %}
  
  {% block body %}
      <h1> NEW </h1>
      <!--<form action="/boards/create/" method="post">-->
      <form action="{% url 'boards:new' %}" method="post" enctype="multipart/form-data">
          {% csrf_token %}
          ...
          <input type="file" name="image" accept="image/*"><br/>
          <input type="submit">
      </form>
      <!--<a href="/boards/">BACK</a>-->
      <a href="{% url 'boards:index' %}">BACK</a>
  
  {% endblock %}
  ```

- `detail.html`

  - `board.image.url `로 url정보
  - `board.image.name`으로 파일 이름을 가지고올 수 있음

  ```html
  {% extends 'boards/base.html' %}
  
  {% block body %}
  <h1>DETAIL PAGE</h1>
      <p> board id : {{ board.id }}</p>
      <p> board title : {{ board.title }}</p>
      <p> <img src="{{ board.image.url }}" alt="{{ board.image.name }}"> </p>
      ...
  {% endblock %}
  ```

  

## 이미지 저장경로에 대한 설정

- `curd/settings.py`의 MEDIA_URL 등록해주도록함
- media파일에 접근하기위한 url

```python
MEDIA_URL ='/media/'
```

- `media root`설정

```python
MEDIA_ROOT = os.path.join(BASE_DIR,'media')
```

- `curd/urls.py`

  ```python
  ...
  from django.conf import settings
  from django.conf.urls.static import static
  
  
  urlpatterns = [
      path('boards/', include('boards.urls')),
      path('admin/', admin.site.urls),
  ]
  
  # domain.com/media/smaple.jpg
  urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
  ```

- 이미지 파일 수정할 수 있게

- `edit.html`

  ```python
  {% extends 'boards/base.html' %}
  
  {% block body %}
      <h1> EDIT </h1>
      {% if board.image %}
      <img src="{{ board.image.url }}" alt="{{ board.image.name }}">
      {% endif %}
  
      <!--<form action="/boards/{{ board.id }}/update/" method="post">-->
      <form action="{% url 'boards:edit' board.id %}" method="post" enctype=multipart/form-data>
          ...
          <input type="file" name="image" accept="image/*"><br/>
          <textarea name="content" id="content">{{ board.content }}</textarea><br/>
          <input class="btn btn-success" type="submit" value="수정하기">
      </form>
      <!--<a href="/boards/">BACK</a>-->
      <a href="{% url 'boards:index' %} ">BACK</a>
  {% endblock %}
  ```

- `views.py`

## image 처리

- Piloow설치

```bash
pip install Pillow
```

- 이미지 처리 위한 pkg install

```bash
pip install pilkit
```

```bash
pip install django-imagekit
```

- `curd/settings.py`
  - imagekit등록

```python
INSTALLED_APPS = [
    # Local Apps
    'boards',
    # 3rd party Apps
    'django_extensions',
    'imagekit',

    # Django Apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

- `boards/models.py`

```pyhton
from imagekit.models import ProcessedImageField
from pilkit.processors import Thumbnail

class Board(models.Model):
    ...
    #image = models.ImageField(blank=True)
    image = ProcessedImageField(
        upload_to='boards/images', # 저장위치 (media 이후의 경로)
        processors=[Thumbnail(200, 300)],
        format="JPEG",
        options={'quality':90},
    )
    ...
```

