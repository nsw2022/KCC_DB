set SERVEROUTPUT on;


/*
DECLARE
    v_no NUMBER := 10;
    v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
    
    -- ��� ����
    c_message CONSTANT VARCHAR2(50):= 'Hello PL/SQL!!!';
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PL/SQL ����');
        DBMS_OUTPUT.PUT_LINE(c_message);
        DBMS_OUTPUT.PUT_LINE(v_hireDate);
    END;
    
*/
-- ���� ����
DECLARE
    v_no NUMBER := 10;
    v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
    
    -- ��� ����
    c_message CONSTANT VARCHAR2(50):= 'Hello PL/SQL!!!';
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PL/SQL ����');
        DBMS_OUTPUT.PUT_LINE(c_message);
        DBMS_OUTPUT.PUT_LINE(v_hireDate);
    END;
    
    
-- ���� Ư�� employes ���̺��� �ο츦 �˻��Ͽ� ������ �Ҵ��غ���.
DECLARE
    v_name VARCHAR2(20);
    v_salary NUMBER;
    v_hireDate VARCHAR2(30);
BEGIN
    SELECT first_name, salary, TO_CHAR(sysdate, 'YYYY-MM-DD')
    INTO v_name, v_salary, v_hireDate
    FROM employees
    WHERE first_name = 'Ellen';
    
    DBMS_OUTPUT.PUT_LINE('�˻��� ����� ����:');
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_salary || ' ' || v_hireDate);
END;

select * from departments;
select * from employees;

desc departments;
-- ���� hr> �����ȣ 100���� �ش��ϴ� ����� �̸��� �μ����� ����Ͻÿ�.
DECLARE
    v_name VARCHAR2(20);
    v_deptName VARCHAR2(20);
    v_deptno NUMBER;
BEGIN
    select e.last_name, d.department_name, d.department_id
    into v_name,v_deptName,v_deptno
    from employees e inner join departments d
    on e.department_id = d.department_id
    where e.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('�˻��� ����� ����:');
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_deptName || ' ' || v_deptno);
end;

-- �⺻�ڷ���
/*
 DECLARE
    -- �⺻�� ��������
    v_search varchar2(20):= 'Lisa';
    -- ���۷�����
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    
BEGIN
    SELECT last_name, salary
    INTO v_name, v_salary
    FROM employees
    WHERE first_name = v_search;
    
    DBMS_OUTPUT.PUT_LINE(v_name ||' '||v_salary);
END;   
*/

DECLARE
    -- �⺻�� ��������
    v_search varchar2(20):= 'Lisa';
    -- ���۷�����
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    
BEGIN
    SELECT last_name, salary
    INTO v_name, v_salary
    FROM employees
    WHERE first_name = v_search;
    
    DBMS_OUTPUT.PUT_LINE(v_name ||' '||v_salary);
END;
/*
<hr> 
1. ������̺��� 201�� ����� �̸��� �̸����� ����϶�.(���۷��� ��)
2. employees => employees2 qhrtk
   ��� ���̺��� �����ȣ�� ���� ū ����� ã���� �����ȣ +1 ������ �Ʒ��� ����� �߰��϶�
*/

SELECT * FROM employees;
--1    
DECLARE
    v_name employees.last_name%TYPE;
    v_email employees.email%TYPE;
BEGIN
    SELECT last_name, email
    INTO v_name, v_email
    FROM employees
    WHERE employee_id = 201;
    
    DBMS_OUTPUT.PUT_LINE(v_name ||' '||v_email);
end;

create table employees2 as (select * from employees) ;
drop table employees2;

 create table employees2 as 
        ( 
         select * 
         from employees 
         );
select * from employees2;
--2


DECLARE
   v_empId employees.employee_id%TYPE;
