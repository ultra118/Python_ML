# numbers.txt 내용 뒤집기
with open('numbers.txt', 'r') as f:
    numbers = f.readlines()

reverse_list = []
for n in numbers:
    reverse_list.append(int(n.replace('\n', '')))

reverse_list.reverse()

with open('numbers.txt', 'w') as f:
    for d in reverse_list:
        f.write(f'{d}\n')


