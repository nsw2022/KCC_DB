DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);


select * from users;

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
    FLOOR(1 + RAND() * 1000) AS age    -- 1부터 1000 사이의 랜덤 값으로 나이 생성
FROM cte;

-- 잘 생성됐는 지 확인
SELECT count(*) FROM users;

select * from users where age = 23;

# 인덱스 생성
# CREATE INDEX 인덱스명 ON 테이블명 (컬럼명);
CREATE INDEX idx_age ON users(age);

# SHOW INDEX FROM 테이블명;
SHOW INDEX FROM users;

# [이것만은 꼭 기억해두자!]
# -  인덱스란 데이터를 빨리 찾기 위해 특정 컬럼을 기준으로 미리 정렬해놓은 표