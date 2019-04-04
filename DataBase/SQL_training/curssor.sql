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

-- .����

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
�������� dml�� update�ϰ� �Ǹ� �����ϴ� ���� lock�� �ɸ� �� �� ����
�׷����� ������ �ʵ��� �ϱ����� for update�� �ٿ���
=> �켱 open�Ҷ� �۾���� ���θ� ã�Ƽ� lock�� �ɾ����
��ȯ���� ���鼭 ������Ʈ�� �� 
�׷��� ������ �������� dml�� �����Ϸ��ϸ� ����
*/
create or replace procedure p1(w varchar2)
is
    cursor c1
    is
    select e.empno, e.ename, e.sal, e.deptno
    from t1 e, t2 d
    where e.deptno = d.deptno
    and d.loc = w
    for update of e.sal wait 5; -- lock�� �Ȱɸ��� ��
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