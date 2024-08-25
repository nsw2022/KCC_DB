-- 게시판시퀀스, 제목, 내용, 회원시퀀스(후보키), 만든날짜, 수정날짜, 조회수, 좋아요, 
create table board(
    board_seq NUMBER(10, 0) PRIMARY key,
    title VARCHAR2(50) not null ,
    content VARCHAR2(500) not null,
    member_seq NUMBER(10, 0) ,
    created_at date DEFAULT sysdate,
    updated_at date,
    hit_count NUMBER(10, 0) DEFAULT 0,
    like_count NUMBER(10, 0) DEFAULT 0,
    CONSTRAINT board_member_fk FOREIGN key (member_seq) REFERENCES member (member_seq)
);

-- 회원시퀀스, 아이디, 비밀번호, 주소, 이름, 가입날짜
CREATE table member(
    member_seq NUMBER(10, 0) PRIMARY KEY,
    email VARCHAR2(255) not null,
    pass VARCHAR2(255) not null,
    address VARCHAR2(255) not null,
    name VARCHAR2(255) not null,
    created_at date DEFAULT sysdate
);
insert into member (member_seq, email, pass, address,name ,created_at)
values(MEMBER_SEQ.nextval,'tmddn3410','1234','청량리','승우',sysdate);
select * from member where member_seq = 1;

-- 댓글시퀀스, 내용, 게시판시퀀스(후보키), 멤버시퀀스(후보키), 만든날짜, 수정날짜,
CREATE table reply(
    reply_seq NUMBER(10, 0) PRIMARY key,
    content VARCHAR2(500) not null,
    board_seq NUMBER(10, 0),
    member_seq NUMBER(10, 0),
    created_at date DEFAULT sysdate,
    updated_at date,
    like_count NUMBER(10, 0) DEFAULT 0,
    CONSTRAINT reply_borad_fk FOREIGN key (board_seq) REFERENCES board (board_seq),
    CONSTRAINT reply_member_fk FOREIGN key (member_seq) REFERENCES member (member_seq)
);



CREATE SEQUENCE board_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE reply_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE member_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
