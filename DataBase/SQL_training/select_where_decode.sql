------------------- select
select *
from emp;

select sal, sal, sal, sal
from emp;

select sum(sal), avg(sal), max(sal), min(sal)
from emp;
-- nvl은 null이면 0으로 값 치환
select empno, ename, sal, comm, sal*12+nvl(comm,0) 연봉
from emp;
-- comm = null인것은 null
select empno, sal, comm
from emp
where comm = null;

-- null인 것을 찾기 위해서는 is연산자 사용
select empno, sal, comm
from emp
where comm is null;
------------------- select
------------------- where
--drop table t1 purge;

create table t1
as
select empno, sal, deptno
from emp;

select *
from t1;

select empno, sal, sal*1.1
from t1
where sal >= 1500;

select empno, sal, sal*1.1
from t1
where sal >= 1500 and deptno = 20;

-- subtstr(ename, 1, 1) 1요소부터 1요소까지
-- substr(ename, 2) 2요소부터 끝까지
-- like 'A%' A로 시작하는 값들
select empno, ename, substr(ename, 1, 1) 첫글자, substr(ename, 2) 나머지, deptno
from emp
where ename like 'A%';

-- join, Cartesian product, 선호되지 않음
select *
from emp, dept
order by 1;
-- emp와 dept의 deptno가 같은 join
select emp.empno, emp.ename, dept.*
from emp, dept
where emp.deptno = dept.deptno
order by 1;

-------------- decode
select deptno,
sal, 
decode(deptno, 10, 'A') d10, 
decode(deptno, 20, 'B') d20, 
decode(deptno, 30, 'C') d30 
from emp;

select 
sum(sal) total, 
sum(decode(deptno, 10, sal)) d10, 
sum(decode(deptno, 20, sal)) d20, 
sum(decode(deptno, 30, sal)) d30 
from emp;

select job,
sum(sal) total, 
sum(decode(deptno, 10, sal)) d10, 
sum(decode(deptno, 20, sal)) d20, 
sum(decode(deptno, 30, sal)) d30 
from emp
group by job
order by job;


select job,
sum(sal) total, 
sum(nvl(decode(deptno, 10, sal), 0)) d10, 
sum(nvl(decode(deptno, 20, sal), 0)) d20, 
sum(nvl(decode(deptno, 30, sal), 0)) d30
from emp
group by job
order by job;