create table users(
      username varchar2(50) not null primary key,
      password varchar2(50) not null,
      enabled char(1) default '1');

drop table users;
 create table authorities (
      username varchar2(50) not null,
      authority varchar2(50) not null,
      constraint fk_authorities_users foreign key(username) references users(username));
      
 create unique index ix_auth_username on authorities (username,authority);

drop table authorities;
insert into users (username, password) values ('user00','pw00');
insert into users (username, password) values ('member00','pw00');
insert into users (username, password) values ('admin00','pw00');

insert into authorities (username, authority) values ('user00','ROLE_USER');
insert into authorities (username, authority) values ('member00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_MANAGER'); 
insert into authorities (username, authority) values ('admin00','ROLE_ADMIN');
commit;


select * from users;

select * from authorities order by authority;

create table tbl_member(
      userid varchar2(50) not null primary key,
      userpw varchar2(100) not null,
      username varchar2(100) not null,
      regdate date default sysdate, 
      updatedate date default sysdate,
      enabled char(1) default '1');

create table tbl_member_auth (
     userid varchar2(50) not null,
     auth varchar2(50) not null,
     constraint fk_member_auth foreign key(userid) references tbl_member(userid)
);

create table persistent_logins(
  username varchar2(64) not null,
  series varchar2(64) primary key,
  token varchar2(64) not null,
  last_used timestamp not null
)

--
select * from tbl_member;
select * from tbl_member_auth;

drop table tbl_member;
drop table tbl_member_auth;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'TBL_MEMBER';

ALTER TABLE tbl_member_auth DROP CONSTRAINT SYS_C007909;


SELECT CONSTRAINT_NAME, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE R_CONSTRAINT_NAME IN (
    SELECT CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'TBL_MEMBER'
);

ALTER TABLE TBL_MEMBER_AUTH DROP CONSTRAINT FK_MEMBER_AUTH;







