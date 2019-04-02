/*
====================================
Program
====================================
- 해야할 일을 미리 기술해 놓은 것
*/
/*
====================================
PL / SQL
====================================
- Pascal -> Ada -> Anonymous Block
- Block Strucutred Language -> Anoymous block (이름이 없는 블락)
                            -> Named block (이름이 있는 블락) : procedure, function
                            
- SQL 엔진 + PL/SQL 엔진
- 할당 연산자 vs 비교 연산자

                  C, Java    Basic, PowerScript   Pascal, PL/SQL
    할당 연산자   A = B      A = B                A := B
    비교 연산자   A == B     A = B                A = B
    
declare -- 옵션
    선언부
begin   -- 필수
    실행부
exception -- 옵션
    예외처리부
end;    -- 필수
/
select dname, rowid
from dept
order by 2;
*/
-----------------------------------------
--> Anonymous Block (이름이 없는 블락)
-----------------------------------------
set serveroutput on -- 화면에 보이게하는
begin
    dbms_output.put_line('Hello world!');
end;
/
-----------------------------------------
--> Named Block (이름이 없는 블락)
-----------------------------------------
create or replace procedure p2(a number)
is
begin
    for i in 1..a loop
        dbms_output.put_line(i||'번째, Hello world!');
    end loop;
end;
/
exec p2(3);

create or replace procedure p3(a number)
is
    v_sal number;
begin
    select sal into v_sal
    from emp
    where empno = a;

    dbms_output.put_line(v_sal);
end;
/
exec p3(7788)

-- 문제. 부서번호를 입력하면 평균급여를 리턴하는 프로시져를 생성
create or replace procedure emp_avg_sal(a number)
is
    mean_sal number;
begin
    select round(avg(sal)) into mean_sal
    from emp
    where deptno = a;
   
    dbms_output.put_line(mean_sal);
end;
/
show errors -- 오류확인

exec emp_avg_sal(10);
exec emp_avg_sal(30);
----------------------------------------------
--> 위으 procedure를 Function으로
----------------------------------------------
-- a로 들어오고 b로 나감
create or replace procedure emp_avg_sal(a in number, b out number)
is
begin
    select round(avg(sal),2) into b
    from emp
    where deptno = a;
end;
/

create or replace procedure emp_sal_compare(a number)
is
    v_sal emp.sal%type;
    v_deptno emp.deptno%type;
    v_avg_sal number;
begin
    select sal,deptno into v_sal, v_deptno
    from emp
    where empno = a;
    
    emp_avg_sal(v_deptno, v_avg_sal);
    if v_sal > v_avg_sal then
        dbms_output.put_line('소속 부서 평균 급여보다 금여 큼');
    elsif v_sal < v_avg_sal then
        dbms_output.put_line('소속 부서 평균 급여보다 금여 적음');
    else
        dbms_output.put_line('소속 부서 평균 급여보다 금여 같음');
    end if;
end;
/
show errors

exec emp_sal_compare(7788);

-----------------------
--> emp_avg_sal 프로시저를 함수로 변경할 경우
-----------------------
drop procedure emp_avg_sal;

create or replace function emp_avg_sal(p_deptno emp.deptno%type)
    return number
is
    b number;
begin
    select round(avg(sal), 2) into b
    from emp
    where deptno = p_deptno;
    
    return b; -- 함수는 begin과 end사이에 return문이 있어야 함
end;
/
show errors


create or replace procedure emp_sal_compare(a number)
is
    v_sal emp.sal%type;
    v_deptno emp.deptno%type;
begin
    select sal,deptno into v_sal, v_deptno
    from emp
    where empno = a;
    
    if v_sal > emp_avg_sal(v_deptno) then
        dbms_output.put_line('소속 부서 평균 급여보다 금여 큼');
    elsif v_sal < emp_avg_sal(v_deptno) then
        dbms_output.put_line('소속 부서 평균 급여보다 금여 적음');
    else
        dbms_output.put_line('소속 부서 평균 급여보다 금여 같음');
    end if;
end;
/
exec emp_sal_compare(7788);

