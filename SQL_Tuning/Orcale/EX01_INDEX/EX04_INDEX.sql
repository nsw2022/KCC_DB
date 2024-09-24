/*
  인덱스를 사용하면 데이터를 조회할 때의 성능이 향상된다. 
  그러면 인덱스를 무조건적으로 많이 추가하는 게 좋다고 착각할 수도 있다. 
  하지만 인덱스를 추가하면 조회 성능은 올라가지만, 쓰기 작업(삽입, 수정, 삭제)의 성능은 저하된다.
  
   
  인덱스를 사용하면 데이터를 조회할 때의 성능이 향상된다.
  그러면 인덱스를 무조건적으로 많이 추가하는 게 좋다고 착각할 수도 있다. 
  하지만 인덱스를 추가하면 조회 성능은 올라가지만, 쓰기 작업(삽입, 수정, 삭제)의 성능은 저하된다.  
  
  실제로 그런지 테스트 해보자
*/

-- 시퀀스 생성
CREATE SEQUENCE test_table_no_index_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE test_table_many_indexes_seq START WITH 1 INCREMENT BY 1;

-- 테이블 A: 인덱스가 없는 테이블
CREATE TABLE test_table_no_index (
    id INT PRIMARY KEY,
    column1 INT,
    column2 INT,
    column3 INT,
    column4 INT,
    column5 INT,
    column6 INT,
    column7 INT,
    column8 INT,
    column9 INT,
    column10 INT
);

-- 테이블 B: 인덱스가 많은 테이블
CREATE TABLE test_table_many_indexes (
    id INT PRIMARY KEY,
    column1 INT,
    column2 INT,
    column3 INT,
    column4 INT,
    column5 INT,
    column6 INT,
    column7 INT,
    column8 INT,
    column9 INT,
    column10 INT
);

-- 각 컬럼에 인덱스를 추가
CREATE INDEX idx_column1 ON test_table_many_indexes (column1);
CREATE INDEX idx_column2 ON test_table_many_indexes (column2);
CREATE INDEX idx_column3 ON test_table_many_indexes (column3);
CREATE INDEX idx_column4 ON test_table_many_indexes (column4);
CREATE INDEX idx_column5 ON test_table_many_indexes (column5);
CREATE INDEX idx_column6 ON test_table_many_indexes (column6);
CREATE INDEX idx_column7 ON test_table_many_indexes (column7);
CREATE INDEX idx_column8 ON test_table_many_indexes (column8);
CREATE INDEX idx_column9 ON test_table_many_indexes (column9);
CREATE INDEX idx_column10 ON test_table_many_indexes (column10);

-- 인덱스 조회
SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE table_name IN ('TEST_TABLE_NO_INDEX', 'TEST_TABLE_MANY_INDEXES');

-- 더미 데이터 삽입
-- 인덱스가 없는 테이블에 데이터 10만개 삽입  소요시간 2.8 초
INSERT INTO test_table_no_index (id, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10)
SELECT 
	test_table_no_index_seq.NEXTVAL,
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000))
FROM dual
CONNECT BY level <= 100000;

-- 인덱스가 많은 테이블에 데이터 10만개 삽입  --47초 소요
INSERT INTO test_table_many_indexes (id, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10)
SELECT 
	test_table_many_indexes_seq.NEXTVAL,
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000)), 
    TRUNC(DBMS_RANDOM.VALUE(1, 1000))
FROM dual
CONNECT BY level <= 100000;

/*
[이것만은 꼭 기억해두자!]
- 최소한의 인덱스만 사용하려고 하자.
- 인덱스를 추가하면 조회 속도는 빨라지나, 쓰기(삽입, 수정, 삭제) 속도는 느려짐을 항상 기억하자.
*/