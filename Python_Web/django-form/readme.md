# django-form

## start project 설정

- `start project`

```bash
$ django-admin startproject django_form .
```

- `start app`

```bash
$ python manage.py startapp boards
```

- `django_form/settings.py`

```python
INSTALLED_APPS = [
    'boards',
	...
]
...
LANGUAGE_CODE = 'ko-kr'
TIME_ZONE = 'Asia/Seoul'
```

- `.gitignore`추가
  - `gitignore.io`에서 제외하고싶은 환경 추가

```bash
$ touch .gitignore
$ vi .gitignore
```

- `django_form/urls`

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('boards/', include('boards.urls')),
    path('admin/', admin.site.urls),
]
```

## start app 설정

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

- makemigrations

```bash
$ python manage.py makemigrations
```

- migrate

```bvash
$ python manage.py migrate
```

### admin

- `admin.py`

```python
from django.contrib import admin
from .models import Board

# Register your models here.
@admin.register(Board)
class BoardAdmin(admin.ModelAdmin):
    list_display = ('title', 'content', 'created_at', 'updated_at')
    # readonly_fields
```

- 계정 만들기

```bash
$ python manage.py createsuperuser
사용자 이름 (leave blank to use 'student'): ultra118
이메일 주소:
Password:
Password (again):
Superuser created successfully.
```

## urls

- `startproject/settings.py`

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('boards/', include('boards.urls')),
    path('admin/', admin.site.urls),
]
```

## 반복적은 form 태그사용에 대한 해결

- `boards/forms.py`생성
  - 각 폼 태그에대한 속성을 설정해 줄 수 있음
  - 그리고 `Meta`class를 통해 어느 model로 form을 만들지 지정할 수 있음

```python
from django import forms
from .models import Board

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
        model =  Board
        fields = ('title', 'content', )
```

- `boards/views.py`
  - BoardForm의 인자로 form을 받고 이 form이 유효하다면 db에 저장

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_POST, require_GET, require_http_methods
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

require_http_methods(['GET','POST'])
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
            board = form.save()
            return redirect('boards:detail', board.pk)
    else:
        form = BoardForm()
    context = {'form': form}
    return render(request, 'boards/form.html', context)
```

- `BoardForm`의 instance인자로 특정 board를 넘겨주면 그 board의 값을 갖는 form을 갖게할 수 있음
  - update에서 유용 

```python

@require_GET
def detail(request, board_pk):
    # object가 있으면 가져오고 없으면 404페이지
    # 어떤 모델에서 꺼내올 건지, 어떤 값을 꺼내올건지
    board = get_object_or_404(Board, pk=board_pk)
    context = {'board': board}
    return render(request, 'boards/detail.html', context)

@require_POST
def delete(request, board_pk):
    # 특정 보드를 불러와서 삭제
    board = get_object_or_404(Board, pk=board_pk)
    board.delete()
    return redirect('boards:index')

@require_http_methods(['GET','POST'])
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
```

- `form.html`

  - {{ form.as_p }}로 form 데이터를 다 불러오는데 보기 좋게 뽑아오기위해

  - bootstrap활용 

    - pip install django-bootstrap4

    - `django-from/settings.py`

      ```python
      INSTALLED_APPS = [
          'boards',
      
          'bootstrap4',
      
          'django.contrib.admin',
          'django.contrib.auth',
          'django.contrib.contenttypes',
          'django.contrib.sessions',
          'django.contrib.messages',
          'django.contrib.staticfiles',
      ]
      ```

    - 사용하는 html에서

      ```html
      {% load bootstrap4 %} 
      ```

      

```html
{% extends 'boards/base.html' %}
{% load bootstrap4 %}

