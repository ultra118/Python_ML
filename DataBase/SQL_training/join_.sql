/*
# SET 연산자(수직 조인)
- UNION ALL : 합집합(중복 허용)
- UNION     : 합집합(중복 제거)
*/
-- 가공한 결과에 의한 집계
select job, decode(job, 'ANALYST', job, 'MANAGER', job, 'Others') as job
-- job이 analyst, manager 면 그대로 나머지는 others로
from emp;

select decode(job, 'ANALYST', job, 'MANAGER', job, 'Others') as job, sum(sal) as 총계
from emp
group by decode(job, 'ANALYST', job, 'MANAGER', job, 'Others')
order by 총계;
-----------------------------------------------------------------------------------------------------------------------
/*
to_char 함수
select hiredate, to_char(hiredate, 'yyyy mm dd') -- yyyy mm dd 같은 각 element들로 format을 만듬
*/
select hiredate, to_char(hiredate, 'yyyy mm dd') 
from emp;

-- 분기별 입사자 수
select hiredate, to_char(hiredate, 'q')
from emp;

select to_char(hiredate, 'q') 분기, count(*) 입사자수
from emp
group by to_char(hiredate, 'q')
order by 분기;

select hiredate, to_char(hiredate, 'YEAR Year year')
from emp;

select hiredate, to_char(hiredate, 'YEAR Month Mon Day Dy')
from emp;

select hiredate, to_char(hiredate, 'fmYEAR Month Mon Day Dy') -- fm : fill mode ,, 중간의 space를 지워줌
from emp;

/*
오라클은 Date를 내부적으로 7byte Numberic으로 저장 : 20 19 03 27 11 43 25
화면에 보이는건 session의 환경에 따라 달라짐
*/
select sysdate
from dual;
-- nls_date_format에 따라 달라짐
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
select sysdate
from dual;

select sysdate, to_char(sysdate, 'hh hh12 hh24 mi ss')
from dual;

select sysdate, to_char(sysdate, 'sssss')
from dual;

select sysdate, '오늘은 '||to_char(sysdate, 'yyyy')||'년 '||to_char(sysdate, 'mm')||'월'||to_char(sysdate, 'dd')||'입니다.'
from dual;

select sysdate, to_char(sysdate, '"오늘은" yyyy"년" mm"월" dd"일입니다"') as greeting
from dual;
-----------------------------------------------------------------------------------------------------------------------
/*
LOWER, UPPER, INITCAP 함수
*/

select 'My name' a, 'My name' b, 'My name' c, 'My name' d
from dual;

select 'My name' a, upper('My name') b, lower('My name') c, initcap('My name') d
from dual;

/*
# join
- Equi join, Inner join (등가 조인)
- Nonequi join (비등가 조인)
- Outer join (외부 조인)
- Self join  (자체 조인)
from 절에 table이 2개 이상

select *
from emp, dept -- join, Catesian product, row 복제
order by 1;

select e.empno, e.ename, d.*
from emp e, dept d  -- join statement
where e.deptno = d.deptno -- join predicate
and e.sal >= 1000   -- Non-Join predicate
and e.job like 'A%'  -- Non-Join predicate
and d.deptno = 20  -- Non-Join predicate

*/
select * from departments; -- 8 rows
select * from employees; -- 20 rows

select department_id, departement_name, employee_id, job_id, salary
from employees, departments; 

select E.EMPLOYEE_ID, E.DEPARTMENT_ID, E.SALARY
from employees E, departments D -- alias 사용
where E.DEPARTMENT_ID = D.DEPARTMENT_ID and E.SALARY >= 3000
order by E.SALARY;

-- 사원을 등급별로 
select * from SALGRADE;
select * from emp;

select s.grade, count(*), round(avg(e.sal)), round(stddev(e.sal))
from emp e, salgrade s
where e.sal >= s.losal and e.sal <= s.hisal
group by s.grade
order by 1;