-----------------------
--> user objects 확인
-----------------------
select * from emp;
select object_name, object_type
from user_objects
order by 2,1;

-----------------------------------------
--> DML을 PL/SQL 프로그램 Unit을 이용해서 구현
-----------------------------------------

drop table t1 purge;

create table t1
as
select empno, ename, sal, job from emp where 1 = 2;

create or replace procedure t1_insert_proc
(a number, v varchar2, c number, d varchar2)
is
begin
    if c < 1000 then
        dbms_output.put_line('입력실패~ 급여 확인');
    else
        insert into t1 values (a,b,c,d);
    end if;
end;
/
show errors


-- 문제. 급여가 높은 사원의 사번을 출력하는 함수

create or replace function emp_sal_compare2(a emp.empno%type)
return number
is
    b number;
begin
    select e.empno into b
    from emp e
    where sal > (select sal
                 from emp
                 where empno = a) and e.empno != a;
    
    return b;
end;
/
show errors


create or replace function emp_sal_compare3
(p_first_empno emp.empno%type, p_second_empno emp.empno%type)
return emp.empno%type
is
    w_sal emp.sal%type;
    e_sal emp.sal%type;    
begin
    select sal into w_sal from emp where empno = p_first_empno;
    select sal into e_sal from emp where empno = p_second_empno;
    
    if w_sal > e_sal then
        return p_first_empno;
    elsif w_sal < e_sal then
        return p_second_empno;
    else
        return p_first_empno;
    end if;    
end;
/
show errors


--create or replace function emp_sal_compare4
--(p_first_empno emp.empno%type)
--return emp.empno%type
--is 
--    return_empt emp.empno%type;
--begin
--    select decode(trunc(e.sal/w.sal), 0, w.empno, e.empno) into return_empt
--    from emp e, emp w
--    where e.empno = 7788
--    and w.empno != e.empno;
--    
--    return return_empt;
--end;
--/

select w.empno, e.empno, emp_sal_compare3(w.empno,e.empno)
from emp w, emp e
where w.empno = 7788;



--------------------------------
--> 함수없이
--------------------------------

select w.empno, e.empno, case when w.sal > e.sal then w.empno
                              when w.sal < e.sal then e.empno
                              else 0
                         end as winner
from emp w, emp e
where w.empno = 7788
and e.empno != w.empno;


select decode(trunc(e.sal/w.sal), 0, w.empno, e.empno)
    from emp e, emp w
    where e.empno = 7788
    and w.empno != e.empno;


/*
====================================
PL / SQL 변수 선언
====================================

*/
create or replace function tax(a number)
return number
is
    v_sal number := a; --변수 ( 메모리할당, 메모리에 변수명 선언, 타입지정, 쓰레기값)
    v_tax constant number := 0.013; -- 상수
begin
    return v_sal * v_tax;
end;
/

select empno, job, sal, tax(sal) as tax
from emp
where job in ('MANAGER', 'SALESMAN');

---------------------------------------
--> SELECT문 유형에 따른 변수 선언 6가지
---------------------------------------
set serveroutput on
--> [1]
create or replace procedure p1(k number)
is
v_sal emp.sal%type;
begin
    select sal into v_sal
    from emp
    where empno = k;
    
    dbms_output.put_line(k||'사원의 급여는'||v_sal||'입니다');
end;
/
exec p1(7788);
--> [2]
create or replace procedure p2 (k number)
is
    r emp%rowtype; -- pl / sql record = struct
begin
    select * into r
    from emp
    where empno = k;
    
    dbms_output.put_line(r.empno||' '||r.ename);
    dbms_output.put_line(r.sal);
end;
/
exec p2(7788)
-->[3]
create or replace procedure p3 (k number)
is
    r pack1.rt;
begin 
    select ename, job, sal into r 
    from emp
    where empno = k;
    
    dbms_output.put_line('이름은 ' || r.ename || ' 직업은 ' || r.job || ' 연봉은 ' || r.sal);
end;
/
create or replace package pack1
is 
    TYPE rt IS RECORD 
    (ename emp.ename%type, job emp.job%type, sal emp.sal%type);
