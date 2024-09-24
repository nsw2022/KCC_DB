/*
 방금전 실행계획에 있어 type이 괸장히 중요하다하였는데 type의 유형에 대해 알아보자
 (EX. type이란? : 테이블의 데이터를 어떤 방식으로 조회하는지)
 
*/

-- 테이블 생성
DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

-- 더미데이터 생성
INSERT INTO users (name, age) VALUES 
('Alice', 30),
('Bob', 23),
('Charlie', 35);

-- 실행 계획 조회하기
EXPLAIN SELECT * FROM users WHERE age = 23; # type : all
/*
 type가 ALL로 조회가 되어진다.
 ALL : 풀 테이블 스캔
 풀 테이블 스캔(Full Table Scan)이란 인덱스를 활용하지 않고 
 테이블을 처음부터 끝까지 전부 다 뒤져서 데이터를 찾는 방식이다. 
 처음부터 끝까지 전부 다 뒤져서 필요한 데이터를 찾는 방식이다보니 비효율적이다.
 
 해당 uesrs 테이블에서 데이터들을 age를 기준으로 정렬이 되어있지 않고
 ID를 기준으로 정렬이 되어있다.
 그렇다 보니 데이블의 모든 데이터를 탐색하여 찾아 ALL 이 뜬것이다.
 다음은 INDEX Scan에 대해 알아보자
 */


-- #########################################################

-- 테이블 생성
DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
-- 더미 데이터 생성
-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, age)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')),   -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    FLOOR(1 + RAND() * 1000) AS age    -- 1부터 1000 사이의 난수로 나이 생성
FROM cte;

-- 인덱스 생성
CREATE INDEX idx_name ON users (name);

-- 실생 계획 조회하기
EXPLAIN SELECT * FROM users 
ORDER BY name 
LIMIT 10;

/*
이번에는 백개의 데이터에서 인덱스로 name 을 만든 후
실행 계획을 살펴보면 type: index로 찍혀있다

index : 풀 인덱스 스캔
풀 인덱스 스캔(Full Index Scan)이란 인덱스 테이블을 처음부터 끝까지 다 뒤져서 데이터를 찾는 방식이다. 
인덱스의 테이블은 실제 테이블보다 크기가 작기 때문에, 풀 테이블 스캔(Full Table Scan)보다 효율적이다. 
하지만 인덱스 테이블 전체를 읽어야 하기 때문에 아주 효율적이라고 볼 수는 없다.

1. name을 기준으로 정렬해서 데이터를 가져와야 하기 때문에, name을 기준으로 정렬되어 있는 인덱스를 조회한다. 
(덩치가 큰 users 테이블의 데이터를 하나씩 찾아보면서 정리를 하는 것보다, 이미 name을 기준으로 정렬되어 있는 인덱스를 참고하는 게 효율적이라고 판단한 것이다.)
2. 모든 인덱스의 값을 다 불러온 뒤에 최상단 10개의 인덱스만 뽑아낸다. 
3. 10개의 인덱스에 해당하는 데이터를 users 테이블에서 조회한다.


*/

