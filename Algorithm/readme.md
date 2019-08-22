## 알고리즘

- 참조

  - [Big-O 표기법](https://www.youtube.com/watch?v=VcCkPrGaKrs&list=PLjSkJdbr_gFYSUYfnF_OGXtnGs2d3vWg7&index=2>)

  - [알고리즘 공부 방법](<https://blog.yena.io/studynote/2018/11/14/Algorithm-Basic.html>)

  - [자료구조 & 정렬 알고리즘]([https://librewiki.net/wiki/%EC%8B%9C%EB%A6%AC%EC%A6%88:%EC%88%98%ED%95%99%EC%9D%B8%EB%93%AF_%EA%B3%BC%ED%95%99%EC%95%84%EB%8B%8C_%EA%B3%B5%ED%95%99%EA%B0%99%EC%9D%80_%EC%BB%B4%ED%93%A8%ED%84%B0%EA%B3%BC%ED%95%99/%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98_%EA%B8%B0%EC%B4%88](https://librewiki.net/wiki/시리즈:수학인듯_과학아닌_공학같은_컴퓨터과학/알고리즘_기초))

  - [정렬 알고리즘]([https://medium.com/@fiv3star/%EC%A0%95%EB%A0%AC%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-sorting-algorithm-%EC%A0%95%EB%A6%AC-8ca307269dc7](https://medium.com/@fiv3star/정렬알고리즘-sorting-algorithm-정리-8ca307269dc7))

  - [자료구조](<https://blog.naver.com/vsky712/220558368042>)

  - [자료구조2](<https://daimhada.tistory.com/168?category=820522>)

    

> 알고리즘은 어떤 문제를 해결하기 위한 일련의 절차를 공식화한 형태로 표현한 것

### Big-O

> 알고릴즘의 성능을 수학적으로 표현해주는 표기 법
>
> 시간/공간 복잡도를 표현할 수 있음

#### 시간복잡도

> 문제를 해결하는데 걸리는 시간과 입력의 함수 관계
>
> 시간 복잡도를 나타낼 때에는 `Big O`표기법을 이용

- 실제 learning time이라기 보다는 데이타나 사용자의 증가율에 따른 알고리즘의 성능을 예측하는 것이 목표

  - 상수와 같은 숫자들은 모두 1

- $O(1)$
  
  - 입력에 상관없이 언제나 일정한 속도로 결과를 반환
  
    - ```python
      def F(n):
      	return n[0] == 0 and true or false
      ```
  
  - 데이터가 증가함에 따라 성능이 변화가 없을 때
  
- $O(n)$
  
- 데이터가 증가함에 따라 비례해서 처리시간도 증가
  
    - ```python
      def F(n):
          for i in n:
              print(i)
      ```
    
  - n이 늘어남에 따라 처리가 하나씩 늘어남
  
    - n의 크기만큼 처리시간이 걸리게 됨
  
  - 언제나 데이터와 시간이 같은 비율로 증가
  
- $O(n^2)$

  - n개의 데이터를 받으면 n만큼 돌리는데 그 만큼 각 엘리먼트에 대해 n번씩 돌림

    - ```python
      def F(n):
          for i in n:
              for j in n:
                  print(i+j)
      ```

- $O(nm)$

  - n을 m만큼 돌리는 것

    - ```python
      def F(n,m):
          for i in n:
              for j in m:
                  print(i+j)
      ```

- $O(n^3)$

  - n을 삼중으로 돌리는 것

    - ```python
      def F(n):
          for i in n:
              for j in n:
                  for k in n:
                      print(i+j+k)
      ```

    - $O(n^2)$ 보타 더 가파른 그래프를 보여줌

- $O(2^n)$

  - 피보나치 수열

    - 1, 1, 2, 3, 5, 8 ...

    - ```python
      def F(n, r):
          if n <= 0:
      		return 0
          elif n == 1:
              return r[n] = 1
          return r[n] = F(n-1, r) + F(n-2, r)
      ```

      - n-1, n-2을 인자로 재귀함수
        - 각 요소마다 2개의 함수 호출하는 구조이기 떄문에 $2^n$의 복잡도를 가짐

    - 1부터 시작해서 한 면을 기준으로 정사각형을 만드는데 늘어난 면을 기준으로 정사각형을 붙여줌

    - 피보나치 수열 최적화

      - ![image](https://user-images.githubusercontent.com/28910538/63133480-5cbe0200-c000-11e9-8675-d3fa8e08645c.png)

        - 불필요한 작업을 반복하고 있음

      - ```python
        def F(n, r):
            if n <= 0:
                return 0
            elif n == 1:
                return r[n] = 1
            # 기존의 계산해온 결과가 있는지를 확인하고, 있으면 더 이상 재귀호출을 하지않고 그 값을 반환
            elif r[n] > 0:
                return r[n]
            return r[n] = F(n-1, r) + F(n-2, r)
        ```

        - 최적화 통해 $O(N)$의 복잡도로 최적화 가능

- $O(m^n)$
  
- m개씩 n번 늘어나는 알고리즘
  
- $O(log n)$

  - 이진 검색

    - 가운데 값을 기준으로 찾고 분리해가며 데이터를 찾음

    - 한 번 처리가 진행될 때 마다 검색해야하는 데이터양의 절반씩 떨어지는 것

    - ```python
      def F(k, arr, s, e):
          if s>e:
              return -1
          m = (s+e)/2
          if arr[m] == k:
              return m
          elif arr[m] > k
          	return F(k, arr, s, m-1)
          else:
              return F(k, arr, m+1, e)
          
      ```

    - 순차검색에 비해 속도가 현저히 빠름

    - 데이터가 증가해도 성능이크게 차이가 나지않음

- $O(sqrt(n))$

- 문자열의 치환

  - 문자열안의 문자열로 만들 수 있는 모든 조합의 시간복잡도
  - N! 로 문자 선택에 대한 가짓 수

- Big-O표기법에서 상수는 버림

  - O(2n) => O(n)
    - 실제 알고리즘의 러닝타임을 재려고 만든게 아니라
    - 장기적으로 데이터가 증가함에따른 처리시간의 증가율을 예측
    - 차원이 늘어나지 않는 한 상수는 무시

#### 자료구조

> 데이터를 효율적으로 다루기 위해 데이터를 저장하는 방법

- ![image](https://user-images.githubusercontent.com/28910538/63142847-812cd500-c026-11e9-99a3-6e00355e516f.png)
  - 자료형에 따른 분류
    - 단순 구조 : 정수, 실수, 문자, 문자열
    - 선형 구조 : 1:1의 자료간 관계
    - 비선형 구조 : 1:N 또는 M:N의 자료간 관계
    - 파일구조 : 순차/색인/직접 파일

#### 추상 자료형(ADT : Abstract Data Type)

> 구체적인 기능의 완성 과정 언급없이 순수하게 기능이 무엇인지 나열한 것