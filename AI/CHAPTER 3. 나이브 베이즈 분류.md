# CHAPTER 3. 나이브 베이즈 분류

- [KOOC-문일철교수님-인공지능 및 기계학습](<https://www.edwith.org/machinelearning1_17/joinLectures/9738>)

## Optimal Classification

- X라는 정보가 조건으로 주어진 상태에서 Y가 어떤 값일지에 대한 확률값을 계산

### Bayes classifier

- X를 넣어서 Y를 예측 여기서 f(X)는 Y hat
- ![image](https://user-images.githubusercontent.com/28910538/62676782-f8d78000-b9e6-11e9-9245-1735340e530d.png)
- Y hat과 Y가 같지않을 확률이 최소화되는 function을 approximation

### Optimal Classification and Bayes Risk

- ![image](https://user-images.githubusercontent.com/28910538/62676823-173d7b80-b9e7-11e9-8f3e-78f4f6554767.png)

- ![image](https://user-images.githubusercontent.com/28910538/62676879-35a37700-b9e7-11e9-96b7-98b652c3b59f.png)
  - decision boundary를 기준으로 급격하게 큰 확률차이로 구분 해줘야함
  - decision boundary를 기준으로 분명히 존재하는 확률의 영역을 무시하기도함
  - Basyes Risk를 최대한 줄이는 최적화된 분류가 필요
- ![image](https://user-images.githubusercontent.com/28910538/62676944-71d6d780-b9e7-11e9-8b0c-09a093c6c207.png)
  - Y|X를 스위치 시켜줄 수 있는 Bayes 이론
  - y가 true,false일때 Likelihood는 true에 대한, false에 대한 각 경우에 대해서만 x가 얼마만큼의 값을 가질 수 있는지 확률을 구함
  - dataset D를 통해 P를 계산하는 것에 큰 문제점이 있음
    - X변수가 아주아주 많아지게 되면 그것에대한 콤비네이션에 대한 표현을 하는데 한계가 있음
    - 이런 문제점 해결 위해서 Naive Bayes
      - 그런 X변수 사이 콤비네이션을 무시하겠다는 것

## Conditional Independence

> 여러 개의 X(attribute)가 주어졌을때 Y(label)를 판별

- ![image](https://user-images.githubusercontent.com/28910538/62677724-473a4e00-b9ea-11e9-8aeb-1dd8d678ed9a.png)
  - P(Y=y)는 k-1인 하나의 파라미터만 있으면 되는데
  - P(X=x|Y=y)는 (2^4-1)*k
  - x는 vector value이고 vector의 길이는 d로 볼때 d를 컨트롤을 어떻게든 해줘야함
    - d를 줄이지않고 컨트롤하기 위해 Conditional Independence 가정 도입
      - ![image](https://user-images.githubusercontent.com/28910538/62677821-941e2480-b9ea-11e9-891d-28a115f7bf20.png)
    - 독립이라 가정하면 P(X,Y) = P(X)P(Y)의 수식이 가능
      - ![image](https://user-images.githubusercontent.com/28910538/62677770-6e911b00-b9ea-11e9-8044-ae6e33cb3d7f.png)
      - 파라미터 수를 대폭 줄일 수 있음
    - x1과 x2가 conditional independece하다
      - x2, y가 주어졌을떄 와 y만 주어졌을 떄의 조건부 확률이 같을 때
- Conditional vs Marginal Independence
  - marginally independent : 명령을 듣지 못했는데도 다른 사람의 행동을 보고 영향을 받음 -> 독립적인 관계가 아님
  - conditional indepdent : 명령을 듣던 듣지 못하던 다름 사람의 행동에 전혀 영향을 받지 않음 -> 독립적

## Naive Bayes Classifier

- ![image](https://user-images.githubusercontent.com/28910538/62756668-94cebd80-bab3-11e9-825b-382c7a4ced4d.png)
  - 애트리뷰트간 독립성을 가정해 파라미터 수를 줄임

- ![image](https://user-images.githubusercontent.com/28910538/62756632-7e286680-bab3-11e9-91ef-0d15ae5658df.png)
  - 조인트된 x attribute에 대해 Naive Bayes를 적용해 파라미터 수를 비약적으로 줄일 수 있음
  - (2^d-1)k case => (2-1)dk case
- 문제
  - Naive assumption
    - Naive bayes의 특성 -> 모든 애트리뷰에 대해 서로 독립적이라 가정
    - 파라미터를 억지로 줄이려다보니 발생하게되는 문제
  - 잘못된 확률 추정치에 대한 문제 발생
    - 어떤 형태로든 항상 발생하는 문제로 볼 수 있음

## 요약

- Naive Bayes는 Bayes이론과 Naive의 가정을 접목시켜 조건부 확률에 대한 각 애트리뷰트의 독립성을 가정해 파라미터수를 줄임 그리고 MLE든지 MAP든지 써서 간단하게 분류해줌