 
 
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
����� Ŀ��
===================================
select���� ����Ͽ� ���̺��� ���ڵ带 �����ö�, 
�� row�� ������
- �Ͻ��� Ŀ�� : ��� DML �� PL/SQL SELECT���� ���� PL/SQL���� �����ϰ� ����
- ����� Ŀ�� : ���α׷��Ӱ� �����ϰ� ����
    - Query���� ��ȯ�� ù��° �� ���Ŀ� �� ���� ó���� ������ �� ����
    - ���� ó�� ���� ���� ����
    - ���α׷��Ӱ� PL/SQL ��Ͽ��� ����� Ŀ���� �������� ������ �� ����
    - ���� : Ŀ���� ����, ���� ��ġ�ϰ�, Ŀ���� ����
        - DECLARE : ���� SQL���� ����
        - OPEN : ����� ���� �ĺ�
        - FETCH : ���� ���� ������ �ε�
        - EMPTY : ���� �࿡ ���� �׽�Ʈ, ���� ������ FETCH�� ���ư�
        - CLOSE : ��� �� ���� ����
*/
create or replace procedure p1(w number)
is
    cursor c1   -- cursor ���
    is 
    select empno, ename, sal, deptno
    from emp
    where deptno = w
    order by sal desc;
    -- �ش� ���̺��̳� ���� �÷��Ӽ��� �״�� ����
    r c1%rowtype;
begin
    open c1;    -- curosr�� open
    
    loop
        fetch c1 into r;
        exit when c1%notfound or c1%rowcount > 3; -- �ֱ� ��ġ�� ���� ��ȯ���� ������ True or ���ݱ��� ��ȯ�� �� ��� >3
        p.p(r.empno||' '||r.ename);
    end loop;
    
    close c1;
end;
/
show errors
exec p1(10)
--     ���
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
-- ���
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
# ����.������ ���� ����� ���弼��

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
�������� dml�� update�ϰ� �Ǹ� �����ϴ� ���� lock�� �ɸ� �� �� ����
�׷����� ������ �ʵ��� �ϱ����� for update�� �ٿ���
=> �켱 open�Ҷ� �۾���� ���θ� ã�Ƽ� lock�� �ɾ����
��ȯ���� ���鼭 ������Ʈ�� �� 
�׷��� ������ �������� dml�� �����Ϸ��ϸ� ����
*/
/*
1. index���ļ� ���̺�� ���°�
2. rowid�� �������ְ� index�� ��ġ�°�
3. current of cursor�� rowid�� �����ϴ� �Ͱ� ���� �����ս�
�߰��� index ��ġ���ʰ� rowid�� �ٷ� �����Ϳ� ����
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
    for update of e.sal wait 5; -- �̸� lock�������ν� �ٸ� ����ڵ��� ���� ���ϰ� ��
    
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
-- ��� �����ϰ�
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
���� ó��
=====================
# Error 
- Syntax error
- Logic error
- Runtime error -> Oracle-defined Exception -> Predefined exception   -- �ذ� -> [1] when �̸� then 
                                            -> Non-predefined exception  -- �ذ� -> [2] ����-> �̸��ο� -> �ڵ� �߻� -> ó�� 
                                                                                    Ȥ�� [3] when others then
                -> User_defined Exception -- �ذ� --> [4] ���� ->  raise -> ó�� �� �ذ� 
                                                      Ȥ�� [5] raise_applicaiton_error ���ν��� 
*/
drop table t1 purge;
create table t1 (no number);
----------------------------------------------
--> [1] when �̸� then
-- ����ó���� ����� ���������� �����߻� ������ �۾��鵵 �� ���󰡰Ե�
----------------------------------------------
create or replace procedure p1(a number, b number)
is 
begin
    insert into t1 values (1000);
    p.p(a/b);
exception
    when zero_divide then 
        p.p('0���� ���� �� ����');
    when others then
        p.p('���� �߻�');
end;
/
show errors;
exec p1(3,0)
select * from t1; --> exception �߻� ������ �Է� �����Ͱ� �״�� �������

rollback;
----------------------------------------------
--> [2] ���� -> �̸� �ο� -> �ڵ� �߻� -> ó��
----------------------------------------------
drop table t1 purge;
create table t1 (no number not null);

create or replace procedure p1(a number)
is
    e_null exception;
    -- pragma�� �����ϸ� �� �ڴ� �����Ϸ� ������
    pragma exception_init(e_null, -1400); -- 1400 �����ڴ� e_null��
begin
    insert into t1 values(a);
exception 
    when e_null then
        p.p(' NUll���� ������� �� ����');
end;
/
--   ��� packageȭ �س��� �� �� ����
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
        p.p('null�� �Է��� �� �����ϴ�!');
end;
/

exec p1(null)

----------------------------------
--> [3] when others then
----------------------------------
create or replace procedure p1(a number)
is
begin
    p.p('�ٸ� ������ ����');
    insert into t1 values(a);
exception
    when others then
        p.p(sqlcode);
        p.p(sqlerrm);
end;
/
exec p1(null)
----------------------------------
--> [4] raise�� ���� �߻� -> ó��
----------------------------------
drop table t1 purge;
create table t1 (no number);

create or replace procedure p1(e number)
is
    v_sal emp.sal%type;
    e_low exception;
begin
    p.p('�߿��� �۾���');
    
    select sal into v_sal
    from emp
    where empno = e;
    
    if v_sal < 3000 then
        raise e_low;
    end if;
    
    p.p(v_sal);
exception
    when e_low then
        p.p('�޿��� �ʹ� ����');
end;
/

exec p1(7900)
show errors