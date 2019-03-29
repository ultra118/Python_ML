/*
==========================
SET 연산자(a.k.a 수직 조인)
==========================
# 연산자의 종류
- UNION ALL : 합집합(중복 허용)
- UNION     : 합집합(중복 제거)
- INTERSECT : 교집합(중복 제거)
- MINUS     : 차집합(중복 제거)
*/

-- 문제. 근무하는 사원이 있는 부서의 부서번호
select deptno from dept
intersect 
select deptno from emp;

-- 문제. 근무하는 사원이 없는 부서의 부서번호
select deptno from dept
minus
select deptno from emp;

-- 문제. 부하직원이 있는 사원
select empno from emp
intersect
select mgr from emp;

-- 문제. 부하직원이 없는 사원
select empno from emp
minus
select mgr from emp;

-- 문제. 집계, 소계, 총계를 쿼리
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

-- 문제. 빠진 번호 찾기
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
-- 1부터 100까지의 숫자중 랜덤하게 7개의 숫자가 빠짐
-- 여기서 빠진 숫자를 어떻게 찾을 것인지

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
 연습문제

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
DML, TCL, 읽기 일관성 및 Lock
============================
*/

/*
============================
Table
============================
과정 : 현실 세계 ->     데이터 모델링       -> 데이터베이스 구현 
                    - 선별, 정리              - Create Database ~
                    - Logical Modeling        Create User ~
                      Relational Modeling     Create Table ~
                      Physical Modeiling ...

- Data Integrity(무결성) 유지를 끊임없이 고민해야 함
    -> 데이터 무결성의 유일한 판단 기준은 비지니스 룰
    -> 테이블 생성시 무결성 제약 설정
    -> PL/SQL을 이용해서 트리거 생성
    -> Application Code
- Table Instance Chart
  
  
       
*/
/*
==============
테이블 생성
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
 sal    number(10,2),-- 전체 10자리 소수점 이하 2자리
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
insert into t_dept values(10, 'IT','MASAN'); -- deptno가 중복됨

alter table t_dept add unique(deptno); -- error => 이미 중복되어 있어서
-- 중복되는 deptno을 updater 해주고 권한 재설정 
update t_dept
set deptno = 20
where dname = 'IT';

insert into t_dept values(10, 'RD', 'Suwon'); -- error , 위에서 deptno는 중복 안되게 설정해 뒀으니
insert into t_dept values(30, 'RD', 'Suwon');

select *
from t_dept;

select *
from departments;

-- 40부터 시작해서 10씩 증가하는 sequence (1000 까지)
create sequence t_dept_deptno_seq
start with 40
increment by 10
maxvalue 1000;

insert into t_dept values (t_dept_deptno_seq.nextval, 'ACCOUNT', 'GJ');
insert into t_dept values (t_dept_deptno_seq.nextval, 'ACCOUNT', 'GJ');

-- 방금 next된 valu를 확인
select t_dept_deptno_seq.currval
from dual;

-- null은 어떤 값인지 모르는 값이기때문에 uniqe 설정에 성립되며 계속 들어갈 수 있음(중복되지 않는다고 간주)
insert into t_dept values (null, 'SALES', 'GJ');
insert into t_dept values (null, 'RESEARCH', 'GJ');

select *
from t_dept;
/*
==============
테이블 수정
==============
T_EMP
empno   ename       sal     hp      ... deptno
number  varchar2    number  varchar2    number
중복X    중복O       중복O    중복X        
널X      널X         널O     널O
                    0이상                정해진 값  

T_DEPT
deptno  dname
중복X    중복O
널 X     널 X
*/

drop table t_emp purge;
drop table t_dept purge;
/*
====================
컬럼 레벨의 제약조건
====================
*/
create table t_dept
(deptno number(2)   constraint t_dept_deptno_pk primary key, -- primary key는 하나만 지정할 수 있고, uniuqe not null 특징, 주 식별자
 dname  varchar2(10) constraint t_dept_dname_nn not null,
 loc    varchar2(10));
 -- insert 할때 어느부분의 제약이 위반되는지 constraint를 통해 알수 있음
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
테이블 레벨 제약조건 설정 문법
====================
*/
drop table t_emp purge;
drop table t_dept purge;

create table t_dept
(deptno number(2),
 dname  varchar2(10),
 loc    varchar2(10),
 constraint t_dept_deptno_pk primary key(deptno),
 -- not null(dname) not null은 안됨 => check로 바꿔줌
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
반드시 테이블 레벨 문법 제약 설정을 해야하는 경우
==============================================
*/
-- 두 개 이상의 컬럼으로 하나의 제약을 생성할 경우
create table t_simin
(no number primary key,
 ju1 varchar2(6),
 ju2 varchar2(7),
    unique(ju1, ju2));

/*
부록 AP create table
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




-- RPAD 함수
select empno, ename, sal, ceil(sal/100) -- ceil은 올림
from emp;

select empno, ename, sal , rpad('*', ceil(sal/100), '*') as starts
from emp;

/*
==============================
테이블 관련 대표적 메타 데이터
==============================
*/
select table_name, NUM_ROWS, BLOCKS
from user_tables;

select table_name, constraint_name, constraint_type, search_condition
from user_constraints;
/*
oracle은 pk같은 제약조건들을 검사할때 처음부터 끝까지 다 값이 중복되는지 비교하는게 아니라
내부적으로 indexing 값을 설정해두고 특정 구조를 갖춰서 연산량을 줄이는 형태로 값을 비교하게 됨?
*/
select table_name, index_name
from user_indexes
order by 1;

/*
====================================
View,Index, Sequence, Synonym

# View
# Index
    - 데이터 저장소의 데이터가 순서없이 저장되어 있어서 이를 극복하기 위해 만든 객체로서 rowid를 전문적으로 보관함
    - pseudocolumn은 인자가 없는 함수와 유사, 근데 같은 값을 리턴하는건 아님 
        - rowid
            - pseudocolumn 가운데 하나
            - 64진법
            - 6(Object) 3(file) 6(block) 3(row)
    - oracle에서 데이터를 가장 빨리 찾는 방법은 rowid를 활용하는 것

# Sequence
# Synoym
====================================
*/
select rowid, e.* from emp e;

select rowid, rownum , user, sysdate, empno from emp;
-- table과 별개의 장소에 마치 key-value 처럼 rowid와 job을 mapping
create index emp_job_idx
on emp(job);

select job, rowid -- 위와 같음
from emp
order by 1,2;
-- 아래 쿼리를 수행할 경우 오라클의 Optimzer가 인덱스 사용 여부를 판단하여
-- 인덱스를 사용할 경우 MANAGER라는 값으로 인덱스를 찾아 적절한 rowid를 획득함
-- 획득한 rowid로 테이블의 데이터를 찾아서 return 하게 됨
select *
from emp
where job = 'MANAGER';



