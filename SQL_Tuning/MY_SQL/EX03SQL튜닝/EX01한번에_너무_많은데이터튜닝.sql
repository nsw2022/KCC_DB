DROP TABLE IF EXISTS users; # 기존 테이블 삭제

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

-- 높은 재귀(반복) 횟수를 허용하도록 설정
-- (아래에서 생성할 더미 데이터의 개수와 맞춰서 작성하면 된다.)
SET SESSION cte_max_recursion_depth = 1000000; 

-- 더미 데이터 삽입 쿼리
INSERT INTO users (name, age)
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000000 -- 생성하고 싶은 더미 데이터의 개수
)
SELECT 
    CONCAT('User', LPAD(n, 7, '0')),   -- 'User' 다음에 7자리 숫자로 구성된 이름 생성
    FLOOR(1 + RAND() * 1000) AS age    -- 1부터 1000 사이의 난수로 나이 생성
FROM cte;

SELECT * FROM users LIMIT 10000; -- 대략 200ms

SELECT * FROM users LIMIT 10; -- 대략 20ms

/*
	
조회 결과 데이터의 개수 줄이기

실제 페이스북, 인스타그램의 서비스를 보더라도 한 번에 모든 게시글의 데이터를 불러오지 않는다. 스크롤을 내리면서 필요한 데이터를 그때그때 로딩하는 방식이다.
다른 커뮤니티 서비스의 게시판을 보면 페이지네이션을 적용시켜서 일부 데이터만 조회하려고 한다. 
그 이유가 조회하는 데이터의 개수가 성능에 많은 영향을 끼치기 때문이다. 

직관적으로 생각해보면 100만개의 데이터에서 1개의 데이터를 찾는 것보다 10,000개의 데이터를 찾는 게 오래 걸릴 수 밖에 없다. 


[이것만은 꼭 기억해두자!]
- 데이터를 조회할 때 한 번에 너무 많은 데이터를 조회하는 건 아닌 지 체크해봐라.
- LIMIT, WHERE문 등을 활용해서 한 번에 조회하는 데이터의 수를 줄이는 방법을 고려해봐라.

</aside>
      
*/