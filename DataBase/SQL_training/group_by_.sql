/*
=========================
5�� �׷� ������ ���� ������
=========================
* �����͸� �����ؼ� ���� �� �ְ� �����Լ��� group by ���� ����

*/

-------------------------
--> 01. �⺻ ���� �Լ�
-- count, sum, min, max, avg, variance, stddev
-------------------------
select count(*)
from employees;

-- �ߺ� ���� distinct
select count(distinct department_id)
from employees;

select sum(salary)
from employees;

select sum(distinct salary)
from employees;

select round(avg(salary), 2), round(avg(distinct salary), 2)
from employees;

select min(salary), max(salary)
from employees;

-- �л�
select round(variance(salary), 2), round(stddev(salary), 2)
from employees;
-- ǥ������

-------------------------
--> 02. group by���� having ��
-- group by
-- �����͸� ��� ����
-------------------------
select department_id, sum(salary)
from employees
group by department_id;

select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, region;

-- group query�� ����ϸ� select ����Ʈ�� �ִ� �÷����̳� ǥ���� �� ���� �Լ��� �����ϰ��
-- ��� group by ���� ��õǾ�� ��

-- having���� groupy by�� ������ ��ġ�� group by�� ����� ������� �ٽ� ����
-- where vs having
--> where ���� ���� ��ü�� ���� ���� ����
--> having ���� where ������ ó���� ����� ���� group by�� ���� �� ���� �� ����� �ٽ� ����
select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period = '201311'
group by period, region
having sum(loan_jan_amt) > 100000
order by region;

------------------------
-- 03. rollup���� cube ��
------------------------
-- rollup�� ����� ǥ������ �������� ������ ���, �� �߰����� ���� ������ ������
-- rollup�� ����� �� �ִ� ǥ���Ŀ��� grouping ���
-- ��, select ����Ʈ���� ���� �Լ��� ������ �÷� ���� ǥ������ �� �� ����
-- ǥ���� n���� n+1 ���� ����, �����ʿ��� ���ʼ����� �������� ������ ����� ��ȯ��

select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by period, gubun
order by period;

select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by rollup(period, gubun);
-- group by(gubun, period), group by(period), group by()

-- ���� roll up
select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by period, rollup(gubun);
-- group by (period, gubun), group by (period)

-- cube 
-- rollup�� ����ϳ� ������ �ٸ� rollup�� ������ ������ ����
-- cube�� ����� ǥ���� ������ ���� ������ ��� ���պ��� ������ ��ȯ
-- cube�� ������ ���� ��ŭ �������� ����
select period, gubun, sum(loan_jan_amt) totla_jan
from kor_loan_status
where period like '2013%'
group by cube(period, gubun);
--group by (period, gubun), group by (period), group by (gubun), group by ()

------------------
--> 04. ���� ������
-- union, union all, intersect, minus
------------------
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));
       
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');

select goods
from exp_goods_asia
where country = '�ѱ�'
order by seq;
-- union
select goods
from exp_goods_asia
where country = '�ѱ�'
union
select goods
from exp_goods_asia
where country = '�Ϻ�';
-- union all�� �ߺ��� ��� ����
-- intersect�� ������
-- minus�� �� ����

-- ���� �������� ���� ����
-- 1. ����Ǵ� �� select���� select ����Ʈ ������ ������ Ÿ���� ��ġ�ؾ���
-- 2. order by���� �� ������ ���忡���� ����� �� ����
-- 3. blob, clob, bfile Ÿ���� �÷��� ���ؼ��� ���X
-- 4. union, intersect, minus�����ڴ� long�� �÷����� ����� �� ����

-- grouping set��
-- rollup�̳� cubeó�� group by���� ����ؼ� �׷� ������ ���Ǵ� ��
select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by grouping sets(period, gubun);
-- group by period union all group by gubun

/*
5�� ��������
*/
-- 5.1
select to_char(hire_date, 'yyyy') as hire_year, count(hire_date)
from employees
group by to_char(hire_date, 'yyyy')
order by 1;

-- 5.2
select period,region, sum(loan_jan_amt)
from kor_loan_status
where period like '2012%'
group by period,region;

-- 5.3 
select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, rollup(gubun);

select period, gubun, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period, gubun
union all
select period, null, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2013%'
group by period
order by period;

-- 5.4
select period, case when gubun = '���ô㺸����' then sum(loan_jan_amt)
                    else 0
                    end ���ô㺸�����,
               case when gubun = '��Ÿ����' then sum(loan_jan_amt)
                    else 0
                    end ��Ÿ�����
from kor_loan_status
where period = '201311'
group by period, gubun;

select period, 0 as ���ô㺸�����, sum(loan_jan_amt) as ��Ÿ�����
from kor_loan_status
where period = '201311'
and gubun = '��Ÿ����'
group by period, gubun
union all
select period, sum(loan_jan_amt) as ���ô㺸�����, 0 as ��Ÿ�����
from kor_loan_status
where period = '201311'
and gubun = '���ô㺸����'
group by period, gubun;

-- 5.5
select region, 
       sum(amt1) as "201111",
       sum(amt2) as "201112",
       sum(amt3) as "201210",
       sum(amt4) as "201211",
       sum(amt5) as "201212",
       sum(amt6) as "201310",
       sum(amt7) as "201311"
from (select region, case when period = '201111' then loan_jan_amt else 0 end amt1,
                     case when period = '201112' then loan_jan_amt else 0 end amt2,
                     case when period = '201210' then loan_jan_amt else 0 end amt3,
                     case when period = '201211' then loan_jan_amt else 0 end amt4,
                     case when period = '201212' then loan_jan_amt else 0 end amt5,
                     case when period = '201310' then loan_jan_amt else 0 end amt6,
                     case when period = '201311' then loan_jan_amt else 0 end amt7
      from kor_loan_status
)
group by region;


/*
=============================================
6�� ���̺� ���̸� ������ �ִ� ���ΰ� �������� �˾� ����
=============================================
*/
-------------------
--> 01. ������ ����
-- ���� �����ڿ� ���� ���� : ���� ����, ��Ƽ ����
-- ���� ��� ���� ���� : ���� ����
-- ���� ���ǿ� ���� ���� : ���� ����, �ܺ� ����, ���� ����, īŸ�þ� ����
-- ��Ÿ : ANSI ����
-------------------

-------------------------
--> 02. ���� ���ΰ� �ܺ� ����
-------------------------
-- ���� ����
-- where ������ ��ȣ �����ڸ� ����� 2�� �̻��� ���̺��̳� �並 �����ϴ� ����
-- where ���ǿ� �����ϴ� ������ ����, where ������ ����� ������ ���������̶���
-- ���������� �÷� ������ ���, �� �÷��� ���� ���� ���� ����
select a.employee_id, a.emp_name, a.department_id, b.department_name
from employees a, departments b
where a.department_id = b.department_id;
-- ���� ����
-- ���������� ����� ���������� �����ϴ� �����͸� ������������ ����
-- IN�� exist �����ڸ� ���
select department_id, department_name
from departments a
where exists(select * 
             from employees b 
             where a.department_id = b.department_id and b.salary > 3000)
order by a.department_name;

select department_id, department_name
from departments a
where a.departemnt

select