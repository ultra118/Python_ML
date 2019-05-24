# Git

# Git setting

1. `git config user.name` 통해 user name 확인
   - 등록되어 있지 않다면 `git config --global user.name user_name`으로 user_name설정
2. `git config user.email` 통해 user_email 확인
   - `gint config --global user.email user_email` 통해 user_email 등록

# Git으로 올리지 않을 파일들을 설정

1. `.gitignore` 파일을 만듬 -> `cat .gitignore`
   - <https://www.gitignore.io/>에서 해당 환경에 대한 igrnoe 파일 받아서 저장

# 기본명령어

1.  git 저장소 (repository) 초기화

   ```bash
   $ git init
   ```

   - 원하는 폴더를 저장소로 만들게 되면, `git bash` 에서는 (`master`)라고 표기된다.
   - 그리고 숨김폴더로 `.git`/ 이 생성된다

2. 커밋할 목록에 담기 (Staging Area)

   ```bash
   $ git add .
   ```

   - 현재 작업 공간(Working Directory / Tree)의 변경사항을 커밋할 목록에 추가한다.( `add`)
   - `.` 리눅스에서 현재 디렉토리(폴더)를 표기하는 방법으로, 현재 내 폴더에 있는 파일의 변경사항을 전부 추가한다.
   - 단일파일만 추가하려면 `git add 'file_name'`
   - 폴더를 추가하려면 `git add 'folder_name/'`

3. 커밋하기

   ```bash
   $ git commit -m 'message-'
   ```

   - 커밋을 할때에는 해당하는 버전의 이력을 의미하는 메세지를 반드시 적어준다.
   - 메시지는 지금 버전을 쉽게 이해할 수 있도록 작성한다
   - 커밋은 현재 코드의 상태를 스냅샷 찍는 것이다.

4. 로그 확인하기

   ```bash
   $ git log 
   commit 8611dcf54e3723f4cabb2b0134180776724bff70 (HEAD -> master)
   Author: SungMin IM <ultra3484@gmail.com>
   Date:   Fri May 24 11:11:04 2019 +0900
   
       update
   
   ```

   - 현재까지 커밋된 이력을 모두 확인할 수 있다.

5.  git 상태 확인하기

   ```bash
   $ git status
   ```

   - CLI(Command Line Interface) 현재 상태를 알기 위해 반드시 명령어를 통해 확인한다.
   - 커밋할 목록에 담겨 있는지,  untracked인지, 커밋할 내역이 있는지 등등 다양한 정보를 알려준다.

# 원격저장소 활용하기

1. 원격저장소 (remote repository) 등록하기

   ```bash
   $ git remote add origin '경로'
   ```

   - 원격 저장소(`remote`)를 등록(add)한다. `origin` 이름으로 경로를 
   - 최초에 한번만 등록
   - 아래의 명령어로 현재 등록된 원격 저장소를 확인할 수 있다

   ```bash
   $ git remote --v
   origin  https://github.com/ultra118/TIL.git (fetch)
   origin  https://github.com/ultra118/TIL.git (push)
   ```

2.  원격 저장소에 올리기(push)

   ```bash
   $ git push origin master
   ```

   - `origin`이라는 이름의 원격저장소에 `master`로 `push`

3. 원격 저장소로부터 가져오기(`pull`)

   ```bash
   $ git pull origin master
   ```

## 원격 저장소 복제(clone)하기

```bash
$ git clone 'git path'
```

- 다운 받기를 원하는 폴더에서 `git bash`를 열고
- 다운 받고자하는 git 의 파일경로정보를 가지고와서 저장소 복제





1. 

   