end;
/
exec p3(7788);
-->[4]
create or replace procedure p4 (k number)
is
begin

end;
/
-->[5]
-->[6]
----------------------------------------
--> getter setter 처럼
----------------------------------------
drop table t1 purge;

create table t1
as
select * from emp;

create or replace procedure t1_set_ename
(a t1.empno%type, b t1.ename%type)
is
begin
    update t1
    set ename = b
    where empno = a;
end;
/
select * from t1;
exec t1_set_ename(7369, 'SNIM');
select * from t1;

create or replace function t1_get_ename
(a t1.empno%type) return t1.ename%type
is
    v_ename t1.ename%type;
begin
    select ename into v_ename
    from t1
    where empno = a;
    
    return v_ename;
end;
/
exec dbms_output.put_line(t1_get_ename(7369));

----------------------------------------
--> package로 변환
-- begin 없음, 
-- public으로 만들어주기 위해 헤더부분을 (is 앞)
----------------------------------------
create or replace package t1_pack
is
    procedure t1_set_ename
    (a t1.empno%type, b t1.ename%type);
    function t1_get_ename
    (a t1.empno%type) return t1.ename%type;
    procedure t1_set_job
    (a t1.empno%type, b t1.job%type);
    function t1_get_job
    (a t1.empno%type) return t1.job%type;
    procedure t1_insert
    (a t1.empno%type, b t1.job%type, c t1.ename%type, d t1.mgr%type,
     e t1.hiredate%type, f t1.sal%type, g t1.comm%type, h t1.deptno%type);
    procedure t1_delte_empno
    (a t1.empno%type);
end;
/
select * from t1;
create or replace package body t1_pack
is
    procedure t1_set_ename
    (a t1.empno%type, b t1.ename%type)
    is
    begin
        update t1
        set ename = b
        where empno = a;
    end;
    function t1_get_ename
    (a t1.empno%type) return t1.ename%type
    is
        v_ename t1.ename%type;
    begin
        select ename into v_ename
        from t1
        where empno = a;
        
        return v_ename;
    end;
    procedure t1_set_job
    (a t1.empno%type, b t1.job%type)
    is
    begin
        update t1
        set job = b
        where empno = a;
    end;
    function t1_get_job
    (a t1.empno%type) return t1.job%type
    is
        v_job t1.job%type;
    begin
        select job into v_job
        from t1
        where empno = a;
        
        return v_job;
    end;
    procedure t1_insert
    (a t1.empno%type, b t1.job%type, c t1.ename%type, d t1.mgr%type,
     e t1.hiredate%type, f t1.sal%type, g t1.comm%type, h t1.deptno%type)
    is
    begin
        insert into t1 values(a,b,c,d,e,f,g,h);
    end;
    procedure t1_delte_empno
    (a t1.empno%type)
    is
    begin
        delete from t1
        where empno = a;
    end;
end;
/
exec t1_pack.t1_set_ename(7369, 'PRINCE')
select * from t1;
desc t1_pack
exec dbms_output.put_line(t1_pack.t1_get_ename(7369))
select * from t1;
exec t1_pack.t1_set_job(7369, 'DEV')
select * from t1;
exec dbms_output.put_line(t1_pack.t1_get_job(7369));
select * from t1;
exec t1_pack.t1_insert(8000, 'AAG', 'DEV', 7839,to_date('26-07-2019', 'dd/mm/yyyy') , 3005, null, 30);
select * from t1;
exec T1_PACK.T1_DELTE_EMPNO(7369);
select * from t1;
describe t1;
----------------------------------------
--> %rowtype 활용 예제
----------------------------------------
create or replace procedure p0
( a in jobs.job_id%type, b out jobs%rowtype)
is
begin
    select * into b
    from jobs
    where job_id = upper(a);
end;
/

create or replace function f0(j in jobs.job_id%type) 
return jobs.job_title%type
is 
    r jobs%rowtype;
begin
    p0(j,r);
    
    return r.job_title;
end;
/

select * from jobs;

exec dbms_output.put_line(f0('ad_pres'));
exec dbms_output.put_line(f0('st_man'));