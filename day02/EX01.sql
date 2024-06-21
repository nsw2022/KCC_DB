select substr('abcdef',2,3) from dual; 
select substr('abcdef',3) from dual; 

select job, substr(job,1, 2),substr(job, 5),substr(job, -3) from emp;


select * from emp;

-- kcc
select cname, substr(cname, 1, length(cname)-1) from course;


select 'Orcale', LPAD('Orcale', 10, '#') from dual;

select sysdate -1 "어제" , sysdate "오늘" , sysdate +1 "내일" from dual;

-- hr
select last_name ,round((sysdate-hire_date)/365,2) || '년' from employees;

select sysdate, next_day(sysdate, '토요일') from dual;

select TO_CHAR(SYSDATE, 'YYYY-MM-DD'), TO_CHAR(5000000, '$999,999,999') from dual;

select TO_DATE('2024-06-20', 'YYYY/MM/DD'), TO_DATE('20240622', 'YYYY-MM-DD') from dual;

select last_name,hire_date from employees where TO_CHAR(hire_date, 'YYYY')='2007' ORDER by hire_date;

select employee_id, salary, commission_pct,NVL(commission_pct, 0) from employees;

select employee_id, salary, NVL2(commission_pct, 'O','X')from employees;

select job_id, DECODE(job_id, 'SA_MAN', 'Sales Dept', 'SH_CLERK','Sales Dept' , 'Another' ) From employees;

SELECT job_id,
    CASE job_id
        WHEN 'SA_MAN' THEN 'Sales Dept'
        WHEN 'SH_CLERK' THEN 'Sales Dept'
        ELSE 'Another'
    END AS job_department,
    CASE
        WHEN commission_pct IS NULL THEN '널이라니 크킄'
        ELSE 'Not Null'
        
        +-0124578
    END AS commission_status
FROM employees;


-- 테이블 복사
CREATE TABLE emp01 
    AS SELECT * FROM employees;
    
-- 테이블 구조만 복사
CREATE TABLE emp02
    AS SELECT * FROM employees where 1=0;
    
    ALTER TABLE emp02 add(job varchar2(50));
    
ALTER TABLE emp02
 MODIFY(job varchar2(100));
 
 ALTER TABLE emp02
    DROP COLUMN job;
    
