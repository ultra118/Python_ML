 
 
 create or replace package p
  is
    procedure p(a number);
    procedure p(a date);
    procedure p(a varchar2);
  end;
  /

  create or replace package body p
  is
    procedure p(a number)
    is
    begin
      dbms_output.put_line(a);
    end;

    procedure p(a date)
    is
    begin
      dbms_output.put_line(a);
    end;

    procedure p(a varchar2)
    is
    begin
      dbms_output.put_line(a);
    end;
  end;
  /  
set serveroutput on
exec p.p(100)
/*
===================================
명시적 커서
===================================
select문을 사용하여 테이블에서 레코드를 가져올때, 
한 row씩 엑세스
- 암시적 커서 : 모든 DML 및 PL/SQL SELECT문에 대해 PL/SQL에서 선언하고 관리
- 명시적 커서 : 프로그래머가 선언하고 관리
    - Query에서 반환된 첫번째 행 이후에 행 단위 처리를 수행할 수 있음
    - 현재 처리 중인 행을 추적
    - 프로그래머가 PL/SQL 블록에서 명시적 커서를 수동으로 제어할 수 있음
    - 제어 : 커서를 열고, 행을 패치하고, 커서를 닫음
        - DECLARE : 명명된 SQL영역 생성
        - OPEN : 결과행 집합 식별
        - FETCH : 현재 행을 변수에 로드
        - EMPTY : 기존 행에 대해 테스트, 행이 있으면 FETCH로 돌아감
        - CLOSE : 결과 행 집합 해제
*/
create or replace procedure p1(w number)
is
    cursor c1   -- cursor 명시
    is 
    select empno, ename, sal, deptno
    from emp
    where deptno = w
    order by sal desc;
    -- 해당 테이블이나 뷰의 컬럼속성을 그대로 들고옴
    r c1%rowtype;
begin
    open c1;    -- curosr를 open
    
    loop
        fetch c1 into r;
        exit when c1%notfound or c1%rowcount > 3; -- 최근 패치가 행을 반환하지 않으면 True or 지금까지 반환된 총 행수 >3
        p.p(r.empno||' '||r.ename);
    end loop;
    
    close c1;
end;
/
show errors
exec p1(10)
--     ↓↓
create or replace procedure p1(w number)
is
    cursor c1
    is
    select empno, ename, sal, deptno
    from emp
    where deptno = w
    order by sal desc;
begin
    for r in c1 loop
        p.p(r.empno||' '||r.ename);
    end loop;
end;
/
exec p1(10)
-- ↓↓
create or replace procedure p1(w number)
is
begin
    for r in (select empno, ename, sal, deptno
              from emp
              where deptno = w
              order by sal desc) loop
        p.p(r.empno||' '||r.ename);
    end loop;
end;
/

exec p1(10)

/*
# 문제.다음과 같은 결과를 만드세요

  ------------------------
  10 ACCOUNTING NEW YORK
  ------------------------
  7782 CLARK 2450
  7839 KING 5000
  7934 MILLER 1300
  ------------------------
  20 RESEARCH DALLAS
  ------------------------
  7369 SMITH 800
  7566 JONES 2975
  7788 SCOTT 3000
  7876 ADAMS 1100
  7902 FORD 3000
  ------------------------
  30 SALES CHICAGO
  ------------------------
  7499 ALLEN 1600
  7521 WARD 1250
  7654 MARTIN 1250
  7698 BLAKE 2850
  7844 TURNER 1500
  7900 JAMES 950
  ------------------------
  40 OPERATIONS BOSTON
  ------------------------
  ------------------------
*/

create or replace procedure p1
is
begin
    p.p('---------------------------------');
    for d in (select * from dept) loop
        p.p(d.deptno||' '||d.dname||' '||d.loc);
        p.p('---------------------------------');
        for e in (select empno, ename, sal
                  from emp
                  where deptno = d.deptno) loop
                  p.p(e.empno||' '||e.ename||' '||e.sal);
        end loop;
        p.p('---------------------------------');
    end loop;
end;
/
show errors
exec p1()

--

