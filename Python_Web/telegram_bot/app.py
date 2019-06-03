#  app.py
from flask import Flask, request
import requests
# pip install python-decouple
# token 관리하기위해 decople의 config사용
from decouple import config
app = Flask(__name__)

token = config('TOKEN')
api_url = f'https://api.telegram.org/bot{token}'

#  http://127.0.0.1/
@app.route('/')
def root():
    print('123')
    return 'Happy Hacking'


@app.route(f'/{token}', methods=['POST'])
def telegram():
    # 파일 상단에서 import pprint
    message = request.get_json().get('message')
    if message is not None:
        chat_id = message.get('from').get('id')
        text = message.get('text')
    # chat_id = response['message']['from']['id']
    # text = response['message']['text']
        requests.get(f'{api_url}/sendMessage?chat_id={chat_id}&text={text}')

    return '', 200


if __name__ == '__main__':
    app.run(debug=True)