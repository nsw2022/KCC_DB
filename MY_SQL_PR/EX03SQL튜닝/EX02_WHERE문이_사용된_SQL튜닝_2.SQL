-- 이번엔 조건을 바꿔서 Sales 부서이면서 최근 3일 이내에 가입한 유저 조회하기

DROP TABLE IF EXISTS users; 

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 100만건 데이터 랜덤 삽입
-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, department, created_at)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')) AS name,  -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    CASE 
        WHEN n % 10 = 1 THEN 'Engineering'
        WHEN n % 10 = 2 THEN 'Marketing'
        WHEN n % 10 = 3 THEN 'Sales'
        WHEN n % 10 = 4 THEN 'Finance'
        WHEN n % 10 = 5 THEN 'HR'
        WHEN n % 10 = 6 THEN 'Operations'
        WHEN n % 10 = 7 THEN 'IT'
        WHEN n % 10 = 8 THEN 'Customer Service'
        WHEN n % 10 = 9 THEN 'Research and Development'
        ELSE 'Product Management'
    END AS department,  -- 의미 있는 단어 조합으로 부서 이름 생성
    TIMESTAMP(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND) AS created_at -- 최근 10년 내의 임의의 날짜와 시간 생성
FROM cte;

-- 잘 생성됐는 지 확인
SELECT COUNT(*) FROM users;
SELECT * FROM users LIMIT 10;

-- 데이터 조회해서 성능 측정하기  200ms
SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);


-- 실행계획 조회해보기
# 실행 계획
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);
/*
-> Filter: ((users.department = 'Sales') and (users.created_at >= <cache>((now() - interval 3 day))))  (cost=93877 rows=33224) (actual time=4.9..485 rows=114 loops=1)
    -> Table scan on users  (cost=93877 rows=996810) (actual time=0.0505..371 rows=1e+6 loops=1)

	세부 내용은 안쪽부터 바깥쪽으로 읽는것이다.
	1. 풀 테이블 스캔을 했다 -> Table scan on users
	   이때 엑세스한 데이터의 개수는 지수표현법인 1e+6(10^6 1,000,000) 
	   
	2. 엑세스한 1,000,000 데이터중department='Sales' 필터링 해온다 Filter: ((users.department = 'Sales') and (users.created_at >= <cache>((now() - interval 3 day))))  
	   -> 조건을 만족한 개수 rows는 (actual time=4.9..485 rows=114 loops=1) 다 
	      ※ 이때 유의할점 마지막에 걸린 time=4.9..485 는 필터링 시간에만 걸린시간이 아닌 총시간이다 처음 (actual time=0.0505..371 rows=1e+6 loops=1) 에서 빼주어야함
	      ※ (actual time=0.0505..371 rows=1e+6 loops=1) 읽는법은 ...뒤의 371ms다

*/

-- ##########################################################

/*
 	지금까지 봣을때 성능 개선을 위한 인덱스 컬럼을 추가해야할 방법은 3가지로 보인다
 	1. created_at 컬럼을 기준으로 인덱스 생성
 	2. department 컬럼을 기준으로 인덱스 생성
 	3. department, created_at 둘다 인덱스 생성
 	
 	아직 필자는 경험이 없어 3개다 해보고 어떤게 나은지 비교를 해보겠다. 
*/

-- created_at 컬럼 기준으로 인덱스 생성
CREATE INDEX idx_created_at ON users (created_at);

# 성능 측정
SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획  - 20ms
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

/*
-> Filter: (users.department = 'Sales')  (cost=507 rows=113) (actual time=0.0737..3.42 rows=114 loops=1)
    -> Index range scan on users using idx_created_at over ('2024-08-24 10:33:55' <= created_at), with index condition: (users.created_at >= <cache>((now() - interval 3 day)))  (cost=507 rows=1126) (actual time=0.0248..3.33 rows=1126 loops=1)

 1. idx_created_at 인덱스를 활용해 인덱스 레인지 스캔을 했다.
    -> rows는 1126개이다 1,000,000 중 상당히 적은수를 탐색했기에 많이 줄어든 모습니다
 2. 엑세스한 1126 데이터 중 uesrs.department = 'Sales' 만족하는 필터링 해온다 -> Filter: (users.department = 'Sales')
    -> 조건을 만족하는 데이터의 개수는 114개다 (actual time=0.0737..3.42 rows=114 loops=1)

*/

