/*
=========================
SQL PLUS
=========================

SQL*PLUS ��ɾ�
- ȯ�漳�� : show, set
- ������� : column, ttitle, btitle, break, ...
- ������� : input, append, delete, ...
- ��ũ��Ʈ ���ϰ��� : save, get, start, ...
- ġȯ���� : &, &&, define, ...
- ���ε� ���� : var, ...
- ��Ÿ : run, clear, host, describe, connect, ...

# ȯ�漳��
show all
set timing on / off
set sqlprompt "ism> "
show colsep
set colsep "|"
list �Ǵ� l : ��� Ȯ��
run �Ǵ� r : ����� ����� �����ְ� ����
/ : �� �Ⱥ����ְ� �ٷ� ����
set linesize 200 : �¿� ��
set pagesize 40 : ���Ʒ� ��

# �������
? column      
help column

col last_name for a15 - �÷� format�� ���� 15�ڸ�
col salary for 999,999.99 

break on department_id - ������ ���� ���� ���� �ݺ��Ǿ ������ ������
break on department_id skip 1 - ���� ���ڳ��� ����ְ� ���̰� ����

tti 'Salary|Report' : Slary �ٱ��� Report�� ������ ��ܿ������ page��ȣ�� ����
bti 'Confidential' : ������
tti off
bti off
clear break

col

# ��� ����
l ���ؼ� ��� ����
���� �Է� ���� �� �ش� ��� ���� ����
append ,ename, sal : ,ename, sal �߰�
append �Ǵ� a

input ��� ���� ���� �Ʒ��� ��� �߰��� �Է�
where deptno = 30

�� 2 3 �� ���� 2~3 ����� Ȯ���� �� ����

# ��ũ��Ʈ ���ϰ���
save �����̸� : ���� -> ���� ,, ���� �̸��� ������ ������� replace�ɼ� �߰�
get �����̸� : ���� -> ����
start �����̸� : ���� -> ���� -> ����
@ �����̸� : ���� -> ���� -> ����
edit �����̸� : ���� ���� or ���� ����
edit : ���� ����
spool �����̸� .... spool off : ȭ�� ĸ��
host ��� : sql�� ���������� �ʰ� �ü���� ��� ���

# ���ε� ���� : var, ...
client �� ����
PL/SQL ���忡���� �ܺκ�����
�װ� ǥ���ϴ� ��ġǥ���ڰ� ':'��

var b_sal number
begin
    select sal into :b_sal
    from emp
    where empno = 7788;
end;
/
�����
print b_sal

select empno, ename, sal
from emp
where sal < :b_sal; �� ���� ���

select empno, ename, sal
from emp
where sal < &sv_sal;  -> sv_sal�� �Է¹޾Ƽ� ������
- old new�� ��� ���� �����ֱ� ���ؼ��� 
set verify off

# ���� 1
variable b_annual_salary number
declare
    v_empno emp.empno%type := &sv_empno;
begin
    select sal*12 + nvl(comm, 0) into :b_annual_salary
    from emp
    where empno = v_empno;
end;
/
print b_annual_salary



ġȯ������ user process���� ����
server�� ����Ǹ� serverprocess�� ���������
session�� �������� ������ ���ε庯���� serverprocess�� �޸𸮿� ����Ǿ�����
user process���� ���� ����
PL/SQL ������ ���� �޸𸮿� ����

���ε庯���� ȣ��Ʈ������� ��
SQL PLUS����s VARIABLE Ű���带 ����� ����

# ���� 2

ed sal_rep.sql

accept sv_deptno prompt '�μ� ��ȣ�� �Է��� �ּ��� : '

set linesize 60
set pagesize 40
set feedback off
set verify off

tti 'Salary|Report'
bti 'Confidential'
break on deptno skip 1

spool sal_rep.txt

select deptno, empno, ename, job, sal
from emp
where deptno in (&sv_deptno)
order by deptno, empno;

spool off
tti off
bti off
clear break
set linesize 400
set pagesize 100
set feedback on

@ sal_rep.sql

==================
SQL data type
==================
- ���� -> col1 char(10
      -> col1 varchar2(10)
      
- ���� -> col1 number(4)
      -> col1 number(10, 2) : ���� �Ҽ���
      -> col1 number : �ε� �Ҽ���
- ��¥ -> data
      -> timestamp
      -> interval
- ��Ÿ - LOB -> CLOB
            -> BLOB
            -> BFile
==================================
PL/SQL Statment in Blocks
==================================

*/

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
