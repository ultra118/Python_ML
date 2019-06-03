# 간단한 Web Crawling

```bash
$ pip install BeautifulSoup
$ pip install selenium
```

- [chrome web driver 설치](<https://sites.google.com/a/chromium.org/chromedriver/downloads>)
  - version 확인
    - chrome 도움말의 chrome 정보

- driver를 통해 원격으로 페이지 띄우고

  ```python
  driver = webdriver.Chrome(webdriver_path)
  driver.get('url~')
  ```

- page source를 찍어서 bs4로 분석

  ```python
  req = driver.page_source
  soup = BeautifulSoup(req, 'html.parser')
  ```

# .csv파일로 저장

```python
with open('./~.csv', 'w', encoding='utf-8') as f:
    f.write(~)
```

