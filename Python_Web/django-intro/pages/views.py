from django.shortcuts import render
import random

# Create your views here.
def index(request):
    return render(request, 'index.html')

def dinner(request):
    menu = ['밥1', '밥2', '밥3', '밥4', '밥5']
    dinner_choice = random.choice(menu)
    return render(request, 'dinner.html', {'dinner' : dinner_choice})

def greeting(request, name):
    return render(request, 'greeting.html', {'hello_name' : name})