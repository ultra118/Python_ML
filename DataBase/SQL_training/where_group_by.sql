-- ���־��� ���
-- ed ���ϸ�
-- �� �ȿ� ���־��� ��� �����
-- @���ϸ�.sql ���� ����


-- sal�� 2000�̸��̸� low 2000�̻��̸� high
select sal, sal, sal
from emp;

-- trunc ���� => ����ȭ
select empno, trunc(sal/2000)
from emp;

-- decdoe case ǥ����
select empno, sal, 
decode(trunc(sal/2000), 0, 'low', 'high') flag
from emp;

-- simple case ǥ����
select empno, sal,
case trunc(sal/2000) when 0 then 'low'
when 1 then 'high'
else 'hhigh'
end flag
from emp;

-- searched case ǥ����
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

-- ���� ������
select empno, ename || ' is a ' || job as sawon
from emp;
-- j�� �����ϴ� table ���������
-- table��� ������ drop ����� ���ؼ� ����
select 'drop table' || tname || 'cascade constraints;' as commands
from tab
where tname like 'J%';

-- '�� ���ڷ� �������ؼ��� �ٿ��� ������ �� ''
select ename || ' ''s house is bigger then Toms''s'
from emp
where sal >= 3000;
-- �Ǵ� q������ ���
-- ���Ѵٴ� ���� q'[]'��簡 q'XX'��簡 �ƹ� ��Ī�Ǵ� ���ڵ��� �־��൵ ��
select ename||q'X's house is bigger then Toms'X'
from emp
where sal >= 3000;

-- �ߺ�����
select unique job
from emp;
select distinct job
from emp;
-- ������� ���� �ߺ� ���� 
select distinct deptno, job
from emp;


/*
���ڿ� �� ��¥
- ���� ���� ��ҹ��ڸ� �����ϰ�, ��¥ ���� ������ ����(��/�ҹ��� ���� X)
*/


/*
������
*/
select *
from emp
where empno >= 7500 and
empno <= 8000;
-- ���� ���� ǥ��
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
and �� or ���� �켱������ ����
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

-- like�� �ѹ��� 2���� �� �� ����
-- between�� ~ �̻� ~ ���ϸ� ��


/*
ename�� 5������ ���
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
-- ���� %�� _�� �˻��ϱ� ���� escape ���
select *
from t1
where col2 like '%A!_A%' escape '!';

-- empno �÷��� ���� �ִ� �� 
select *
from emp
where empno = empno;

-- �׻� False�� �������� ������ ���
select *
from emp
where 1 = 2;

/*
Order By�� ����
- ��������(asc, default��)
- ��������(desc)
- �� ���̻��� �������� ����
- select ����Ʈ�� ���� Į������ ����
- null�� ���� ū ������ ��޵�
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

-- ������ ����� ���� Order by
-- ����. ����̸��� ª�� ������� ����

select empno, ename
from emp
order by length(ename) asc, ename;
-- ª�� ��, ���ĺ� ��

-- ����. �Ի������� ������ ����

select empno, ename, hiredate, to_char(hiredate, 'mm') as month
from emp
order by month, hiredate;
-- to_char(datetype, 'mm') ���� ����


/*
������
group by�� ����
*/
select job, sum(sal)
from emp
group by job;

select deptno ,job, sum(sal)
from emp
group by deptno, job;

/*
������ ����� ���� Group by
����. �Ի������� ��(Month)�� Ȱ���� ����
*/
select to_char(hiredate, 'mm') as ��, count(*) as �ο���
from emp
group by to_char(hiredate, 'mm')
order by ��;

/*
Group by�� ���� �߿� ����
SELECT ����Ʈ���� ������ �Լ��� ���� column �̿��� ��� column�� 
�ݵ�� GROUP BY���� ��Ÿ���� ��
��, ���ͷ��� ����
*/
--- error
select deptno, job, sum(sal)
from emp
group by deptno;
--- ���ͷ� ����
select '�μ��� ������', deptno, sum(sal)
from emp
group by deptno;
-- ���� Group By
select deptno, job, sum(sal)
from emp
group by deptno, job;

/*
avg������ distinct ��� 
> sal�� �ߺ��� �����ϰ� ����� ���ϵ��� ��
all�� default 
avg(all sal) �� avg(sal)�� ����
*/

select avg(all sal) from emp;
select avg(distinct sal) from emp;

/*
��� �׷��Լ��� null�� ������
��, count(*)�� ����
�������
avg(sal)�� �𸣴°�(null)�� �������� ����� null�̹Ƿ� null�����ϰ� �� ���ؼ� 1/n(null�����Ѵ�)
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

-- 6, 4, 2�� ����
select count(*), count(no), count(distinct no)
from t1;

select count(*), -- �����
count(comm) -- Ŀ�̼��� �޴� �����
from emp
where deptno = 30;
-- count(*)�� null�� ����
select *
from emp
where deptno = 30;


/*
null���� �����ؼ� �׷��Լ� ����ϱ� ����
nvlȰ��
*/

select comm, nvl(comm, 0)
from emp;

select avg(comm), -- Ŀ�̼� �޴� ������� ��� Ŀ�̼�
avg(nvl(comm, 0)) -- ��ü ������� ��� Ŀ�̼�
from emp;

/*
where ����
having���� ����

����ѵ� ���� �ٸ�
where�� �����ϰ� �ȵǸ� having
where���� �׷��Լ��� ������ �� ����
*/
select deptno, sum(sal)
from emp
where deptno != 20  -- 20�� �ƴ� �͵鸸
group by deptno;

select deptno, sum(sal)
from emp
group by deptno
having deptno != 20;

select deptno, sum(sal)
from emp
where sum(sal) < 10000 -- ��������
group by deptno;
-- �׷� ��� ����
select deptno, sum(sal)
from emp
group by deptno
having sum(sal) < 10000;

/*
�׷��Լ� ��ø
*/
select max(avg(sal)) -- �μ��� �ִ���� �޿�
from emp
group by deptno;

/*
������ ���� �� ����
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