/*
Outer join
*/
-- +붙은 쪽이 부족한 부분
select e.employee_id, e.department_id, d.department_id
from employees e, departments d
where e.department_id = d.department_id (+);

-- 문제. 7844 사원보다 많은 급여를 받는 사원
select *
from emp e, emp t
where t.empno = 7844 and
e.sal > t.sal;

-- 문제. 누적합 구하기

drop table t1 purge;

create table t1 as 
select empno a, sal b
from emp
where rownum <= 3;

select *
from t1 a, t1 b;

select *
from t1 a, t1 b
where a.a >= b.a
order by a.a;

select a.A, a.B, sum(b.B) -- 누적합
from t1 a, t1 b
where a.a >= b.a
group by a.A, a.B
order by a.a;



/*
서브쿼리
- 다른 SQL에 포함된 SELECT
*/

/*
6장 연습문제
*/
-- 서브쿼리
-- 다른 SQL에 포함된 select 
/*
임의 사원의 부서 번호와 급여를 커미션을 받는 사원의 부서 번호 및 급여와
비교하여 값이 일치하는 사원의 성, 부서 번호 및 급여를 표시하는 query를
작성합니다.
*/
select LAST_NAME, DEPARTMENT_ID, SALARY
from employees
where (salary, department_id) in
(select salary, department_id
from employees
where COMMISSION_PCT is not null);
-- d.department_name
/*
급여와 커미션이 위치 ID1700에 위치한 사원의 급여 및 커미션과 일치하는
사원의 성, 부서 이름 및 급여를 표시합니다.
*/
select e.last_name, d.department_name, e.salary
from employees e, departments d
where e.department_id = d.department_id and
(salary, NVL(commission_pct,0)) 
in (select salary, NVL(commission_pct,0)
from departments d, employees e
where e.department_id = d.department_id and d.location_id = 1700);

/*
Kochhar와 동일한 급여 및 커미션을 받는 모든 사원의 성, 채용 날짜 및 급여를
표시하는 query를 작성합니다.
참고: 결과 집합에 Kochhar를 표시하지 마십시오
*/
select e.LAST_NAME, e.HIRE_DATE, e.SALARY
from employees e, departments d
where d.DEPARTMENT_ID  = e.DEPARTMENT_ID and
(e.salary, NVL(e.commission_pct,0)) 
in (select e.SALARY, NVL(e.commission_pct,0)
from employees e
where e.LAST_NAME like 'Kochhar');

/*
모든 영업 관리자(JOB_ID = 'SA_MAN')보다 많은 급여를 받는 사원을
표시하는 query를 작성합니다. 결과를 하향식으로 정렬합니다
*/
-- sa_man salary
select e.job_id, e.salary
from employees e
where e.job_id = 'SA_MAN';

select e.last_name, e.job_id, e.salary, 
(select e.salary from employees e where e.job_id = 'SA_MAN') as SA_MAN_salary
from employees e
where e.salary > ALL (select e2.salary
from employees e2
where e2.JOB_ID = 'SA_MAN');


/*
SQL join Syntax 

*/
-- 문제. 부서와 부서에 속한 사원들의 ...를 쿼리하세요

-- 문제. 사원과 사원들의 급여 등급을 쿼리하세요
-- 문제. 7844 사원보다 많은 급여를 받는 사원?
-- 문제. 누적합 구하기


/*
HR 나라별 직원 수
*/

select count(*)
from employees e, departments d, locations l, countries c, regions r;

-- cout(*)로 하면 null도 1로 나옴
select r.region_id, r.region_name, count(e.employee_id)
from employees e, departments d, locations l, countries c, regions r
where nvl(e.department_id(+), 10) = d.department_id 
and d.location_id(+) = l.location_id
and l.country_id(+) = c.country_id
and c.region_id(+) = r.region_id
group by r.region_id, r.region_name;


