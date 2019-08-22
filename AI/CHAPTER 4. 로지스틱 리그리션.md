# CHAPTER 4. 로지스틱 리그리션

- [KOOC-문일철교수님-인공지능 및 기계학습](<https://www.edwith.org/machinelearning1_17/joinLectures/9738>)



## Decision Boundary

### Optimal Classification and Bayes Risk

- ![image](https://user-images.githubusercontent.com/28910538/62759686-fc3d3b00-babc-11e9-8e40-a0dad7572186.png)
  - 특정 포인트 X기 주어졌을때 1일지 0일지에 대한 확률 값으로 분류할 수 있음
  - Bayes Lisk를 줄이는 쪽으로 하는데 Lisk가 없어지는건 아님
    - 1에 가까운 답을 주더라도 0일 확률이 없는건 아니라는 말
  - decision boundary라고 부르는 X middle
  - X middle을 기준으로 classification 
  - S-curve의 형태가 유용함
    - 근데 어떤 형태로 만들어야 sigmoid 형태가 되는지

### Classification with One Variable

- log를 씌워 급격한 변화를 좀 누그러뜨림

### Linear Function vs  Non-Linear Function

- ![image](https://user-images.githubusercontent.com/28910538/62759720-1aa33680-babd-11e9-89f5-d7b83d709a84.png)
  - S-curve를 사용해 decision boundary로 부터로의 에러율을 줄일 수 있음

## Introduction to Logistic Regression

### Logistic function

> 0~1 사이의 시그모이드 함수 특징. 역함수 하면 `Logit Function` 미분에 적용하기 편함

![image](https://user-images.githubusercontent.com/28910538/62761073-9f438400-bac0-11e9-8826-a09126cdb7bb.png)

### Logistic Function Fitting

- ![image](https://user-images.githubusercontent.com/28910538/62761113-ba15f880-bac0-11e9-8836-d0054da16151.png)
  - 압축하거나 shift하기 위한 a, b
  - a와 b를 하나의 vector형태로
  - Linear Regression 모양과 닮은 형태가 되기때문에 그대로 적용해서 fitting할 수 있음
    - Linear Regression + Logistic = Logistic Regerssion

### Logistic Regression

- ![image](https://user-images.githubusercontent.com/28910538/62761177-eb8ec400-bac0-11e9-942b-98a04ff51e6a.png)
  - tehta를 배우는과정이 중요

## Logistic Regression Parameter Approximation 1

### Finding the Parameter, theta

- Maximum conditional Likelihood Estimation
  - 주어진 condition에 대한 class variable 

## Gradient Method

## How Gradient method works

## Logistic Regression Parameter Approximation 2

## Naive Bayes to Logistic Regression

## Navie Basyes vs Logistic Regression

