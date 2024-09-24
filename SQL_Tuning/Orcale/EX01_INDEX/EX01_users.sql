/*
[declare begin end 기본구조 설명 및 문법실행]
1. declare begin end - PL/SQL 기본으로 쿼리, 문법을 실행할 수 있습니다
2. declare [선언부] - 변수, 상수를 선언할 수 있습니다
3. begin [실행부] - 제어, 반복문, 함수 등 다양한 로직 기술을 실행합니다
4. end [종료부] - 실행된 로직의 종료를 선언합니다
5. 실행한 결과는 DBMS_OUTPUT에서 확인할 수 있습니다
*/

/* PL/SQL 블록을 사용하여 기존의 'users' 테이블과 'users_seq' 시퀀스를 삭제 */
BEGIN
    -- 'users' 테이블을 동적 SQL을 사용하여 삭제
    EXECUTE IMMEDIATE 'DROP TABLE users';
    -- 'users_seq' 시퀀스를 동적 SQL을 사용하여 삭제
    EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq';

-- 예외 처리 섹션
EXCEPTION
    -- 모든 예외를 캐치하는 절
    WHEN OTHERS THEN
        -- 특정 오류(-942: 존재하지 않는 테이블 또는 뷰)가 아닌 다른 오류 발생 시 예외를 다시 발생
        IF SQLCODE != -942 THEN
            RAISE;
        -- 존재하지 않는 테이블 또는 시퀀스 오류는 무시
        END IF;
END;

/* 시퀀스 'users_seq' 생성: 새로운 사용자 ID를 자동으로 생성하기 위한 시퀀스 */
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;

/* 'users' 테이블 생성 */
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR2(100),
    age INT
);

/* 테이블에 데이터가 삽입될 때마다 자동으로 id 값을 증가시키는 트리거 설정 */
CREATE OR REPLACE TRIGGER users_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    -- 'users_seq' 시퀀스에서 다음 값을 가져와 새로운 행의 'id'에 할당
    SELECT users_seq.NEXTVAL INTO :new.id FROM dual;
END;
/

/* 더미 데이터 삽입: 'users' 테이블에 1,000,000개의 더미 데이터를 삽입 */
INSERT INTO users (name, age)
SELECT 'User' || LPAD(TO_CHAR(level), 7, '0'), TRUNC(DBMS_RANDOM.VALUE(1, 1000001))
FROM dual
CONNECT BY level <= 1000000; -- 재귀 쿼리를 사용하여 1부터 1,000,000까지의 데이터 생성

/* 'users' 테이블에 있는 모든 레코드 수 조회 */
SELECT COUNT(*) FROM users;

/* 인덱스 생성: 'age' 컬럼에 대한 인덱스를 생성하여 조회 성능 향상 */
CREATE INDEX idx_age ON users(age);

/* 인덱스 조회: 'users' 테이블에 생성된 모든 인덱스 정보 조회 */
-- 이 쿼리는 데이터베이스 관리자에게 해당 테이블의 인덱스 구성과 성능을 분석하는 데 유용
SELECT * FROM user_indexes WHERE table_name = 'USERS';

-- # 이것만은 꼭 기억해두자!
-- 인덱스란 데이터를 빨리 찾기 위해 특정 컬럼을 기준으로 미리 정렬해놓은 표
