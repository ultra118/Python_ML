/*
HR ������ ������
�μ��� ���� ����� Americas�� ����
*/

/*SQL Syntax*/
select r.region_id, r.region_name, count(e.employee_id)
from employees e JOIN departments d ON (nvl(e.department_id, 10) = d.department_id)
                 JOIN locations l ON (d.location_id = l.location_id)
                 JOIN countries c ON (l.country_id = c.country_id)
                 RIGHT JOIN regions r ON (c.region_id = r.region_id)
group by r.region_id, r.region_name
order by r.region_id;


/*Oracle Syntax*/
select count(*)
from employees e,
     departments d,
     locations l,
     countries c,
     regions r;

-- count(*)�� �ϸ� null�� 1�� ī��Ʈ
select r.region_id, r.region_name, count(e.employee_id)
from employees e,
     departments d,
     locations l,
     countries c,
     regions r
where nvl(e.department_id(+), 10) = d.department_id and
     d.location_id(+) = l.location_id and
     l.country_id(+) = c.country_id and
     c.region_id(+) = r.region_id
group by r.region_id, r.region_name;
/*
inner join�����δ� �ذ��� �� ����
c ~ r join�κп��� ���ε����ʴ� c.region id ������ ��µ��� ����
*/
-- select r.region_id, r.region_name, count(e.employee_id)
select r.region_id, r.region_name, count(e.employee_id)
from (select e.employee_id, c.region_id
from employees e,
     departments d,
     locations l,
     countries c
where nvl(e.department_id, 10) = d.department_id and
     d.location_id(+) = l.location_id and
     l.country_id(+) = c.country_id ) e, regions r
where e.region_id(+) = r.region_id
group by r.region_id, r.region_name
order by r.region_id;



