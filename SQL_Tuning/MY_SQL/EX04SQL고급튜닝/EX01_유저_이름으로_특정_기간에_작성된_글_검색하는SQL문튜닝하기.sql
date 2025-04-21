use turning;

DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

-- 1. 기본 테이블 셋팅
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);



-- 2. 더미데이터 추가
-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- users 테이블에 더미 데이터 삽입
INSERT INTO users (name, created_at)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

-- posts 테이블에 더미 데이터 삽입
INSERT INTO posts (title, created_at, user_id)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('Post', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at, -- 최근 10년 내의 임의의 날짜와 시간 생성
    FLOOR(1 + RAND() * 50000) AS user_id -- 1부터 50000 사이의 난수로 급여 생성
FROM cte;


-- 3. 기존 SQL 성능 측정하기
-- 22년 1월 11부터 24년 3월 7일 까지 User0000046 이 작성한 게시글을 조회하는 SQL 문이다.
SELECT p.id, p.title, p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'User0000046'
AND p.created_at BETWEEN '2022-01-01' AND '2024-03-07';

-- 4. 실행 계획 조회해보기
EXPLAIN SELECT p.id, p.title, p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'User0000046'
AND p.created_at BETWEEN '2022-01-01' AND '2024-03-07';
/*
 id|select_type|table|partitions|type  |possible_keys|key    |key_len|ref              |rows  |filtered|Extra      |
--+-----------+-----+----------+------+-------------+-------+-------+-----------------+------+--------+-----------+
 1|SIMPLE     |p    |          |ALL   |user_id      |       |       |                 |997442|   11.11|Using where|
 1|SIMPLE     |u    |          |eq_ref|PRIMARY      |PRIMARY|4      |turning.p.user_id|     1|    10.0|Using where| 
 */

/* 5. 성능 개선해보기
 위 쿼리를 싱행해보면 type이 ALL 인것을 확인 할 수 있다 
 각 테이블의 p와 u는 alias 로 지정한 것을 의미한다

이때 사용한 ref에 보면 p의 user_id를 통해 조인을 한 것을 확인할 수 있다.



이제 이것을 성능 개선해보자

풀테이블 스캔은 인덱스를 추가하면 성능이 향상된다

인덱스를 추가할 수 있는 컬럼의 후보는 where 에 있는것을 보통 사용한다 where에 사용한 컬럼은 name과 create_at 이다

두줄에 누가 좋을지는 둘다 추가하여 보자
 **/

CREATE INDEX idx_name ON users (name);
CREATE INDEX idx_created_at ON posts (created_at);


-- 6. 다시 성능 측정
SELECT p.id, p.title, p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'User0000046'
AND p.created_at BETWEEN '2022-01-01' AND '2024-03-07';
-- 일단 성능이 빨라진 것을 확인할 수 있다

-- 7. 다시 성능 계획
EXPLAIN SELECT p.id, p.title, p.created_at
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'User0000046'
AND p.created_at BETWEEN '2022-01-01' AND '2024-03-07';
/*
 id|select_type|table|partitions|type|possible_keys         |key     |key_len|ref         |rows|filtered|Extra      |
--+-----------+-----+----------+----+----------------------+--------+-------+------------+----+--------+-----------+
 1|SIMPLE     |u    |          |ref |PRIMARY,idx_name      |idx_name|152    |const       |   1|   100.0|Using index|
 1|SIMPLE     |p    |          |ref |user_id,idx_created_at|user_id |5      |turning.u.id|  20|   44.76|Using where|
 
 name 이라는 idx는 잘 활용하지만 idx_created_at 는 사용하지 않는걸 확인할 수 있음
 이렇게 까지 확인했다면 사용하지 않는 인덱스는 삭제해주어야 함
 */

-- 8. 인덱스 삭제
ALTER TABLE posts DROP INDEX idx_created_at;
