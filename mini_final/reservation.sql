CREATE TABLE payment (
	payment_imp_uid	VARCHAR2(50 char) PRIMARY KEY,
	payment_provider	VARCHAR2(20 char) NOT NULL,
	payment_method	VARCHAR2(20 char) NOT NULL,
	payment_price	NUMBER NOT NULL
);

CREATE TABLE reservation (
	reservation_id	NUMBER	PRIMARY KEY,
	payment_imp_uid	VARCHAR2(50) NOT NULL,
	member_seq	NUMBER NOT NULL,
	non_user_code NUMBER NOT NULL,
	schedule_id	NUMBER	NOT NULL,
	seat_number	VARCHAR2(20 char) NULL,
	price	NUMBER	NULL,
	reservation_date Date NULL,
	reservation_status	NUMBER(1) NULL
);

-- alter table reservation add constraint reservation_id_pk primary key(rno);
alter table reservation add constraint reservation_payment_imp_uid_fk foreign key(payment_imp_uid)
references payment(payment_imp_uid);

alter table reservation add constraint reservation_member_seq_fk foreign key(member_seq)
references member(member_seq);

alter table reservation add constraint reservation_non_user_id_fk foreign key(non_user_code)
references non_user(non_user_code);

alter table reservation add constraint reservation_schedule_id_fk foreign key(schedule_id)
references schedule(schedule_id);

CREATE TABLE non_user (
	non_user_code NUMBER PRIMARY KEY,
	non_user_tel	VARCHAR2(20 char) NOT NULL,
	non_user_birth	DATE NOT NULL
);

CREATE TABLE schedule(
    schedule_id NUMBER PRIMARY KEY,
    bus_id NUMBER NOT NULL,
    route_id VARCHAR2(50 char) NOT NULL,
    schedule_start_time DATE NOT NULL,
    schedule_end_time DATE NOT NULL,
    schedule_price NUMBER NOT NULL
);

alter table schedule add constraint schedule_bus_id_fk foreign key(bus_id)
references bus(bus_id);
alter table schedule add constraint schedule_route_id_fk foreign key(route_id)
references route(route_id);


    -- CONSTRAINT schedule_bus_id_fk FOREIGN key (bus_id) REFERENCES bus (bus_id)
    -- CONSTRAINT schedule_route_id_fk FOREIGN key (route_id) REFERENCES route (route_id)

CREATE TABLE route(
    route_id VARCHAR2(50 char) PRIMARY KEY,
    route_start_id VARCHAR2(20 char) NOT NULL,
    route_end_id VARCHAR2(20 char) NOT NULL,
    requierd_time DATE,
    route_status NUMBER(1) NOT NULL,
    CONSTRAINT route_route_start_id_fk FOREIGN key (route_start_id) REFERENCES terminal (terminal_id),
    CONSTRAINT route_route_route_end_id_fk FOREIGN key (route_end_id) REFERENCES terminal (terminal_id)
);


CREATE SEQUENCE non_user_code
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
drop SEQUENCE non_user_code;
    
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (non_user_code.nextval, '010-7740-5366');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-2419-7294');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-1234-5678');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-2345-6789');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-3456-7890');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-4567-8901');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-5678-9012');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-6789-0123');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-7890-1234');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-8901-2345');
INSERT INTO non_user (non_user_code, non_user_tel) VALUES (NON_USER_CODE.nextval, '010-9012-3456');


CREATE TABLE member (
	member_seq	NUMBER PRIMARY KEY,
	member_id	VARCHAR2(50 char) NOT NULL,
	member_pass	VARCHAR2(20 char) NOT NULL,
	member_name	VARCHAR2(50 char) NOT NULL,
	member_tel	VARCHAR2(20 char) NOT NULL,
	member_email VARCHAR2(50 char) NOT NULL,
	member_birth DATE NOT NULL,
	member_role	VARCHAR2(20 char) NOT NULL,
	create_date	DATE DEFAULT SYSDATE	NOT NULL,
	withdraw NUMBER(1) NOT NULL
);
select * from member;
    
INSERT INTO member
(member_seq, member_id, member_pass, member_name, member_tel, member_email, member_birth, member_role, create_date, withdraw)
VALUES (member_seq.nextval, 'member1', 'userpass1', 'Member One', '010-1111-1111', 'member1@naver.com', TO_DATE('2001-01-01', 'YYYY-MM-DD'), 'ROLE_USER', SYSDATE, 1);

INSERT INTO member
(member_seq, member_id, member_pass, member_name, member_tel, member_email, member_birth, member_role, create_date, withdraw)
VALUES (member_seq.nextval, 'member2', 'userpass2', 'Member Two', '010-2222-2222', 'member2@naver.com', TO_DATE('2002-02-02', 'YYYY-MM-DD'), 'ROLE_USER', SYSDATE, 1);

INSERT INTO member
(member_seq, member_id, member_pass, member_name, member_tel, member_email, member_birth, member_role, create_date, withdraw)
VALUES (member_seq.nextval, 'member3', 'userpass3', 'Member Three', '010-3333-3333', 'member3@naver.com', TO_DATE('2003-03-03', 'YYYY-MM-DD'), 'ROLE_USER', SYSDATE, 1);

INSERT INTO member
(member_seq, member_id, member_pass, member_name, member_tel, member_email, member_birth, member_role, create_date, withdraw)
VALUES (member_seq.nextval, 'member4', 'userpass4', 'Member Four', '010-4444-4444', 'member4@naver.com', TO_DATE('2004-04-04', 'YYYY-MM-DD'), 'ROLE_USER', SYSDATE, 1);

CREATE SEQUENCE member_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE bus_id
    START WITH 62
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE schedule_id
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE company_id
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE reservation_id
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

