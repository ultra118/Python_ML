# django - crud

- install django

```bash
$ pip install django
```

- project start - crud라는 이름으로 현재 디렉토리에 생성

```bash
$ django-admin startproject crud .
```

## app 추가해주기

- app 만들기

```bash
$ python manage.py startapp boards
```

- curd의 `setting.py`의 `INSTALLED_APPS`에새로 생성된 app을 추가해줌
- 아랫 부분에 `LANGUAGE_CODE`와 `TIME_ZONE`설정

```python
INSTALLED_APPS = ['boards.apps.BoardsConfig', ... ]

...

LANGUAGE_CODE = 'ko-kr'

TIME_ZONE = 'Asia/Seoul'
```

## .gitignore 추가

- [gitignore.io](<https://www.gitignore.io/>)
  - python, pycharm, database, windows

## MODEL

- `boards/model.py`에서 model을 작성

```python
from django.db import models

# Create your models here.

class Board(models.Model): # model로서 사용할 수 있음
    # id는 기본적으로 처음 테이블 생성시 자동으로 만들어 짐
    # id = models.AutoField(primary_key=True)
    # 클래스 변수 => DB에서의 필드를 나타냄
    title = models.CharField(max_length=10)
    content = models.TextField()
    # auto_now_add -> 객체를 하나 생성할 때의 시점에 저장
    created_at = models.DateTimeField(auto_now_add=True)
    # auto_now -> 지금 작업을 할 때를 기준으로 저장
    updated_at = models.DateTimeField(auto_now=True)
```

- `crud/settings.py`의 `USE_TZ`을 Flase로 바꿔 줌

```python
# True로 두면 templates나 form 안에서만 TIME_ZONE가 적용 되기때문에
# 모든 범위에서 TIME_ZONE적용되게 하기 위해 False를 줌
USE_TZ = False
```

- 작성하고나면 어떤 모델을 사용할 건지 데이터베이스에 저장하기위한 설계도를 그리기 위해 

- model이 database에 저장이 되어아하는데 어떤 값으로 저장이되는지 설계도 처럼 그려주는데 그 설계도들이 쌓이는 디렉토리는 `boards/migrations`
- model을 사용하기위해 처음에 반드시 `makemigrations`를 해줘야함

```bash
 $ python manage.py makemigrations
 
 Migrations for 'boards':
  boards\migrations\0001_initial.py
    - Create model Board

```

- 그리고 migrate작업을 함

```bash
$ python manage.py migrate
$ python manage.py migrate boards
# boards한테만 적용시킴
```

## Django-shell

- django의 model들을 사용할 수 있는 `python shell`

```bash
$ python manage.py shell 

Python 3.7.0 (default, Jun 28 2018, 08:04:48) [MSC v.1912 64 bit
 (AMD64)]
Type 'copyright', 'credits' or 'license' for more information
IPython 6.5.0 -- An enhanced Interactive Python. Type '?' for he
lp.

In [1]: 
```

```bash
In [1]: from boards.models import Board

In [2]: Board.objects.all()
Out[2]: <QuerySet []>
```

### create - 1

```python
In [3]: board = Board()

In [4]: board
Out[4]: <Board: Board object (None)>

In [5]: board.title = 'new Board'

In [6]: board.content = 'Hello World'

In [7]: board
Out[7]: <Board: Board object (None)>
# 값을 다 넣었으니 있는지 확인
In [8]: board.title
Out[8]: 'new Board'

In [9]: board.content
Out[9]: 'Hello World'

In [10]: board.save()

In [11]: board
# save를 하고나서 None -> 1이 된 것을 확인할 수 있음
Out[11]: <Board: Board object (1)>

In [12]: board.id
Out[12]: 1
    
In [13]: Board.objects.all()
Out[13]: <QuerySet [<Board: Board object (1)>]>

```

### create -2

```python
In [14]: board=Board(title="Second Board", content="Django!")

In [15]: board.title
Out[15]: 'Second Board'

In [16]: board.content
Out[16]: 'Django!'
    
    
In [17]: board.save()

In [19]: board
Out[19]: <Board: Board object (2)>

```

### create-3

```python
In [22]: Board.objects.create(title="Thrid board", content="Happy Hacking!")
Out[22]: <Board: Board object (3)>
```

### 기본적으로 필드 default는 not null

- 반드시 필드 값을 채워줘야 함

```python
In [24]: board = Board()
In [25]: board.title = "New Board"
In [26]: board.full_clean()
----------------------------------------------------------------
ValidationError                Traceback (most recent call last)

<ipython-input-26-e4c7af6ead3d> in <module>()
----> 1 board.full_clean()

C:\ProgramData\Anaconda3\lib\site-packages\django\db\models\base
.py in full_clean(self, exclude, validate_unique)
   1201
   1202         if errors:
-> 1203             raise ValidationError(errors)
   1204
   1205     def clean_fields(self, exclude=None):

ValidationError: {'content': ['이 필드는 빈 칸으로 둘 수 없습니
다.']}


```

## admin 등록

- `admin.py`내용 수정

```python
from django.contrib import admin
from .models import Board

# Register your models here.
admin.site.register(Board)
```

- admin 등록하고

```bash
$ python manage.py createsuperuser
사용자 이름 (leave blank to use 'student'): ultra118
이메일 주소:
Password:
Password (again):
Superuser created successfully.
```

- server 실행하고
- `/admin`접속하면 admin page로 관리할 수 있음

### 간단한 쿼리

- Select

```python
# SELECT * FROM boards;
Board.objects.all()
Out[3]: <QuerySet [<Board: 1번째 글 - new Board : Hello World>,
<Board: 2번째 글 - Second Board : Django!>,
<Board: 3번째 글 - Thrid board : Happy Hacking!>]>
    
# SELECT * FROM boards WHERE title='new Board';
Board.objects.filter(title="new Board")
Out[9]: <QuerySet [<Board: 1번째 글 - new Board : Hello World>,
<Board: 4번째 글 - new Board : go home>]>

# SELECT * FROM boards WHERE title='new Board' LIMIT 1;
Board.objects.filter(title="new Board").first()
Out[10]: <Board: 1번째 글 - new Board : Hello World>

# SELECT * FROM boards WHERE id=1;
 Board.objects.filter(id=1)
Out[11]: <QuerySet [<Board: 1번째 글 - new Board : Hello World>]

# SELECT * FROM boards WHERE id=1;
# primary key인 것에만 get을 사용할 수 있음
# get은 값이 중복이거나 일치하는 값이 없으면 오류가 나기 때문
Board.objects.get(id=1)
Out[12]: <Board: 1번째 글 - new Board : Hello World>

# SELECT * FROM boards ORDER BY title ASC;            
Board.objects.order_by('title').all()
Out[16]: <QuerySet [<Board: 2번째 글 - Second Board : Django!>,
<Board: 3번째 글 - Thrid board : Happy Hacking!>, <Board: 1번째
글 - new Board : Hello World>, <Board: 4번째 글 - new Board : go
 home>]>

# SELECT * FROM boards ORDER BY title DESC;
Board.objects.order_by('-title',).all().reverse()
Out[19]: <QuerySet [<Board: 2번째 글 - Second Board : Django!>, <Board: 3번째 글 - Thri
d board : Happy Hacking!>, <Board: 1번째 글 - new Board : Hello World>, <Board: 4번째
글 - new Board : go home>]>

# indexing도 가능
# 하지만 type이 list는 아니고 querry set type이라 완전 리스트처럼 생각하고 쓸 수 는 없음
Board.objects.all()[:2]
Out[26]: <QuerySet [<Board: 1번째 글 - new Board : Hello World>, <Board: 2번째 글 - Sec
ond Board : Django!>]>

# LIKE
Board.objects.filter(content__contains="Happy")
Out[29]: <QuerySet [<Board: 3번째 글 - Thrid board : Happy Hacking!>]>

# Startswith
Board.objects.filter(content__startswith="Happy")
Out[31]: <QuerySet [<Board: 3번째 글 - Thrid board : Happy Hacking!>]>

# Endswith
Board.objects.filter(content__endswith="!")
Out[32]: <QuerySet [<Board: 2번째 글 - Second Board : Django!>, <Board: 3번째 글 - Thri
d board : Happy Hacking!>]>
```

- Update

```python
# Update ...
board = Board.objects.get(pk=1)
board
Out[34]: <Board: 1번째 글 - new Board : Hello World>
board.title
Out[35]: 'new Board'

board.title = 'old Board'
board
Out[37]: <Board: 1번째 글 - old Board : Hello World>

# admin page에서 update되는걸 확인할 수 있음
board.save()
```

- Delete
  - save같은거 안해도 바로 삭제 됨

```python
board = Board.objects.get(pk=1)

board
Out[40]: <Board: 1번째 글 - old Board : Hello World>

In [41]: board.delete()
Out[41]: (1, {'boards.Board': 1})

board = Board.objects.get(pk=1)
---------------------------------------------------------------------------
...
DoesNotExist: Board matching query does not exist.

```



## 사용자 입력 받아서 CRUD

- `crud/urls.py`에서 `urlpatterns`에 경로 `include`

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('boards/', include('boards.urls')),
    path('admin/', admin.site.urls),
]

```

- `boards/urls.py`에서 매핑위한 `path `설정

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),
    path('new/', views.new), # 사용자 입력 페이지
    path('create/', views.create) # 데이터 저장 페이지
]
```

- `boards/views.py`에서 함수 생성

```python
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
```

- `boards/templates/boards/.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Boards New</title>
</head>
<body>
    <h1>New</h1>
    <form action="/boards/create/">
        <input type="text" name="title">
        <br>
        <textarea name="content" id="" cols="30" rows="10"></textarea>
        <input type="submit">
    </form>
</body>
</html>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create</title>
</head>
<body>
    <h1>성공적으로 글이 작성되었습니다.</h1>

</body>
</html>
```

