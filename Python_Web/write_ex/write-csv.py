lunch = {
    '밥1':'0123',
    '밥2':'0124',
    '밥3':'0125',
}

# 1. String formatting
with open('lunch.csv', 'w', encoding='utf-8') as f:
    for item in lunch.items():
        f.write(f'{item[0]}, {item[1]}\n')

# 2. Join method 활용
with open('lunch2.csv', 'w', encoding='utf-8') as f:
    for item in lunch.items():
        print(item)
        f.write(','.join(item) + '\n')

# 3. csv.writer
import csv
with open('lunch3.csv', 'w', newline= '', encoding='utf-8') as f:
    csv_writer = csv.writer(f)
    for item in lunch.items():
        csv_writer.writerow(item)