CREATE OR REPLACE FUNCTION getSalary(p_no employees.employee_id%TYPE)
    RETURN NUMBER
IS  
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = p_no;
    
    RETURN v_salary;
END;

select getSalary(100) from dual;

select * from employees;

/*
���� �����ȣ�� �Է¹޾� �̸��� ��ȯ�ϴ� �Լ��� �������� ������ �����ϱ�
*/

CREATE OR REPLACE FUNCTION getName(p_deptNo employees.department_id%TYPE)
    RETURN VARCHAR2
IS
    result VARCHAR2(50) := null;
BEGIN
    -- ����� �˻�
    select last_name INTO result
    FROM employees
    WHERE employee_id = p_deptNo;
    return result;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN '�ش� ��� ����';
END;
select * from employees;
SELECT getName(90) from dual;