BEGIN
    SELECT employee_id
    INTO v_empId
    FROM employees
    WHERE employee_id = (SELECT MAX(employee_id) FROM employees);
    
    INSERT INTO employees2(employee_id, first_name, last_name, email,hire_date, job_id) VALUES (
        v_empId + 1, 'HONG', 'gil dong', 'aa@aa.com',SYSDATE, 'AD_VP'
    );
    commit;
END;
select * from employees2;



/*
-- ROWTYPE -> 1���� �ο� Ÿ���� ���´�
 
*/

DECLARE
    employee_recoard employees%ROWTYPE;
    v_department_name departments.department_name%TYPE;
BEGIN
    SELECT * INTO employee_recoard
        FROM employees
        WHERE first_name='Lisa';
        
    DBMS_OUTPUT.PUT_LINE(employee_recoard.employee_id  ||' '|| employee_recoard.first_name ||' '|| employee_recoard.salary);

end;

-- scott>40�� �μ��� �μ������� rowtype�� �̿��ؼ� �������
DECLARE
    v_loc dept%Rowtype;
BEGIN
    SELECT * INTO v_loc
    FROM dept
    where deptno = 40;
    
    dbms_output.put_line(v_loc.deptno ||' '|| v_loc.dname ||' '|| v_loc.loc);
    
end;
--���
/*
    
*/

DECLARE
    v_no NUMBER := 7;
    v_score NUMBER := 80;
BEGIN
    --�ܼ�
    /*
    IF v_no = 7 THEN
        DBMS_OUTPUT.PUT_LINE('7�̴�');
    END IF;
    */
    -- IF ~ ELSE ~ END IF
    /*
    IF v_no = 5 THEN
        DBMS_OUTPUT.PUT_LINE('5�̴�');
    ELSE
        DBMS_OUTPUT.PUT_LINE('5�� �ƴϴ�');
    END IF;
    */
    -- IF ~ ELSIF ~ END IF
    IF v_score >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('A');
    ELSIF v_score >= 80 THEN
        DBMS_OUTPUT.PUT_LINE('B');
    ELSIF v_score >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('C');
    ELSE
        DBMS_OUTPUT.PUT_LINE('F');
    END IF;

END;

select * from dept;
select * from employees;

-- �������ϱ� 10~120���̿� ������ �μ���ȣ�� �޾Ƽ� �ش� �μ��� ��� �޿��� ���� ����� ��µǵ��� ����.
DECLARE
    v_SAL employees.salary%TYPE;
BEGIN

    SELECT AVG(SALARY)
    INTO v_sal
    FROM EMPLOYEES
    WHERE department_id = ROUND(DBMS_RANDOM.VALUE(10,120),-1)
    GROUP BY DEPARTMENT_ID;
    /*
    if v_SAL>=6000 then dbms_output.put_line('����');
    elsif v_SAL>=3000 then dbms_output.put_line('����');
    else dbms_output.put_line('����');
    end if;
    */
    case when v_sal BETWEEN 1 and 3000 then
        dbms_output.put_line('����');
    when v_sal BETWEEN 3000 and 6000 then
        dbms_output.put_line('����');
    else
        dbms_output.put_line('����');
    end case;
END;

-- �ݺ���

DECLARE
    i NUMBER := 0;
    total NUMBER := 0;

BEGIN
    LOOP
    i := i+1;
    total := total + i;
    -- ����
    EXIT WHEN i >= 10;
    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(total);
END;

-- �ݺ��� WHILE
DECLARE
    i NUMBER := 0;
    total NUMBER := 0;

BEGIN
    WHILE I <= 10 LOOP
    total := total + i;
    i := i+1;
    END LOOP.
    DBMS_OUTPUT.PUT_LINE(total);
END;

-- �ݺ��� FOR
DECLARE
    i NUMBER := 0;
    total NUMBER := 0;
BEGIN
  FOR i IN 1..10 LOOP
     total := total + i;
  END LOOP;
    DBMS_OUTPUT.PUT_LINE(total);
END;

