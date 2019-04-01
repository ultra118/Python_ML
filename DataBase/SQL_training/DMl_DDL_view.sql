/*
========================================================
DML, TCL, 읽기 일관성 및 Lock  
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
-- 컬럼보다 적은 데이터를 주기 위해서는 컬럼을 특정 지어줘서 줘야함
-- insert into t1 values(1001, 'States'); -- error
insert into t1(a,b) values(1001, 'States'); -- 암시적 null입력
insert into t1 values(1001, 'States', null); -- 명시적 null입력

select * from t1;


insert into t1 values (&svno, 'abc', 300);

/*
inplicit query 
암시적 쿼리
*/

/*
데이터를 지우는 방식은 3가지가 있음
Delete vs Truncate vs Drop

*/
                        -- rollback     |   공간반납
delete from t1;         --    O                X
-- 지웠던 데이터를 다시 복구할 수 있음
-- 테이블에서는 데이터가 지워지지만 지워진 데이터가 어딘가로 옮겨진다고 볼 수 있음
truncate table t1;      --    X             최초 크기만 남기고 반납
-- 지웠던 데이터 복구 X, t1을 최초상태로 되돌림
-- 테이블을 초기화하고 그 처음으로 되돌아감
drop table t1;          --    X             몽땅반납
-- 그냥 테이블을 날려버림 
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

savepoint s1; --일종의 flag

insert into t1 (no) values (3000);
insert into t1 (no) values (4000);

savepoint s2;

insert into t1 (no) values (5000);
insert into t1 (no) values (6000);

rollback to s2; -- s1 만날때까지 뒤로감 (s1 위의 명령들만 살아남음)

commit;

select * from t1;
/*
==================================
읽기 일관성, Lock 그리고 Deadlock
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

commit; -- commit을 해주면 다른 세션에서 테이블의 데이터들을 쿼리할 수 있음
-- 데이터를 동시에 사용하게하는 동시성을 보장하며
-- 다른 사람의 작업에 일관성을 갖게 함
update t_books
set name = 'Python'
where no = 1000;
-- 자동으로 lock이 걸림
-- 다른 세션에서 같은 해당 컬럼에 대한 update를 하면 실행되지 않음

select * from t_books;
rollback; -- 트랜잭션 종료시키면 다른 세션에서는 lock이 풀림, 수정된 값이 반영됨

-- DeadLock
-- 양쪽이 wait 상태에 빠지게 됨
-- 먼저 기다린 사람의 wait만 에러 
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
PL/SQL을 이용해서 트리거(Trigger) 생성
========================================================
*/
drop table t1 purge;
create table t1(no number, name varchar2(10));
-- name 컬럼에 반드시 대문자 입력이라는 룰을 설정해야 함

create or replace trigger t1_name_tri
before insert or update of name on t1 -- insert, update를 수행하기전에 begin과 end사이 먼저 실행
for each row 
begin
--할당연산자 :=
    :new.name := upper(:new.name); -- 대문자로 바꿔서 name을 채워줌
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
index : 데이터 저장소의 데이터가 순서없이 저장되어 있어서 이를 극복하기 위해 만든 객체로서 rowid를 전문적으로 보관함
이익
    - (잘 만들고 잘 사용할 때)~검색속도 향상
    - PK, UK 제약 강화
    - FK 관련 일부 Lock 해결
vs
손해 
    - ~검색속도 저하
    - ~ DML 속도 저하
    - 스토리지 소비
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
-- not null은 add로 추가할 수 없고 modify로 해줘야함
alter table t1 modify (ename not null);

rename t1 to tab1;

truncate table tab1;
-- metat data 형태로 테이블,컬럼에 대해 주석을 달아줌
comment on table tab1 is '테스트 프로젝트 용';
-- column에 관한 주석
comment on column tab1.empno is '사번';
comment on column tab1.ename is '사원이름';

select * from user_tab_comments;
select * from user_col_comments;

drop table tab1;


/*
=============================================
PL / SQL 맛보기
=============================================
*/

set serveroutput on

begin
    dbms_output.put_line('Hello world!');
end;
/
begin
    for i in 1..10 loop
        dbms_output.put_line(i||'번째, Hello world!');
    end loop;
end;
/
-- 변수는 선언부가 있음
declare 
    v_sal number;
begin
    select sal into v_sal
    from emp
    where empno = 7788;
    
    dbms_output.put_line(v_sal);
end;
/
-- 저장됨
create or replace procedure p1
is
begin
    dbms_output.put_line('Hello world!');
end;
/
-- 만들어진 procedure 확인
select object_name, object_type
from user_objects
order by 2,1;

select name, text
from user_source;

-- p1 실행
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
        dbms_output.put_line('급여를 확인하세요!');
    else 
        insert into t1
        values (a, b, c, d);
    end if;
end;
/

exec t1_insert_proc(1000, 'Tom', 30, 'MANAGER');


/*
연습문제 9-1: 데이터 조작
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
- Named Select : select에 이름을 붙여서 서버에 저장
    - select문을 파일로 저장햇 사용하는 것 또한 select에 이름을 지정해주는 것으로 볼 수 있음
- 뷰에 대한 질의는 Base Table에 대한 질의로 Query Transformation됨(예외 존재)
- 집합의 무한 확장

- Simple View (테이블 내용 그대로 보여줌) vs Complex View ( 그대로 보여주는 뷰가 아닌 것)
=========================================================
*/

select empno, ename, sal
from emp
where deptno = 30;

-- 자주사용하는 sql문은 파일로 저장해서
    -- ed 파일이름.sql 같은 방식
    -- start 파일이름.sql 혹은 @ 파일이름.sql로 실행 
    -- 하지만 파일을 항상 들고다니거나해야하는 단점이 있음 => 이를 해결하기 위해 view
create or replace view v1
as
select empno, ename, sal
from emp
where deptno = 30;

select view_name, text
from user_views;

select *
from v1;

-- view가 먼저 실행되고 그 결과로 될 수도 있지만 
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
from ace30.vu_emp1; -- emp table 내부가 어떤지 모름


/*
=================================
Sequence : 고유번호를 자동으로 생성할 수 있음
- sequence를 사용할 경우 값의 Gap이 발생할 수 있음

- 발생할 번호를 포함한 DML문 롤백
- 하나의 시퀀스를 여러 테이블에서 사용할 경우
- Cache 설정으로 추출한
=================================
*/
-- curval은 마지막 sequence 값 리턴하는데 , nextval을 한번이라도 호출하고 나서야 수행 됨

/*
연습 11
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
/* synonym 별명 */
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