-- 1. 부서번호가 10번인 부서의 사람 중 사원번호, 이름, 월급을 출력하라
select empno, ename, sal from emp where deptno = 10; 

-- 2.  사원번호가 7369인 사람 중 이름, 입사일, 부서번호를 출력하라.
select ename, hiredate, deptno from emp where empno = 7369;

-- 3.  이름이 ALLEN인 사람의 모든 정보를 출력하라.
select * from emp where ename = 'ALLEN';

-- 5번 직업이 MANAGER가 아닌 사람의 모든 정보를 출력하라.
select * from emp where job != 'MANAGER';

-- 6번  입사일이 81/04/02 이후에 입사한 사원의 정보를 출력하라.
select * from emp where hiredate >= '81/04/02';

-- 7번 급여가 $800 이상인 사람의 이름, 급여, 부서번호를 출력하라.
select ename, sal, deptno from emp where sal >= 800;

-- 8번 부서번호가 20번 이상인 사원의 모든 정보를 출력하라.
select * from emp where deptno >= 20;

-- 10번  입사일이 81/12/09 보다 먼저 입사한 사람들의 모든 정보를 출력하라
select * from emp where hiredate < '81/12/09';

-- 11. 문제) 입사번호가 7698보다 작거나 같은 사람들의 입사번호와 이름을 출력하라.
select empno, ename from emp where empno >= 7698;

-- 12. 입사일이 81/04/02 보다 늦고 82/12/09 보다 빠른 사원의 이름, 월급, 부서번호를 출력하라.
select ename, sal, deptno from emp where hiredate < '82/12/09' and hiredate > '81/04/02';

-- 13 급여가 $1,600보다 크고 $3,000보다 작은 사람의 이름, 직업, 급여를 출력하라.
select ename, job, sal from emp where sal >1600 and sal < 3000;

-- 14 사원번호가 7654와 7782 사이 이외의 사원의 모든 정보를 출력하라.
select * from emp where empno < 7654 or empno > 7782;

-- 15. 문제) 이름이 B와 J 사이의 모든 사원의 정보를 출력하라.
select * from emp where ename like 'B%' or ename like 'J%';

-- 16. 문제) 입사일이 81년 이외에 입사한 사람의 모든 정보를 출력하라.
select * from emp where hiredate < '81/01/01' or hiredate >= '82/01/01';

-- 17. 문제) 직업이 MANAGER와 SALESMAN인 사람의 모든 정보를 출력하라.
select * from emp where job ='MANAGER' or job = 'SALESMAN';

-- 18. 문제) 부서번호와 20, 30번을 제외한 모든 사람의 이름, 사원번호, 부서번호를 출력하라.
select ename, empno, deptno from emp where not (deptno=20 or deptno=30) ;

-- 19. 문제) 이름이 S로 시작하는 사원의 사원번호, 이름, 입사일, 부서번호를 출력하라.
select empno, hiredate, deptno from emp where ename like 'S%';

-- 20. 문제) 입사일이 81년도인 사람의 모든 정보를 출력하라
select * from emp where hiredate >= '81/01/01' and hiredate <= '81/12/31';

-- 21. 문제) 이름 중 S자가 들어가 있는 사람만 모든 정보를 출력하라
select * from emp where ename like 'S%';

-- 23. 문제) 첫 번째 문자는 관계없고, 두 번째 문자가 A인 사람의 정보를 출력하라.
select * from emp where ename like '_A%';

-- 24. 문제) 커미션이 NULL인 사람의 정보를 출력하라.
select * from emp where comm is null;

-- 25. 문제) 커미션이 NULL이 아닌 사람의 모든 정보를 출력하라.
select * from emp where comm is not null;

-- 26. 문제) 부서가 30번 부서이고 급여가 $1,500 이상인 사람의 이름, 부서 ,월급을 출력하라.
select  e.ename, dept.dname, e.sal
from emp e
join dept on e.deptno = dept.deptno
where dept.deptno = 30 and e.sal >= 1500;

-- 27. 문제) 이름의 첫 글자가 K로 시작하거나 부서번호가 30인 사람의 사원번호, 이름, 부서번호를 출력하라.
select empno, ename, deptno from emp where  ename like 'K%' or deptno = 30;

-- 28. 문제) 급여가 $1,500 이상이고 부서번호가 30번인 사원 중 직업이 MANAGER인 사람의 정보를 출력하라
select * from emp where sal >= 1500 and deptno = 30 and job = 'MANAGER';

-- 29. 문제) 부서번호가 30인 사람 중 사원번호 SORT하라.
select * from emp where deptno = 30 order by empno;

-- 30. 문제) 급여가 많은 순으로 SORT하라.
select * from emp order by sal desc;

-- 그룹바이 연습 직업 CLERK 합계별 급여
select job, sum(sal) from  emp where job = 'CLERK'  GROUP by job;

select * from dept;
select * from emp;