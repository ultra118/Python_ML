from django.db import models

# Create your models here.


class Movie(models.Model):
    title = models.CharField(max_length=100) # 영화명
    title_origin = models.CharField(max_length=100) # 영화명 원문
    vote_count = models.IntegerField() # TMDB투표수
    open_date = models.CharField(max_length=30) # 개봉일
    genre = models.CharField(max_length=50) # 장르
    score = models.FloatField() # 평점
    poster_url = models.TextField() # 포트서 이미지 URL
    description = models.TextField() # 영화소개
