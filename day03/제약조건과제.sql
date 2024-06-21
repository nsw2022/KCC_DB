create table member(
    id varchar2(20) PRIMARY key,
    name VARCHAR2(20),
    regno VARCHAR2(13) UNIQUE,
    hp VARCHAR2(13) UNIQUE not null,
    address VARCHAR2(100) not null
);

create table book(
    code number(4),
    title VARCHAR2(50),
    count NUMBER(6),
    price NUMBER(10),
    publish VARCHAR2(50)
);

ALTER table book 
    add (
        CONSTRAINT book_code_rf PRIMARY key(code)       
    )
    MODIFY title not null
;
desc book;
drop table book;

create table order2(
    no VARCHAR2(10),
    id VARCHAR2(20),
    code NUMBER(4),
    count NUMBER(6),
    dr_date date
);


ALTER table order2 
    add (
        CONSTRAINT order2_no_pk PRIMARY key(code),
        CONSTRAINT order2_no_fk FOREIGN key(id)
        REFERENCES member(id),
        CONSTRAINT order2_code_fk FOREIGN key(code)
        REFERENCES book(code)
    )
;

insert into member VALUES('tmddn3410','³ë½Â¿ì',980303,'010-7740-5366','Ã»·®¸®');
insert into book VALUES(1,'³ÓÁö',20,10000,'ÇÑºû');
insert into order2 VALUES('1','tmddn3410',1,5,sysdate);


desc member;
desc book;
desc order2;

select * from member;
select * from book;
select * from order2;
