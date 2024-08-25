-- �Խ��ǽ�����, ����, ����, ȸ��������(�ĺ�Ű), ���糯¥, ������¥, ��ȸ��, ���ƿ�, 
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

-- ȸ��������, ���̵�, ��й�ȣ, �ּ�, �̸�, ���Գ�¥
CREATE table member(
    member_seq NUMBER(10, 0) PRIMARY KEY,
    email VARCHAR2(255) not null,
    pass VARCHAR2(255) not null,
    address VARCHAR2(255) not null,
    name VARCHAR2(255) not null,
    created_at date DEFAULT sysdate
);
insert into member (member_seq, email, pass, address,name ,created_at)
values(MEMBER_SEQ.nextval,'tmddn3410','1234','û����','�¿�',sysdate);
select * from member where member_seq = 1;

-- ��۽�����, ����, �Խ��ǽ�����(�ĺ�Ű), ���������(�ĺ�Ű), ���糯¥, ������¥,
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
