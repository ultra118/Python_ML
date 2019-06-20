from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm
from django.contrib.auth import login as auth_login, logout as auth_logout, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST, require_GET, require_http_methods
from .forms import CustomUserChangeForm, CustomUserCreationForm

# Create your views here.

@require_http_methods(['GET', 'POST'])
def signup(request):
    if request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # user = form.get_user()
            auth_login(request, user)
            return redirect('boards:index')
    else:
        form = CustomUserCreationForm()
    context = {'form': form}
    return render(request, 'accounts/signup.html', context)


@require_http_methods(['GET', 'POST'])
def login(request):
    # 로그인이 되어있으면 index로 보냄
    if request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = AuthenticationForm(request, request.POST)
        #  사용자 입력 유효성 검사
        if form.is_valid():
            #  로그인
            # request, 사용자
            auth_login(request, form.get_user())
            return redirect(request.GET.get('next') or 'boards:index')
    else:  # GET /accounts/login/ -> html 페이지만 렌더링
        form = AuthenticationForm()
    context = {'form': form}
    return render(request, 'accounts/login.html', context)


@require_GET
def logout(request):
    # 로그아웃 로직
    auth_logout(request)
    return redirect('boards:index')

@login_required
@require_http_methods(['GET', 'POST'])
def update(request):
    if not request.user.is_authenticated:
        return redirect('boards:index')
    if request.method == 'POST':
        form = CustomUserChangeForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect('boards:index')
    else:
        # 사용자 정보를 instance에 넣어줌
        form = CustomUserChangeForm(instance=request.user)
    # GET으로 들어와도 사용하고, valid가 안될때도 사용할 수 있게
    context = {'form': form}
    return render(request, 'accounts/update.html', context)


@login_required
@require_http_methods(['GET', 'POST'])
def change_password(request):
    if request.method == 'POST':
        # 비밀번호 변경로직
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            form.save()
            # 세션의 정보와 회원의 정보가 달라져서 session을 유지한 상태로 새롭게 업데이트
            update_session_auth_hash(request, request.user)
            return redirect('board:index')
    else:
        form = PasswordChangeForm(request.user)
    context = {'form': form}
    return render(request, 'accounts/change_password.html', context)


@require_POST
def delete(request):
    # 유저 삭제 로직
    request.user.delete()
    return redirect('boards:index')
