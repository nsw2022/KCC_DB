/*
  인덱스를 사용하면 데이터를 조회할 때의 성능이 향상된다. 
  그러면 인덱스를 무조건적으로 많이 추가하는 게 좋다고 착각할 수도 있다. 
  하지만 인덱스를 추가하면 조회 성능은 올라가지만, 쓰기 작업(삽입, 수정, 삭제)의 성능은 저하된다.
  
   
  인덱스를 사용하면 데이터를 조회할 때의 성능이 향상된다.
  그러면 인덱스를 무조건적으로 많이 추가하는 게 좋다고 착각할 수도 있다. 
  하지만 인덱스를 추가하면 조회 성능은 올라가지만, 쓰기 작업(삽입, 수정, 삭제)의 성능은 저하된다.  
  
  실제로 그런지 테스트 해보자
*/

-- 테이블 A: 인덱스가 없는 테이블
CREATE TABLE test_table_no_index (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
    id INT AUTO_INCREMENT PRIMARY KEY,
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

show index from test_table_many_indexes;

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 100000; 

-- 인덱스가 없는 테이블에 데이터 10만개 삽입  평균 1.110
INSERT INTO test_table_no_index (column1, column2, column3, column4, column5, column6, column7, column8, column9, column10)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 100000
)
SELECT
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000)
FROM cte;

-- 인덱스가 많은 테이블에 데이터 10만개 삽입  -- 소요시간이 점점늘어남 최초 5초 이후 1초씩 추가됨...
INSERT INTO test_table_many_indexes (column1, column2, column3, column4, column5, column6, column7, column8, column9, column10)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 100000
)
SELECT
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000),
    FLOOR(RAND() * 1000)
FROM cte;

/*
 [이것만은 꼭 기억해두자!]
- 최소한의 인덱스만 사용하려고 하자.
- 인덱스를 추가하면 조회 속도는 빨라지나, 쓰기(삽입, 수정, 삭제) 속도는 느려짐을 항상 기억하자.
 */
