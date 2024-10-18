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
  chk.chklst_nm, s
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

