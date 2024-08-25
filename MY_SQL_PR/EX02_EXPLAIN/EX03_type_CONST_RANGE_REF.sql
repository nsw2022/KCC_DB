/*
  이번 type은 const range ref 를 알아볼꺼다 먼저 const부터 알아보자
  
  const는 조회하고자 하는 1건의 데이터가 헤메지않고 단번에 찾아올 수 있을대 const가 출력된다.
  그러다 보니 고유인덱스 또는 기본 키를 사용해서 1건의 데이터만 조회한 경우에 const가 출력된다. 이 방식은 효율적인 방식이다.
  
 
 - 인덱스가 없다면 특정 값을 일일이 다 뒤져야 한다. 그래서 1건의 데이터를 바로 찾을 수 없다.
 - 인덱스가 있는데 고유하지 않다며(NOT UNIQUE) 원하는 1건의 데이터를 찾았다고 하더라도, 나머지 데이터에 같은 값이 있을지도 모르므로 다른 데이터를 탐색해봐야한다.
 - 고유하다면(UNIQUE) 1건의 데이터를 찾는 순간, 나머지 데이터는 아에 볼 필요가 없어진다. 왜나하면 찾고자 하는 데이터가 유일한 데이터이기 때문이다
   → 고유 인덱스와 기본 키는 전부 UNIQUE한 특성을 가지고 있다. 
  
 */

-- 테이블 생성하기
DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account VARCHAR(100) UNIQUE
);

-- 더미 데이터 넣기
INSERT INTO users (account) VALUES 
('user1@example.com'),
('user2@example.com'),
('user3@example.com');

-- 실행 계획 조회하기
EXPLAIN SELECT * FROM users WHERE id = 3;
EXPLAIN SELECT * FROM users WHERE account = 'user3@example.com';
-- 상당히 빠르게 접근할수있는걸 볼수있다..! rows가 둘다 1


-- ############################################################
/*
range : 인덱스 레인지 스캔 (Index Range Scan)
인덱스 레인지 스캔(Index Range Scan) 은 인덱스를 활용해 범위 형태의 데이터를 조회한 경우를 의미한다.
범휘형태란 BETWEEN, 부등호(<, >, <=, >=), IN, LIKE 를 활용한 데이터 조회를 뜻한다.
이 방식은 인덱스를 활용하기 때문에 효율적인 방식이다, 하지만인덱스를 사용하더라도 데이터를 조회하는 범위가 클 경우
성능 저하의 원인이 되기도 한다.
  
      
*/

-- 데이블 생성하기
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    age INT
);

-- 더미 데이터 넣기
-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000;  

-- 더미 데이터 삽입 쿼리
INSERT INTO users (age)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    FLOOR(1 + RAND() * 1000) AS age    -- 1부터 1000 사이의 난수로 나이 생성
FROM cte;

-- 인덱스 생성하기
CREATE INDEX idx_age ON users(age);
DROP INDEX idx_age ON users; -- 시간적 여유ㅜ가된다면 아래 명령문들을 실행하기전에 인덱스를 제거하고 rows를 배교해보자 엄청난다


-- 실행 게획 조회하기
EXPLAIN SELECT * FROM users
WHERE age BETWEEN 10 and 20;

EXPLAIN SELECT * FROM users
WHERE age IN (10, 20, 30);

EXPLAIN SELECT * FROM users
WHERE age < 20;


-- #####################################################################
/*
 
  ref : 비고유 인덱스를 활용하는 경우
  비고유 인덱스를 사용하는 경우 (UNIQUE가 아닌 컬럼 인덱스를 사용한 경우) type ref가 출력된다.
*/

-- 테이블 생성하기
DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- 더미 데이터 넣기
INSERT INTO users (name) VALUES 
('박재성'),
('김지현'),
('이지훈');

-- 인덱스 생성하기
CREATE INDEX idx_name ON users(name);

-- 실행계획 조회하기
EXPLAIN SELECT * FROM users WHERE name = '박재성';
