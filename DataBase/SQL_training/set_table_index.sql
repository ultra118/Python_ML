/*
==========================
SET ������(a.k.a ���� ����)
==========================
# �������� ����
- UNION ALL : ������(�ߺ� ���)
- UNION     : ������(�ߺ� ����)
- INTERSECT : ������(�ߺ� ����)
- MINUS     : ������(�ߺ� ����)
*/

-- ����. �ٹ��ϴ� ����� �ִ� �μ��� �μ���ȣ
select deptno from dept
intersect 
select deptno from emp;

-- ����. �ٹ��ϴ� ����� ���� �μ��� �μ���ȣ
select deptno from dept
minus
select deptno from emp;

-- ����. ���������� �ִ� ���
select empno from emp
intersect
select mgr from emp;

-- ����. ���������� ���� ���
select empno from emp
minus
select mgr from emp;

-- ����. ����, �Ұ�, �Ѱ踦 ����
select deptno, job, sum(sal)
from emp
group by deptno, job
union all
select deptno , null, sum(sal)
from emp
group by deptno
union all
select null,null, sum(sal)
from emp
order by 1,2;

-- ����. ���� ��ȣ ã��
drop table t1 purge;

create table t1 
as 
select level no
from dual
connect by level <= 100;

delete from t1
where no in 
(select trunc(dbms_random.value(1, 100))
 from dual
 connect by level < 7);
-- 1���� 100������ ������ �����ϰ� 7���� ���ڰ� ����
-- ���⼭ ���� ���ڸ� ��� ã�� ������

select level no
from dual
connect by level <= 100
minus
select no from t1;

/*
 5. group by
 6. join
 7. subquery
 8. set  
 ��������

*/
-- group by~
select job, max(sal), min(sal), sum(sal), avg(sal)
from emp
group by job;

select job, count(*)
from emp
group by job;

select count(count(mgr))
from emp
group by mgr;

select max(sal)-min(sal)
from emp;

select *
from emp;

select mgr, min(sal)
from emp
where sal > 1000 and mgr is not null
group by mgr;


select count(*) as total, to_char(hiredate, 'yy')
from emp, (select to_char(hiredate, 'yy'), count(*)
           from emp
           group by to_char(hiredate, 'yy'))

select count(*)
from emp
group by to_char(hiredate, 'yy');

select count(*) as total,
sum(decode(to_char(hiredate, 'yy'), 80,1,0)) "80",
sum(decode(to_char(hiredate, 'yy'), 81,1,0)) "81",
sum(decode(to_char(hiredate, 'yy'), 82,1,0)) "82",
sum(decode(to_char(hiredate, 'yy'), 83,1,0)) "83"
from emp;

select *
from dept;

select job,
sum(decode(deptno, 10, sal)) as dept10,
sum(decode(deptno, 20, sal)) as dept20,
sum(decode(deptno, 30, sal)) as dept30,
sum(decode(deptno, 40, sal)) as dept40,
sum(sal) as total
from emp
group by job;

-- sub query

select e.ename, e.hiredate
from emp e
where e.deptno in (select deptno from emp where ename = 'KING')
and e.ename <> 'KING';

where empno, ename, sal
from emp
where sal > (select round(avg(sal)) from emp);

select *
from emp;
/*
============================
DML, TCL, �б� �ϰ��� �� Lock
============================
*/

/*
============================
Table
============================
���� : ���� ���� ->     ������ �𵨸�       -> �����ͺ��̽� ���� 
                    - ����, ����              - Create Database ~
                    - Logical Modeling        Create User ~
                      Relational Modeling     Create Table ~
                      Physical Modeiling ...

- Data Integrity(���Ἲ) ������ ���Ӿ��� ����ؾ� ��
    -> ������ ���Ἲ�� ������ �Ǵ� ������ �����Ͻ� ��
    -> ���̺� ������ ���Ἲ ���� ����
    -> PL/SQL�� �̿��ؼ� Ʈ���� ����
    -> Application Code
- Table Instance Chart
  
  
       
*/
/*
==============
���̺� ����
==============
*/
drop table t_emp purge;
drop table t_dept purge;

create table t_dept
(deptno number(2),
 dname  varchar2(10),
 loc    varchar2(10));
 
create table t_emp
(empno  number(4),
 ename  varchar2(10),
 sal    number(10,2),-- ��ü 10�ڸ� �Ҽ��� ���� 2�ڸ�
 hp     varchar2(11),
 deptno number(2));
 
