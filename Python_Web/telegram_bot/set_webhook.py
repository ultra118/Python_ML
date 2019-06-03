from decouple import config
token = config('TOKEN')
api_url = f'https://api.telegram.org/bot{token}'
webbook_url = input()

print(f'{api_url}/setWebhook?url={webbook_url}')

# https://api.telegram.org/bot844869629:AAG8rHb8IsnJqx580vdzjBgvnzY97zTXWtQ/setWebhook?url=https://f5b1a903.ngrok.io/844869629:AAG8rHb8IsnJqx580vdzjBgvnzY97zTXWtQ