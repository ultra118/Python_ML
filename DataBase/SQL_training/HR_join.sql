/*
HR 국가별 직원수
부서가 없는 사원은 Americas로 포함
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

-- count(*)로 하면 null을 1로 카운트
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
inner join만으로는 해결할 수 없음
c ~ r join부분에서 조인되지않는 c.region id 값들이 출력되지 않음
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



