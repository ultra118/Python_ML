-- 자주쓰는 명령
-- ed 파일명
-- 그 안에 자주쓰는 명령 써놓고
-- @파일명.sql 통해 실행


-- sal이 2000미만이면 low 2000이상이면 high
select sal, sal, sal
from emp;

-- trunc 절삭 => 정수화
select empno, trunc(sal/2000)
from emp;

-- decdoe case 표현식
select empno, sal, 
decode(trunc(sal/2000), 0, 'low', 'high') flag
from emp;

-- simple case 표현식
select empno, sal,
case trunc(sal/2000) when 0 then 'low'
when 1 then 'high'
else 'hhigh'
end flag
from emp;

-- searched case 표현식
select empno, sal,
case when sal < 2000 then 'low' 
when sal > 2000 and sal < 3000 then 'high' 
when sal >= 3000  then 'hhigh'
end flag
from emp;

-- literal
select empno, ename, 'ACCOUNTING'
from emp
where deptno = 10;

-- 연결 연산자
select empno, ename || ' is a ' || job as sawon
from emp;
-- j로 시작하는 table 지우기위해
-- table목록 에대해 drop 명령을 더해서 만듬
select 'drop table' || tname || 'cascade constraints;' as commands
from tab
where tname like 'J%';

-- '를 문자로 쓰기위해서는 붙여서 쓰도록 함 ''
select ename || ' ''s house is bigger then Toms''s'
from emp
where sal >= 3000;
-- 또는 q연산자 사용
-- 감싼다는 것을 q'[]'라든가 q'XX'라든가 아무 대칭되는 문자들을 넣어줘도 됨
select ename||q'X's house is bigger then Toms'X'
from emp
where sal >= 3000;

-- 중복제거
select unique job
from emp;
select distinct job
from emp;
-- 행단위로 봐서 중복 비교함 
select distinct deptno, job
from emp;


/*
문자열 및 날짜
- 문자 값은 대소문자를 구분하고, 날짜 값은 형식을 구분(대/소문자 구분 X)
*/


/*
연산자
*/
select *
from emp
where empno >= 7500 and
empno <= 8000;
-- 위와 같은 표현
select *
from emp
where empno between 7500 and 8000;

select *
from emp
where empno >= 7500 and 
empno <= 8000 and
(ename like 'A%' or
ename like 'B%');
/*
and 가 or 보다 우선순위가 높음
*/
select empno, ename, mgr, sal, comm
from emp
where empno between 7500 and 8000
and (ename like 'A%' or ename like 'B%')
and comm is null
and mgr in (7698, 7788);

/*
Globalization Support
*/
alter session set nls_language = 'american';
alter session set nls_territory = 'america';

select empno, hiredate, to_char(hiredate, 'Month')
from emp;

select *
from emp
where rtrim(to_char(hiredate, 'Month')) = 'December'
and deptno in (10, 30)
and (job like '%C%' or job like '%K%')
and sal > 500 and sal <= 2000;

-- like는 한번에 2개를 줄 수 없음
-- between는 ~ 이상 ~ 이하만 됨


/*
ename이 5글자인 사원
*/
select empno, ename
from emp
where ename like '_____';

drop table t1 purge;
create table t1(col1 number, col2 varchar2(10));

insert into t1 values (1000, 'AAA');
insert into t1 values (2000, 'ABA');
insert into t1 values (3000, 'ACA');
insert into t1 values (3000, 'A_A');

select *
from t1;

select *
from t1
where col2 like '%A_A%';
-- 실제 %및 _를 검색하기 위해 escape 사용
select *
from t1
where col2 like '%A!_A%' escape '!';

-- empno 컬럼에 값이 있는 행 
select *
from emp
where empno = empno;

-- 항상 False인 조건으로 쿼리한 결과
select *
from emp
where 1 = 2;

/*
Order By절 이해
- 오름차순(asc, default임)
- 내림차순(desc)
- 두 개이상의 조건으로 정렬
- select 리스트에 없는 칼럼으로 정렬
- null은 가장 큰 값으로 취급됨
*/
select empno, ename, sal as salary from emp order by 3;
select empno, ename, sal as salary from emp order by sal;
select empno, ename, sal as salary from emp order by salary;

select empno, ename, sal as salary from emp order by 3 desc;
select empno, ename, sal as salary from emp order by sal desc;
select empno, ename, sal as salary from emp order by salary desc;

