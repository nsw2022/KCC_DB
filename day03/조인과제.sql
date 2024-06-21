
select * from employees;
select * from jobs;

-- 1. �̸� 'Himuro'
select e.last_name, d.department_name
from employees e, departments d
where e.manager_id = d.manager_id  and e.last_name = 'Himuro';

-- 2. �������� 'Accountant' ����� �̸��� �μ���
select e.last_name, j.job_title
from employees e, jobs j
where e.job_id = j.job_id and j.job_title='Accountant';

-- 3. Ŀ�̼��� �޴� ����� �̸��� �װ� ���� �μ��� ����϶�
select e.last_name, d.department_name, e.commission_pct
from employees e, departments d
where e.manager_id = d.manager_id and e.commission_pct is not null;

-- 4. �޿��� 4000 ������ ����� �̸� �޿� �ٹ���
select e.last_name, e.salary, l.city
from employees e, departments d, locations l
where d.location_id = l.location_id and e.salary <= 4000;

-- 5 'Chen' �� ������ �μ����� �ٹ��ϴ� ����� �̸��� ����϶�.
select a.last_name, b.last_name
from employees A, employees B
where a.department_id = b.department_id and a.last_name = 'Chen';