-- LOOP => ������ 3�� 
DECLARE
    i NUMBER := 9;
    total NUMBER := 0;
BEGIN
  FOR i IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE(3 ||' x '|| i ||' = '|| i*3 ); 
  END LOOP;
    
END;

DECLARE
    i NUMBER := 9;
    j NUMBER := 9;
BEGIN
  FOR i IN 2..9 LOOP
    for j in 1..9 loop
         DBMS_OUTPUT.PUT_LINE(i ||' x '|| j ||' = '|| i*j ); 
    end loop;
  END LOOP;
    
END;


-- ����(Exception)
/*
- PL/SQL ������ ���ܶ�� �Ѵ�.
- �����Ͻ� ������ ����, ����� �߻��ϴ� ����
- �̸� ���ǵ� ����Ŭ �������� : ������ �ʿ� ����, �߻��� �ڵ����� ���ӵ�
- ����� ���ܸ� ������ �߻� : ����ο��� ���� ����, ����ο��� RAISC�� ���

*/
DECLARE
    employee_record employees%ROWTYPE; --> �ϳ��� ��´�.

BEGIN 
    SELECT employee_id, last_name, department_id
    INTO employee_record.employee_id,
        employee_record.last_name,
        employee_record.department_id
    FROM employees
    WHERE department_id = 50;
    
    EXCEPTION 
    -- UNIQUE ���������� ���� �÷��� �ߺ��� ������ insert
    WHEN DUP_VAL_ON_INDEX THEN 
    DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
    
-- SELECT�� ��� 2�� �̻��� �ο츦 ��ȯ
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('�˻��� �ο찡 �����ϴ�.');
    
-- �����Ͱ� ���� ��
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('�˻��� ����� �����ϴ�.');
    
-- �� ���� ���� ����
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('��Ÿ ����');
END;


-- ����ڰ� ������ ���� �߻� => ���� ����
DECLARE
    e_user_exception EXCEPTION; -- ����� ���� ����
    cnt NUMBER := 0;

BEGIN
    SELECT COUNT(*) INTO cnt
    FROM employees
    WHERE department_id = 40; -- �÷� �̸��� ������ �����ϴ� �̸����� ����

    IF cnt < 5 THEN
        RAISE e_user_exception;
    END IF;

EXCEPTION
    WHEN e_user_exception THEN
        DBMS_OUTPUT.PUT_LINE('5�� ���� �μ� ����');
END;


-- ���� hr> ���Ի���� �Է½� �߸��� �μ���ȣ�� ���ؼ� ����� ���� ó��
-- employee2 ���̺� Ȱ��, ���� �μ���ȣ -> ����� ���� ����, �������� ��� �� �Է� �ɰ�

select *from employees2;

DECLARE
    e_user_exception EXCEPTION; -- ����� ���� ����
    v_empId employees2.employee_id%TYPE;
    v_dept NUMBER := 90;
    employee_record employees%ROWTYPE; -- �ϳ��� ��´�
BEGIN
    SELECT employee_id
    INTO v_empId
    FROM employees2
    WHERE employee_id = (SELECT MAX(employee_id) FROM employees);
    
    BEGIN
        SELECT *
        INTO employee_record
        FROM employees2
        WHERE department_id = v_dept;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_user_exception;
        WHEN TOO_MANY_ROWS THEN
            INSERT INTO employees2(employee_id, first_name, last_name, email, hire_date, job_id) VALUES (
                v_empId + 1, 'HONG', 'gil dong', 'aa@aa.com', SYSDATE, 'AD_VP'
            );
            COMMIT;
        WHEN OTHERS THEN
            INSERT INTO employees2(employee_id, first_name, last_name, email, hire_date, job_id) VALUES (
                v_empId + 1, 'HONG', 'gil dong', 'aa@aa.com', SYSDATE, 'AD_VP'
            );
            COMMIT;
    END;