/*
누군가가 dml로 update하게 되면 실행하다 말고 lock이 걸릴 수 도 있음
그런일이 생기지 않도록 하기위해 for update를 붙여줌
=> 우선 open할때 작업대상 전부를 찾아서 lock을 걸어놓고
순환문을 돌면서 업데이트를 함 
그렇기 때문에 누군가가 dml로 수정하려하면 막힘
*/
/*
1. index거쳐서 테이블로 가는거
2. rowid를 지정해주고 index안 거치는거
3. current of cursor로 rowid로 접근하는 것과 같은 퍼포먼스
중간에 index 거치지않고 rowid로 바로 데이터에 접근
*/
drop table t1 purge;
drop table t2 purge;

create table t1 as select * from emp;
create table t2 as select * from dept;

-- <1>
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5; -- 미리 lock해줌으로써 다른 사용자들이 접근 못하게 함
    
    r c1%rowtype;
begin 
    open c1;
    
    loop
        fetch c1 into r;
        exit when c1%notfound;
        update t1
        set sal = r.sal*1.1
        where empno = r.empno;
    end loop;
    
    close c1;
end;
/
select * from t1;
exec p1('DALLAS')
select sal from t1;
-- ↓↓ 간단하게
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5;
begin
    for r in c1 loop
        update t1
        set sal = r.sal * 1.1
        where empno = r.empno;
    end loop;
end;
/
select * from t1;
exec p1('DALLAS')
select sal from t1;
-- <2>
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.rowid as rid, e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5;
begin
    for r in c1 loop
        update t1
        set sal = r.sal * 1.1
        where rowid = r.rid;
    end loop;
end;
/
-- <3>
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5;
begin
    for r in c1 loop
        update t1
        set sal = r.sal * 1.1
        where current of c1;
    end loop;
end;
/
    

/*
=====================
예외 처리
=====================
# Error 
- Syntax error
- Logic error
- Runtime error -> Oracle-defined Exception -> Predefined exception   -- 해결 -> [1] when 이름 then 
                                            -> Non-predefined exception  -- 해결 -> [2] 선언-> 이름부여 -> 자동 발생 -> 처리 
                                                                                    혹은 [3] when others then
                -> User_defined Exception -- 해결 --> [4] 선언 ->  raise -> 처리 로 해결 
                                                      혹은 [5] raise_applicaiton_error 프로시져 
*/
drop table t1 purge;
create table t1 (no number);
----------------------------------------------
--> [1] when 이름 then
-- 예외처리를 제대로 하지않으면 에러발생 이전의 작업들도 다 날라가게됨
----------------------------------------------
create or replace procedure p1(a number, b number)
is 
begin
    insert into t1 values (1000);
    p.p(a/b);
exception
    when zero_divide then 
        p.p('0으로 나눌 수 없음');
    when others then
        p.p('에러 발생');
end;
/
show errors;
exec p1(3,0)
select * from t1; --> exception 발생 이전의 입력 데이터가 그대로 살아있음

rollback;
----------------------------------------------
--> [2] 선언 -> 이름 부여 -> 자동 발생 -> 처리
----------------------------------------------
drop table t1 purge;
create table t1 (no number not null);

create or replace procedure p1(a number)
is
    e_null exception;
    -- pragma로 시작하면 그 뒤는 컴파일러 지시자
    pragma exception_init(e_null, -1400); -- 1400 지시자는 e_null임
begin
    insert into t1 values(a);
exception 
    when e_null then
        p.p(' NUll값을 집어넣을 수 없음');
end;
/
--   ↓↓ package화 해놓고 쓸 수 있음
create or replace package exception_pack
is
    e_null exception;
    pragma exception_init(e_null, -1400);
end;
/

create or replace procedure p1(a number)
is
begin
    insert into t1 values(a);
exception
    when exception_pack.e_null then
        p.p('null값 입력할 수 없습니다!');
end;
/

exec p1(null)

----------------------------------
--> [3] when others then
----------------------------------
create or replace procedure p1(a number)
is
begin
    p.p('다른 문장이 많음');
    insert into t1 values(a);
exception
    when others then
        p.p(sqlcode);
        p.p(sqlerrm);
end;
/
exec p1(null)
----------------------------------
--> [4] raise로 수동 발생 -> 처리
----------------------------------
drop table t1 purge;
create table t1 (no number);

create or replace procedure p1(e number)
is
    v_sal emp.sal%type;
    e_low exception;
begin
    p.p('중요한 작업들');
    
    select sal into v_sal
    from emp
    where empno = e;
    
    if v_sal < 3000 then
        raise e_low;
    end if;
    
    p.p(v_sal);
exception
    when e_low then
        p.p('급여가 너무 작음');
end;
/

exec p1(7900)
show errors