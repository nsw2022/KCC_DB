
select * from employees;
select * from jobs;

-- 1. 이름 'Himuro'
select e.last_name, d.department_name
from employees e, departments d
where e.manager_id = d.manager_id  and e.last_name = 'Himuro';

-- 2. 직종명이 'Accountant' 사원의 이름과 부서명
select e.last_name, j.job_title
from employees e, jobs j
where e.job_id = j.job_id and j.job_title='Accountant';

-- 3. 커미션을 받는 사람의 이름과 그가 속한 부서를 출력하라
select e.last_name, d.department_name, e.commission_pct
from employees e, departments d
where e.manager_id = d.manager_id and e.commission_pct is not null;

-- 4. 급여가 4000 이하인 사원의 이름 급여 근무지
select e.last_name, e.salary, l.city
from employees e, departments d, locations l
where d.location_id = l.location_id and e.salary <= 4000;

-- 5 'Chen' 과 동일한 부서에서 근무하는 사원의 이름을 출력하라.
select a.last_name, b.last_name
from employees A, employees B
where a.department_id = b.department_id and a.last_name = 'Chen';