EXCEPTION
    WHEN e_user_exception THEN
        DBMS_OUTPUT.PUT_LINE('���� �μ� ��ȣ');
END;

-- ����� ����
DECLARE
    p_department_id NUMBER := 60;
    ex_invalid_deptid EXCEPTION;
    v_cnt NUMBER := 0;
    v_employee_id employees2.employee_id%TYPE;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM employees2
    WHERE department_id = p_department_id;
    
    IF v_cnt = 0 THEN
        RAISE ex_invalid_deptid;
    END IF;
    
    SELECT MAX(employee_id) + 1
    INTO v_employee_id
    FROM employees2; 
    
    INSERT INTO employees2(employee_id, last_name, email, hire_date, job_id, department_id) 
    VALUES(v_employee_id, 'bb', 'aa@com', SYSDATE, 'AD_VP', p_department_id);
    
EXCEPTION
    WHEN ex_invalid_deptid THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �����ϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ ����');
END;

select * from employees2;


-- Ŀ��
DECLARE 
    -- Ŀ�� ����
    CURSOR department_cursors IS
        SELECT department_id, department_name, location_id
        FROM departments;
    -- department Ŀ������ �ϳ� ���� ROWTYPE�� ���⿡
    -- ROWTYPE���� �޾���� ��
    department_record department_cursors%ROWTYPE;

BEGIN
    -- Ŀ�� ����
    OPEN department_cursors;
    LOOP
        FETCH department_cursors INTO department_record;
        EXIT WHEN department_cursors%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(department_record.department_id || ' ' ||
                             department_record.department_name || ' ' ||
                             department_record.location_id);
    END LOOP;
    CLOSE department_cursors;
END;

-- FOR..IN
DECLARE 
    -- Ŀ�� ����
    CURSOR department_cursors IS
        SELECT department_id, department_name, location_id
        FROM departments;
    -- department Ŀ������ �ϳ� ���� ROWTYPE�� ���⿡
    -- ROWTYPE���� �޾���� ��
    department_record department_cursors%ROWTYPE;

BEGIN
    FOR department_record IN department_cursors LOOP
        DBMS_OUTPUT.PUT_LINE(department_record.department_id || ' ' ||
                                 department_record.department_name || ' ' ||
                                 department_record.location_id);
    END LOOP;
END;

SELECT * FROM EMPLOYEES;
-- FOR..IN
DECLARE 
    CURSOR employees_cursor IS
        SELECT employee_id, last_name, salary
        FROM EMPLOYEES;
    
    employee_plus NUMBER := 0;
BEGIN
    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('   ���   |  ��   |  �޿�   |   ���� �޿� ');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    
    FOR employees_record IN employees_cursor LOOP
        employee_plus := employee_plus + employees_record.salary;
        DBMS_OUTPUT.PUT_LINE(LPAD(employees_record.employee_id, 8) || ' | ' ||
                             RPAD(employees_record.last_name, 5) || ' | ' ||
                             LPAD(employees_record.salary, 6) || ' | ' ||
                             LPAD( TO_CHAR(employee_plus,'999,999'), 10) );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
END;


DECLARE
    CURSOR employee_cursors IS
    SELECT
        employee_id,
        first_name,
        salary
    FROM
        employees2;

    v_salary_sum    NUMBER := 0;
    employee_record employee_cursors%rowtype;
BEGIN
    FOR employee_record IN  employee_cursors LOOP
    
        v_salary_sum := v_salary_sum + employee_record.salary;
        DBMS_OUTPUT.PUT_LINE(
            employee_record.employee_id || ' '|| employee_record.first_name ||'   '|| employee_record.salary ||'  '|| v_salary_sum );
        
    END LOOP;


end;

select * from countries;
insert into countries values ('zz','��ǳ��Ʈ, ������Ʈ, ���׽�Ʈ', 4);
select country_name  from countries where country_name like '%��ǳ%';
delete from countries where country_name like '%��ǳ%';