select *
from t_dept;

select *
from t_emp;


select *
from tab
where tname like 'T!_%' escape '!';

desc t_dept
desc t_emp

insert into t_dept values(10, 'Marketing', 'Seoul');
insert into t_dept values(10, 'IT','MASAN'); -- deptno�� �ߺ���

alter table t_dept add unique(deptno); -- error => �̹� �ߺ��Ǿ� �־
-- �ߺ��Ǵ� deptno�� updater ���ְ� ���� �缳�� 
update t_dept
set deptno = 20
where dname = 'IT';

insert into t_dept values(10, 'RD', 'Suwon'); -- error , ������ deptno�� �ߺ� �ȵǰ� ������ ������
insert into t_dept values(30, 'RD', 'Suwon');

select *
from t_dept;

select *
from departments;

-- 40���� �����ؼ� 10�� �����ϴ� sequence (1000 ����)
create sequence t_dept_deptno_seq
start with 40
increment by 10
maxvalue 1000;

insert into t_dept values (t_dept_deptno_seq.nextval, 'ACCOUNT', 'GJ');
insert into t_dept values (t_dept_deptno_seq.nextval, 'ACCOUNT', 'GJ');

-- ��� next�� valu�� Ȯ��
select t_dept_deptno_seq.currval
from dual;

-- null�� � ������ �𸣴� ���̱⶧���� uniqe ������ �����Ǹ� ��� �� �� ����(�ߺ����� �ʴ´ٰ� ����)
insert into t_dept values (null, 'SALES', 'GJ');
insert into t_dept values (null, 'RESEARCH', 'GJ');

select *
from t_dept;
/*
==============
���̺� ����
==============
T_EMP
empno   ename       sal     hp      ... deptno
number  varchar2    number  varchar2    number
�ߺ�X    �ߺ�O       �ߺ�O    �ߺ�X        
��X      ��X         ��O     ��O
                    0�̻�                ������ ��  

T_DEPT
deptno  dname
�ߺ�X    �ߺ�O
�� X     �� X
*/

drop table t_emp purge;
drop table t_dept purge;
/*
====================
�÷� ������ ��������
====================
*/
create table t_dept
(deptno number(2)   constraint t_dept_deptno_pk primary key, -- primary key�� �ϳ��� ������ �� �ְ�, uniuqe not null Ư¡, �� �ĺ���
 dname  varchar2(10) constraint t_dept_dname_nn not null,
 loc    varchar2(10));
 -- insert �Ҷ� ����κ��� ������ ���ݵǴ��� constraint�� ���� �˼� ����
create table t_emp
(empno  number(4)   constraint t_emp_empno_pk primary key, 
 ename  varchar2(10) constraint t_emp_ename_nn not null,
 sal    number(10, 2) constraint t_emp_sal_ck check(sal >= 0),
 hp     varchar2(11) constraint t_emp_hp_uk unique constraint t_emp_hp_nn not null,
 deptno number(2)   constraint t_emp_deptno_fk references  t_dept(deptno));

insert into t_dept values (10, 'IT', 'Seoul');
insert into t_dept values (10, 'SALES', 'Suwon'); -- error .. unique constraint
insert into t_dept values (null, 'SALES', 'Suwon'); -- error .. not null constraint

/*
====================
���̺� ���� �������� ���� ����
====================
*/
drop table t_emp purge;
drop table t_dept purge;

create table t_dept
(deptno number(2),
 dname  varchar2(10),
 loc    varchar2(10),
 constraint t_dept_deptno_pk primary key(deptno),
 -- not null(dname) not null�� �ȵ� => check�� �ٲ���
 constraint t_dept_dname_nn check (dname is not null)
 );  
 
create table t_emp
(empno  number(4),
 ename  varchar2(10),
 sal    number(10, 2),
 hp     varchar2(11),
 deptno number(2),
 primary key(empno),
 check(ename is not null),
 check(sal >= 0),
 unique(hp),
 check(hp is not null),
 foreign key(deptno) references t_dept(deptno)
);
/*
==============================================
�ݵ�� ���̺� ���� ���� ���� ������ �ؾ��ϴ� ���
==============================================
*/
-- �� �� �̻��� �÷����� �ϳ��� ������ ������ ���
create table t_simin
(no number primary key,
 ju1 varchar2(6),
 ju2 varchar2(7),
    unique(ju1, ju2));

/*
�η� AP create table
*/
drop table member_t purge;
drop table title purge;
drop table title_copy purge;

