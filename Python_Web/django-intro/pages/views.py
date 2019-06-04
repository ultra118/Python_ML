from django.shortcuts import render
import random
from datetime import datetime
import requests

# Create your views here.
def index(request):
    return render(request, 'pages/index.html')

def dinner(request):
    menu = ['밥1', '밥2', '밥3', '밥4', '밥5']
    dinner_choice = random.choice(menu)
    return render(request, 'pages/dinner.html', {'dinner' : dinner_choice})
def greeting(request, name):
    return render(request, 'pages/greeting.html', {'hello_name' : name})

def introduce(request, name, age):
    return render(request, 'pages/introduce.html', {'name' : name, 'age': age})

def template_language(request):
    menus = ['밥1', '밥2', '밥3', '밥4', '밥5']
    messages = ['apple', 'banana', 'orange', 'mango','cucumber']
    my_sentence = 'Life is short, you need python'
    datetimenow = datetime.now()
    empty_list = []

    context = {
        'menus' : menus,
        'messages' : messages,
        'my_sentece' : my_sentence,
        'datetimenow' : datetimenow,
        'empty_list' : empty_list,
    }
    return render(request, 'pages/template_language.html',context)

def isitbirthday(request):
    return render(request, 'pages/isitbirthday.html')

def throw(request):
    return render(request, 'pages/throw.html')

def catch(request):
    m_name = request.GET.get('name')
    m_age = request.GET.get('age')
    context = {'name' : m_name, 'age' : m_age }
    return render(request, 'pages/catch.html', context )

def artii(request):
    return render(request, 'pages/artii.html')

def result(request):
    word = request.GET.get('word')
    fonts_url = 'http://artii.herokuapp.com/fonts_list'
    fonts = requests.get(url=fonts_url).text
    font_list = fonts.split('\n')
    font = random.choice(font_list)
    artii_url = f'http://artii.herokuapp.com/make?text= {word}&font={font}'
    result = requests.get(url=artii_url).text
    context = {'font' : font,
               'result' : result}
    return render(request, 'pages/result.html', context )

def static_example(request):
    return render(request, 'pages/static_example.html')