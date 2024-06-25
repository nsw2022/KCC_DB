CREATE TABLE board(
seq NUMBER,
title VARCHAR2(50),
writer VARCHAR2(50),
contents VARCHAR2(200),
regdate DATE,
hitcount NUMBER
);

INSERT INTO board VALUES(1, 'a1', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(2, 'a2', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(3, 'a3', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(4, 'a4', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(5, 'a5', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(6, 'a6', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(7, 'a7', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(8, 'a8', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(9, 'a9', 'a', 'a', sysdate, 0);
INSERT INTO board VALUES(10, 'a10', 'a', 'a', sysdate, 0);
  
select * from board;
select * from(
SELECT ROWNUM AS ROW_NUM, temp.*
FROM (
        SELECT * FROM board
        ORDER BY seq DESC)temp
      ) 
where row_num BETWEEN 6 and 10;

CREATE SEQUENCE board_seq;

INSERT INTO board VALUES(board_seq.nextval, 'a1', 'a', 'a', sysdate, 0);

INSERT INTO board(seq, title, writer, contents, regdate, hitcount)
(select board_seq.nextval, title, writer, contents, regdate, hitcount from board);

SELECT * FROM board
WHERE seq = 19999;
   
select * from board;
    select * from board;
delete from board 
    where rownum in 
        (select rownum from (
            select * 
            from board)R 
            where rownum<=10);
            
DELETE FROM board
WHERE rowid IN (
  SELECT rid FROM (
    SELECT rowid AS rid, ROWNUM AS rnum
    FROM board
    WHERE ROWNUM <= 10
  )
);

ALTER TABLE board
ADD CONSTRAINT board_seq_pk PRIMARY KEY(seq);

desc board;