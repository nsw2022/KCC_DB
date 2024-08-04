CREATE TABLE users (
    user_id VARCHAR2(50) NOT NULL PRIMARY KEY,
    password VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    p_name VARCHAR2(100),
    registered_date DATE DEFAULT SYSDATE
);
drop table users;

CREATE TABLE board (
    id NUMBER PRIMARY KEY,
    title VARCHAR2(255),
    pname VARCHAR2(100),
    pw VARCHAR2(100),
    upfile VARCHAR2(255),
    content CLOB,
    reg_date DATE,
    cnt NUMBER,
    seq NUMBER,
    lev NUMBER,
    gid NUMBER
);

INSERT INTO board (id, title, pname, pw, upfile, content, reg_date  , cnt, seq, lev, gid)
VALUES (board_seq.NEXTVAL, '게시글 제목 1', '작성자1', 'password1', 'file1.jpg', '게시글 내용입니다.',sysdate ,0, 1, 0, 1);

INSERT INTO board (id, title, pname, pw, upfile, content,reg_date  , cnt, seq, lev, gid)
VALUES (board_seq.NEXTVAL, '게시글 제목 2', '작성자2', 'password1', 'file1.jpg', '게시글 내용입니다.',sysdate ,0, 1, 0, 1);


CREATE SEQUENCE board_seq START WITH 1 INCREMENT BY 1;
drop sequence "KCC"."BOARD_SEQ";
select * from board;
drop table board;