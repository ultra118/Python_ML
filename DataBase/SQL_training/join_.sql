/*
# SET ������(���� ����)
- UNION ALL : ������(�ߺ� ���)
- UNION     : ������(�ߺ� ����)
*/
-- ������ ����� ���� ����
select job, decode(job, 'ANALYST', job, 'MANAGER', job, 'Others') as job
-- job�� analyst, manager �� �״�� �������� others��
from emp;

select decode(job, 'ANALYST', job, 'MANAGER', job, 'Others') as job, sum(sal) as �Ѱ�
from emp
group by decode(job, 'ANALYST', job, 'MANAGER', job, 'Others')
order by �Ѱ�;
-----------------------------------------------------------------------------------------------------------------------
/*
to_char �Լ�
select hiredate, to_char(hiredate, 'yyyy mm dd') -- yyyy mm dd ���� �� element��� format�� ����
*/
select hiredate, to_char(hiredate, 'yyyy mm dd') 
from emp;

-- �б⺰ �Ի��� ��
select hiredate, to_char(hiredate, 'q')
from emp;

select to_char(hiredate, 'q') �б�, count(*) �Ի��ڼ�
from emp
group by to_char(hiredate, 'q')
order by �б�;

select hiredate, to_char(hiredate, 'YEAR Year year')
from emp;

select hiredate, to_char(hiredate, 'YEAR Month Mon Day Dy')
from emp;

select hiredate, to_char(hiredate, 'fmYEAR Month Mon Day Dy') -- fm : fill mode ,, �߰��� space�� ������
from emp;

/*
����Ŭ�� Date�� ���������� 7byte Numberic���� ���� : 20 19 03 27 11 43 25
ȭ�鿡 ���̴°� session�� ȯ�濡 ���� �޶���
*/
select sysdate
from dual;
-- nls_date_format�� ���� �޶���
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
select sysdate
from dual;

select sysdate, to_char(sysdate, 'hh hh12 hh24 mi ss')
from dual;

select sysdate, to_char(sysdate, 'sssss')
from dual;

select sysdate, '������ '||to_char(sysdate, 'yyyy')||'�� '||to_char(sysdate, 'mm')||'��'||to_char(sysdate, 'dd')||'�Դϴ�.'
from dual;

select sysdate, to_char(sysdate, '"������" yyyy"��" mm"��" dd"���Դϴ�"') as greeting
from dual;
-----------------------------------------------------------------------------------------------------------------------
/*
LOWER, UPPER, INITCAP �Լ�
*/

select 'My name' a, 'My name' b, 'My name' c, 'My name' d
from dual;

select 'My name' a, upper('My name') b, lower('My name') c, initcap('My name') d
from dual;

/*
# join
- Equi join, Inner join (� ����)
- Nonequi join (�� ����)
- Outer join (�ܺ� ����)
- Self join  (��ü ����)
from ���� table�� 2�� �̻�

select *
from emp, dept -- join, Catesian product, row ����
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
from employees E, departments D -- alias ���
where E.DEPARTMENT_ID = D.DEPARTMENT_ID and E.SALARY >= 3000
order by E.SALARY;

-- ����� ��޺��� 
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
-- +���� ���� ������ �κ�
select e.employee_id, e.department_id, d.department_id
from employees e, departments d
where e.department_id = d.department_id (+);

-- ����. 7844 ������� ���� �޿��� �޴� ���
select *
from emp e, emp t
where t.empno = 7844 and
e.sal > t.sal;

-- ����. ������ ���ϱ�

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

select a.A, a.B, sum(b.B) -- ������
from t1 a, t1 b
where a.a >= b.a
group by a.A, a.B
order by a.a;



/*
��������
- �ٸ� SQL�� ���Ե� SELECT
*/

/*
6�� ��������
*/
-- ��������
-- �ٸ� SQL�� ���Ե� select 
/*
���� ����� �μ� ��ȣ�� �޿��� Ŀ�̼��� �޴� ����� �μ� ��ȣ �� �޿���
���Ͽ� ���� ��ġ�ϴ� ����� ��, �μ� ��ȣ �� �޿��� ǥ���ϴ� query��
�ۼ��մϴ�.
*/
select LAST_NAME, DEPARTMENT_ID, SALARY
from employees
where (salary, department_id) in
(select salary, department_id
from employees
where COMMISSION_PCT is not null);
-- d.department_name
/*
�޿��� Ŀ�̼��� ��ġ ID1700�� ��ġ�� ����� �޿� �� Ŀ�̼ǰ� ��ġ�ϴ�
����� ��, �μ� �̸� �� �޿��� ǥ���մϴ�.
*/
select e.last_name, d.department_name, e.salary
from employees e, departments d
where e.department_id = d.department_id and
(salary, NVL(commission_pct,0)) 
in (select salary, NVL(commission_pct,0)
from departments d, employees e
where e.department_id = d.department_id and d.location_id = 1700);

/*
Kochhar�� ������ �޿� �� Ŀ�̼��� �޴� ��� ����� ��, ä�� ��¥ �� �޿���
ǥ���ϴ� query�� �ۼ��մϴ�.
����: ��� ���տ� Kochhar�� ǥ������ ���ʽÿ�
*/
select e.LAST_NAME, e.HIRE_DATE, e.SALARY
from employees e, departments d
where d.DEPARTMENT_ID  = e.DEPARTMENT_ID and
(e.salary, NVL(e.commission_pct,0)) 
in (select e.SALARY, NVL(e.commission_pct,0)
from employees e
where e.LAST_NAME like 'Kochhar');

/*
��� ���� ������(JOB_ID = 'SA_MAN')���� ���� �޿��� �޴� �����
ǥ���ϴ� query�� �ۼ��մϴ�. ����� ��������� �����մϴ�
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
-- ����. �μ��� �μ��� ���� ������� ...�� �����ϼ���

-- ����. ����� ������� �޿� ����� �����ϼ���
-- ����. 7844 ������� ���� �޿��� �޴� ���?
-- ����. ������ ���ϱ�


/*
HR ���� ���� ��
*/

select count(*)
from employees e, departments d, locations l, countries c, regions r;

-- cout(*)�� �ϸ� null�� 1�� ����
select r.region_id, r.region_name, count(e.employee_id)
from employees e, departments d, locations l, countries c, regions r
where nvl(e.department_id(+), 10) = d.department_id 
and d.location_id(+) = l.location_id
and l.country_id(+) = c.country_id
and c.region_id(+) = r.region_id
group by r.region_id, r.region_name;


