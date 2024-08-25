--�������������, �̸�, �ּ�, �����, ������,Ż�𿩺�(����Ʈ0, ����(Ż���->1))
create table restaurant(
    res_seq NUMBER(10, 0) PRIMARY KEY,
    name VARCHAR2(255) not null,
    address VARCHAR2(255) not null,
    created_at date DEFAULT SYSDATE,
    update_at date,
    unsubscribed NUMBER DEFAULT 0
);
insert into restaurant (res_seq, name, address, created_at, update_at)
values (res_seq.nextval, 'ù��° �������', 'û������', sysdate, null);

select * from restaurant;


--������� �޴� ������, ������� ������, �޴��̸�, ���� ,���糯¥, ������¥, ��������(����Ʈ0, ����->1, ����->2)
create table menu(
    menu_seq NUMBER(10, 0) PRIMARY KEY,
    res_seq NUMBER(10, 0),
    name varchar2(255) not null,
    price NUMBER(10, 0),
    created_at date DEFAULT SYSDATE,
    update_at date,
    emphasis NUMBER DEFAULT 0,
    CONSTRAINT menu_restaurant_fk FOREIGN key (res_seq) REFERENCES restaurant (res_seq)
);
insert into menu(menu_seq, res_seq, name, price, created_at, update_at)
values (menu_seq.nextval, 1, '������', 9000, sysdate, null);

select * from menu;

CREATE table member(
    member_seq NUMBER(10, 0) PRIMARY KEY,
    email VARCHAR2(255) not null,
    pass VARCHAR2(255) not null,
    address VARCHAR2(255) not null,
    name VARCHAR2(255) not null,
    created_at date DEFAULT sysdate,
    unsubscribed NUMBER DEFAULT 0
);
insert into member (member_seq, email, pass, address,name ,created_at)
values(MEMBER_SEQ.nextval,'tmddn3410','1234','û����','�¿�',sysdate);
select * from member;

-- ���������, ������� ������, ���������, ����, ����Ƚ��,�����, ������, ��������(����Ʈ->0, ����(�Ű�����)->1)
create table review(
    review_seq NUMBER(10, 0) PRIMARY KEY,
    res_seq number(10, 0),
    member_seq number(10, 0),
    content varchar2(255),
    score float,
    created_at date default sysdate,
    update_at date,
    unsubscribed NUMBER DEFAULT 0,
    CONSTRAINT review_restaurant_fk FOREIGN key (res_seq) REFERENCES restaurant (res_seq),
    CONSTRAINT review_member_fk FOREIGN key (member_seq) REFERENCES member (member_seq)
);
insert into review (review_seq, res_seq, member_seq, content, score, created_at, update_at)
values (review_seq.nextval, 1, 1, '������ ��ū�ϰ� ��⵵ �����ֳ�!', 2.3, sysdate, null);
select * from review;

CREATE SEQUENCE res_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE menu_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;


CREATE SEQUENCE member_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE review_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

