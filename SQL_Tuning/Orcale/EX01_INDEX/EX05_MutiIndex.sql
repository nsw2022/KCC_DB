/*
 멀티 컬럼 인덱스란, 2개 이상의 컬럼을 묶어서 설정하는 인덱스를 뜻한다. 
 즉, 데이터를 빨리 찾기 위해 2개 이상의 컬럼을 기준으로 미리 정렬해놓은 표이다. 
*/
-- 테이블이 존재하는지 확인 후 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users PURGE';
    EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

DROP SEQUENCE users_seq;

-- 시퀀스 생성
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;

-- 테이블 생성
CREATE TABLE users (
    id INT PRIMARY KEY,
    이름 VARCHAR2(100),
    부서 VARCHAR2(100),
    나이 INT
);

-- 데이터 삽입
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '박미나', '회계', 26);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '김미현', '회계', 23);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '김민재', '회계', 21);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '이재현', '운영', 24);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '조민규', '운영', 23);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '하재원', '인사', 22);
INSERT INTO users (id, 이름, 부서, 나이) VALUES (users_seq.nextVAL, '최지우', '인사', 22);

-- 멀티 컬럼 인덱스 생성
CREATE INDEX idx_부서_이름 ON users (부서, 이름);

-- 인덱스 조회 (Oracle 방식)
SELECT index_name, table_name, column_name
FROM user_ind_columns
WHERE table_name = 'USERS';

-- 조건에 맞는 데이터 조회
SELECT * FROM users
WHERE 부서 = '인사'
ORDER BY 이름;


/*
[이것만은 꼭 기억해두자!]
- 멀티 컬럼 인덱스 컬럼의 순서는 매우 중요하다.
- 멀티 컬럼 인덱스에서 처음에 배치된 컬럼들은 일반 인덱스처럼 활용할 수 있다.
- 멀티 컬럼 인덱스를 구성할 때 데이터 중복도가 높은 컬럼이 앞쪽으로 오는 게 좋다.  
*/
