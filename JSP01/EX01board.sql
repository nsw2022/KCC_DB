CREATE TABLE board(
    seq number,
    title varchar2(50),
    writer varchar2(50),
    contents varchar2(200),
    regdate date,
    hitcount number
    
);

CREATE SEQUENCE BOARD_SEQ
    START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

select * from board;

drop table board;