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
        movie = Movie()
        movie.title = request.POST.get('title')
        movie.title_origin = request.POST.get('title_origin')
        movie.vote_count = request.POST.get('vote_count')
        movie.open_date = request.POST.get('open_date')
        movie.genre = request.POST.get('genre')
        movie.score = request.POST.get('score')
        movie.poster_url = request.POST.get('poster_url')
        movie.description = request.POST.get('description')
        movie.save()
        return redirect('movies:detail', movie.id)

@require_http_methods(['GET','POST'])
def update(request, movie_id):
    movie = Movie.objects.get(pk=movie_id)
    if request.method == 'GET':
        content = {'movie': movie}
        return render(request, 'movies/update.html', content)
    else:
        movie.title = request.POST.get('title')
        movie.title_origin = request.POST.get('title_origin')
        movie.vote_count = request.POST.get('vote_count')
        movie.open_date = request.POST.get('open_date')
        movie.genre = request.POST.get('genre')
        movie.score = request.POST.get('score')
        movie.poster_url = request.POST.get('poster_url')
        movie.description = request.POST.get('description')
        movie.save()
        return redirect('movies:detail', movie.id)

@require_http_methods(['POST'])
def delete(request, movie_id):
    movie = Movie(pk=movie_id)
    movie.delete()
    return redirect('movies:index')



