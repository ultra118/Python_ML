# CHAPTER 1. 확률에 대한 이해

- [KOOC-문일철교수님-인공지능 및 기계학습](<https://www.edwith.org/machinelearning1_17/joinLectures/9738>)
- [MLE](<https://ratsgo.github.io/statistics/2017/09/23/MLE/>)
- [MLE와 MAP](<https://darkpgmr.tistory.com/62>)
- [확률변수와 확률분포](<https://drhongdatanote.tistory.com/49>)

### Thumbtack Question

- 압정을 던져서 앞으로 떨어지냐 엎어져서 떨어지냐를 판정하는 경우
  - 쉽게 50:50의 확률이라 판단하기는 어려움(동전이랑은 다르니까)
  - 몇번 던져보고 3/5, 2/5의 확률이 나온다고 할때 

### Binomial Distribution

> 이산적인 확률분포에대해 알고 있어야함

- head가 나오는지 tail이 나오는지에 대한 분포
- 2가의 케이스만 존재하기 때문에 `Binomial Distribution`
- 압정을 던져보는 경우를 `Bernoulli experiment`라 함
- 앞이 나오는 것과 뒤가 나오는 것에 서로 영향이 없는 상황을 `i.i.d`
- ![image](https://user-images.githubusercontent.com/28910538/62595193-581a8f00-b918-11e9-8d19-b02036c46b97.png)
  - theta가 압정의 앞면이 나올 확률이라 할떄 head나올 확률 tail나올 확률 총합은 1
  - theta가 주어졌을때 데이터가 만들어직 확률은 P(D|theta)
  - D는 head와 tail로 구성된 관측된 정보
- ![image](https://user-images.githubusercontent.com/28910538/62595827-cfe9b900-b91a-11e9-8742-0a31e053871f.png)
  - 가정 : 압정의 도박결과는 세타라는 확률분포를 따른다
  - 어떻게하면 가정이 강해서 참이라고 말할 수 있는지
  - binomail distribution이 따른다고 할때
  - 세타를 최적화해서 가설을 강해지도록 만든다고 할때
  - 어떤 세타를 선택했을때 데이터를 가장 잘 설명할 수 있는지
    - 그것을 찾아내는것이 확률의 요체

## MLE(Maximum likelihood Estimation) : 최대 값 우도

> 최대 값 우도라는 확률의 추론 위의 세타를 찾아내기 위한 추론방식 중 하나

- ![image](https://user-images.githubusercontent.com/28910538/62595907-2c4cd880-b91b-11e9-970f-5c96abc630bf.png)
  - theta가 주어졌을 때 Data를 관측할 확률을 최대화하는 theta를 찾아내고 그 theta를 theta hat이라 함
  - 압정 갬블에서 MLE를 적용하게되면
  - ![image](https://user-images.githubusercontent.com/28910538/62596049-a7ae8a00-b91b-11e9-87a4-d738c300bb87.png)
  - 최대화 되는 지점을 쉽게 찾기위해 log를 매핑시킴
    - 로그에 매핑 안해도 최대화되는 지점은 일맥상통하기 때문
  - ![image](https://user-images.githubusercontent.com/28910538/62596027-95cce700-b91b-11e9-985d-56606b164b27.png)
- 수식을 정리하고 세타라는 변수에 대해 미분을 하도록 함, 극점을 찾아 최대값을 찾아냄
  - ![image](https://user-images.githubusercontent.com/28910538/62596100-d3ca0b00-b91b-11e9-9437-2edc59539262.png)
- MLE 통해 전체 몇번 던져서 몇번의 앞이 나오는지를 추론할 수 있게 됨
- 세타 헷은 추론일 뿐이지 진짜 파라미터는 아님
- 여러번 던져서 거기에 대한 에러를 줄일 수 있음
- 트루 파라미터인 세타*는 세타 헷과 동일할 수는 없음

### PAC(Probably Approximate Correct) learning

>아마도 이 확률보다는 오차범위내에서는 correct한 learning의 결과물

- 추론한 세타(세타 헷)과 트루 파라미터(세타 스타)가 특정 에러 바운드보다 클 확률은 이것보(수식..)다는 작다
- ![image](https://user-images.githubusercontent.com/28910538/62596158-0e33a800-b91c-11e9-9803-ed5f877c1104.png)
- 허용할  수 있는 에러바운드가 커지면 커질수록 확률은 작아짐
- N은 던지는 횟순데 이게 커지면 커질수록 작아지게 됨

## MAP(Maximum A Posteriori)

> 추가정보를 넣어 사전정보를 가미한 theta를 알아봄

- MLE가 다가 아님
- 50 대 50이 맞지 않을까 하는 사전정보를 파라미터를 추정하는 과정에 넣을 수 있음
- 추가정보를 넣어서 사전정보를 가미한 세타를 알아보도록 함
- ![image](https://user-images.githubusercontent.com/28910538/62597230-505ee880-b920-11e9-87f4-b14d054ddd8f.png)
  - MLE*세타의 확률/데이터가 존재할 확률을 통해 데이터가 주어졌을 때 세타의 확률을 구할 수 있음
  - 중요한건 파라미터 세타
  - 데이터가 주어졌을 때 어떤 세타가 사실일 확률
  - 50대 50이지 않을까 = Prior Knowledge(사전 정보)
- P(D)는 이미 일어난 상황으로 theta가 바뀌는 것에 영향을 받지 않음
- ![image](https://user-images.githubusercontent.com/28910538/62597434-09bdbe00-b921-11e9-90ed-a88b8b95fc31.png)
- P(theta)를 구하기 위해서 [beta distribution](<https://ratsgo.github.io/statistics/2017/05/28/binomial/>)을 사용
  - 특정 범위내에서 0에서 1로 컨파인 되어있는 누적분포 함수로 확률을 잘 표현함
- ![image](https://user-images.githubusercontent.com/28910538/62597479-25c15f80-b921-11e9-9aee-f436dff2c18b.png)
  - P(theta)를 구하기위해 필요한 파라미터는 알파와 베타
  - 이항 분포에서는 head가 나온 횟수 tail이 나온 횟수가 필요했음
  - P(세타|D)와 P(D|세타)가 유사한 형태를 띔
    - ![image](https://user-images.githubusercontent.com/28910538/62597651-b304b400-b921-11e9-8afe-4c8990c18564.png)
  - MLE같은 경우는 argmax(P(D|theta)), 하고 극점을 통한 최적화로 theta hat을 찾은거고
  - MAP는 다른게 아니라 그냥 이걸 바꾼거임
    - ![image](https://user-images.githubusercontent.com/28910538/62597617-94062200-b921-11e9-94d3-784f196d7317.png)
    - mle최적화하던 수식적용하면 비슷한 세타헷이 나옴
    - 알파와 베타라는 사전정보를 넣음으로써 mle와는 다른 theta hat을 얻을 수 있음
    - 많은 실험을 하게되면 알파와 베타의 값은 영향력이 점점 줄어들게 됨
      - 즉, 실험을 많이 진행하면 MLE와 MAP의 값은 같아지게 됨
    - 그럼 알파 베타는 어떻게 정할지
    - 이런 정보를 주는건 아주 중요한 과정, 관측값이 많지 않을때는 MLE와 MAP는 서로 다른 결과를 냄
    - MAP는 그런 사전정보를 잘못주면 잘못된 정보를 얻을 수도 있음

## Probability and Distribution(확률과 분포)

### Motivation and Basics

- mle는 데이타를 중심으로 세타라하는 파라미터를 알아내는 것
- map는 사전지식을 가미해서 데이타(앞정이 앞/뒤 가나오는 것을)를 알아가는과정
- 그 파라미터를 구하는 과정 자체를 확률이라 볼 수 있음

### Probability

- E1과 E2라는 사건이 발생할 확률을 정의
- ![image](https://user-images.githubusercontent.com/28910538/62603890-d172ab80-b931-11e9-9d2f-e1d81e84afad.png)
- 0보다는 크고, 오메가라하는 모든 이벤트 사건의 확률을 더하면 1이 됨
- 몇몇가지 특성을 알 수 있게 됨
- A와 B가 특수한 관계에 있는 사건일때
- ![image](https://user-images.githubusercontent.com/28910538/62603945-eb13f300-b931-11e9-96a8-e9f925643b0c.png)

### Conditional Probability(조건 부 확률)

- 범위 내의 확률을 구하도록 함
- ![image](https://user-images.githubusercontent.com/28910538/62603985-03840d80-b932-11e9-9630-fa62f7aacd43.png)
- E2는 일부만 들어가게되고 제한된 영역에서의 확률을 구함
- B라는 조건이 참인 내부에서 A가 발생할 확률이 무엇인지
- 조건부 확률로 다른 공식을 유도해낼 수 있음
- ![image](https://user-images.githubusercontent.com/28910538/62604005-13035680-b932-11e9-8fc8-5689759d77bc.png)

### Probability Distribution

- 확률변수

  > 무작위 실험을 했을 때, 특정 확률로 발생하는 각각의 결과를 수치적 값으로 표현하는 변수

  - 압정을 던져서 앞이나 뒤가 나올때 발생하는 결과에 실수 값(앞=1, 뒤=0)을 부여하는 변수
  - 대표적인 확률 변수의 종류에는 이산확률 변수와 연속확률 변수가 있음
    - 이산확률 변수는 딱딱 떨어지는 값
    - 연속확률 변수는 연속적으로 이어진 변수

- 확률 분포

  > 확률변수의 모든 값과 그에 대응하는 확률들이 어떻게 분포하고 있는지를 말함

- 확률 함수

  > 확률변수에 의해 정의된 실수를 확률(0~1사이)에 대응시키는 함수

  

- 확률 분포는 어떤 이벤트가 발생하는 것에 할당을 해줌
  - PDF(Probability Density Function, 확률 밀도 함수)
    - 연속적인 변수에 의한 확률 분포 함수
    - 그 값자체가 확률이 아님 분포 내에서 특정한 값
    - 분포를 나타내는 곡선
  - CDF(Cumulative Distribution Function, 누적 분포 함수)
    - 어떤 확률 분포에 대해서 확률 변수가 특정 값보다 작거나 같은 확률을 나타냄
    - 주거 확률들을 제공
- 다양한 분포를 만들 수 있음
  - 함수에 공식을 정해놓고 파라미터를 바꾸거나
  - 공식 자체를 바꾸는 것
- 분포에 이름을 주는데
  - normal distribution
    - normal distribution은 롱테일이라는 것이 있음
      - 끝부분이 아주 길게 가게되는데 이 부분을 롱테일이라고 함
  - 
    - 포뮬라가 있고 mean과 variance라는 파라미터가 들어감
  - beta distribution
    - 롱테일이 없고 딱 정해진 범위가 있음
      - 0에서1사이
    - 범위가 딱 정해져있는 것을 표현할때 beta distribution
      - 0에서 1사이의 값이 매칭되기때문에 확률에 잘 적용되서 사용
  - Binomial Distribution
    - beta나 normal은 부드러운 선인데 binomial은 이산 적인 값으로 점으로 떨어짐
    - 0 or 1의 값
  - mulitinomial distribution
    - 두가지 케이스에서 나오는게 binomial이라고 하면
    - 여러 개의 선택지가 있다하면 multinormial distribution