select * from mbr;

select * from chklst_ctg;

select * from chklst;

select * from insp_plan;

select * from insp_schd;

select * from store;
select * from comm_cd;
select * from comm_cd_dtl;


-- 가맹점 점검 계획 관리 
SELECT
  sto.store_nm,
  CASE 
    WHEN sto.brand_cd = 'B001' THEN 'KCC 크라상' 
    WHEN sto.brand_cd = 'B002' THEN 'KCC 도넛'
    WHEN sto.brand_cd = 'B003' THEN 'KCC 브레드'
    WHEN sto.brand_cd = 'B004' THEN 'KCC 카페'
  END AS brand_nm,
  chk.chklst_nm,
  chk.cre_tm, 
  mbr.mbr_nm
FROM insp_schd isc
INNER JOIN store sto
    ON sto.store_id = isc.store_id
INNER JOIN insp_plan inp
    ON inp.insp_plan_id = isc.insp_plan_id
INNER JOIN chklst chk
    ON chk.chklst_id = inp.chklst_id
INNER JOIN mbr
    ON mbr.mbr_id = sto.insp_mbr_id
WHERE inp.insp_plan_use_w = 'Y';


SELECT
  sto.store_nm,
  CASE 
    WHEN sto.brand_cd = 'B001' THEN 'KCC 크라상' 
    WHEN sto.brand_cd = 'B002' THEN 'KCC 도넛'
    WHEN sto.brand_cd = 'B003' THEN 'KCC 브레드'
    WHEN sto.brand_cd = 'B004' THEN 'KCC 카페'
  END AS brand_nm,
  chk.chklst_nm,
  chk.cre_tm,
  CASE
    WHEN chk.insp_type_cd = 'IT001' THEN '제품점검'
    WHEN chk.insp_type_cd = 'IT002' THEN '위생점검'
    WHEN chk.insp_type_cd = 'IT003' THEN '정기점검'
    WHEN chk.insp_type_cd = 'IT004' THEN '비정기점검'
    WHEN chk.insp_type_cd = 'IT005' THEN '기획점검'
  END AS insp,
  mbr.mbr_nm
FROM insp_schd isc
INNER JOIN store sto
    ON sto.store_id = isc.store_id
INNER JOIN insp_plan inp
    ON inp.insp_plan_id = isc.insp_plan_id
INNER JOIN chklst chk
    ON chk.chklst_id = inp.chklst_id
INNER JOIN mbr
    ON mbr.mbr_id = sto.insp_mbr_id
WHERE inp.insp_plan_use_w = 'Y';

-- 점검계획별 체크리스트
SELECT 
    S.STORE_ID,
    S.STORE_NM,
    IP.INSP_PLAN_ID,
    IP.FRQ_CD,
    C.CHKLST_ID,
    C.CHKLST_NM,
    CC.CTG_ID,
    CC.CTG_NM,
    CE.EVIT_ID,
    CE.EVIT_CONTENT,
    CE.SCORE
FROM 
    STORE S
JOIN 
    INSP_SCHD ISCH ON S.STORE_ID = ISCH.STORE_ID
JOIN 
    INSP_PLAN IP ON ISCH.INSP_PLAN_ID = IP.INSP_PLAN_ID
JOIN 
    CHKLST C ON IP.CHKLST_ID = C.CHKLST_ID
JOIN 
    CHKLST_CTG CC ON C.CHKLST_ID = CC.CHKLST_ID
JOIN 
    CHKLST_EVIT CE ON CC.CTG_ID = CE.CTG_ID
ORDER BY 
    CC.SEQ, CE.EVIT_SEQ;


