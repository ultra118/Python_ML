/*
=========================
SQL PLUS
=========================

SQL*PLUS 명령어
- 환경설정 : show, set
- 결과포맷 : column, ttitle, btitle, break, ...
- 명령편집 : input, append, delete, ...
- 스크립트 파일관리 : save, get, start, ...
- 치환변수 : &, &&, define, ...
- 바인드 변수 : var, ...
- 기타 : run, clear, host, describe, connect, ...

# 환경설정
show all
set timing on / off
set sqlprompt "ism> "
show colsep
set colsep "|"
list 또는 l : 명령 확인
run 또는 r : 저장된 명령을 보여주고 실행
/ : 는 안보여주고 바로 실행
set linesize 200 : 좌우 폭
set pagesize 40 : 위아래 폭

# 결과포맷
? column      
help column

col last_name for a15 - 컬럼 format을 문자 15자리
col salary for 999,999.99 

break on department_id - 정렬해 놓고 같은 값이 반복되어서 나오면 지워줌
break on department_id skip 1 - 같은 숫자끼리 모아주고 사이간 여백

tti 'Salary|Report' : Slary 줄구분 Report의 제목이 상단에생기고 page번호도 생김
bti 'Confidential' : 꼬리말
tti off
bti off
clear break

col

# 명령 편집
l 통해서 명령 띄우고
숫자 입력 으로 그 해당 명령 수장 가능
append ,ename, sal : ,ename, sal 추가
append 또는 a

input 명령 통해 제일 아래에 명령 추가로 입력
where deptno = 30

ㅣ 2 3 을 통해 2~3 명령을 확인할 수 있음

# 스크립트 파일관리
save 파일이름 : 버퍼 -> 파일 ,, 같은 이름의 파일을 덮어쓰려면 replace옵션 추가
get 파일이름 : 파일 -> 버퍼
start 파일이름 : 파일 -> 버퍼 -> 실행
@ 파일이름 : 파일 -> 버퍼 -> 실행
edit 파일이름 : 파일 생성 or 파일 편집
edit : 버퍼 편집
spool 파일이름 .... spool off : 화면 캡쳐
host 명령 : sql을 빠져나가지 않고 운영체제의 명령 사용

# 바인드 변수 : var, ...
client 쪽 변수
PL/SQL 입장에서는 외부변수임
그걸 표현하는 위치표시자가 ':'임

var b_sal number
begin
    select sal into :b_sal
    from emp
    where empno = 7788;
end;
/
출력은
print b_sal

select empno, ename, sal
from emp
where sal < :b_sal; 와 같이 사용

select empno, ename, sal
from emp
where sal < &sv_sal;  -> sv_sal을 입력받아서 쿼리됨
- old new가 띄는 것으 ㄹ없애기 위해서는 
set verify off

# 예제 1
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



치환변수는 user process에서 존재
server와 연결되면 serverprocess가 만들어지고
session이 끊어지기 전까지 바인드변수는 serverprocess의 메모리에 적재되어있음
user process에서 참조 가능
PL/SQL 변수는 서버 메모리에 적재

바인드변수는 호스트변수라고도 함
SQL PLUS에선s VARIABLE 키워드를 사용해 생성

# 예제 2

ed sal_rep.sql

accept sv_deptno prompt '부서 번호를 입력해 주세요 : '

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
- 문자 -> col1 char(10
      -> col1 varchar2(10)
      
- 숫자 -> col1 number(4)
      -> col1 number(10, 2) : 고정 소수점
      -> col1 number : 부동 소수점
- 날짜 -> data
      -> timestamp
      -> interval
- 기타 - LOB -> CLOB
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
