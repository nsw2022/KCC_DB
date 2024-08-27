/*
	인덱스를 걸었는데 인덱스가 작동하지 않는경우에 대해 알아보자  
*/

DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

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

-- 실행 계획 조회해보기
EXPLAIN SELECT * FROM users 
ORDER BY name DESC;

/*
	실행계획을 확인해보면 type이 all 인것을 확인할 수 있고 possible_keys도 null인걸 확인할 수 있다.
	우리는 전체 테이블을 조회하였기때문에 옵티마이저가 넓은 범위의 데이터를 조회할 때는 인덱스를 활용하는것이
	비효율적이라고 판단한다.
	굳이 인덱스를 거쳤다가 각 원래 테이블로 데이터를 일일이 하나씩 찾아내는것 보다 바로 원래 테이블에 접근해서
	모든 데이터를 통째로 가져와서 정렬하는게 효율적이라고 판단하는것 실제 성능도 풀테이블 스캔을 통해 가져오는게 효율적이다.
*/