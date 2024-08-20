drop table users;
create table users(
  id number primary key,
  name varchar2(50),
  joinDate DATE,
  password varchar2(50),
  ssn varchar2(50)
)

create sequence user_seq;

insert into users values(user_seq.nextval,'User1', sysdate, 'test1111','750411-111111');
insert into users values(user_seq.nextval,'User2', sysdate, 'test2222','850411-111111');
insert into users values(user_seq.nextval,'User3', sysdate, 'test3333','950411-111111');

create table post(
  id number primary key,
  description varchar2(50),
  user_id number references users(id)
)

create sequence post_seq;

insert into post values(post_seq.nextval, 'first post', 1);

select * from post;