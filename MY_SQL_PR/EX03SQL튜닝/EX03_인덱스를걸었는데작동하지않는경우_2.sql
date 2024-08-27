/*
	인덱스를 걸었는데 작동하지않는 두번째 경우이다
*/

DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    salary INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- users 테이블에 더미 데이터 삽입
INSERT INTO users (name, salary, created_at)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    FLOOR(1 + RAND() * 1000000) AS salary,    -- 1부터 1000000 사이의 난수로 급여 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

CREATE INDEX idx_name ON users (name);
CREATE INDEX idx_salary ON users (salary);

# User000000으로 시작하는 이름을 가진 유저 조회
EXPLAIN SELECT * FROM users
WHERE SUBSTRING(name, 1, 10) = 'User000000';

# 2달치 급여(salary)가 1000 이하인 유저 조회
EXPLAIN SELECT * FROM users
WHERE salary * 2 < 1000
ORDER BY salary;

/*
	분명 인덱스를 생성했는데 왜 활용하지않는걸까?
	SQL문을 작성할 인덱스 컬럼을 가공(함수 적용, 산술 연산, 문자열 조작 등)
	MySQL은 해당 인덱스를 활용하지 못하는 경우가 많다. 따라서 인덱스를 적극 활용하기 위해서는
	인덱스 컬럼 자체를 최대한 가공하지 않아야 한다
	이번엔 인덱스 컬럼을 가공하지 않게끔 최대한 수정해보자
*/

# User000000으로 시작하는 이름을 가진 유저 조회
EXPLAIN SELECT * FROM users
WHERE name LIKE 'User000000%';

# 2달치 급여(salary)가 1000 이하인 유저 조회
EXPLAIN SELECT * FROM users
WHERE salary < 1000 / 2
ORDER BY salary;

/*
[이것만은 꼭 기억해두자!]
- 인덱스 컬럼을 가공(함수 적용, 산술 연산, 문자역 조작 등)하면, 
  MySQL은 해당 인덱스를 사용하지 못하는 경우가 많다. 
  따라서 인덱스를 적극 활용하기 위해서는 인덱스 컬럼 자체를 최대한 가공하지 않아야 한다.   
*/