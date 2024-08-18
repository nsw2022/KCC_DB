DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO users (id, name) VALUES 
(1, 'a'),
(3, 'b'),
(5, 'c'),
(7, 'd');

SELECT * FROM users;

UPDATE users
SET id = 2
WHERE id = 7;

SELECT * FROM users;

# 특정 테이블 인덱스 조회
# SHOW INDEX FROM 테이블명;
SHOW INDEX FROM users; 

# [이것만은 꼭 기억해두자!]
# - PK에는 인덱스가 기본적으로 적용된다.
# - PK에는 인덱스가 적용되어 있으므로 PK를 기준으로 데이터가 정렬된다.
