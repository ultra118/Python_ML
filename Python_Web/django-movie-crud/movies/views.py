from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_http_methods
from .models import Movie


# Create your views here.
@require_http_methods(['GET'])
def index(request):
    movies = Movie.objects.all()
    print(movies)
    content = {'movies': movies}
    return render(request, 'movies/index.html', content)

@require_http_methods(['GET','POST'])
def detail(request, movie_id):
    movie = Movie.objects.get(pk=movie_id)
    if request.method == 'GET':
        content = {'movie':movie}
        return render(request, 'movies/detail.html', content)
    else:
        pass

@require_http_methods(['GET','POST'])
def create(request):
    if request.method == 'GET':
        return render(request, 'movies/create.html')
    else:
        title = request.POST.get('title')
        title_origin = request.POST.get('title_origin')
        vote_count = request.POST.get('vote_count')
        open_date = request.POST.get('open_date')
        genre = request.POST.get('genre')
        score = request.POST.get('score')
        poster_url= request.POST.get('poster_url')
        description = request.POST.get('description')
        Movie(title=title, title_origin=title_origin, vote_count= vote_count)
