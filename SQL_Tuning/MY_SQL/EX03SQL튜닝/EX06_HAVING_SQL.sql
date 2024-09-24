-- sql 튜닝

DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    department VARCHAR(100),
    salary INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, age, department, salary, created_at)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    FLOOR(1 + RAND() * 100) AS age, -- 1부터 100 사이의 난수로 생성
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
    FLOOR(1 + RAND() * 1000000) AS salary,    -- 1부터 1000000 사이의 난수로 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

-- 인덱스 생성하기
CREATE INDEX idx_age ON users (age);


-- 데이터 조회해서 성능 측정하기   3초 걸림
SELECT age, MAX(salary) FROM users
GROUP BY age
HAVING age >= 20 AND age < 30;

-- 실행계획 조회
EXPLAIN SELECT age, MAX(salary) FROM users
GROUP BY age
HAVING age >= 20 AND age < 30;

-- 상세조회
EXPLAIN ANALYZE SELECT age, MAX(salary) FROM users
GROUP BY age
HAVING age >= 20 AND age < 30;
/*
-> Filter: ((users.age >= 20) and (users.age < 30))  (cost=200263 rows=90) (actual time=572..3354 rows=10 loops=1)
    -> Group aggregate: max(users.salary)  (cost=200263 rows=90) (actual time=25.9..3353 rows=100 loops=1)
        -> Index scan on users using idx_age  (cost=100624 rows=996389) (actual time=0.482..3275 rows=1e+6 loops=1)

1. idx_age 라는 인덱스를 활용하여 users table 조회
   인덱스에는 salary 값이 없어 실제 데이터에 접근해야하기 위해 1번에서 100만개에 다 접근할수 밖에없음
   
2. 그룹화를하여 최댓값을 구함 Group aggregate: max(users.salary)  (cost=200263 rows=90) (actual time=25.9..3353 rows=100 loops=1)
   
   
3. Filter 링 작업도 그렇게 오래걸리진않음 

결론 비효율적인 원인은 인덱스에 없는 값을 검색하여 실제 테이블을 조회했어야했기 때문
고로 코드를 수정해보자

*/

-- 기존코드
SELECT age, MAX(salary) FROM users
GROUP BY age
HAVING age >= 20 AND age < 30;

-- 바꿀 코드 해빙에서 필터링 하는 것이 아닌 where 절에서 먼저 걸러주는것
-- 300ms 로 10분의 1이 줄었다
SELECT age, MAX(salary) FROM users
WHERE age >= 20 AND age < 30
GROUP BY age;

EXPLAIN ANALYZE SELECT age, MAX(salary) FROM users
WHERE age >= 20 AND age < 30
GROUP BY age;

/*
[이것만은 꼭 기억해두자!]
- HAVING문 대신에 WHERE문을 쓸 수 있는 지 체크해보자.
(어쩔 수 없이 HAVING을 쓸 수 밖에 없는 경우도 존재한다.)  
*/

