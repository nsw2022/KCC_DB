/*
 멀티 컬럼 인덱스란, 2개 이상의 컬럼을 묶어서 설정하는 인덱스를 뜻한다. 
 즉, 데이터를 빨리 찾기 위해 2개 이상의 컬럼을 기준으로 미리 정렬해놓은 표이다. 
*/

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    이름 VARCHAR(100),
    부서 VARCHAR(100),
    나이 INT
);

INSERT INTO users (이름, 부서, 나이) VALUES
('박미나', '회계', 26),
('김미현', '회계', 23),
('김민재', '회계', 21),
('이재현', '운영', 24),
('조민규', '운영', 23),
('하재원', '인사', 22),
('최지우', '인사', 22);

# CREATE INDEX idx_부서_이름 ON users (부서, 이름);
CREATE INDEX idx_부서_이름 ON users (부서, 이름);
SHOW INDEX FROM users;


SELECT * FROM users
WHERE 부서 = '인사' 
ORDER BY 이름;

/*
[이것만은 꼭 기억해두자!]
- 멀티 컬럼 인덱스 컬럼의 순서는 매우 중요하다.
- 멀티 컬럼 인덱스에서 처음에 배치된 컬럼들은 일반 인덱스처럼 활용할 수 있다.
- 멀티 컬럼 인덱스를 구성할 때 데이터 중복도가 높은 컬럼이 앞쪽으로 오는 게 좋다.  
*/
