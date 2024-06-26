set SERVEROUTPUT on;
CREATE OR REPLACE PROCEDURE my_new_job_proc1(p_deptno 
                                             IN employees.department_id%TYPE)
                                             --> 파라미터가 들어온다는 의미로 IN
IS 
   CURSOR employee_cursors IS --> CURSOR에 데이터가 들어감
      SELECT *
         FROM employees
         WHERE department_id = p_deptno;
         
   employee_record employee_cursors%ROWTYPE;
   
BEGIN 
   DBMS_OUTPUT.PUT_LINE('=================사원 리스트=================');

   FOR employee_record IN employee_cursors LOOP
      DBMS_OUTPUT.PUT_LINE(p_deptno|| ' ' || employee_record.employee_id
                                       || ' ' || employee_record.last_name);
   END LOOP;
END;

-- 프로시저 실행
EXECUTE my_new_job_proc1(30);

/*
퀴즈 기존 jobs=>jobs2로 복사 프로시저를 이용하여 
job_id, job_title, min_salary, max_salary 
입력받아 테이블에 새로운 row를 추가하자
('a','IT',100,100)
*/
CREATE TABLE jobs2 AS
    (SELECT * FROM jobs);
    

CREATE OR REPLACE PROCEDURE insertjobs( 
    p_job_id IN jobs2.job_id%TYPE,
    p_job_title IN jobs2.job_title%TYPE,
    p_min_salary IN jobs2.min_salary%TYPE,
    p_max_salary IN jobs2.max_salary%TYPE)
IS
BEGIN
     INSERT INTO jobs2(job_id, job_title, min_salary, max_salary)
     VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
     commit;
END;

EXECUTE insertjobs('a','it',100,1000);

select * from jobs2;


/*
job2테이블 job_id 제약조건(pk) 추가
프로시저를 이용하여 동일한 job_id를 체크
no => inser 실행
yew => update
*/

alter table jobs2
    add(
    CONSTRAINT jobs2_job_id_pk PRIMARY key(job_id)
    );
    
CREATE OR REPLACE PROCEDURE my_new_job_proc2(
                                p_job_id IN jobs2.job_id%TYPE,
                                p_job_title IN jobs2.job_title%TYPE,
                                p_min_salary IN jobs2.min_salary%TYPE,
                                p_max_salary IN jobs2.max_salary%TYPE
                                )
is
    v_cnt number := 0;
BEGIN
    
    SELECT count(*) into v_cnt
    FROM jobs2
    WHERE job_id = p_job_id;
    
    IF v_cnt = 0 THEN
        INSERT INTO JOBS2(job_id, job_title, min_salary, max_salary ) 
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
        commit;
    ELSE
        UPDATE jobs2 
        set 
        job_title=p_job_title,
        min_salary=p_min_salary,
        max_salary=p_max_salary;
    END IF;
end;

EXECUTE my_new_job_proc2('b','it',10,1000);

select * from jobs2;

CREATE OR REPLACE PROCEDURE my_new_job_proc3(
                                p_job_id IN jobs2.job_id%TYPE,
                                p_job_title IN jobs2.job_title%TYPE,
                                p_min_salary IN jobs2.min_salary%TYPE := 100,
                                p_max_salary IN jobs2.max_salary%TYPE := 1000
                                )
is
    v_cnt number := 0;
BEGIN
    
    SELECT count(*) into v_cnt
    FROM jobs2
    WHERE job_id = p_job_id;
    
    IF v_cnt = 0 THEN
        INSERT INTO JOBS2(job_id, job_title, min_salary, max_salary ) 
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
        commit;
    ELSE
        UPDATE jobs2 
        set 
        job_title=p_job_title,
        min_salary=p_min_salary,
        max_salary=p_max_salary;
    END IF;
end;
EXECUTE my_new_job_proc3('b','it');
select * from jobs2;


-- out, in 매개변수 설정
CREATE OR REPLACE PROCEDURE my_new_job_proc4(
                                p_job_id IN jobs2.job_id%TYPE,
                                p_job_title IN jobs2.job_title%TYPE,
                                p_min_salary IN jobs2.min_salary%TYPE := 100,
                                p_max_salary IN jobs2.max_salary%TYPE := 1000,
                                p_result OUT NUMBER
                                )
is
    v_cnt number := 0;
BEGIN
    
    SELECT count(*) into v_cnt
    FROM jobs2
    WHERE job_id = p_job_id;
    
    IF v_cnt = 0 THEN
        p_result := 1;
        INSERT INTO JOBS2(job_id, job_title, min_salary, max_salary ) 
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary);
        commit;
    ELSE
        p_result := 2;
        UPDATE jobs2 
        set 
        job_title=p_job_title,
        min_salary=p_min_salary,
        max_salary=p_max_salary;
    END IF;
end;
-- 프로시저 실행
DECLARE
    p_result NUMBER;
BEGIN
    my_new_job_proc4('d','d1',200,2000,p_result);
    IF p_result=1 THEN
        DBMS_OUTPUT.PUT_LINE('추가 되었습니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('수정 되었습니다.');
    END IF;
END;
