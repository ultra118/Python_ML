/*
========================================================
DML, TCL, �б� �ϰ��� �� Lock  
========================================================
*/
drop table t1 purge;

create table t1
as
select empno a, ename b, sal c
from emp
where 1 = 2;

select * from t1;

insert into t1 values(1000, 'Korea', 267.34);
-- �÷����� ���� �����͸� �ֱ� ���ؼ��� �÷��� Ư�� �����༭ �����
-- insert into t1 values(1001, 'States'); -- error
insert into t1(a,b) values(1001, 'States'); -- �Ͻ��� null�Է�
insert into t1 values(1001, 'States', null); -- ����� null�Է�

select * from t1;


insert into t1 values (&svno, 'abc', 300);

/*
inplicit query 
�Ͻ��� ����
*/

/*
�����͸� ����� ����� 3������ ����
Delete vs Truncate vs Drop

*/
                        -- rollback     |   �����ݳ�
delete from t1;         --    O                X
-- ������ �����͸� �ٽ� ������ �� ����
-- ���̺����� �����Ͱ� ���������� ������ �����Ͱ� ��򰡷� �Ű����ٰ� �� �� ����
truncate table t1;      --    X             ���� ũ�⸸ ����� �ݳ�
-- ������ ������ ���� X, t1�� ���ʻ��·� �ǵ���
-- ���̺��� �ʱ�ȭ�ϰ� �� ó������ �ǵ��ư�
drop table t1;          --    X             �����ݳ�
-- �׳� ���̺��� �������� 
/*
==================================
TCL : COMMIT, ROLLBACK, SAVEPOINT
==================================
*/
drop table t1 purge;
create table t1 (no number, name varchar2(10));

insert into t1 (no) values (1000);
insert into t1 (no) values (2000);

update t1 set name = 'Java' where no = 2000;

savepoint s1; --������ flag

insert into t1 (no) values (3000);
insert into t1 (no) values (4000);

savepoint s2;

insert into t1 (no) values (5000);
insert into t1 (no) values (6000);

rollback to s2; -- s1 ���������� �ڷΰ� (s1 ���� ��ɵ鸸 ��Ƴ���)

commit;

select * from t1;
/*
==================================
�б� �ϰ���, Lock �׸��� Deadlock
==================================
*/
create table t_books
( no number, 
  name varchar2(20));
  
insert into t_books
values (1000, 'Java');

insert into t_books
values (2000, 'SQL');

select * from t_books;

commit; -- commit�� ���ָ� �ٸ� ���ǿ��� ���̺��� �����͵��� ������ �� ����
-- �����͸� ���ÿ� ����ϰ��ϴ� ���ü��� �����ϸ�
-- �ٸ� ����� �۾��� �ϰ����� ���� ��
update t_books
set name = 'Python'
where no = 1000;
-- �ڵ����� lock�� �ɸ�
-- �ٸ� ���ǿ��� ���� �ش� �÷��� ���� update�� �ϸ� ������� ����

select * from t_books;
rollback; -- Ʈ����� �����Ű�� �ٸ� ���ǿ����� lock�� Ǯ��, ������ ���� �ݿ���

-- DeadLock
-- ������ wait ���¿� ������ ��
-- ���� ��ٸ� ����� wait�� ���� 
update t_books
set name = 'Python'
where no = 1000;

update t_books
set name = 'Unix'
where no = 2000;

commit;

select * from t_books;
/*

========================================================
PL/SQL�� �̿��ؼ� Ʈ����(Trigger) ����
========================================================
*/
drop table t1 purge;
create table t1(no number, name varchar2(10));
-- name �÷��� �ݵ�� �빮�� �Է��̶�� ���� �����ؾ� ��

create or replace trigger t1_name_tri
before insert or update of name on t1 -- insert, update�� �����ϱ����� begin�� end���� ���� ����
for each row 
begin
--�Ҵ翬���� :=
    :new.name := upper(:new.name); -- �빮�ڷ� �ٲ㼭 name�� ä����
end;
/
insert into t1 values (1000, 'john');
insert into t1 values (2000, 'alice');
select * from t1;

