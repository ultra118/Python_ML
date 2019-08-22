# CHAPTER 2. 기계학습의 기초

- [KOOC-문일철교수님-인공지능 및 기계학습](<https://www.edwith.org/machinelearning1_17/joinLectures/9738>)

## Rule Based Machine Learning Overview

- 경험에 의해서 배우고 특정 task를 수행하는데 퍼포먼스가 점점 더 좋아짐
- 더 많은 경험을 쌓고 더 많은 사전지식을 가지면 수행능력이 더 좋아 짐

### 완벽한 세상임을 가정한 Rule Based Learning

- 특정한 task t를 정의
  - Sky, Temp, Humid, Wind, Water, Forecst를 통해 EnjoySpt의 Yes or No를 분류
- EnjoySpt에 어떠한 요소가 가장 큰 영향을 끼치는지
- Function Approximation
  - 다양한 정보들에 대해 함수하나로 딱 딱 결정을 해주는 함수
- 하나의 인스턴스 X에 속성값들을 Features라 하고, Yes or No인 값을 Label이라 함
- 이런 인스턴스들이 모여있는게 Dataset D
- 가설 H를 세움
  - 여러 가설들이 존재할 수 있고
  - 특정 h_i에 대해 Yes로 분류가 되는지 정의할 수 있음
- Target Function c
  - 목표로 하는 함수

### Function Approximation

- 가설을 통해 판별
  - Generalization vs Specialization
- 참이되는 매핑관계를 만듬
  - 

## Introduction to Rule Based Algorithm

### Find-S Algorithm

> D라고하는 dataset의 모든 x인스턴스 중에 x가 만약 positive라고 하면, feature들에 있는 모든 feature로 판단해 그 값도 포함하는지 안하는지를 결정

- 초기 가설을 전부 null로 넣고 시작
- 인스턴스의 feature와 비교해 union 해가며 가설 수정해감

### Version Space

- 많은 가설이 가능하고 어떤 하나의 가설로 모아진다고 말하기가 어려움, 적어도 이 범위에서의 가설은 만족하지 않을까 범위를 찾는방법으로 볼 수 있음
- 범위를 정해주기 위해서는 boundary를 정해주는데
  - General Boundary, G
  - Specific Boundary, S

### Candidate Elimination Algorithm

> 특정 VS를 만들기위해 가장 G한 가설과 가장 S한 가설을 세운다음 점점 좁혀나가는 알고리즘

- ![image](https://user-images.githubusercontent.com/28910538/62608226-70030a80-b93a-11e9-8601-c5f8f6a8386e.png)

- 가장 specific 한 h를 잡아줌
- 가장 general한 h를 잡아줌
- boundary를 점점 좁혀나감
- positive 경우 인스턴스의 feature들을 커버할 수 있는만큼만 일반화 시켜줌
- negative인 경우 위쪽의 specific한 경우와 비교해 general한 h를 좀 더 specific하게 바꿔줌 
  - general한 경우를 각 feature에 대한 specific한 가설로 여러 케이스를 만듬
  - 위배되는 statement는 없애줌

- specfic한 h와 general한 h사이에 boundary가 생기고 그 중간에는 여러개의 h가 있음
  - 다양한 h중 하나가 target function c이지 않을까 판정하는 것이 rule based
- 어떻게 classify 하는지 
  - sepecific h에는 틀린데 general h에는 맞는 케이스의 경우 어떻게?
    - 데이터셋의 개별 feautre에 noise가 생길 수 밖에 없고
    - decision factor가 있을 수도 있음 
    - 즉, 완벽한 세상에서나 가능한 classify

## Introduction to Decision Tree

- 가설을 트리형태로 표현해 decision tree를 만듬

### Credit Approval Dataset

- 

## Entropy and Information Gain

### Entropy

> 어떤 attribute를 더 잘 체크할 수 있는지 알려주는 하나의 지표

- 불확실성을 줄이기 위해
- 불확실성을 어떻게 측정하는지
  - entropy로 측정

- 비슷한 확률분포는 불확실성이 높다고 볼 수 있음
  - 동전을 던졌을떄 50:50의 확률로 불확실하게 값이 나오는 경우
- ![image](https://user-images.githubusercontent.com/28910538/62668824-4f819180-b9c8-11e9-84a6-c840b3b7f924.png)
  - 확률밀도 모든 X에 대해 log를 씌운것과 안씌운 확률의 곱의 모든 합
- Conditional Entropy
  - ![image](https://user-images.githubusercontent.com/28910538/62668849-61fbcb00-b9c8-11e9-87ae-3a9ea440278d.png)
  - 어떤 특정 feature에 대한 정보가 있을 경우에 entropy를 판별

### Information Gain

> 어떤 특정 entropy가 주어졌을 때 어떤 attribute를 conditional로 줬을 경우의 변하는 entropy 값을 측정, 그 차이

![image](https://user-images.githubusercontent.com/28910538/62668875-79d34f00-b9c8-11e9-9007-d688094bb445.png)

- 모든 attribute에 대한 entropy를  구하고 Information Gain을 비교해가며 가장 작은 IG의 애트리뷰트 선택
- Top-Down Induction Alogorithm
  - ID3
    - open node를 하나 선택
    - IG를 통해 best variable를 선택해 split
      - 인스턴스를 sorting해줘서 넣어 줌
    - 동일한 class에 도달하면 끝냄

### Problem of Decision Tree

> decision tree가 무조건 깊다고 좋은 건 아님, 오버피팅 발생 우려

##  How to create a decision tree given a training dataset

- 통계적 기반

## Linear Regression

> Linear한 형태의 approximated function

- ![image](https://user-images.githubusercontent.com/28910538/62673933-32a28980-b9db-11e9-846d-8f6e59c42353.png)
  - hypothesis == decision tree
  - linear는 건드리지 않고 theta를 잘 건들여 approximated function을 만듬
  - n : feature values
  - theta : parameter
- ![image](https://user-images.githubusercontent.com/28910538/62673970-5239b200-b9db-11e9-8a38-eb0b6a996c8b.png)
  - f hat에는 error 포함 X, 실제 f에는 error가 붙어있음
  - X theta로 설명되는 부분은 크게, e는 작게 하는 것을 목표로 theta를 조정(X는 정해진 것이기 때문에 수정 X)
  - theta를 추정
    - ![image](https://user-images.githubusercontent.com/28910538/62673996-6da4bd00-b9db-11e9-9462-ce097fb509e0.png)
    - 실제로 관측한 Y값에서 추정되는 f - f hat의 값이 최소화되는 지점을 뽑음
    - theta와 관련이 없는 값은 상수 값으로 보고 제외

### Optimized theta

- theta에 대해서 미분을 해줌

- x라는 feature set을 어떤 function을 거쳐 새로운 vector로 theta를 만듬
  - 여러 승수의 값으로 f를 추정
    - 제곱의 제곱의 제곱
      - 곡선의 형태를 띄게됨
- 곡선이 better fitting인지 의문

## 요약

- rule base라든지 decision tree라든지 linear regression을 사용해 봄
- 많은 데이터를 기반으로 트레이닝을 하고 예측하는데 한계점이 존재함
  - 데이터가 많아지면 많아질수록 모델이 복잡하고 에러가 늘어나는 한계점이 있기 때문