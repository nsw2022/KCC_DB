-- 1
select * from bonus;
select * from dept;
select * from emp;
select * from salgrade;

select dept.deptno, emp.empno, emp.ename, emp.sal
from dept, emp
where dept.deptno = emp.deptno and emp.sal > 2000
order by deptno;

select dept.deptno, emp.empno, emp.ename, emp.sal
from emp
join dept
    on emp.deptno = dept.deptno
    where emp.sal > 2000;

--2 
select dept.deptno, dept.dname, round(avg(emp.sal)), max(emp.sal), count(*)
from dept, emp
where 
emp.deptno = dept.deptno
group by dept.deptno, dept.dname
order by deptno;

select dept.deptno, dept.dname, round(avg(emp.sal)), max(emp.sal), count(*)
from dept
join emp
    on emp.deptno = dept.deptno
    group by dept.deptno, dept.dname
    order by deptno;

--3
select dept.deptno, dept.dname, emp.empno, emp.ename, emp.job, emp.sal
from emp, dept
where emp.deptno(+) = dept.deptno
order by dept.deptno asc, emp.ename asc;

select dept.deptno, dept.dname, emp.empno, emp.ename, emp.job, emp.sal
from emp full JOIN dept
on emp.deptno = dept.deptno;

--4
select e.deptno, e.empno, e.ename, e.mgr, e.sal, d.deptno, s.losal, s.hisal, s.grade, e.empno as MGR, e.ename as MGR_ENAME
from emp e, dept d, salgrade s
where e.deptno = d.deptno(+) and
e.sal BETWEEN s.losal AND s.hisal
ORDER by e.deptno asc;


select * from dept;

select d.deptno, d.dname, 
e.ename, e.mgr, e.sal, 
d.deptno, 
s.losal, s.hisal, s.grade, 
e2.empno as MGR, e2.ename as MGR_ENAME
    from dept d 
    left outer join emp e
    on e.deptno = d.deptno
    left outer join emp e2
    on e.mgr = e2.empno
    left OUTER join salgrade s
    on e.sal BETWEEN s.losal and s.hisal
    ORDER by d.deptno asc, e.empno asc;

SELECT ename, sal, grade
    FROM emp, salgrade
    WHERE sal BETWEEN losal AND hisal
    ORDER BY grade;
