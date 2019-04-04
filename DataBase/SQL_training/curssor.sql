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
*/
create or replace procedure p1(w number)
is
    cursor c1
    is
    select empno, ename, sal, deptno
    from emp
    where deptno = w
    order by sal desc;
    
    r c1%rowtype;
begin
    open c1;
    
    loop
        fetch c1 into r;
        exit when c1%notfound or c1%rowcount > 3;
        p.p(r.empno||' '||r.ename);
    end loop;
    
    close c1;
end;
/
exec p1(10)

-- .문제

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
drop table t1 purge;
drop table t2 purge;

create table t1 as select * from emp;
create table t2 as select * from dept;


/*
누군가가 dml로 update하게 되면 실행하다 말고 lock이 걸릴 수 도 있음
그런일이 생기지 않도록 하기위해 for update를 붙여줌
=> 우선 open할때 작업대상 전부를 찾아서 lock을 걸어놓고
순환문을 돌면서 업데이트를 함 
그렇기 때문에 누군가가 dml로 수정하려하면 막힘
*/
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5; -- lock이 안걸리게 함
    r c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into r;
        update t1
        set sal = r.sal * 1.1
        where empno = r.empno;
    end loop;
    
end;
/

select * from t2;
exec p1('DALLAS')