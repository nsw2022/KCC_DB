set SERVEROUTPUT on;
CREATE OR REPLACE PROCEDURE my_new_job_proc1(p_deptno 
                                             IN employees.department_id%TYPE)
                                             --> �Ķ���Ͱ� ���´ٴ� �ǹ̷� IN
IS 
   CURSOR employee_cursors IS --> CURSOR�� �����Ͱ� ��
      SELECT *
         FROM employees
         WHERE department_id = p_deptno;
         
   employee_record employee_cursors%ROWTYPE;
   
BEGIN 
   DBMS_OUTPUT.PUT_LINE('=================��� ����Ʈ=================');

   FOR employee_record IN employee_cursors LOOP
      DBMS_OUTPUT.PUT_LINE(p_deptno|| ' ' || employee_record.employee_id
                                       || ' ' || employee_record.last_name);
   END LOOP;
END;

-- ���ν��� ����
EXECUTE my_new_job_proc1(30);

/*
���� ���� jobs=>jobs2�� ���� ���ν����� �̿��Ͽ� 
job_id, job_title, min_salary, max_salary 
�Է¹޾� ���̺� ���ο� row�� �߰�����
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
job2���̺� job_id ��������(pk) �߰�
���ν����� �̿��Ͽ� ������ job_id�� üũ
no => inser ����
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


-- out, in �Ű����� ����
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
-- ���ν��� ����
DECLARE
    p_result NUMBER;
BEGIN
    my_new_job_proc4('d','d1',200,2000,p_result);
    IF p_result=1 THEN
        DBMS_OUTPUT.PUT_LINE('�߰� �Ǿ����ϴ�.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('���� �Ǿ����ϴ�.');
    END IF;
END;
