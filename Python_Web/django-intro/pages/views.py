from django.shortcuts import render
import random
from datetime import datetime

# Create your views here.
def index(request):
    return render(request, 'index.html')

def dinner(request):
    menu = ['밥1', '밥2', '밥3', '밥4', '밥5']
    dinner_choice = random.choice(menu)
    return render(request, 'dinner.html', {'dinner' : dinner_choice})
def greeting(request, name):
    return render(request, 'greeting.html', {'hello_name' : name})

def introduce(request, name, age):
    return render(request, 'introduce.html', {'name' : name, 'age': age})

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
    return render(request, 'template_language.html',context)

def isitbirthday(request):
    return render(request, 'isitbirthday.html')

def throw(request):
    return render(request, 'throw.html')

def catch(request):
    m_name = request.GET.get('name')
    m_age = request.GET.get('age')
    context = {'name' : m_name, 'age' : m_age }
    return render(request, 'catch.html', context )