create table member
 (member_id     number(10),
  last_name     varchar2(25),
  first_name    varchar2(25),
  address       varchar2(100),
  city          varchar2(30),
  phone         varchar2(15),
  join_date     date default sysdate,
  constraint member_member_id_pk primary key(member_id),
  constraint member_last_name_nn check (last_name is not null),
  constraint member_join_date_nn check (join_date is not null)
);

create table title
( title_id      number(10),
  title         varchar2(60),
  description   varchar2(400),
  rating        varchar2(4),
  category     varchar2(20),
  release_date  date,
  constraint title_title_id_pk primary key(title_id),
  constraint title_title_nn check (title is not null),
  constraint title_description_nn check (description is not null),
  constraint title_rating_ck check (rating in ('G','PG','R','NC17','NR')),
  constraint title_category_ck check (category in ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY'))
);

create table title_copy
( copy_id       number(10),
  title_id      number(10),
  status        varchar2(15),
  
  constraint title_copy_title_id_fk foreign key(title_id) references title(title_id),
  constraint title_copy_copy_id_title_id_pk primary key (copy_id,title_id),
  constraint title_copy_status_nn check (status is not null),
  constraint title_copy_status_ck check (status in ('AVAILABLE', 'DESTROYED', 'RENTED', 'RESERVED'))
);

create table rental
( book_date     date default sysdate,
  member_id     number(10),
  copy_id       number(10),
  act_ret_date  date,
  exp_ret_date  date default sysdate+2,
  title_id      number(10),
  constraint rental_mebmer_id_fk foreign key (member_id) references member(member_id),
  constraint rental_book_memb_cpy_title_pk primary key (book_date, member_id, copy_id, title_id),
  constraint rental_copy_id_title_id_fk foreign key (copy_id, title_id) references title_copy(copy_id, title_id)
);

create table reservation
( res_date      date,
  member_id     number(10),
  title_id      number(10),
  constraint reservation_res_meber_title_pk primary key (res_date, member_id, title_id),
  constraint reservation_member_id_fk foreign key (member_id) references member(member_id),
  constraint reservation_title_id_fk foreign key (title_id) references title(title_id)  
);




-- RPAD �Լ�
select empno, ename, sal, ceil(sal/100) -- ceil�� �ø�
from emp;

select empno, ename, sal , rpad('*', ceil(sal/100), '*') as starts
from emp;

/*
==============================
���̺� ���� ��ǥ�� ��Ÿ ������
==============================
*/
select table_name, NUM_ROWS, BLOCKS
from user_tables;

select table_name, constraint_name, constraint_type, search_condition
from user_constraints;
/*
oracle�� pk���� �������ǵ��� �˻��Ҷ� ó������ ������ �� ���� �ߺ��Ǵ��� ���ϴ°� �ƴ϶�
���������� indexing ���� �����صΰ� Ư�� ������ ���缭 ���귮�� ���̴� ���·� ���� ���ϰ� ��?
*/
select table_name, index_name
from user_indexes
order by 1;

/*
====================================
View,Index, Sequence, Synonym

# View
# Index
    - ������ ������� �����Ͱ� �������� ����Ǿ� �־ �̸� �غ��ϱ� ���� ���� ��ü�μ� rowid�� ���������� ������
    - pseudocolumn�� ���ڰ� ���� �Լ��� ����, �ٵ� ���� ���� �����ϴ°� �ƴ� 
        - rowid
            - pseudocolumn ��� �ϳ�
            - 64����
            - 6(Object) 3(file) 6(block) 3(row)
    - oracle���� �����͸� ���� ���� ã�� ����� rowid�� Ȱ���ϴ� ��

# Sequence
# Synoym
====================================
*/
select rowid, e.* from emp e;

select rowid, rownum , user, sysdate, empno from emp;
-- table�� ������ ��ҿ� ��ġ key-value ó�� rowid�� job�� mapping
create index emp_job_idx
on emp(job);

select job, rowid -- ���� ����
from emp
order by 1,2;
-- �Ʒ� ������ ������ ��� ����Ŭ�� Optimzer�� �ε��� ��� ���θ� �Ǵ��Ͽ�
-- �ε����� ����� ��� MANAGER��� ������ �ε����� ã�� ������ rowid�� ȹ����
-- ȹ���� rowid�� ���̺��� �����͸� ã�Ƽ� return �ϰ� ��
select *
from emp
where job = 'MANAGER';



