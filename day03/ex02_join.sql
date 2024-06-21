SELECT employee_id, department_id
FROM employees
where last_name = 'King';

select department_id, department_name
from departments
where department_id In(80, 90);

select * from employees;
desc departments;
-- 조인이용 방법
SELECT e.employee_id, d.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.last_name = 'King';

-- 퀴즈 kcc> '송강' 교수가 강의하는 과목을 검색하라
desc professor;
desc course;

select p.pno, p.pname, c.cname
from professor p, course c
where p.pno = c.pno and pname='송강';
select * from student;
select * from professor;
select * from course;

select * from score;

-- 1.학점이 2학점인 과목과 이를 강의하는 교수님 검색
select p.pname, c.cname, c.st_num
from professor p, course c
where p.pno = c.pno and c.st_num = 2;

-- 2. 화학과 1한년 학생의 기말고사 성정
select s.sno, s.sname, s.major, sco.result
from student s, professor p, score sco
where p.SECTION = s.major and s.syear = 1 and s.major = '화학';

-- 3. 화학과 1학년 학생이 수강하는 과목을 검색(3개 테이블 조인
select s.sno, s.sname, s.major, s.avr, c.cname
from student s, professor p,course c
where p.SECTION = s.major  and s.syear = 1 and s.major = '화학';


-- ANSI JOIN(SQL-99)
/*
이전방법
        -- 조인이용 방법
        SELECT e.employee_id, d.department_id, d.department_name
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE e.last_name = 'King';
*/

select e.employee_id,e.department_id, d.department_name
    from employees e inner join departments d
    on e.department_id = d.department_id
    where e.last_name = 'king';

-- 퀴즈 hr> 3개이상 테이블을 조인하여 사원이름, 이메일, 부서번호, 부서이름, 직종번호(job_id), 직종이름(job_title)
select * from employees;
select * from departments;
select * from jobs;
-- jobs.job_id emplo.job_id   dep.managerid emp.managerid
--select e.last_name, e.email  
--from employees e inner join jobs j
--on e.job_id = j.job_id
--inner join departments d

-- 퀴즈 hr>Seattle 에 근무하는 사원이름 부서번호 직종번호 직종이름 도시이름 줄력해보자
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
SELECT A.last_name || '의 매니저는 '|| B.last_name || ' 이다.'
from employees A, employees B
where A.manager_id = B.employee_id
AND a.last_name = 'Kochhar';


-- outerjoin

-- 전체 107
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


-- kcc> 등록된 과목에 대한 모든 교수를 검색하라.
-- => 등록하지 않은 교수도 출력
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




