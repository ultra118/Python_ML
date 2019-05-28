import os
#
# # 지정한 폴더로 이동
# os.chdir()
# # 폴더에 저장된 전체 파일 목록을 list로 반환
# os.listdir()
# # 파일이름을 변경 -> 인자로 두개 받고 인자1일 인자2로 변경
# os.rename()
# # 파일 경로와, 확장자를 분리하여 반환
file_list = os.listdir('.')

for f in file_list:
    if '.txt' in f:
        os.rename(f, '지원자_'+f)

