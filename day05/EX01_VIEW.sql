SELECT e.last_name, e.salary, l.street_address
    FROM employees e 
    INNER JOIN departments d ON e.manager_id = d.manager_id
    INNER JOIN locations l ON d.location_id = l.location_id
    WHERE salary<= 4000;
    
    
CREATE VIEW TEST_VIEW AS SELECT e.last_name, e.salary, l.street_address
    FROM employees e 
    INNER JOIN departments d ON e.manager_id = d.manager_id
    INNER JOIN locations l ON d.location_id = l.location_id
    WHERE salary<= 4000;
    
SELECT * 
FROM TEST_VIEW
WHERE SUBSTR(street_address,1,4)='2004';

SELECT * FROM employees;

CREATE VIEW TEST_VIEW2 AS
SELECT employee_id, first_name, last_name, 
       email, phone_number hire_date, job_id
       commission_pct, manager_id department_id
FROM employees;

SELECT *
FROM TEST_VIEW2;
