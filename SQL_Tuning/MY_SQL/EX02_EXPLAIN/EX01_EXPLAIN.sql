DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

INSERT INTO users (name, age) VALUES
('박미나', 26),
('김미현', 23),
('김민재', 21),
('이재현',  24),
('조민규', 23),
('하재원', 22),
('최지우', 22);

EXPLAIN SELECT * FROM users
WHERE age = 23;

/*
실행계획은 우리가 아는 쿼리문 앞에 EXPLAIN을 붙힌후 사용할수있다 나오는 컬럼들을 살펴보자  
 
- id : 실행 순서
- select_type : (처음에는 몰라도 됨)
- table : 조회한 테이블 명
- partitions : (처음에는 몰라도 됨)
- type : 테이블의 데이터를 어떤 방식으로 조회하는 지 ⭐️⭐️⭐️   <-⭐️ 가 많을 수록 중요
- possible keys : 사용할 수 있는 인덱스 목록을 출력 ⭐️
- key : 데이터 조회할 때 실제로 사용한 인덱스 값 ⭐️
- key_len : (처음에는 몰라도 됨)
- ref : 테이블 조인 상황에서 어떤 값을 기준으로 데이터를 조회했는 지
- rows : SQL문 수행을 위해 접근하는 데이터의 모든 행의 수 (= 데이터 액세스 수) ⭐️⭐️⭐️
    
    → 이 값을 줄이는 게 SQL 튜닝의 핵심이다!
    
- filtered : 필터 조건에 따라 어느 정도의 비율로 데이터를 제거했는 지 의미
    
    → filtered의 값이 30이라면 100개의 데이터를 불러온 뒤 30개의 데이터만 실제로 응답하는데 사용했음을 의미한다. 
    
    → filtered 비율이 낮을 수록 쓸데없는 데이터를 많이 불러온 것.
    
- Extra : 부가적인 정보를 제공 ⭐️
    
    → ex. Using where, Using index  
*/

EXPLAIN ANALYZE SELECT * FROM users
WHERE age = 23;

/*
 이번엔 실행계획의 자세한 정보를 조회하여 보자
  -> Filter: (users.age = 23)  (cost=0.95 rows=1) (actual time=0.0314..0.0352 rows=2 loops=1)
  	-> Table scan on users  (cost=0.95 rows=7) (actual time=0.0278..0.0321 rows=7 loops=1)
  다음과 같은 정보를 확인할 수 있다
  
  읽는 순서에 주의하자 안쪽부터 바깥 순서로 읽어야 한다.
  지금 경우는 Table scan on users 스캔 부터 읽는다는 말이다.
  
- Table scan on users : users 테이블을 풀 스캔했다.
    - rows : 접근한 데이터의 행의 수
    - actual time=0.0437..0.0502
        - 0.0437 (앞에 있는 숫자) : 첫 번째 데이터에 접근하기까지의 시간
        - 0.0502 (뒤에 있는 숫자) : 마지막 데이터까지 접근한 시간
- Filter: (users.age = 23) : 필터링을 통해 데이터를 추출했다. 필터링을 할 때의 조건은 users.age = 23이다.

위 작업을 한 번에 이어서 해석해보면 다음과 같다. 

> users 테이블의 모든 데이터(7개)에 접근했다. 그러고 그 데이터 중 age = 23의 조건을 만족하는 데이터만 필터링해서 조회해왔다.


  -> Filter: (users.age = 23)  (cost=0.95 rows=1) (actual time=0.0314..0.0352 rows=2 loops=1)
  맨상단의 해당 줄의 주의하자 이때 필터링이 걸린 시간이 0.0352인가 보다 하고 넘어갈수있다, 그렇지 않다. 최상단의 걸린시간은 하단에 있는 명령들의
  모든 과정을 포함한 그런 초이다. 그럼 실제로 걸린시간이 얼마인가?
  
   -> Filter: (users.age = 23)  (cost=0.95 rows=1) (actual time=0.0314..0.0352 rows=2 loops=1)
  	-> Table scan on users  (cost=0.95 rows=7) (actual time=0.0278..0.0321 rows=7 loops=1)
  	
  	해당과정에서 총걸린시간이 0.0352에서 0.0321을 뺀 시간이 실제 걸린 시간이다 주의하도록 하자
    
  
 */