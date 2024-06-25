set SERVEROUTPUT on;


/*
DECLARE
    v_no NUMBER := 10;
    v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
    
    -- 상수 선언
    c_message CONSTANT VARCHAR2(50):= 'Hello PL/SQL!!!';
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PL/SQL 수업');
        DBMS_OUTPUT.PUT_LINE(c_message);
        DBMS_OUTPUT.PUT_LINE(v_hireDate);
    END;
    
*/
-- 변수 선언
DECLARE
    v_no NUMBER := 10;
    v_hireDate VARCHAR2(30) := TO_CHAR(SYSDATE, 'YYYY/MM/DD');
    
    -- 상수 선언
    c_message CONSTANT VARCHAR2(50):= 'Hello PL/SQL!!!';
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PL/SQL 수업');
        DBMS_OUTPUT.PUT_LINE(c_message);
        DBMS_OUTPUT.PUT_LINE(v_hireDate);
    END;
    
    
-- 문제 특정 employes 테이블의 로우를 검색하여 변수에 할당해보자.
DECLARE
    v_name VARCHAR2(20);
    v_salary NUMBER;
    v_hireDate VARCHAR2(30);
BEGIN
    SELECT first_name, salary, TO_CHAR(sysdate, 'YYYY-MM-DD')
    INTO v_name, v_salary, v_hireDate
    FROM employees
    WHERE first_name = 'Ellen';
    
    DBMS_OUTPUT.PUT_LINE('검색된 사원의 정보:');
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_salary || ' ' || v_hireDate);
END;

select * from departments;
select * from employees;

desc departments;
-- 퀴즈 hr> 사원번호 100번에 해당하는 사원의 이름과 부서명을 출력하시오.
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
    DBMS_OUTPUT.PUT_LINE('검색된 사원의 정보:');
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_deptName || ' ' || v_deptno);
end;

-- 기본자료형
/*
 DECLARE
    -- 기본형 데이터형
    v_search varchar2(20):= 'Lisa';
    -- 레퍼런스형
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
    -- 기본형 데이터형
    v_search varchar2(20):= 'Lisa';
    -- 레퍼런스형
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
1. 사원테이블에서 201번 사원의 이름과 이메일을 출력하라.(레퍼런스 형)
2. employees => employees2 qhrtk
   사원 테이블에서 사원번호가 가장 큰 사원을 찾은후 사원번호 +1 번으로 아래의 사원을 추가하라
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
-- ROWTYPE -> 1개의 로우 타입을 갖는다
 
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

-- scott>40번 부서의 부서정보를 rowtype을 이용해서 출력하자
DECLARE
    v_loc dept%Rowtype;
BEGIN
    SELECT * INTO v_loc
    FROM dept
    where deptno = 40;
    
    dbms_output.put_line(v_loc.deptno ||' '|| v_loc.dname ||' '|| v_loc.loc);
    
end;
--제어문
/*
    
*/

DECLARE
    v_no NUMBER := 7;
    v_score NUMBER := 80;
BEGIN
    --단수
    /*
    IF v_no = 7 THEN
        DBMS_OUTPUT.PUT_LINE('7이다');
    END IF;
    */
    -- IF ~ ELSE ~ END IF
    /*
    IF v_no = 5 THEN
        DBMS_OUTPUT.PUT_LINE('5이다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('5가 아니다');
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

-- 난수구하기 10~120사이에 임의의 부서번호를 받아서 해당 부서의 평균 급여에 따라서 등급이 출력되도록 하자.
DECLARE
    v_SAL employees.salary%TYPE;
BEGIN

    SELECT AVG(SALARY)
    INTO v_sal
    FROM EMPLOYEES
    WHERE department_id = ROUND(DBMS_RANDOM.VALUE(10,120),-1)
    GROUP BY DEPARTMENT_ID;
    /*
    if v_SAL>=6000 then dbms_output.put_line('높음');
    elsif v_SAL>=3000 then dbms_output.put_line('보통');
    else dbms_output.put_line('낮음');
    end if;
    */
    case when v_sal BETWEEN 1 and 3000 then
        dbms_output.put_line('낮음');
    when v_sal BETWEEN 3000 and 6000 then
        dbms_output.put_line('보통');
    else
        dbms_output.put_line('높음');
    end case;
