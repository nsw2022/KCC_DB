-- ��Ű�� ����
CREATE OR REPLACE PACKAGE my_package
IS
PROCEDURE getEmployee(in_id IN employees.employee_id%TYPE,
                      out_id OUT employees.employee_id%TYPE,
                      out_name OUT employees.first_name%TYPE,
                      out_salary OUT employees.salary%TYPE);
    FUNCTION getSalary(p_no employees.employee_id%TYPE)
    RETURN NUMBER;
END;

-- ��Ű�� ����
CREATE OR REPLACE PACKAGE BODY my_package --> BODY�� �߰�
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
    END; --> ���ν��� ����
FUNCTION getSalary(p_no employees.employee_id%TYPE)
   RETURN NUMBER
    IS 
        v_salary NUMBER;
    BEGIN 
        SELECT salary INTO v_salary
      FROM employees 
      WHERE employee_id = p_no;
        RETURN v_salary;
    END; --> �Լ�����
END; --> ��Ű�� ����

-- �Լ� ����
SELECT my_package.getSalary(100) FROM dual;

-- ���ν��� ����
DECLARE
    p_id NUMBER;
    p_name VARCHAR2(50);
    p_salary NUMBER;
BEGIN
    my_package.getemployee(100, p_id, p_name, p_salary);
    dbms_output.put_line(p_id || ' ' || p_name || ' ' || p_salary);
END;

-- ��Ű�� ��

-- Ʈ���� ����


CREATE TABLE emp14(
    empno NUMBER PRIMARY KEY,
    ename VARCHAR2(20),
    job VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER trg_01
    AFTER INSERT 
    ON emp14 
    BEGIN 
        DBMS_OUTPUT.PUT_LINE('���� ����� �߰� �Ǿ����ϴ�.');
    END;
    
INSERT INTO emp14 VALUES (1, 'ȫ�浿','����');

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
    
INSERT INTO emp14 VALUES (2, '��¿�','����');
SELECT * FROM sal01;

select * from sal01;
-- ���� HR ����� �����Ǹ� �� ����� �޿�����(sal01) ���̺��� �ش� �ο쵵 �Բ� ���� �ǵ��� Ʈ���Ÿ� ������ ����
CREATE OR REPLACE TRIGGER trg_03
    AFTER DELETE
    ON emp14
    FOR EACH ROW
    BEGIN
        DELETE from sal01 where empno = :old.empno;
    end;
/*
<mission hr> employees2���� retire_date �÷��� �߰�����.
  ALTER TABLE employees2 ADD(retire_date date);
  �׸��� �Ʒ��� ���뿡 �´� package,  procedure ����� ����.
*/

ALTER TABLE employees2 ADD(retire_date date);
--��Ű�� �����
CREATE OR REPLACE PACKAGE hr_pkg IS
    --�ű� ��� �Է�
    --�űԻ�� ��� => ������(�ִ�)��� + 1
    --�űԻ�� ���
    PROCEDURE new_emp_proc(ps_emp_name IN VARCHAR2,
	pe_email IN VARCHAR2,
	pj_job_id IN VARCHAR2,
	pd_hire_date IN VARCHAR2);
    -- TO_DATE(pdhire_date, 'YYYY-MM-DD');

   -- ��� ��� ó��
   --����� ����� ������̺��� �������� �ʰ� �������(retire_date)�� NULL���� ����
   PROCEDURE retire_emp_proc(pn_employee_id IN NUMBER);

END hr_pkg;
-- 
CREATE OR REPLACE PACKAGE BODY hr_pkg IS
 -- �ű� ��� �Է�
    PROCEDURE new_emp_proc (
        ps_emp_name  IN VARCHAR2,
        pe_email     IN VARCHAR2,
        pj_job_id    IN VARCHAR2,
        pd_hire_date IN VARCHAR2
    ) IS
        vn_emp_id    employees2.employee_id%TYPE;
        vd_hire_date DATE := to_date(pd_hire_date, 'YYYY-MM-DD');
    BEGIN
        --�űԻ�� ��� => ������(�ִ�)��� + 1
        SELECT
            nvl(MAX(employee_id), 0) + 1
        INTO vn_emp_id
        FROM
            employees2;

      --�űԻ�� ���
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

  --���ó��
  --����� ����� ������̺��� �������� �ʰ� �������(retire_date)�� NULL���� ����
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

      --UPDATE�� �Ǽ��� ��������
        vn_cnt := SQL%rowcount;

     --���ŵ� �Ǽ��� 0�̸� ����� ����ó��
        IF vn_cnt = 0 THEN
            RAISE e_no_data; --���������� ����� ���� �߻�
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_no_data THEN
            dbms_output.put_line(pn_employee_id || '�� ������� �ƴմϴ�.');
            ROLLBACK;
    END retire_emp_proc;

END hr_pkg;


EXECUTE hr_pkg.new_emp_proc('ȫ�浿', 'aaa@aa.com', 'AD_VP', '2021-02-24');

EXECUTE hr_pkg.retire_emp_proc(100)


SELECT * FROM employees2;

    