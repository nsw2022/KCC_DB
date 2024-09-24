/*
	이번엔 ORDER BY 문이 사용된 SQL 문 튜닝에 대하여 알아보자
	 
*/

DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    salary INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, department, salary, created_at)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    CASE 
        WHEN n % 10 = 1 THEN 'Engineering'
        WHEN n % 10 = 2 THEN 'Marketing'
        WHEN n % 10 = 3 THEN 'Sales'
        WHEN n % 10 = 4 THEN 'Finance'
        WHEN n % 10 = 5 THEN 'HR'
        WHEN n % 10 = 6 THEN 'Operations'
        WHEN n % 10 = 7 THEN 'IT'
        WHEN n % 10 = 8 THEN 'Customer Service'
        WHEN n % 10 = 9 THEN 'Research and Development'
        ELSE 'Product Management'
    END AS department,  -- 의미 있는 단어 조합으로 부서 이름 생성
    FLOOR(1 + RAND() * 1000000) AS salary,    -- 1부터 1000000 사이의 난수로 나이 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

-- 데이터 조회해서 성능 측정하기  200MS
SELECT * FROM users
ORDER BY salary
LIMIT 100;

# 실행 계획
EXPLAIN SELECT * FROM users
ORDER BY salary
LIMIT 100;

# 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
ORDER BY salary
LIMIT 100;
/*
-> Limit: 100 row(s)  (cost=100569 rows=100) (actual time=607..607 rows=100 loops=1)
    -> Sort: users.salary, limit input to 100 row(s) per chunk  (cost=100569 rows=996636) (actual time=607..607 rows=100 loops=1)
        -> Table scan on users  (cost=100569 rows=996636) (actual time=0.0906..459 rows=1e+6 loops=1)
        
        1. 풀테이블 스캔 (actual time=0.0906..459 rows=1e+6 loops=1)
        rows -> 1,000,000개 엑세스
        2. users.salary를 기준으로 정렬 Sort: users.salary, 
        3. limit으로 인해 100개의 데이터만 조회했다 Limit: 100 row(s)
         
*/

-- 성능 개선을 위한 인덱스 추가
CREATE INDEX idx_salary ON users (salary);

-- sql문 실행시간 60ms
SELECT * FROM users
ORDER BY salary
LIMIT 100;

-- 실행 계획 조회해보기
EXPLAIN SELECT * FROM users
ORDER BY salary
LIMIT 100;

/*
 [이것만은 꼭 기억하자]
- ORDER BY는 시간이 오래걸리는 작업이므로 최대한 피해주는 것이 좋다. 
  인덱스를 사용하면 미리 정렬을 해둔 상태이기 때문에, ORDER BY를 사용해서 정렬해야 하는 번거로운 작업을 피할 수 있다.
   
- LIMIT 없이 큰 범위의 데이터를 조회해오는 경우 옵티마이저가 인덱스를 활용하지 않고 풀 테이블 스캔을 해버릴 수도 있다.
  따라서 성능 효율을 위해 LIMIT을 통해 작은 데이터의 범위를 조회해오도록 항상 신경쓰자.  
*/