END;

-- 반복문

DECLARE
    i NUMBER := 0;
    total NUMBER := 0;

BEGIN
    LOOP
    i := i+1;
    total := total + i;
    -- 조건
    EXIT WHEN i >= 10;
    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(total);
END;

-- 반복문 WHILE
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

-- 반복문 FOR
DECLARE
    i NUMBER := 0;
    total NUMBER := 0;
BEGIN
  FOR i IN 1..10 LOOP
     total := total + i;
  END LOOP;
    DBMS_OUTPUT.PUT_LINE(total);
END;

-- LOOP => 구구단 3단 
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


-- 예외(Exception)
/*
- PL/SQL 오류를 예외라고 한다.
- 컴파일시 문법적 오류, 실행시 발생하는 오류
- 미리 정의된 오라클 서버예외 : 선언할 필요 없고, 발생시 자동으로 ㅇㅣ동
- 사용자 예외를 강제로 발생 : 선언부에서 예외 정의, 실행부에서 RAISC문 사용

*/
DECLARE
    employee_record employees%ROWTYPE; --> 하나만 담는다.

BEGIN 
    SELECT employee_id, last_name, department_id
    INTO employee_record.employee_id,
        employee_record.last_name,
        employee_record.department_id
    FROM employees
    WHERE department_id = 50;
    
    EXCEPTION 
    -- UNIQUE 제약조건을 갖는 컬럼에 중복된 데이터 insert
    WHEN DUP_VAL_ON_INDEX THEN 
    DBMS_OUTPUT.PUT_LINE('이미 존재하는 사람입니다.');
    
-- SELECT문 결과 2개 이상의 로우를 반환
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('검색된 로우가 많습니다.');
    
-- 데이터가 없을 때
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('검색된 사원이 많습니다.');
    
-- 그 밖의 예외 사유
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('기타 예외');
END;


-- 사용자가 강제로 예외 발생 => 예외 정의
DECLARE
    e_user_exception EXCEPTION; -- 사용자 예외 정의
    cnt NUMBER := 0;

BEGIN
    SELECT COUNT(*) INTO cnt
    FROM employees
    WHERE department_id = 40; -- 컬럼 이름을 실제로 존재하는 이름으로 수정

    IF cnt < 5 THEN
        RAISE e_user_exception;
    END IF;

EXCEPTION
    WHEN e_user_exception THEN
        DBMS_OUTPUT.PUT_LINE('5명 이하 부서 금지');
END;


-- 퀴즈 hr> 신입사원을 입력시 잘못된 부서번호에 대해서 사용자 예외 처리
-- employee2 테이블 활용, 없는 부서번호 -> 사용자 정의 예외, 정상적일 경우 잘 입력 될것

select *from employees2;

DECLARE
    e_user_exception EXCEPTION; -- 사용자 예외 정의
    v_empId employees2.employee_id%TYPE;
    v_dept NUMBER := 90;
    employee_record employees%ROWTYPE; -- 하나만 담는다
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
        DBMS_OUTPUT.PUT_LINE('없는 부서 번호');
END;

-- 강사님 버전
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
        DBMS_OUTPUT.PUT_LINE('해당 부서가 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 예외');
END;

select * from employees2;


-- 커서
DECLARE 
    -- 커서 선언
    CURSOR department_cursors IS
        SELECT department_id, department_name, location_id
        FROM departments;
    -- department 커서들의 하나 값은 ROWTYPE과 같기에
    -- ROWTYPE으로 받아줘야 함
    department_record department_cursors%ROWTYPE;

BEGIN
    -- 커서 열기
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
    -- 커서 선언
    CURSOR department_cursors IS
        SELECT department_id, department_name, location_id
        FROM departments;
    -- department 커서들의 하나 값은 ROWTYPE과 같기에
    -- ROWTYPE으로 받아줘야 함
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
    -- 헤더 출력
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('   사번   |  성   |  급여   |   누적 급여 ');
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
insert into countries values ('zz','통풍시트, 열선시트, 가죽시트', 4);
select country_name  from countries where country_name like '%통풍%';
delete from countries where country_name like '%통풍%';
