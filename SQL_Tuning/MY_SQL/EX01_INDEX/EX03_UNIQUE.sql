DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);


SHOW INDEX FROM users;

# [이것만은 꼭 기억해두자!]
# - UNIQUE 옵션을 사용하면 인덱스가 같이 생성되기 때문에 조회 성능이 향상된다.