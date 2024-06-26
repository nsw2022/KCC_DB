-- 패키지 선언
CREATE OR REPLACE PACKAGE my_package
IS
PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                      out_id OUT employees.employee_id%TYPE,
                      out_name OUT employees.first_name%TYPE,
                      out_salary OUT employees.salary%TYPE);
    FUNCTION getSalary(p_no employees.employee_id%TYPE)
    RETURN NUMBER;
END;

-- 패키지 본문
CREATE OR REPLACE PACKAGE BODY my_package --> BODY만 추가
   IS
   PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                            out_id OUT employees.employee_id%TYPE,
                            out_name OUT employees.first_name%TYPE,
                            out_salary OUT employees.salary%TYPE)
    IS
    BEGIN 
        SELECT employee_id, first_name, salary
        INTO out_id, out_name, out_salary
        FROM employees
        WHERE employee_id = in_id;
    END; --> 프로시저 종료
FUNCTION getSalary(p_no employees.employee_id%TYPE)
   RETURN NUMBER
    IS 
        v_salary NUMBER;
    BEGIN 
        SELECT salary INTO v_salary
      FROM employees 
      WHERE employee_id = p_no;
        RETURN v_salary;
    END; --> 함수종료
END; --> 패키지 종료

-- 함수 실행
SELECT my_package.getSalary(100) FROM dual;

-- 프로시저 실행
DECLARE
    p_id NUMBER;
    p_name VARCHAR2(50);
    p_salary NUMBER;
BEGIN
    my_package.getemployee(100, p_id, p_name, p_salary);
    dbms_output.put_line(p_id || ' ' || p_name || ' ' || p_salary);
END;

-- 패키지 끝

-- 트리거 시작


CREATE TABLE emp14(
    empno NUMBER PRIMARY KEY,
    ename VARCHAR2(20),
    job VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER trg_01
    AFTER INSERT 
    ON emp14 
    BEGIN 
        DBMS_OUTPUT.PUT_LINE('신입 사원이 추가 되었습니다.');
    END;
    
INSERT INTO emp14 VALUES (1, '홍길동','개발');

CREATE TABLE sal01(
    salno NUMBER PRIMARY KEY,
    sal NUMBER,
    empno NUMBER REFERENCES emp14(empno)
);

CREATE SEQUENCE sal01_salno_seq;

CREATE OR REPLACE TRIGGER trg_02
    AFTER INSERT
    ON emp14
    FOR EACH ROW
    BEGIN
        INSERT INTO sal01 VALUES(sal01_salno_seq.NEXTVAL,
                                4000,
                                :NEW.empno
                                );
    END;
    
INSERT INTO emp14 VALUES (2, '노승우','개발');
SELECT * FROM sal01;

select * from sal01;
-- 퀴즈 HR 사원이 삭제되면 그 사원의 급여정보(sal01) 테이블의 해당 로우도 함께 삭제 되도록 트리거를 구현해 보자
CREATE OR REPLACE TRIGGER trg_03
    AFTER DELETE
    ON emp14
    FOR EACH ROW
    BEGIN
        DELETE from sal01 where empno = :old.empno;
    end;
/*
<mission hr> employees2에서 retire_date 컬럼을 추가하자.
  ALTER TABLE employees2 ADD(retire_date date);
  그리고 아래의 내용에 맞는 package,  procedure 만들어 보자.
*/

ALTER TABLE employees2 ADD(retire_date date);
--패키지 선언부
CREATE OR REPLACE PACKAGE hr_pkg IS
    --신규 사원 입력
    --신규사원 사번 => 마지막(최대)사번 + 1
    --신규사원 등록
    PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2);
    -- TO_DATE(pdhire_date, 'YYYY-MM-DD');

   -- 퇴사 사원 처리
   --퇴사한 사원은 사원테이블에서 삭제하지 않고 퇴사일자(retire_date)를 NULL에서 갱신
   PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER);

END hr_pkg;
-- 
CREATE OR REPLACE PACKAGE BODY hr_pkg IS
 -- 신규 사원 입력
    PROCEDURE new_emp_proc (
        ps_emp_name  IN VARCHAR2,
        pe_email     IN VARCHAR2,
        pj_job_id    IN VARCHAR2,
        pd_hire_date IN VARCHAR2
    ) IS
        vn_emp_id    employees2.employee_id%TYPE;
        vd_hire_date DATE := to_date(pd_hire_date, 'YYYY-MM-DD');
    BEGIN
        --신규사원 사번 => 마지막(최대)사번 + 1
        SELECT
            nvl(MAX(employee_id), 0) + 1
        INTO vn_emp_id
        FROM
            employees2;

      --신규사원 등록
        INSERT INTO employees2 (
            employee_id,
            last_name,
            hire_date,
            email,
            job_id
        ) VALUES (
            vn_emp_id,
            ps_emp_name,
            vd_hire_date,
            pe_email,
            pj_job_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('insert error');
            ROLLBACK;
    END new_emp_proc;

  --퇴사처리
  --퇴사한 사원은 사원테이블에서 삭제하지 않고 퇴사일자(retire_date)를 NULL에서 갱신
    PROCEDURE retire_emp_proc (
        pn_employee_id IN NUMBER
    ) IS
        vn_cnt NUMBER := 0;
        e_no_data EXCEPTION;
    BEGIN
        UPDATE employees2
        SET
            retire_date = sysdate
        WHERE
                employee_id = pn_employee_id
            AND retire_date IS NULL;

      --UPDATE된 건수를 가져오기
        vn_cnt := SQL%rowcount;

     --갱신된 건수가 0이면 사용자 예외처리
        IF vn_cnt = 0 THEN
            RAISE e_no_data; --인위적으로 사용자 예외 발생
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_no_data THEN
            dbms_output.put_line(pn_employee_id || '는 퇴사대상이 아닙니다.');
            ROLLBACK;
    END retire_emp_proc;

END hr_pkg;


EXECUTE hr_pkg.new_emp_proc('홍길동', 'aaa@aa.com', 'AD_VP', '2021-02-24');

EXECUTE hr_pkg.retire_emp_proc(100)


SELECT * FROM employees2;

    