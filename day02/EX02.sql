--1
select empno,
RPAD(substr(EMPNO,1,2),4,'*' )as MASKING_EMPNO,
ename,
RPAD(substr(ename, 1,1),length(ename),'*') as MASKiNG_ENAME
from emp
where length(ename) < 6 and length(ename) >= 5;

--2
select empno, ename, sal, round(sal/21.5,2) as DAY_PAY,
round(round(sal/21.5,2)/8,1) as TIME_PAY
from emp;

--3 
select 
empno, 
ename, 
to_char(hiredate,'YYYY/MM/DD') as HIREDATE,
to_char(ADD_MONTHS(hiredate,3),'YYYY-MM-DD')as R_JOB, 
DECODE(NVL(COMM,-1), -1, 'N/A', COMM) as COMM
from emp;

-- 4
select empno, ename, mgr,
case
when mgr is null then '0000'
when substr(mgr,1,2) = '75' then '5555'
when substr(mgr,1,2) = '76' then '6666'
when substr(mgr,1,2) = '77' then '7777'
when substr(mgr,1,2) = '78' then '8888'
else to_char(mgr)
end as CHG_MGR
from emp;

-- µÎ¹øÂ°²¨ 1¹ø
select deptno, round(AVG(sal)), max(sal), min(sal)
from emp
group by deptno;

-- µÎ¹øÂ°²¨ 2¹ø
select job, count(*)
from emp
group by job
HAVING count(*) >=3;

-- µÎ¹øÂ°²¨ 3¹ø
select to_char(hiredate,'YYYY'), deptno, count(*) as cnt
from emp
group by to_char(hiredate,'YYYY'), deptno;

-- µÎ¹øÂ°²¨ 4¹ø
select NVL2(comm, 'O','X') as EXIST_COMM, count(*) as CNT
from emp
group by NVL2(comm, 'O','X');

-- µÎ¹øÂ°²¨ 5¹ø
SELECT DEPTNO,
       TO_CHAR(HIREDATE, 'YYYY') AS HIRE_YEAR,
       COUNT(*) AS CNT,
       MAX(SAL) AS MAX_SAL,
       SUM(SAL) AS SUM_SAL,
       AVG(SAL) AS AVG_SAL
  FROM EMP
GROUP BY ROLLUP(DEPTNO, TO_CHAR(HIREDATE, 'YYYY')); 

--select * from emp;
--desc emp;
--truncate table emp02;
--DROP TABLE EMP01;
select * from emp01;


-- hr
create table dept01
as select * from departments;

insert into dept01 values(300, 'Debeloper',100,10);
insert into dept01 (DEPARTMENT_ID, department_name) values(400, 'Sales');

update dept01 set department_name = 'IT Service' where department_id = 300;

create table emp01 as select * from employees;
select * from emp01;

update emp01 set salary = salary * 1.1 where first_name = 'Den';
select * from emp01 where first_name = 'Den';

delete dept01 where DEPARTMENT_NAME = 'IT Service';
select * from dept01;
desc dept01;
-- ÄûÁî


