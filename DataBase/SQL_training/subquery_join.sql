/*
========================
�������� ����
========================
# ����
# ��������
# SET ������
# ����� ���� �Լ�
*/
/*
DB Partitioning
horizontal partitioning = sharding -> ���� �и�
vertical partitioning -> ���� �и�
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

/* [1] ���� */
select *
from t1, t2;

select t1.empno, t1.ename, t2.job
from t1, t2
where t1.empno = t2.empno;

/* [2] �������� */
select t1.empno, t1.ename, (select job from t2 where empno = t1.empno)
from t1;

/* [3] SET ������ */
-- union all �� ����, join�� ������
-- ���귮�� �� ����
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

/* [4] ����� ���� �Լ� */
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
��������
- Single column Single row subquery
- Single column Multiple row subquery : �������� ����� �������� �׿� �´� �����ڷ� �� ��
- Multiple column Multiple row subquery (pair-wise subquery)

- Corrleated Subquery (��ȣ���� ��������)
- Scalar subquery : �� �ϳ��� �����ϴ� ����group by���� ������ select���� ��� ������ ��Ÿ�� �� ����
====================
*/

-- ����. 7782 ������� �޿��� ���� �����鼭 7902 ����� ���� ������ �����ϴ� ���
select * from emp;
-- join���� Ǯ��
select e.empno, e.ename, e.job, e.sal, a.sal, b.job
from emp e, emp a, emp b
where a.empno = 7782
and b.empno =7902
and e.sal > a.sal
and e.job = b.job;

-- ���������� Ǯ��
select empno, ename, job, sal
from emp
where sal > (select sal 
             from emp 
             where empno = 7782)
and job = (select job 
           from emp 
           where empno = 7902);
           
-- Query Transformation 
-- where ename like 'SCOTT' => �ڵ����� where ename = 'SCOTT' ���� �ٲ�
-- where sal between 1000 and 2000 => where sal >= 1000 and sal <= 2000
-- where job in ('ANALYST', 'MANAGER') => where job = 'ANALYST' or job = 'MANAGER'

-- ����. ȸ���� ��� �޿����� ���� �޿��� �����鼭 7788 ������� ���� �Ի��� ����� �������� ��������
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


-- ����. ���� �޿����� ENAME, SAL�� ����

select ename, sal
from emp
where sal = (select min(sal) from emp);


-- ����. �ٹ��ϴ� ����� �ִ� �μ��� DEPTNO, DNAME, LOC�� ����

select deptno, dname, loc
from dept
where dept.deptno in (select deptno from emp);

-- ���������ȿ� �������� �ߺ��� ���ŵ�
-- distinct�� �Ƚᵵ ��ġ �� �Ͱ� ���� ȿ��

-- �ٸ� ���
select deptno, dname, loc
from dept d
where 0 <(select count(*)
          from emp
          where deptno = d.deptno);     -- ��ȣ���� ��������
          
select *
from dept;
-- �� �ٸ� ���
select deptno, dname, loc
from dept d
where exists (select 'x'    -- ��ȣ���� �������� + Exists
              from emp 
              where deptno = d.deptno); 
-- ���������� �����ϴ� ���� �޾Ƽ� ���� ���ϴ°� �ƴ϶�
-- �ٱ��ʿ� �ִ°� �����ͷ� �־ ������������ �ϳ��� �߰ߵǸ� (dept d�� �����ϴ� ���������� ���� �� ���� �������� ����)
-- �������� select���� �ƹ��͵� ���� �ʴ´�, ������ ���� �޴°� �ƴϱ⶧����
-- ���������� x�� �־���

-- ����. ���������� �ִ� ����� �����ϼ���
select empno, ename, job, sal
from emp
where empno in (select mgr from emp);
-- exists Ǯ��
select e.empno, e.ename, e.job, e.sal
from emp e
where exists (select mgr from emp where mgr = e.empno);

-- ����. ���������� 3�� �̻��ִ� ���
select e.empno, e.ename, e.job, e.sal
from emp e
where 3 <= (select count(*) from emp where mgr = e.empno);


-- ����. empno, ename, sal �޿� ������ ����, �� ���������� �̿��ؼ�

select e1.empno, e1.ename, e1.sal, (select sum(sal) from emp where empno <= e1.empno) as ������
from emp e1;
-- ��ȣ���� ���������� ��

-- ����. empno, ename, hiredate, "���� �Ի��� ��� ��"

select e.empno,  e.ename, e.hiredate, (select count(*) from emp where hiredate < e.hiredate) as "���� �Ի��� ��� ��"
from emp e
order by hiredate;

-- ����. EMPNO, ENAME ,SAL "ȸ����ձ޿�"�� ���� ��, �������� ������ Ȱ��
-- (Scalar subquery)
select empno, ename, sal, (select round(avg(sal)) from emp) as "ȸ����ձ޿�"
from emp;
-- ����. ���� �������� "�ҼӺμ� ���"
-- (Scalar subquery + ��ȣ����)
select e.empno, e.deptno, e.ename, e.sal, (select round(avg(sal)) from emp where e.deptno = deptno) as "�μ��� ��ձ޿�"
from emp e;
-- dept�� loc�� orderby ������ ���� �� ����
select empno, ename, deptno
from emp e
order by (select loc from dept where deptno = e.deptno);

-- join����
select e.empno, e.ename, e.deptno
from emp e, dept d
where e.deptno = d.deptno
order by d.loc;

-- ����. Mutiple column Multiple row subquery ����
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
where col1 in (select col1 from t2) -- 100�� 200 ����
and col2 in (select col2 from t2); -- A�� B����

--> pair-wise subquery
select *
from t1
where (col1, col2) in (select col1,col2 from t2); -- ������ ���� (100, A), (200, B)

select *
from t2;