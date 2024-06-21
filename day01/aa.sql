-- 1. �μ���ȣ�� 10���� �μ��� ��� �� �����ȣ, �̸�, ������ ����϶�
select empno, ename, sal from emp where deptno = 10; 

-- 2.  �����ȣ�� 7369�� ��� �� �̸�, �Ի���, �μ���ȣ�� ����϶�.
select ename, hiredate, deptno from emp where empno = 7369;

-- 3.  �̸��� ALLEN�� ����� ��� ������ ����϶�.
select * from emp where ename = 'ALLEN';

-- 5�� ������ MANAGER�� �ƴ� ����� ��� ������ ����϶�.
select * from emp where job != 'MANAGER';

-- 6��  �Ի����� 81/04/02 ���Ŀ� �Ի��� ����� ������ ����϶�.
select * from emp where hiredate >= '81/04/02';

-- 7�� �޿��� $800 �̻��� ����� �̸�, �޿�, �μ���ȣ�� ����϶�.
select ename, sal, deptno from emp where sal >= 800;

-- 8�� �μ���ȣ�� 20�� �̻��� ����� ��� ������ ����϶�.
select * from emp where deptno >= 20;

-- 10��  �Ի����� 81/12/09 ���� ���� �Ի��� ������� ��� ������ ����϶�
select * from emp where hiredate < '81/12/09';

-- 11. ����) �Ի��ȣ�� 7698���� �۰ų� ���� ������� �Ի��ȣ�� �̸��� ����϶�.
select empno, ename from emp where empno >= 7698;

-- 12. �Ի����� 81/04/02 ���� �ʰ� 82/12/09 ���� ���� ����� �̸�, ����, �μ���ȣ�� ����϶�.
select ename, sal, deptno from emp where hiredate < '82/12/09' and hiredate > '81/04/02';

-- 13 �޿��� $1,600���� ũ�� $3,000���� ���� ����� �̸�, ����, �޿��� ����϶�.
select ename, job, sal from emp where sal >1600 and sal < 3000;

-- 14 �����ȣ�� 7654�� 7782 ���� �̿��� ����� ��� ������ ����϶�.
select * from emp where empno < 7654 or empno > 7782;

-- 15. ����) �̸��� B�� J ������ ��� ����� ������ ����϶�.
select * from emp where ename like 'B%' or ename like 'J%';

-- 16. ����) �Ի����� 81�� �̿ܿ� �Ի��� ����� ��� ������ ����϶�.
select * from emp where hiredate < '81/01/01' or hiredate >= '82/01/01';

-- 17. ����) ������ MANAGER�� SALESMAN�� ����� ��� ������ ����϶�.
select * from emp where job ='MANAGER' or job = 'SALESMAN';

-- 18. ����) �μ���ȣ�� 20, 30���� ������ ��� ����� �̸�, �����ȣ, �μ���ȣ�� ����϶�.
select ename, empno, deptno from emp where not (deptno=20 or deptno=30) ;

-- 19. ����) �̸��� S�� �����ϴ� ����� �����ȣ, �̸�, �Ի���, �μ���ȣ�� ����϶�.
select empno, hiredate, deptno from emp where ename like 'S%';

-- 20. ����) �Ի����� 81�⵵�� ����� ��� ������ ����϶�
select * from emp where hiredate >= '81/01/01' and hiredate <= '81/12/31';

-- 21. ����) �̸� �� S�ڰ� �� �ִ� ����� ��� ������ ����϶�
select * from emp where ename like 'S%';

-- 23. ����) ù ��° ���ڴ� �������, �� ��° ���ڰ� A�� ����� ������ ����϶�.
select * from emp where ename like '_A%';

-- 24. ����) Ŀ�̼��� NULL�� ����� ������ ����϶�.
select * from emp where comm is null;

-- 25. ����) Ŀ�̼��� NULL�� �ƴ� ����� ��� ������ ����϶�.
select * from emp where comm is not null;

-- 26. ����) �μ��� 30�� �μ��̰� �޿��� $1,500 �̻��� ����� �̸�, �μ� ,������ ����϶�.
select  e.ename, dept.dname, e.sal
from emp e
join dept on e.deptno = dept.deptno
where dept.deptno = 30 and e.sal >= 1500;

-- 27. ����) �̸��� ù ���ڰ� K�� �����ϰų� �μ���ȣ�� 30�� ����� �����ȣ, �̸�, �μ���ȣ�� ����϶�.
select empno, ename, deptno from emp where  ename like 'K%' or deptno = 30;

-- 28. ����) �޿��� $1,500 �̻��̰� �μ���ȣ�� 30���� ��� �� ������ MANAGER�� ����� ������ ����϶�
select * from emp where sal >= 1500 and deptno = 30 and job = 'MANAGER';

-- 29. ����) �μ���ȣ�� 30�� ��� �� �����ȣ SORT�϶�.
select * from emp where deptno = 30 order by empno;

-- 30. ����) �޿��� ���� ������ SORT�϶�.
select * from emp order by sal desc;

-- �׷���� ���� ���� CLERK �հ躰 �޿�
select job, sum(sal) from  emp where job = 'CLERK'  GROUP by job;

select * from dept;
select * from emp;