{% block body %}
    {% if request.resolver_match.url_name == 'create' %}
        <h1>새로운 게시글 작성</h1>
    <!--action을 비워두면 현재 주소로 똑같이 요청을 보냄-->
    <!--create로 들어오면 create로 보내고 update로 들어오면 update로 보내게됨-->
    <!--그니까 이름을 form.html로 바꿔주도록 함-->
    {% else %}
        <h1>게시글 수정</h1>
    {% endif %}
    <form action="" method="post">
        {% csrf_token %}
        <!--<label for="title">Title</label><br/>-->
        <!--<input type="text" id="title" name="title"><br/>-->
        <!--<label for="content">Content</label><br/>-->
        <!--<textarea name="content" id="content" ></textarea><br/>-->
        <!--form안에 데이터가 있으면 알아서 채워주는?-->
        {% bootstrap_from form layout='horizontal' %}
        {% buttons submit= "Submit" reset="Cancel" %}
        {% endbuttons %}
        <!--{{ form.as_p }}-->
        <!--<input type="submit" value="작성하기">-->
    </form>
    {% if request.resolver_match.url_name == 'create' %}
        <a href="{% url 'boards:index' %}">[뒤로가기]</a>
    {% else %}
        <a href="{% url 'boards:detail' board_pk %}">[뒤로가기]</a>
    {% endif %}
{% endblock %}
```

## 인증 권한 위한 app설정

- start app 생성

```bash
$ python manage.py startapp acctouns
```

- djano_form에 app등록

```python
INSTALLED_APPS = [
    'boards',
    'accounts',

    'bootstrap4',

    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

- django_from의 urls에 등록

```python
urlpatterns = [
    path('accounts/', include('accounts.urls')),
    path('boards/', include('boards.urls')),
    path('admin/', admin.site.urls),
]
```

### 새로운 app 생성

```bash
$ python manage.py startapp accounts
```

- `urls.py`

```python
from django.urls import path
from . import views

app_name = 'accounts'

urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('login/', views.login, name='login'),
    path('logout/', views.logout, name='logout'),
    path('update/', views.update, name='update'),
    path('password/', views.change_password, name='change_password'),
    path('delete/', views.delete, name='delete'),
]
```

- `views.py`

```python
from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm
from django.contrib.auth import login as auth_login, logout as auth_logout, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST, require_GET, require_http_methods
from .forms import CustomUserChangeForm

# Create your views here.

@require_http_methods(['GET', 'POST'])
def signup(request):
    if request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # user = form.get_user()
            auth_login(request, user)
            return redirect('boards:index')
    else:
        form = UserCreationForm()
    context = {'form': form}
    return render(request, 'accounts/signup.html', context)


@require_http_methods(['GET', 'POST'])
def login(request):
    # 로그인이 되어있으면 index로 보냄
    if request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = AuthenticationForm(request, request.POST)
        #  사용자 입력 유효성 검사
        if form.is_valid():
            #  로그인
            # request, 사용자
            auth_login(request, form.get_user())
            return redirect(request.GET.get('next') or 'boards:index')
    else:  # GET /accounts/login/ -> html 페이지만 렌더링
        form = AuthenticationForm()
    context = {'form': form}
    return render(request, 'accounts/login.html', context)


@require_GET
def logout(request):
    # 로그아웃 로직
    auth_logout(request)
    return redirect('boards:index')


# 로그인이 되어야만 페이지 접근 가능
@login_required
@require_http_methods(['GET', 'POST'])
def update(request):
    if not request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = CustomUserChangeForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect('boards:index')
    else:
        # 사용자 정보를 instance에 넣어줌
        form = CustomUserChangeForm(instance=request.user)
    # GET으로 들어와도 사용하고, valid가 안될때도 사용할 수 있게
    context = {'form': form}
    return render(request, 'accounts/update.html', context)


@login_required
@require_http_methods(['GET', 'POST'])
def change_password(request):
    if request.method == 'POST':
        # 비밀번호 변경로직
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            form.save()
            # 세션의 정보와 회원의 정보가 달라져서 session을 유지한 상태로 새롭게 업데이트
            update_session_auth_hash(request, request.user)
            return redirect('board:index')
    else:
        form = PasswordChangeForm(request.user)
    context = {'form': form}
    return render(request, 'accounts/change_password.html', context)


@require_POST
def delete(request):
    # 유저 삭제 로직
    request.user.delete()
    return redirect('boards:index')

```

- bootstrap load해서 html 구현

### login_required issue

- redirect는 기본적으로 get요청

- post로 받는 애들은 어차피 수행 못함

- 하나의 게시글이 여러명의 유저를 가질 수 없으니 그거에 대한 관계 model에서 수정
- `boards/models.py`

```python
from django.conf import settings
# 프로젝트의 settings를 가져오고 

# user지워지면 참조되는 값들 싹 다 지움
user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
```

- 모델 수정하고나면 user에대한 default값을 채워주라는 옵션값이 나옴

```bash
 1) Provide a one-off default now (will be set on all existing r
ows with a null value for this column)
 2) Quit, and let me add a default in models.py
Select an option: 1
Please enter the default value now, as valid Python
The datetime and django.utils.timezone modules are available, so
 you can do e.g. timezone.now
Type 'exit' to exit this prompt
>>> 1
```

- 1번 아이디에 해당하는 user를 default로 지정해줌

- 이제 저장할 때 유저 값을 넣어줘야 함 boards.views.py의 `create`부분에서

```python
# commit False없으면 board save를 바로 해버림
# board.save따로해줘야하기때문에 commit false해주고
board = form.save(commit=False)

board.user = request.user
board.save()
```

## comment 추가

- `boards/models.py`에 추가

```python
from django.db import models
from django.conf import settings


# Create your models here.
class Board(models.Model):
    title = models.CharField(max_length=20)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # 참조하고있는유저, on_delte=유저가 삭제되면 board를 어떻게 할지(CASCADE는 다 지워줌)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.pk}. {self.title}'


class Comment(models.Model):
    content = models.CharField(max_length=100)
    # auto=자동 now=현시점 add=add되는 시점으로
    created_at = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    board = models.ForeignKey(Board, on_delete=models.CASCADE)

    def __str__(self):
        return self.content
```

### migrate

```bash
$ python manage.py makemigrations
```

```bash
$ python manage.py migrate
```

### @require

``` python
from django.views.decorators.http import require_POST, require_GET, require_http_methods
from django.contrib.auth.decorators import login_required
```

- 여러 require통해서 특정 method만 받거나 login되어있는지 등으로 받음

### admin page 꾸미기

- `boards/admin.py`

```python
from django.contrib import admin
from .models import Board, Comment


# Register your models here.
@admin.register(Board)
class BoardAdmin(admin.ModelAdmin):
    list_display = ('title', 'content', 'created_at', 'updated_at', )
    # 수정할 수 없는 필드영역 지정
    readonly_fields = ['created_at', 'updated_at', ]


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('content', 'created_at', )
    readonly_fields = ['created_at', ]
```

## M:N 통한 '좋아요 '기능

- model build - `related_name `추가

```python
from django.db import models
from django.conf import settings


# Create your models here.
class Board(models.Model):
    title = models.CharField(max_length=20)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # 참조하고있는유저, on_delte=유저가 삭제되면 board를 어떻게 할지(CASCADE는 다 지워줌)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    # django usermodel - settings.AUTH_USER_MODEL
    like_users = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        # 역참조 할 수 있게
        related_name='like_boards',
        # 반드시 필요한건 아님
        blank=True,
    )

    def __str__(self):
        return f'{self.pk}. {self.title}'


class Comment(models.Model):
    content = models.CharField(max_length=100)
    # auto=자동 now=현시점 add=add되는 시점으로
    created_at = models.DateTimeField(auto_now_add=True)

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    board = models.ForeignKey(Board, on_delete=models.CASCADE)

    def __str__(self):
        return self.content
```



```python
# 내가 지금까지 작성한 게시글
user.board_set.all()

# 내가 좋아요 한 게시글
user.like_boards.all()
```

### font awesome

- base.html head부분에 key src 추가해주기

```html
#활용
<a class="text-danger" href="{% url 'boards:like' board.pk %}">
    <!--좋아요 누른 유저면-->
    {% if user in board.like_users.all %}
    <i class="fas fa-heart"></i>
    {% else %}
    <i class="far fa-heart"></i>
    {% endif %}
</a>
```

