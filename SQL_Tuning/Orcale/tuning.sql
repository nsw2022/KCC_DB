-- 테이블과 시퀀스가 이미 존재하는 경우 삭제
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users PURGE';
    EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

-- 시퀀스 생성
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;

-- 테이블 생성
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR2(100),
    age INT
);


-- 데이터 삽입
BEGIN
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '박미나', 26);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '김미현', 23);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '김민재', 21);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '이재현',  24);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '조민규', 23);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '하재원', 22);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '최지우', 22);
    COMMIT;
END;

-- 실행 계획 설정
EXPLAIN PLAN FOR
SELECT * FROM users WHERE age = 23;

-- 실행 계획 출력
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- 실행 계획 재정의
-- 멀티 컬럼 인덱스 생성
CREATE INDEX idx_name_age ON users (name, age);

-- 실행 계획 재설정 및 출력
EXPLAIN PLAN FOR
SELECT * FROM users WHERE name = '김미현' AND age = 23;

-- 실행 계획 출력
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
