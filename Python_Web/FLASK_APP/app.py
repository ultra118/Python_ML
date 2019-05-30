from flask import Flask, render_template, request
import random
import requests


app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/hello")
def hello_new():
    return "New Hello World!"

@app.route('/greeting/<string:name>')
def greeting(name):
    return f"{name}님 안녕하세요."

@app.route('/cube/<int:num>')
def cube(num):
    return f"{num}**2 = {num**2}"

@app.route('/lunch/<int:person>')
def lunch(person):
    # menu라는 리스트를 만들고 사람 수 만큼 랜덤 아이템 뽑아서 반환
    menu = []
    choice = []
    for i in range(10):
        menu.append(f'밥{i}')
    for j in range(person):
        choice.append(f'{j+1}번째 사람 : {random.choice(menu)}')
    # random.sample([], 몇개뽑을지)
    return '</br>'.join(choice)

@app.route('/html')
def html():
    return '''
    <h1>TEST</h1>
    <p>tteesstt</p>
    '''

@app.route('/html_file')
def html_file():
    return render_template('html_file.html')

@app.route('/hi/<string:name>')
def hi(name):
    return render_template('hi.html', name=name)

@app.route('/cube_new/<int:number>')
def cube_new(number):
    return render_template('cube_new.html', number=number)

@app.route('/naver')
def naver():
    return render_template('naver.html')

@app.route('/send')
def send():
    return render_template('send.html')

@app.route('/receive')
def receive():
    username = request.args.get('username')
    message = request.args.get('message')
    return render_template('receive.html', username = username , message = message)

# 사용자의 username과 password를 input으로 받음
# form action을 통해 login_check로 redirect
@app.route('/login')
def login():
    return render_template('login.html')

# 사용자의 입력이 admin /admin123이 ㅏㅁㅈ는지 확인
# 맞으면 '환영합니다.' 아니면 '관리자가 아닙니다.'
@app.route('/login_check')
def login_check():
    username = request.args.get('username')
    password = request.args.get('password')
    message = '관리자가 아닙니다.'
    if username == 'admin' and password == 'admin123':
        message = '환영합니다.'

    return render_template('login_check.html', message=message)


# 사용자의 로또 인풋을 받는다
# lotto_result로 보낸다
@app.route('/lotto_check')
def lotto_check():
    return render_template('lotto_check.html')

# 사용자릐 로또번호와 로또 회차를 받고
# 그 회차의 로또 당첨번호와 비교
@app.route('/lotto_result')
def lotto_result():
    lotto_num = request.args.get('lotto_num')
    lotto_round = request.args.get('lotto_round')
    # 공백으로 구분된 번호를 list로 받음
    my_lotto_round = [int(n) for n in lotto_num.split(' ')]
    check_set = set(my_lotto_round )
    if len(check_set) != 6:
        return '총 6개의 서로다른 수를 입력해 주세요'
    url = 'https://dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=' + str(lotto_round)
    response = requests.get(url)
    lotto_dict = response.json()

    drwt_list = ['drwtNo'+str(i) for i in range(1,7)]
    lotto_list = [lotto_dict[key] for key in drwt_list]
    #correct_num = [num for num in my_lotto_round if num in lotto_list]
    correct_num = set(lotto_list) & set(my_lotto_round)
    bonus_num = 0
    if lotto_dict['bnusNo'] in my_lotto_round:
        bonus_num = 1


    # 내 로또 번호
    numbers = my_lotto_round
    # 당첨번호
    winner = lotto_list
    correct_count = len(correct_num)
    # rank
    rank = '꽝'
    if correct_count == 3:
        rank = '5등'
    elif correct_count == 4:
        rank = '4등'
    elif correct_count == 5:
        if bonus_num > 0:
            rank = '2등'
        else:
            rank = '3등'
    elif correct_count == 6:
        rank = '1등'
    message = f'맞춘 개수 : {correct_count } 맞는 번호는 {correct_num} {rank} 입니다.'
    return render_template('lotto_result.html', numbers=numbers, winner=winner, message=message)

if __name__ == '__main__':
    app.run(debug=True)