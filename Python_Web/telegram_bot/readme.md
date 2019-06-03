# Telegram bot

## Bot settings

- Search tab에서 `BotFather` 검색
- BotFather 채팅창에 `/start` 메세지 보내기
- `newbot`보내고 new bot 생성 메세지 확인하고 bot 이름과 username 순차적으로 입력

- 돌려주는 Token값 저장하고 [api주소](<https://core.telegram.org/bots/api>)통해서 원하는 서비스 구현

## Telegram 반응형 서비스 만들기

### 1. Flask APP 만들기

```python
#app.py로 생성
from flask import Flask, request
import requests

app = Flask(__name__)

@app.route('/')
def root():
    return 'Happy Hacking'
```

- Termianl에서 실행

```bash
$ python app.py

* Tip: There are .env files present. Do "pip install python-dotenv" to use them.
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Restarting with stat
 * Tip: There are .env files present. Do "pip install python-dotenv" to use them.
 * Debugger is active!
 * Debugger PIN: 114-720-857
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)

```

### 2. Ngrok 통해 포워딩(public URL 만들기)

- ngrok 다운받고 프로젝트 경로로 .exe 파일 집어넣고

```bash
$ ./ngrok.exe http 5000

Session Status                online
Session Expires               6 hours, 41 minutes
Version                       2.3.29
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://f5b1a903.ngrok.io -> http://localhost:5000
Forwarding                    https://f5b1a903.ngrok.io -> http://localhost:5000

```

- 5000번 포트로 들어오는 url에 대한 포워딩?\
- 생성된 주소를 telegram webhook에 설정

### 3. Telegram Webhook 설정

```python
token = config('TOKEN')
api_url = f'https://api.telegram.org/bot{token}'
webbook_url = input()
# 위의 forwarding된 주소 뒤에 token을 붙여서 webhook set
print(f'{api_url}/setWebhook?url={webbook_url}')
```

### 4. FLASK APP 설정

```python
@app.route(f'/{token}', methods=['POST'])
def telegram():
    # 파일 상단에서 import pprint
    message = request.get_json().get('message')
    if message is not None:
        chat_id = message.get('from').get('id')
        text = message.get('text')
        requests.get(f'{api_url}/sendMessage?chat_id={chat_id}&text={text}')
    # 꼭 이렇게 return 해줘야함
    return '', 200

```

### 5. Token 관리

- token을 공개해둘 수 없으니 decouple pkg로 관리

```bash
pip install python-decouple
touch .env
vi .env
```

- `TOKEN=''`과 같은 형태로 값 입력해둠

```python
from decouple import config
token = config('TOKEN')
```

- git hub에는 gitignore에 .env를 추가



### Webhook 이란

- [Webhook개념](<https://jm4488.tistory.com/57>)

- 웹훅은 새 이벤트(클라이언트 측 응용 프로그램이 관심을 가질 수 있는)가 서버에서 발생한 경우 서버 측 응용프로그램이 클라이언트 측 응용 프로그램에 알릴 수 있는 메커니즘을 제공함

- 역 API라고도 함, 일반적인 API는 클라이언트가 서버를 호출하지만, 웹훅은 서버에서 특정 이벤트가 발생했을 때 클라이언트를 호출