/*
=========================
5장 그룹 쿼리와 집합 연산자
=========================
* 데이터를 집계해서 뽑을 수 있게 집계함수와 group by 절로 구성

*/

-------------------------
--> 01. 기본 집계 함수
-- count, sum, min, max, avg, variance, stddev
-------------------------
select count(*)
from employees;

-- 중복 제거 distinct
select count(distinct department_id)
from employees;

select sum(salary)
from employees;

select sum(distinct salary)
from employees;

select round(avg(salary), 2), round(avg(distinct salary), 2)
from employees;

select min(salary), max(salary)
from employees;

-- 분산
select round(variance(salary), 2), round(stddev(salary), 2)
from employees;
-- 표준편차

-------------------------
--> 02. group by절과 having 절
-- group by
-- 데이터를 묶어서 집계
-------------------------
select department_id, sum(salary)
from employees
group by department_id;

select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, region;

-- group query를 사용하면 select 리스트에 있는 컬럼명이나 표현식 중 집계 함수를 제외하고는
-- 모두 group by 절에 명시되어야 함

-- having절은 groupy by절 다음에 위치해 group by한 결과를 대상으로 다시 필터
-- where vs having
--> where 절은 쿼리 전체에 대한 필터 역할
--> having 절은 where 조건을 처리한 결과에 대해 group by를 수행 후 산출 된 결과에 다시 조건
select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period = '201311'
group by period, region
having sum(loan_jan_amt) > 100000
order by region;

------------------------
-- 03. rollup절과 cube 절
------------------------
-- rollup은 명시한 표현식을 기준으로 집계한 결과, 즉 추가적인 집계 정보를 보여줌
-- rollup에 명시할 수 있는 표현식에는 grouping 대상
-- 즉, select 리스트에서 집계 함수를 제외한 컬럼 등의 표현식이 올 수 있음
-- 표현식 n개면 n+1 레벨 까지, 오른쪽에서 왼쪽순으로 레별별로 집계한 결과가 반환됨

select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by period, gubun
order by period;

select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by rollup(period, gubun);
-- group by(gubun, period), group by(period), group by()

-- 분할 roll up
select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by period, rollup(gubun);
-- group by (period, gubun), group by (period)

-- cube 
-- rollup과 비슷하나 개념이 다름 rollup은 레벨별 순차적 접근
-- cube는 명시한 표현식 개수에 따라 가능한 모든 조합별로 집계결과 반환
-- cube는 쿼리의 제곱 만큼 종류별로 집계
select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by cube(period, gubun);
--group by (period, gubun), group by (period), group by (gubun), group by ()

------------------
--> 04. 집합 연산자
-- union, union all, intersect, minus
------------------
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));
       
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

select goods
from exp_goods_asia
where country = '한국'
order by seq;
-- union
select goods
from exp_goods_asia
where country = '한국'
union
select goods
from exp_goods_asia
where country = '일본';
-- union all은 중복도 모두 추출
-- intersect는 교집합
-- minus는 차 집함

-- 집합 연산자의 제한 사항
-- 1. 연결되는 각 select문의 select 리스트 개수와 데이터 타입은 일치해야함
-- 2. order by절은 맨 마지막 문장에서만 사용할 수 있음
-- 3. blob, clob, bfile 타입의 컬럼에 대해서는 사용X
-- 4. union, intersect, minus연산자는 long형 컬럼에는 사용할 수 없음

-- grouping set절
-- rollup이나 cube처럼 group by절에 명시해서 그룹 쿼리에 사용되는 절
select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by grouping sets(period, gubun);
-- group by period union all group by gubun

/*
5장 연습문제
*/
-- 5.1
select to_char(hire_date, 'yyyy') as hire_year, count(hire_date)
from employees
group by to_char(hire_date, 'yyyy')
order by 1;

-- 5.2
select period,region, sum(loan_jan_amt)
from kor_loan_status
where period like '2012%'
group by period,region;

-- 5.3 
select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, rollup(gubun);

select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, gubun
union all
select period, null, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period
order by period;

-- 5.4
select period, case when gubun = '주택담보대출' then sum(loan_jan_amt)
                    else 0
                    end 주택담보대출액,
               case when gubun = '기타대출' then sum(loan_jan_amt)
                    else 0
                    end 기타대출액
from kor_loan_status
where period = '201311'
group by period, gubun;

select period, 0 as 주택담보대출액, sum(loan_jan_amt) as 기타대출액
from kor_loan_status
where period = '201311'
and gubun = '기타대출'
group by period, gubun
union all
select period, sum(loan_jan_amt) as 주택담보대출액, 0 as 기타대출액
from kor_loan_status
where period = '201311'
and gubun = '주택담보대출'
group by period, gubun;

-- 5.5
select region, 
       sum(amt1) as "201111",
       sum(amt2) as "201112",
       sum(amt3) as "201210",
       sum(amt4) as "201211",
       sum(amt5) as "201212",
       sum(amt6) as "201310",
       sum(amt7) as "201311"
from (select region, case when period = '201111' then loan_jan_amt else 0 end amt1,
                     case when period = '201112' then loan_jan_amt else 0 end amt2,
                     case when period = '201210' then loan_jan_amt else 0 end amt3,
                     case when period = '201211' then loan_jan_amt else 0 end amt4,
                     case when period = '201212' then loan_jan_amt else 0 end amt5,
                     case when period = '201310' then loan_jan_amt else 0 end amt6,
                     case when period = '201311' then loan_jan_amt else 0 end amt7
      from kor_loan_status
)
group by region;


/*
=============================================
6장 테이블 사이를 연결해 주는 조인과 서브쿼리 알아 보기
=============================================
*/
-------------------
--> 01. 조인의 종류
-- 조인 연산자에 따른 구분 : 동등 조인, 안티 조인
-- 조인 대상에 따른 구분 : 셀프 조인
-- 조인 조건에 따른 구분 : 내부 조인, 외부 조인, 세미 조인, 카타시안 조인
-- 기타 : ANSI 조인
-------------------

-------------------------
--> 02. 내부 조인과 외부 조인
-------------------------
-- 동등 조인
-- where 절에서 등호 연산자를 사용해 2개 이상의 테이블이나 뷰를 연결하는 조인
-- where 조건에 만족하는 데이터 추출, where 절에서 기술한 조건을 조인조건이라함
-- 조인조건은 컬럼 단위로 기술, 두 컬럼의 값이 같은 행을 추출
select a.employee_id, a.emp_name, a.department_id, b.department_name
from employees a, departments b
where a.department_id = b.department_id;
-- 세미 조인
-- 서브쿼리를 사용해 서브쿼리에 존재하는 데이터만 메인쿼리에서 추출
-- IN과 exist 연산자를 사용
select department_id, department_name
from departments a
where exists(select * 
             from employees b 
             where a.department_id = b.department_id and b.salary > 3000)
order by a.department_name;

select department_id, department_name
from departments a
where a.departemnt

select