/*
========================================================
View, index, Sequence, Synonym
========================================================
*/
/*
index : ������ ������� �����Ͱ� �������� ����Ǿ� �־ �̸� �غ��ϱ� ���� ���� ��ü�μ� rowid�� ���������� ������
����
    - (�� ����� �� ����� ��)~�˻��ӵ� ���
    - PK, UK ���� ��ȭ
    - FK ���� �Ϻ� Lock �ذ�
vs
���� 
    - ~�˻��ӵ� ����
    - ~ DML �ӵ� ����
    - ���丮�� �Һ�
*/


/*
======================================================
DDL : CREATE, ALTER, DROP, RENAME, TRUNCATE, COMMENT
======================================================
*/
drop table t1 purge;

create table t1
( empno number,
  ename varchar2(10));
  
insert into t1
select empno, ename from emp where rownum <= 3;

select * from t1;

alter table t1 add(sal number(10, 2), deptno number(2));

alter table t1 modify(ename varchar2(6), deptno default 10);

alter table t1 add constraint t1_empno_pk primary key(empno);

alter table t1 add not null(ename); -- error 
-- not null�� add�� �߰��� �� ���� modify�� �������
alter table t1 modify (ename not null);

rename t1 to tab1;

truncate table tab1;
-- metat data ���·� ���̺�,�÷��� ���� �ּ��� �޾���
comment on table tab1 is '�׽�Ʈ ������Ʈ ��';
-- column�� ���� �ּ�
comment on column tab1.empno is '���';
comment on column tab1.ename is '����̸�';

select * from user_tab_comments;
select * from user_col_comments;

drop table tab1;


/*
=============================================
PL / SQL ������
=============================================
*/

set serveroutput on

begin
    dbms_output.put_line('Hello world!');
end;
/
begin
    for i in 1..10 loop
        dbms_output.put_line(i||'��°, Hello world!');
    end loop;
end;
/
-- ������ ����ΰ� ����
declare 
    v_sal number;
begin
    select sal into v_sal
    from emp
    where empno = 7788;
    
    dbms_output.put_line(v_sal);
end;
/
-- �����
create or replace procedure p1
is
begin
    dbms_output.put_line('Hello world!');
end;
/
-- ������� procedure Ȯ��
select object_name, object_type
from user_objects
order by 2,1;

select name, text
from user_source;

-- p1 ����
execute p1

create or replace procedure p2(a number)
is
    declare 
        v_sal nubmer;
begin
    select sal into v_sal
    from emp
    where empno = a;
        
    dbms_output.put_line(v_sal);
end;
/

drop table t1 purge;
create table t1
as
select empno, ename, sal, job
from emp
where 1 = 2;

create or replace procedure t1_insert_proc
(a number, b varchar2, c number, d varchar2)
is
begin
    if c <= 1000 then
        dbms_output.put_line('�޿��� Ȯ���ϼ���!');
    else 
        insert into t1
        values (a, b, c, d);
    end if;
end;
/

exec t1_insert_proc(1000, 'Tom', 30, 'MANAGER');


/*
�������� 9-1: ������ ����
*/
drop table my_employee;

create table my_employee
( id         number(4) constraint my_employee_id_pk primary key,
  last_name  varchar2(25),
  first_name varchar2(25),
  userid     varchar2(8),
  salary     number(9,2)
);
-- alter table t1 add(sal number(10, 2), deptno number(2));
-- alter table t1 modify(ename varchar2(6), deptno default 10);
describe my_employee;
insert into my_employee values (1, 'Patel', 'Ralph', 'raptel', 895);
select * from my_employee;
insert into my_employee(id, last_name, first_name, userid, salary) values (2, 'Dancs', 'Betty', 'bdancs', 860);

describe my_employee;

create or replace procedure myemp_insert_proc
(id_val number, lname_val varchar2, fname_val varchar2, uid_val varchar2, sal_val number)
is 
begin
    insert into my_employee values (id_val, lname_val, fname_val, uid_val, sal_val);
end;
/

execute myemp_insert_proc(3,'Biri', 'Ben', 'bbiri', 1100);
execute myemp_insert_proc(4,'Newman', 'Chad', 'cnewman', 750);
execute myemp_insert_proc(5,'Ropeburn', 'Audrey', 'aropebur', 1550);

