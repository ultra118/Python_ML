/*
==================
2장. SQL DDL
==================
*/
-- 2.1
create table orders(
    order_id number(12,0),
    order_date date,
    order_mode varchar2(8 byte),
    customer_id number(6,0),
    order_status number(2,0) default 0,
    order_total number(8,2),
    sales_rep_id number(6,0),
    promotion_id number(6,0),
    constraint pk_order primary key (order_id),
    constraint ck_order_mode check (order_mode in ('direct', 'online'))
);
select * from orders;
-- 2.2
create table order_items(
    order_id number(12,0),
    line_item_id number(3,0),
    product_id number(3,0),
    unit_price number(8,2) default 0,
    quantity number(8,0) default 0,
    constraint pk_order_line primary key (order_id, line_item_id)
);
select * from order_items;
-- 2.3
create table promotions(
    promo_id number(6,0),
    promo_name varchar2(20),
    constraint pk_promo primary key (promo_id)
);
select * from promotions;
-- 2.5
create sequence orders_seq
MINVALUE 1
MAXVALUE 999999
increment by 1
start with 1000;
/*
===========
3장. SQL문장
===========
*/
-- 3.1
describe employees;
create table ex3_6(
    employee_id number(6),
    emp_name varchar2(80),
    salary number(8,2),
    manager_id number(6)
);

insert into ex3_6
select employee_id, emp_name, salary, manager_id
from employees
where manager_id = 124 and
(salary > 2000 and salary < 3000);

select * from ex3_6;

-- 3.2
delete ex3_3;

CREATE TABLE ex3_3 (
       employee_id NUMBER, 
       bonus_amt   NUMBER DEFAULT 0);

insert into ex3_3 (employee_id)
select e.employee_id
from employees e, sales s
where e.employee_id = s.employee_id
and s.sales_month between '200010' and '200012'
group by e.employee_id;

select * from ex3_3;
select * from sales;

merge into ex3_3 d
using (select employee_id, salary, manager_id
       from employees
       where manager_id = 145) b
on (d.employee_id = b.employee_id)
when matched then
update set d.bonus_amt = d.bonus_amt + b.salary * 0.01
when not matched then
insert (d.employee_id, d.bonus_amt) values (b.employee_id, b.salary * 0.005);

select *
from ex3_3;

-- 3.3
select * from employees;
select employee_id, emp_name
from employees
where commission_pct is null
order by employee_id;

-- 3.4
select employee_id, salary
from employees
where salary >= 2000 and salary <= 2500
order by employee_id;

-- 3.5
select employee_id, salary
from employees
where salary = any(2000, 3000, 4000)
order by employee_id;

select employee_id, salary 
from employees
where salary != all(2000, 3000, 4000)
order by employee_id;

-- 4.1
select phone_number from employees;
select employee_id, lpad(substr(phone_number, 5), 12, '(02)') from employees;

-- 4.2
select employee_id, emp_name, hire_date, round((sysdate - hire_date)/365)
from employees
where round((sysdate - hire_date) / 365) >= 10
order by 3;

-- 4.3
select cust_name, cust_main_phone_number,
replace (cust_main_phone_number, '-', '/') cust_new_pnumber
from customers;

-- 4.4
select cust_name, cust_main_phone_number,
translate(cust_main_phone_number, '0123456789', 'acielsifke') cust_new_pnumber
from customers;

select cust_name, cust_year_of_birth,
decode(trunc((to_char(sysdate, 'YYYY') - cust_year_of_birth)/10), 3, '30대',
                                                                  4, '40대',
                                                                  5, '50대',
                                                                  '기타') age
from customers;

-- 4.5
select cust_name, cust_year_of_birth,
case when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 0 and 19 then '10대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 20 and 29 then '20대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 30 and 39 then '30대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 40 and 49 then '40대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 50 and 59 then '50대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 60 and 69 then '60대'
     when trunc((to_char(sysdate, 'YYYY')- cust_year_of_birth)/10) between 70 and 79 then '70대'
    else '기타' end as new_age
from customers;



