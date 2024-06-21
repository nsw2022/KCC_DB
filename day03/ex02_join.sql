SELECT employee_id, department_id
FROM employees
where last_name = 'King';

select department_id, department_name
from departments
where department_id In(80, 90);

select * from employees;
desc departments;
-- �����̿� ���
SELECT e.employee_id, d.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.last_name = 'King';

-- ���� kcc> '�۰�' ������ �����ϴ� ������ �˻��϶�
desc professor;
desc course;

select p.pno, p.pname, c.cname
from professor p, course c
where p.pno = c.pno and pname='�۰�';
select * from student;
select * from professor;
select * from course;

select * from score;

-- 1.������ 2������ ����� �̸� �����ϴ� ������ �˻�
select p.pname, c.cname, c.st_num
from professor p, course c
where p.pno = c.pno and c.st_num = 2;

-- 2. ȭ�а� 1�ѳ� �л��� �⸻��� ����
select s.sno, s.sname, s.major, sco.result
from student s, professor p, score sco
where p.SECTION = s.major and s.syear = 1 and s.major = 'ȭ��';

-- 3. ȭ�а� 1�г� �л��� �����ϴ� ������ �˻�(3�� ���̺� ����
select s.sno, s.sname, s.major, s.avr, c.cname
from student s, professor p,course c
where p.SECTION = s.major  and s.syear = 1 and s.major = 'ȭ��';


-- ANSI JOIN(SQL-99)
/*
�������
        -- �����̿� ���
        SELECT e.employee_id, d.department_id, d.department_name
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE e.last_name = 'King';
*/

select e.employee_id,e.department_id, d.department_name
    from employees e inner join departments d
    on e.department_id = d.department_id
    where e.last_name = 'king';

-- ���� hr> 3���̻� ���̺��� �����Ͽ� ����̸�, �̸���, �μ���ȣ, �μ��̸�, ������ȣ(job_id), �����̸�(job_title)
select * from employees;
select * from departments;
select * from jobs;
-- jobs.job_id emplo.job_id   dep.managerid emp.managerid
--select e.last_name, e.email  
--from employees e inner join jobs j
--on e.job_id = j.job_id
--inner join departments d

-- ���� hr>Seattle �� �ٹ��ϴ� ����̸� �μ���ȣ ������ȣ �����̸� �����̸� �ٷ��غ���
select * from departments where location_id=1700;
select * from locations where city='Seattle';

select d.department_name, d.department_id, d.manager_id, d.department_name, l.city
from departments d
join locations l on l.location_id = d.location_id
where l.city = 'Seattle';

select d.department_name, d.department_id, d.manager_id, d.department_name, l.city
from locations l inner join departments d
on l.location_id = d.location_id
where l.city = 'Seattle';

select * from employees;

-- self join
SELECT A.last_name || '�� �Ŵ����� '|| B.last_name || ' �̴�.'
from employees A, employees B
where A.manager_id = B.employee_id
AND a.last_name = 'Kochhar';


-- outerjoin

-- ��ü 107
select * from employees;
--inner join 106
select * from employees e, departments d
where e.department_id = d.department_id;

-- outer
select e.employee_id, d.department_id, d.department_name 
    from employees e, departments d
    where e.department_id = d.department_id(+);
    
-- (ANSI JOIN)
select e.employee_id, d.department_id, d.department_name
from employees e left join departments d
on e.department_id = d.department_id;


-- kcc> ��ϵ� ���� ���� ��� ������ �˻��϶�.
-- => ������� ���� ������ ���
select * from professor; -- 36

-- inner
select p.pname, p.section, c.cno, c.cname
from professor p inner join course c
on p.pno = c.pno(+);

-- ansi
select p.pname, p.section, c.cno, c.cname
from professor p left join course c
on p.pno = c.pno;

select p.pname, p.section, c.cno, c.cname
from professor p full join course c
on p.pno = c.pno;