select deptno, empno, sal from emp order by deptno, sal desc;

select empno, ename, job from emp order by sal desc;

select empno, comm from emp order by comm asc;

-- 가공한 결과에 의한 Order by
-- 문제. 사원이름이 짧은 사원부터 정렬

select empno, ename
from emp
order by length(ename) asc, ename;
-- 짧은 순, 알파벳 순

-- 문제. 입사일자의 월별로 정렬

select empno, ename, hiredate, to_char(hiredate, 'mm') as month
from emp
order by month, hiredate;
-- to_char(datetype, 'mm') 월만 추출


/*
복수행
group by의 이해
*/
select job, sum(sal)
from emp
group by job;

select deptno ,job, sum(sal)
from emp
group by deptno, job;

/*
가공한 결과에 의한 Group by
문제. 입사일자의 월(Month)을 활용한 집계
*/
select to_char(hiredate, 'mm') as 월, count(*) as 인원수
from emp
group by to_char(hiredate, 'mm')
order by 월;

/*
Group by절 관련 중요 문법
SELECT 리스트에서 복수행 함수로 감싼 column 이외의 모든 column은 
반드시 GROUP BY절에 나타나야 함
단, 리터럴은 예외
*/
--- error
select deptno, job, sum(sal)
from emp
group by deptno;
--- 리터럴 예외
select '부서별 직무별', deptno, sum(sal)
from emp
group by deptno;
-- 옳은 Group By
select deptno, job, sum(sal)
from emp
group by deptno, job;

/*
avg내에서 distinct 사용 
> sal의 중복을 제거하고 평균을 구하도록 함
all은 default 
avg(all sal) 과 avg(sal)은 같음
*/

select avg(all sal) from emp;
select avg(distinct sal) from emp;

/*
모든 그룹함수는 null을 무시함
단, count(*)는 예외
예를들어
avg(sal)은 모르는값(null)을 더했을때 결과는 null이므로 null무시하고 다 더해서 1/n(null제외한다)
*/
drop table t1 purge;
create table t1 (no number);

insert into t1 values (1000);
insert into t1 values (1000);
insert into t1 values (2000);
insert into t1 values (2000);
insert into t1 values (null);
insert into t1 values (null);

select no, no, no
from t1;

-- 6, 4, 2가 나옴
select count(*), count(no), count(distinct no)
from t1;

select count(*), -- 사원수
count(comm) -- 커미션을 받는 사원수
from emp
where deptno = 30;
-- count(*)은 null을 포함
select *
from emp
where deptno = 30;


/*
null값을 포함해서 그룹함수 사용하기 위해
nvl활용
*/

select comm, nvl(comm, 0)
from emp;

select avg(comm), -- 커미션 받는 사람들의 평균 커미션
avg(nvl(comm, 0)) -- 전체 사원들의 평균 커미션
from emp;

/*
where 절과
having절의 차이

비슷한데 조금 다름
where절 먼저하고 안되면 having
where절은 그룹함수를 제어할 수 없음
*/
select deptno, sum(sal)
from emp
where deptno != 20  -- 20이 아닌 것들만
group by deptno;

select deptno, sum(sal)
from emp
group by deptno
having deptno != 20;

select deptno, sum(sal)
from emp
where sum(sal) < 10000 -- 문법오류
group by deptno;
-- 그룹 결과 제한
select deptno, sum(sal)
from emp
group by deptno
having sum(sal) < 10000;

/*
그룹함수 중첩
*/
select max(avg(sal)) -- 부서별 최대평균 급여
from emp
group by deptno;

/*
데이터 제한 및 정렬
*/

select LAST_NAME, SALARY
from employees
where SALARY > 12000;

select LAST_NAME, DEPARTMENT_ID
from employees
where EMPLOYEE_ID = 176;

select LAST_NAME, SALARY
from employees
where SALARY not between 5000 and 12000;

select LAST_NAME, JOB_ID, HIRE_DATE
from employees
where LAST_NAME like 'Matos%' or LAST_NAME like 'Taylor%';

select LAST_NAME, DEPARTMENT_ID
from employees
where DEPARTMENT_ID =20 or DEPARTMENT_ID = 50;

select LAST_NAME as Employee, SALARY "Monthly Salary"
from employees
where (SALARY between 5000 and 12000) and (DEPARTMENT_ID =20 or DEPARTMENT_ID = 50)
order by "Monthly Salary" desc;



