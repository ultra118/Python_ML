import os

file_list= os.listdir('.')

for f in file_list:
    if '.txt' in f:
        front_text = f.split('_')[0]

        if front_text == '지원자':
            os.rename(f, f.replace('지원자', '합격자'))