-- #########################################################

-- department 컬럼으로 인덱싱

ALTER TABLE users DROP INDEX idx_created_at; # 기존 created_at 인덱스 삭제
CREATE INDEX idx_department ON users (department);

# 성능 측정
SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획  20ms
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

/*
 -> Filter: (users.created_at >= <cache>((now() - interval 3 day)))  (cost=8900 rows=63765) (actual time=4.83..292 rows=114 loops=1)
    -> Index lookup on users using idx_department (department='Sales')  (cost=8900 rows=191314) (actual time=0.333..272 rows=100000 loops=1)
 
	결과론적으로보면 조회가 느린걸 알수있다...!
	왜그런지 살펴보면 실행계획시 ref로 조회했다는걸 확인할수있다. (ref가 나왔다는 것은 비고유 인덱스, 유니크 제약조건이 안걸려있는 인덱스)
	department 는 문자열이기때문에 여러값을 가질수있다 ref라는조건이 발생한거고
	데이터의 접근한 rows를 보면 19만개를 접근한것을 확인할 수 있었다.
	상대적으로 탐색하는 데이터가 많아져 시간이 길어졌다는 것을 간접적으로 알수있었다.

*/

-- ######################################################################

-- created_at과 department 둘다 인덱스 생성

# CREATE INDEX idx_department ON users (department); # 위에서 이미 추가함
CREATE INDEX idx_created_at ON users (created_at); # created_at 인덱스 추가

# 성능 측정
SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획 세부 내용
EXPLAIN ANALYZE SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

/*
 	실행 계획을 살펴보면
 	possible_keys 두가지 값을 사용함수있는데
	idx_department,idx_created_at
	
	key를 보면 idx_created_at 만 사용한 것을 확인할 수 있다.
	왜그랬을까? -> 옵티마이저가 이 두가지 인덱스를 비요해보니 created_at 인덱스를 쓰는게 효율적이다 판단하에 데이터를 조회했다
	
	세부계획을 조회해보면 created_at 을 조회했을때와 같은걸 확인할 수 있다
	-> Filter: (users.department = 'Sales')  (cost=502 rows=214) (actual time=0.108..3.49 rows=112 loops=1)
	    -> Index range scan on users using idx_created_at over ('2024-08-24 11:18:04' <= created_at), with index condition: (users.created_at >= <cache>((now() - interval 3 day)))  (cost=502 rows=1115) (actual time=0.0347..3.41 rows=1115 loops=1)


	이를 통해 우리는 rows를 크게 줄일 수 있는 컬럼은 중복 정도가 낮은 컬럼이다 따라서 중복 정도가 낮은 컬럼을 골라서 인덱스를 생성하자.
	
*/

-- ##############################################

-- 멀티 컬럼 인덱스 고려하기

ALTER TABLE users DROP INDEX idx_created_at;
ALTER TABLE users DROP INDEX idx_department;
CREATE INDEX idx_created_at_department ON users (created_at, department);

SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획 -- 약 30ms 정도 걸림
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

-- ㅠ##############################################
-- 모든 경우를 테스트해보자 앞뒤를 바꿔해보자
ALTER TABLE users DROP INDEX idx_created_at_department;
CREATE INDEX idx_department_created_at ON users (department, created_at);

SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

# 실행 계획  -- 똑같이 30ms 걸린다.
EXPLAIN SELECT * FROM users
WHERE department = 'Sales'
AND created_at >= DATE_SUB(NOW(), INTERVAL 3 DAY);

/*
 2가지 멀티컬럼 인덱스를 활용하여봣지만 created_at 인덱스만 걸었을때와 크게 성능 차이가 없다. 
 이런 경우 굳이 멀티 컬럼 인덱스를 사욯자하지않고 단일 컬럼에만 인덱스를 적요시키는게 낮다
 
 [이것만큼은 꼭 기억하자] 단일 컬럼에 설정하는 일반 인덱스를 설정했을 때와 멀티 컬럼 인덱스를 설정했을때 성능차이가 별로 나지 않는다면
 멀티 컬럼 인덱스를 사용하지 말고 인반 인덱스를 사용하자
   
 */