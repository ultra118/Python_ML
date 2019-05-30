import requests

token = '844869629:AAG8rHb8IsnJqx580vdzjBgvnzY97zTXWtQ'
api_url = f'https://api.telegram.org/bot{token}'
# getme
#response = requests.get(api_url+'/getMe').json()

# getUpdates - 채팅 목록 읽어옴
response = requests.get(api_url+'/getUpdates').json()
chat_id = response['result'][0]['message']['from']['id']
print(chat_id)
text = '5시 22분'
response = requests.get(f'{api_url}/sendMessage?chat_id={chat_id}&text={text}').json()
