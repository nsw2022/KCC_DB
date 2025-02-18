CREATE TABLE TB_DEPT
( 
   DEPT_CD     VARCHAR2(8) NOT NULL PRIMARY KEY,
   PAR_DEPT_CD VARCHAR2(8),
   DEPT_NM     VARCHAR2(50)
);

INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_001',NULL,'회사');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_002','DE_001','개발부문');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_003','DE_001','영업부문');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_004','DE_002','개발부');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_005','DE_002','부설연구소');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_006','DE_003','해외영업부');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_007','DE_003','국내영업부');
INSERT INTO TB_DEPT(DEPT_CD,PAR_DEPT_CD,DEPT_NM)VALUES('DE_008','DE_003','영업기획팀');


/*------------------------+
 
	 *  노드구조  * 
   회사 (DE_001)
├── 개발부문 (DE_002)
│   ├── 개발부 (DE_004)
│   └── 부설연구소 (DE_005)
└── 영업부문 (DE_003)
    ├── 해외영업부 (DE_006)
    ├── 국내영업부 (DE_007)
    └── 영업기획팀 (DE_008)

 +------------------------*/

SELECT
	*
FROM TB_DEPT;

-- 정상적인 계층구조 쿼리
SELECT 
    LEVEL LEV,
    DEPT_CD,
    DEPT_NM,
    PAR_DEPT_CD
FROM TB_DEPT
START WITH PAR_DEPT_CD IS NULL -- 시작 위치를 정함
CONNECT BY PAR_DEPT_CD = PRIOR DEPT_CD -- 자식데이터를 지정
ORDER SIBLINGS BY DEPT_CD;
/*
 LEV|DEPT_CD|DEPT_NM|PAR_DEPT_CD|
---+-------+-------+-----------+
  1|DE_001 |회사     |           |
  2|DE_002 |개발부문   |DE_001     |
  3|DE_004 |개발부    |DE_002     |
  3|DE_005 |부설연구소  |DE_002     |
  2|DE_003 |영업부문   |DE_001     |
  3|DE_006 |해외영업부  |DE_003     |
  3|DE_007 |국내영업부  |DE_003     |
  3|DE_008 |영업기획팀  |DE_003     |
   
 */

/*
	level은 오라클에서 실행되는 모든 쿼리 내에서 사용 가능한 가상-열로서, 
	트리 내에서 어떤 단계(level)에 있는지를 나타내는 정수값이다.
 
	start with
 	start with 절은 계층구조가 어떤'행' 에서부터 시작하는지 지정하는 기능
 	하나이상의 조건을 주는것도 가능 e.g)START WITH PAR_DEPT_CD = 'DE_002' and  DEPT_NM = '개발부문'
 	이렇게 정해진 조건에 맞는 행은 결과셋의 '루트노드' 가 된다 그리하여 엔티티의 루트 노드가 2개가 생성됨으로
 	트리가 두번만들어지게 된다 바로아래에 기술하겠다 읽고올라와서 connect by proior 을 마저볼것
 	
 	connect by proior
 	트리 구조에서 현재 행과 이전 행(즉, 부모-자식 관계를 맺는 행)이 어떻게 연결되는지를 오라클에게 알려주는 역할
 	CONNECT BY PAR_DEPT_CD = PRIOR DEPT_CD
    -	현재 행(PAR_DEPT_CD)의 부모 부서 코드가
    -   이전 행(DEPT_CD, 즉, 부모 부서의 코드)과 같다면
    -	부모-자식 관계로 간주하고 트리를 구성하라.
    
+----------------+------------+--------------------------------+----------------+---------+
| 현재 행 (자식) | PAR_DEPT_CD |  연결 조건 (PAR_DEPT_CD = PRIOR DEPT_CD) | 이전 행 (부모) | DEPT_CD |
+----------------+------------+--------------------------------+----------------+---------+
| 개발부문(DE_002) | DE_001     | DE_001 = PRIOR DEPT_CD (회사 DE_001) | 회사(DE_001)  | DE_001  |
| 개발부(DE_004)  | DE_002     | DE_002 = PRIOR DEPT_CD (개발부문 DE_002) | 개발부문(DE_002) | DE_002  |
| 해외영업부(DE_006) | DE_003  | DE_003 = PRIOR DEPT_CD (영업부문 DE_003) | 영업부문(DE_003) | DE_003  |
+----------------+------------+--------------------------------+----------------+---------+

   
*/


-- 조건이 두개라 루트가 2개다
SELECT 
    LEVEL LEV,
    DEPT_CD,
    DEPT_NM,
    PAR_DEPT_CD
FROM TB_DEPT
START WITH PAR_DEPT_CD is null or  DEPT_NM = '개발부문'
CONNECT BY PAR_DEPT_CD = PRIOR DEPT_CD -- 자식데이터를 지정
ORDER SIBLINGS BY DEPT_CD;  -- SIBLINGS 형제노드로 정렬안하고 그냥 ORDER BY 서열을 무시한다
/*-------
LEV|DEPT_CD|DEPT_NM|PAR_DEPT_CD|
---+-------+-------+-----------+
  1|DE_001 |회사     |           |
  2|DE_002 |개발부문   |DE_001     |
  3|DE_004 |개발부    |DE_002     |
  3|DE_005 |부설연구소  |DE_002     |
  2|DE_003 |영업부문   |DE_001     |
  3|DE_006 |해외영업부  |DE_003     |
  3|DE_007 |국내영업부  |DE_003     |
  3|DE_008 |영업기획팀  |DE_003     |
  1|DE_002 |개발부문   |DE_001     |
  2|DE_004 |개발부    |DE_002     |
  2|DE_005 |부설연구소  |DE_002     |
  
    
 */



SELECT 
    LEVEL,
    DEPT_NM,
    LPAD(' ', 2*LEVEL-1) || SYS_CONNECT_BY_PATH(DEPT_NM, '/') PATH,
    DEPT_CD,
    PAR_DEPT_CD
FROM TB_DEPT
START WITH PAR_DEPT_CD IS NULL
CONNECT BY PAR_DEPT_CD = PRIOR DEPT_CD
ORDER SIBLINGS BY DEPT_CD;