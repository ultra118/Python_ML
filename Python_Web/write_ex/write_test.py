import os

# r:읽기, write:쓰기, a:추가

with open('mulcam.txt', 'w') as f:
    for i in range(5):
        f.write('Happy Hacking' + str(i+1) + '\n')

with open('mulcam.txt', 'r') as f:
    # print(f.readlines())
    total_text = f.read()
    print(total_text)


