/*
where 문과 order by 문 어디에 인덱스를 걸면좋은지 한번 테스트를 하면서 알아보자

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

-- 성능 측정 580 ms
SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

EXPLAIN SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

/*
SQL문만 봤을 때는 created_at, department, salary 컬럼에 인덱스를 걸 수 있는 선택지가 있다는 걸 알 수 있다.
어떤 컬럼에 거는 게 효율적인지는 하나씩 걸어보고 SQL문의 성능을 측정해서 판단해도 된다. 

그 전에 우리는 미리 예상하는 걸 연습해보자. 
우선 created_at와 department 컬럼 중에서 인덱스를 걸었을 때 효율적인 컬럼은 created_at이라는 걸 예상할 수 있다.
왜냐하면 위의 SQL 문 조건을 봤을 때 department = ‘Sales’의 조건은 데이터 액세스 수가 많을 수 밖에 없다.
하지만 created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)의 조건은 데이터 액세스 수가 적다. 

성능을 향상시키는 데 중요한 요소 중 하나는 데이터 액세스 수를 줄이는 것이다. 
따라서 department보다 created_at에 인덱스를 생성하는 게 더 좋을 것이다. 

그럼 created_at이랑 salary 중에서 인덱스를 걸었을 때 효율적인 컬럼은 어떤 걸까? 
바로 감이 안올 수 있으니 하나씩 인덱스를 걸면서 실행 계획을 보고 판단해보자.

*/

-- slalry 에 인덱스 걸기
CREATE INDEX idx_salary ON users (salary);

-- 성능 측정  3000ms 아까보다 6배증가 ㅋㅋㅋ
SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

-- 실행 계획  잉 type은 index 스캔
EXPLAIN SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

-- 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

/*
-> Limit: 100 row(s)  (cost=9.09 rows=3.33) (actual time=0.593..3688 rows=100 loops=1)
    -> Filter: ((users.created_at >= <cache>((now() - interval 3 day))) and (users.department = 'Sales'))  (cost=9.09 rows=3.33) (actual time=0.592..3688 rows=100 loops=1)
        -> Index scan on users using idx_salary  (cost=9.09 rows=100) (actual time=0.308..3471 rows=885767 loops=1)

1. idx_salary 인덱스를 활용해 스캔을 하였고 인덱스를 사용하였기 때문에 정렬 과정이 따로 필요없다.
2. 그런 뒤 where 조건을 만족시키는 100개를 필터링 한다. **인덱스에는 created_at, department** 정보가 업기때문에
   실제 테이블에 접근해서 조건을 만족하는 지 확인해야한다.
3. 조건을 만족시키는 데이터 100개를 찾는 순단 더이상 탐색하지 않는다.
 	
*/
-- salary 인덱스 삭제 후 created_at에 걸어 확인해보자
ALTER TABLE users DROP INDEX idx_salary; -- 기존 인덱스 삭제
CREATE INDEX idx_created_at ON users (created_at);

-- 성능 측정  20ms
SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

-- 실행 계획 
EXPLAIN SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;

-- 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY)
AND department = 'Sales'
ORDER BY salary
LIMIT 100;
/*
-> Limit: 100 row(s)  (cost=509 rows=100) (actual time=3.58..3.59 rows=100 loops=1)
    -> Sort: users.salary, limit input to 100 row(s) per chunk  (cost=509 rows=1130) (actual time=3.58..3.59 rows=100 loops=1)
        -> Filter: (users.department = 'Sales')  (cost=509 rows=1130) (actual time=0.0462..3.51 rows=116 loops=1)
            -> Index range scan on users using idx_created_at over ('2024-08-24 16:24:27' <= created_at), with index condition: (users.created_at >= <cache>((now() - interval 3 day)))  (cost=509 rows=1130) (actual time=0.0302..3.43 rows=1130 loops=1)
 
 1. idx_created_at 인덱스를 활용해 인덱스 레인지 스캔을 했다 이때 
 users.created_at >= <cache>((now() - interval 3 day)) 를 만족ㅎ는 데이터에만 엑세스했다
 
 2. 1번 과정에서 엑세스한 데이터 중에서 users.department = 'Sales'를 만족하는 데이터를 필터링했다 rows=104
 3. 2번 과정에서 필터링한 104개의 데이터를  users.salary를 기준으로 정렬시켰다
 4. limit으로 인해 데이터를 100개만 가져왔다.
 
 [이것만은 꼭 기억해두자]
 - ORDER BY의 특징 상 모든 데이터를 바탕으로 정렬을 해야 하기 때문에,
  인덱스 풀 스캔 또는 테이블 풀 스캔을 활용할 수 밖에 없다. 
  이 때문에 ORDER BY문보다 WHERE문에 있는 컬럼에 인덱스를 걸었을 때 성능이 향상되는 경우가 많다. 
  (항상 그런건 아니니 성능 측정과 실행 계획을 살펴보는 습관을 들이자.)

*/