select * from my_employee;

commit;

update my_employee set last_name = 'Drexler' where id = 3;
select * from my_employee;

update my_employee set salary = 1000 where salary < 900;
select * from my_employee;

delete from my_employee where first_name = 'Betty' and last_name = 'Dancs';
select * from my_employee;

commit;

savepoint t18;

delete from my_employee;

select * from my_employee;

rollback to t18;

select * from my_employee;


create or replace myemp_uid_autoinsert_proc
(id_val number, lname_val varchar2, fname_val varchar2, sal_val number)
is
begin
    insert into my_employee values
    (id_val, lname_val, fname_val, lower(substr(fname_val,1,1) || substr(lname_val,1,7)), sal_val);
end;
/
execute myemp_uid_autoinsert_proc(6, 'Anthony', 'Mark', 1500);

select * from my_employee;


/*
=========================================================
View
- Named Select : select�� �̸��� �ٿ��� ������ ����
    - select���� ���Ϸ� ������ ����ϴ� �� ���� select�� �̸��� �������ִ� ������ �� �� ����
- �信 ���� ���Ǵ� Base Table�� ���� ���Ƿ� Query Transformation��(���� ����)
- ������ ���� Ȯ��

- Simple View (���̺� ���� �״�� ������) vs Complex View ( �״�� �����ִ� �䰡 �ƴ� ��)
=========================================================
*/

select empno, ename, sal
from emp
where deptno = 30;

-- ���ֻ���ϴ� sql���� ���Ϸ� �����ؼ�
    -- ed �����̸�.sql ���� ���
    -- start �����̸�.sql Ȥ�� @ �����̸�.sql�� ���� 
    -- ������ ������ �׻� ���ٴϰų��ؾ��ϴ� ������ ���� => �̸� �ذ��ϱ� ���� view
create or replace view v1
as
select empno, ename, sal
from emp
where deptno = 30;

select view_name, text
from user_views;

select *
from v1;

-- view�� ���� ����ǰ� �� ����� �� ���� ������ 
select empno, ename, sal
from v1
where sal >= 2500;

--------------------
--> complex view <--
--------------------
select d.deptno, d.dname, count(*), max(e.sal), min(e.sal)
from emp e, dept d
where e.deptno = d.deptno
group by d.deptno, d.dname;

create or replace view vu_emp1
as
select empno, ename, job
from emp;

create or replace view vu_emp2
as
select empno, ename, job, sal
from emp;

select *
from ace30.emp;

select *
from ace30.vu_emp1; -- emp table ���ΰ� ��� ��


/*
=================================
Sequence : ������ȣ�� �ڵ����� ������ �� ����
- sequence�� ����� ��� ���� Gap�� �߻��� �� ����

- �߻��� ��ȣ�� ������ DML�� �ѹ�
- �ϳ��� �������� ���� ���̺��� ����� ���
- Cache �������� ������
=================================
*/
-- curval�� ������ sequence �� �����ϴµ� , nextval�� �ѹ��̶� ȣ���ϰ� ������ ���� ��

/*
���� 11
*/

create or replace view employees_vu
as
select employee_id, last_name as employee, department_id
from employees;

select * from employees_vu;

select employee, department_id
from employees_vu;

create or replace view dept50
as
select employee_id as empno, last_name as employee, department_id as deptno
from employees
where department_id = 50;

select * from dept50;

describe dept50;

update dept50
set deptno = 80
where employee = 'Matos';

select * from dept50;

drop sequence dept_id_seq;

create sequence dept_id_seq
start with 50
increment by 10
maxvalue 100;

select * from dept;

insert into dept
values (dept_id_seq.nextval, 'Education', null);

insert into dept
values (dept_id_seq.nextval, 'Administration', null);

select * from dept;

create index dept_name_idx 
on dept(dname);

select dname, rowid
from dept
order by 2;
/* synonym ���� */
create synonym dep for dept;

select * from dep;


select * from dept50;
select * from dept;

select *
from employees
where department_id = 80;

update dept50
set deptno = 80
where employee = 'Mourgos';

select * from employees;
select * from dept50;

Truncate table employees;