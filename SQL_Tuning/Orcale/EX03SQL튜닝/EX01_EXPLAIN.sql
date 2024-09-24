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

/*
	Plan Hash Value: Oracle에서 사용되는 실행 계획의 식별자입니다. MySQL의 id와 유사하게 각 실행 계획의 고유한 해시 값을 나타냅니다.
	
	Id: 각 단계의 식별자로, MySQL의 id와 유사합니다. 각 단계의 순서와 계층 구조를 나타냅니다.
	
	Operation: 수행된 작업의 유형을 나타냅니다 (예: "TABLE ACCESS FULL"). MySQL의 type과 비슷한 역할을 하며, 데이터에 접근하는 방식을 설명합니다.
	
	Options: 작업에 대한 추가 옵션을 나타냅니다 (예: "FULL", "INDEX RANGE SCAN" 등).
	
	Object Name: 작업이 수행된 데이터베이스 객체의 이름을 나타냅니다. MySQL의 table 컬럼과 유사합니다.
	
	Cardinality: 이 단계에서 예상되는 행의 수입니다. MySQL의 rows 컬럼과 비슷하며, 효율적인 쿼리 튜닝의 중요한 지표입니다.
	
	Cost: 작업의 예상 비용을 나타내며, CPU 및 I/O 리소스 사용량을 고려합니다. 이는 MySQL의 cost와 유사합니다.
	
	Bytes: 처리될 데이터의 크기를 바이트 단위로 나타냅니다.
	
	Predicate Information: 쿼리에서 사용된 조건을 나타냅니다. filter와 access 조건이 여기에 해당됩니다. MySQL의 filtered 및 조인이나 필터 조건을 설명하는 Extra 컬럼과 유사한 역할을 합니다.
	
	Access Predicates: 데이터를 가져오기 위해 사용된 인덱스 조건을 나타냅니다.
	
	Filter Predicates: 결과를 필터링하는 데 사용된 조건을 나타냅니다.
	
	DBMS_XPLAN.DISPLAY를 사용할 때 주의 깊게 봐야 할 부분
	Operation과 Options: 이 두 컬럼은 쿼리가 데이터에 어떻게 접근하는지를 알려주므로, 쿼리 성능 튜닝에서 중요한 부분입니다.
	Cardinality와 Cost: 이 값들은 쿼리의 효율성을 판단하는 데 중요하며, 특히 큰 테이블을 다룰 때 쿼리가 얼마나 많은 데이터를 처리할지 예측하는 데 도움이 됩니다.
	Predicate Information: 여기에 나타난 조건은 쿼리의 WHERE 절이 어떻게 처리되고 있는지를 보여줍니다. 이는 성능 최적화를 위해 인덱스를 추가하거나 쿼리를 재작성할 때 유용합니다. 
*/

-- 멀티 컬럼 인덱스 생성
CREATE INDEX idx_name_age ON users (name, age);

-- 실행 계획 재설정 및 출력
EXPLAIN PLAN FOR
SELECT * FROM users WHERE name = '김미현' AND age = 23;

-- 실행 계획 출력
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- 실제 실행 통계 확인
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
