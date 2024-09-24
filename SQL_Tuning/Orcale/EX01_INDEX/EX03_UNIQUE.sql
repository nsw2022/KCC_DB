-- 기존 테이블 삭제 로직 (Oracle은 DROP TABLE IF EXISTS를 지원하지 않음)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

-- 테이블 생성
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR2(100)
);

-- 데이터 삽입
INSERT INTO users (id, name) VALUES (1, 'a');
INSERT INTO users (id, name) VALUES (3, 'b');
INSERT INTO users (id, name) VALUES (5, 'c');
INSERT INTO users (id, name) VALUES (7, 'd');

-- 모든 데이터 조회
SELECT * FROM users;

-- 데이터 업데이트
UPDATE users
SET id = 2
WHERE id = 7;

-- 업데이트 후 데이터 조회
SELECT * FROM users;

-- 특정 테이블의 인덱스 조회 (Oracle 방식)
-- 인덱스를 생성하면 USER_INDEXES 시스템 뷰에서 조회할 수 있습니다.
SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'USERS';

-- [이것만은 꼭 기억해두자!]
-- 인덱스 정보와 PK 관련 주의 사항
-- 오라클에서는 PRIMARY KEY가 자동으로 인덱스를 생성하며, 이 인덱스는 데이터를 정렬하는 데 사용됩니다.
-- 좀더 심화해서 말하면 Orclae의 PRIMARY KEY 인덱스는 내부적으로 B-tree 구조를 사용하기에
-- 키값을 기준으로 계층적으로 정렬하여 저장하지만 물리적인 데이터의 저장 순서를 변경하진 않음
-- 따라서 인덱스는 데이터를 효율적으로 검색할 수 있도록 인덱스 키 값에 따라 내부적으로 정렬된 구조를 가짐
