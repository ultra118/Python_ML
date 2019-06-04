# django

## MTV

- `Model `: 데이터를 관리
- `Template `: 사용자가 보는 화면
- `View `: 중간 관리자

- request -> View -> Model -> 파일찾고 -> View -> 파일 갖고 Template로 전달 -> 파일을 사용자에게 Response

## django-intro

- install django

```bash
$ pip install django
```

- django-admin mode

```bash
$ django-admin startproject intro .
# 현재 디렉토리에서 intro라는 이름으로 project를 시작하라
```

- 다음과 같은 디렉터리 구조 갖게 됨
  - ![image](https://user-images.githubusercontent.com/28910538/58780370-b4f58280-8613-11e9-970a-8efb84e28ef7.png)	
    - __init__.py 
      - python project임을 확인할 수 있음
    - settings.py
      - web server의 모든 설정 값들 저장
    - urls.py
      - url을 특정사이트와 mapping
    - wsgi.py
      - public url에 배포를 할 때 사용

- django server 실행

```bash
$ python manage.py runserver

Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

You have 17 unapplied migration(s). Your project may not work prope
rly until you apply the migrations for app(s): admin, auth, content
types, sessions.
Run 'python manage.py migrate' to apply them.
June 03, 2019 - 15:26:24
Django version 2.2.1, using settings 'intro.settings'
Starting development server at http://127.0.0.1:8000/

```

- startapp pages 

```bash
$ python manage.py startapp pages
```

- pages dir 생성됨

  - `admin.py`
  - `apps.py`
  - `models.py` : 모델 정의
  - `tests.py` :  test코드 작성
  - `views.py` : 뷰 정의 - flask의 route같은 부분

- 이후에 intro dir의 `settings.py`에 반드시 app을 등록해줘야함

- `INSTALLED_APPS`부분에 설치한 APP들 추가

  - `pages`안에 있는 `apps.py`에서 `PagesConfig`class를 추가

  ```python
  INSTALLED_APPS = [
      # New apps
      'pages.apps.PagesConfig',
      # Django apps
      'django.contrib.admin',
      'django.contrib.auth',
      'django.contrib.contenttypes',
      'django.contrib.sessions',
      'django.contrib.messages',
      'django.contrib.staticfiles',
  ]
  ```

  - `LANGUAGE_CODE`수정

  ```python
  LANGUAGE_CODE = 'ko-kr'
  TIME_ZONE = 'Asia/Seoul'
  ```

- `urls.py` 수정

  - 집배원 역할을 하는 `.py` 위에서부터 순차적으로 읽는 것 고려해 mapping

  ```python
  from pages import views
  
  urlpatterns = [
      # index로 오면 views.index로 보내기
      path('index/', views.index),
      path('admin/', admin.site.urls),
  ]
  ```

  - 동적으로 변수를 할당해주기 위해서는

  ```python
  urlpatterns = [
      # index로 들어오면 views.index로 연결
      path('greeting/<str:hello_name>/', views.greeting)
  ]
  
  ## views.py
  def greeting(request, name):
      return render(request, 'greeting.html', {'hello_name' : name})
  
  ## templates/greeting.html
  <h1>Hello {{ hello_name }}</h1>
  ```

  

- `views.py`에 `index `추가

  ```python
  def index(request):
      # 어떤 요청받고 어떤 파일을 render할 것인지
      # 기본적으로 templates 안에서 찾음
      return render(request, 'index.html')
  ```

- `index.html`만들기
  
  - `pages`안에서 `templates`생성해주고 그 안에 `.html`파일 생성



## [Built-in template tags and filters](<https://docs.djangoproject.com/ko/2.2/ref/templates/builtins/#if>)

- `views.py`에서 여러 변수 값들에 대해 `dict`타입으로 render 인자로 넘겨줌

### 1.반복문

```python
{% for menu in menus %}
	<!-- forloop.counter는 enumerate 처럼-->
	{{ forloop.counter}}
	<p>{{ menu }}</p>
<!-- for문 끝나는 지점은 반드시 endfor-->
{% endfor %}

{% for user in empty_list %}
	<p>{{ user }}</p>
	{% empty %}
	<!--empty : for 태그 안에 optional하게 있음, list가 비어있을 때 출력됨-->
    <p>현재 가입한 유저가 없습니다.</p>
{% endfor %}

```

### 2.조건문

```python
{% for menu in menus %}
	{{ forloop.counter }}번째 도는 중
	{% if forloop.first %}
		<p>{{menu}}는 첫 번째 메뉴</p>
	{% else %}
		<p>{{menu}}</p>
	{% endif %}
{% endfor %}
```



###  3. length filter 활용

```python
{% for message in messages %}
	{% if message|length > 5%}
		<p>글자가 김</p>
	{% else %}
    	<!-- 글자 수 return -->
		<p>{{ message}}, {{ message|length }}</p>
	{% endif %}
{% endfor %}
```

### 4. lorem ipsum

```python
{% lorem %}
<hr/>
<!-- lorem에서 3글자 -->
{% lorem 3 w %}
<hr/>
<!-- lorem에서 4글자 랜덤하게 -->
{% lorem 4 w random %}
```

### 5.  글자 수 제한(truncate)

```python
<p>{{ my_sentece|truncatewords:3 }}</p> 단어 단위로 제한
<p>{{ my_sentece|truncatechars:3 }}</p> 문자 단위로 제한(미만)
```

### 6. 글자 관련 필터

- 'abc'|legnth : 길이 return
- 'ABC'|lower : 소문자로 바꿔서 return
- my_sentence|title : title형식으로 바꿔줌 -> 모든 단어 첫번째 char은 대문자
- menus|random : random하게 하나를 꺼내 줌

### 7. 연산([django-mathfilters](<https://pypi.org/project/django-mathfilters/>))

- 4|add:6

### 8. 날짜 표현

```python
{% now "DATETIME_FORMAT" %}
2019년 6월 4일 11:23 오전
{% now "SHORT_DATETIME_FORMAT" %}
2019-6-4 11:23
{% now "DATE_FORMAT" %}
2019년 6월 4일
{% now "SHORT_DATE_FORMAT" %}
2019-6-4.
{% now "Y년  m월 d일 (D) h:i" %}
2019년 06월 04일 (화요일) 11:23
{% now "Y" as current_year %}
<p> Copyright {{ current_year }} </p>
<!-- 변수처럼도 사용 가능 -->
```

