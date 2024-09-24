DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, department, created_at)
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
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

-- 잘 생성됐는 지 확인
SELECT COUNT(*) FROM users;
SELECT * FROM users LIMIT 10;


-- 데이터 조회해서 성능 측정하기
SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY); -- 평균 600

-- 실행계획 조회
EXPLAIN SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

/*
	TYPE -> ALL 풀스캔으로 전부조회함
	rows도 9만건 이상

*/
-- 성능상 비효율적

CREATE INDEX idx_created_at ON users (created_at);

SHOW INDEX FROM users;

-- 데이터 조회해서 성능 측정하기
SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY); -- 평균 40

-- 실행계획 조회
EXPLAIN SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY); 
/*
  
  TYPE -> range -> index 풀스캔으로 전부조회함
  rows도 1000건 정도
  범위데이터로 조회해서 각각필요한 데이터만 꺼내오기때문에 성능이 좋다
  [꼭 기억하자] where 문의 부등호 > < <= >= 와 같은곳에서 사용하는 컬럼은 **인덱스를** 사용했을때 향상될 가능성이 높다
  
*/




