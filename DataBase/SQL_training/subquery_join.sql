/*
========================
데이터의 연결
========================
# 조인
# 서브쿼리
# SET 연산자
# 사용자 정의 함수
*/
/*
DB Partitioning
horizontal partitioning = sharding -> 행을 분리
vertical partitioning -> 열을 분리
*/
drop table t1 purge;
drop table t2 purge;

create table t1 as
select empno, ename
from emp
where empno <= 7788;

create table t2
as
select empno, job
from emp
where empno <= 7788;

/* [1] 조인 */
select *
from t1, t2;

select t1.empno, t1.ename, t2.job
from t1, t2
where t1.empno = t2.empno;

/* [2] 서브쿼리 */
select t1.empno, t1.ename, (select job from t2 where empno = t1.empno)
from t1;

/* [3] SET 연산자 */
-- union all 은 덧셈, join은 곱셈임
-- 연산량이 더 적음
select empno, ename, null as job
from t1
union all
select empno, null, job
from t2
order by 1;

select empno, max(ename), max(job)
from (select empno, ename, null as job
    from t1
    union all
    select empno, null, job
    from t2
    order by 1,2)
group by empno
order by empno;

/* [4] 사용자 정의 함수 */
create or replace function uf_get_t2_job(a t1.empno%type)
    return varchar2
is
    v_job t2.job%type;
begin
    select job into v_job
    from t2
    where empno = a;
    
    return v_job;
end;
/

select empno, ename, uf_get_t2_job(empno) as job
from t1;

/*
====================
서브쿼리
- Single column Single row subquery
- Single column Multiple row subquery : 서브쿼리 결과가 여러개면 그에 맞는 연산자로 값 비교
- Multiple column Multiple row subquery (pair-wise subquery)

- Corrleated Subquery (상호관련 서브쿼리)
- Scalar subquery : 값 하나를 리턴하는 서브group by절을 제외한 select문의 모든 절에서 나타날 수 있음
====================
*/

-- 문제. 7782 사원보다 급여를 많이 받으면서 7902 사원과 같은 직무를 수행하는 사원
select * from emp;
-- join으로 풀때
select e.empno, e.ename, e.job, e.sal, a.sal, b.job
from emp e, emp a, emp b
where a.empno = 7782
and b.empno =7902
and e.sal > a.sal
and e.job = b.job;

-- 서브쿼리로 풀때
select empno, ename, job, sal
from emp
where sal > (select sal 
             from emp 
             where empno = 7782)
and job = (select job 
           from emp 
           where empno = 7902);
           
-- Query Transformation 
-- where ename like 'SCOTT' => 자동으로 where ename = 'SCOTT' 으로 바뀜
-- where sal between 1000 and 2000 => where sal >= 1000 and sal <= 2000
-- where job in ('ANALYST', 'MANAGER') => where job = 'ANALYST' or job = 'MANAGER'

-- 문제. 회사의 평균 급여보다 많은 급여를 받으면서 7788 사원보다 일찍 입사한 사원을 서브쿼리 문법으로
select *
from emp;

select empno, ename, sal, hiredate
from emp
where sal > (select avg(sal)
             from emp)
and hiredate < (select hiredate
                from emp
                where empno = 7788);


select *
from emp e, emp a
where e.sal > (select avg(sal) from emp);


-- 문제. 최저 급여자의 ENAME, SAL을 쿼리

select ename, sal
from emp
where sal = (select min(sal) from emp);


-- 문제. 근무하는 사원이 있는 부서의 DEPTNO, DNAME, LOC를 쿼리

select deptno, dname, loc
from dept
where dept.deptno in (select deptno from emp);

-- 서브쿼리안에 들어가있으면 중복이 제거됨
-- distinct를 안써도 마치 쓴 것과 같은 효과

-- 다른 방식
select deptno, dname, loc
from dept d
where 0 <(select count(*)
          from emp
          where deptno = d.deptno);     -- 상호관련 서브쿼리
          
select *
from dept;
-- 또 다른 방식
select deptno, dname, loc
from dept d
where exists (select 'x'    -- 상호관련 서브쿼리 + Exists
              from emp 
              where deptno = d.deptno); 
-- 서브쿼리가 리턴하는 값을 받아서 뭔가 비교하는게 아니라
-- 바깥쪽에 있는걸 데이터로 넣어서 서브쿼리에서 하나라도 발견되면 (dept d에 대응하는 서브쿼리는 전부 다 읽지 않을수도 있음)
-- 서브쿼리 select에는 아무것도 넣지 않는다, 뭔가를 리턴 받는게 아니기때문에
-- 관습적으로 x를 넣어줌

-- 문제. 부하직원이 있는 사원을 쿼리하세요
select empno, ename, job, sal
from emp
where empno in (select mgr from emp);
-- exists 풀이
select e.empno, e.ename, e.job, e.sal
from emp e
where exists (select mgr from emp where mgr = e.empno);

-- 문제. 부하직원이 3명 이상있는 사원
select e.empno, e.ename, e.job, e.sal
from emp e
where 3 <= (select count(*) from emp where mgr = e.empno);


-- 문제. empno, ename, sal 급여 누적합 쿼리, 단 서브쿼리를 이용해서

select e1.empno, e1.ename, e1.sal, (select sum(sal) from emp where empno <= e1.empno) as 누적합
from emp e1;
-- 상호관련 서브쿼리라 함

-- 문제. empno, ename, hiredate, "먼저 입사한 사원 수"

select e.empno,  e.ename, e.hiredate, (select count(*) from emp where hiredate < e.hiredate) as "먼저 입사한 사원 수"
from emp e
order by hiredate;

-- 문제. EMPNO, ENAME ,SAL "회사평균급여"를 쿼리 단, 서브쿼리 문법을 활용
-- (Scalar subquery)
select empno, ename, sal, (select round(avg(sal)) from emp) as "회사평균급여"
from emp;
-- 문제. 위의 문제에서 "소속부서 평균"
-- (Scalar subquery + 상호관련)
select e.empno, e.deptno, e.ename, e.sal, (select round(avg(sal)) from emp where e.deptno = deptno) as "부서별 평균급여"
from emp e;
-- dept의 loc로 orderby 절에도 나올 수 있음
select empno, ename, deptno
from emp e
order by (select loc from dept where deptno = e.deptno);

-- join으로
select e.empno, e.ename, e.deptno
from emp e, dept d
where e.deptno = d.deptno
order by d.loc;

-- 문제. Mutiple column Multiple row subquery 이해
drop table t1 purge;
drop table t2 purge;

create table t1 (col1 number, col2 varchar2(10));

insert into t1 values (100, 'A');
insert into t1 values (100, 'B');
insert into t1 values (200, 'A');
insert into t1 values (200, 'B');

create table t2 (col1 number, col2 varchar2(10));
insert into t2 values (100, 'A');
insert into t2 values (200, 'B');

--> non-pair-wise subquery
select *
from t1
where col1 in (select col1 from t2) -- 100과 200 리턴
and col2 in (select col2 from t2); -- A와 B리턴

--> pair-wise subquery
select *
from t1
where (col1, col2) in (select col1,col2 from t2); -- 쌍으로 리턴 (100, A), (200, B)

select *
from t2;