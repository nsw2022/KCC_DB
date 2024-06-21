create table emp01(
    empno Number ,
    ename VARCHAR2(20) ,
    job varchar2(20),
    deptno NUMBER
);

insert into emp01 values(null, null, 'IT', 30);

create table emp02(
    empno Number not null,
    ename VARCHAR2(20) not null,
    job varchar2(20),
    deptno NUMBER
);

drop table emp01;


insert into emp02 values(100, 'kim', 'IT', 30);
insert into emp02 values(100, 'park', 'IT', 30);

select * from emp02;

create table emp03(
    empno Number UNIQUE,
    ename VARCHAR2(20) not null,
    job varchar2(20),
    deptno NUMBER
);

insert into emp03 values(100, 'kim', 'IT', 30);
insert into emp03 values(100, 'park', 'IT', 30);


create table emp04(
    empno Number PRIMARY KEY,
    ename VARCHAR2(20) not null,
    job varchar2(20),
    deptno NUMBER
);

insert into emp04 values(100, 'kim', 'IT', 30);
insert into emp04 values(100, 'park', 'IT', 30);

create table emp05(
    empno Number PRIMARY KEY,
    ename VARCHAR2(20) not null,
    job varchar2(20),
    deptno NUMBER REFERENCES departments(department_id)
);

insert into emp05 values(200, 'kim', 'IT', 3000);

create table emp06(
    empno Number,
    ename VARCHAR2(20) not null,
    job varchar2(20),
    deptno NUMBER,
    
    CONSTRAINT emp06_empno_pk PRIMARY KEY(empno),
    CONSTRAINT emp06_deptno_fk FOREIGN KEY(deptno)
	    REFERENCES departments(department_id)
);

create table emp07(
    empno Number,
    ename VARCHAR2(20),
    job varchar2(20),
    deptno NUMBER
  
);

alter table emp07 add CONSTRAINT emp07_empno_pk PRIMARY key(empno);
alter table emp07 add CONSTRAINT emp07_deptno_kf FOREIGN key(empno)
    REFERENCES departments(department_id);
    
alter table emp07 modify ename constraint emp07_ename_nn Not null;    

desc emp07;

create table emp08(
    empno Number,
    ename VARCHAR2(20),
    job varchar2(20),
    deptno NUMBER
  
);
-- 여러 제약 조건을 한 번에 추가
ALTER TABLE emp08
    ADD(
        CONSTRAINT emp08_empno_pk PRIMARY KEY(empno),
        CONSTRAINT emp08_deptno_fk FOREIGN KEY(deptno)
        REFERENCES departments(department_id)
    )
    MODIFY ename CONSTRAINT emp08_ename_nn NOT NULL;

create table emp09(
    empno NUMBER,
    ename VARCHAR2(20),
    job VARCHAR2(20),
    deptno NUMBER,
    gender CHAR(1) CHECK(gender IN('M','F'))
);

insert into emp09 values(1,'승우','구직자',20,'ㅎ');


create table emp10(
    empno NUMBER,
    ename VARCHAR2(20),
    job VARCHAR2(20),
    deptno NUMBER,
    loc VARCHAR2(20) DEFAULT 'Seoul'
);

insert into emp10(empno, ename, job, deptno) VALUES(1,'승우','구직자',100);
select * from emp10;

create table emp11(
    empno NUMBER,
    ename VARCHAR2(20),
    job VARCHAR2(20),
    deptno NUMBER, 
    
    CONSTRAINT empno_pk PRIMARY key(empno,ename)
);

insert into emp11 VALUES(100, 'kim','비서',100);
insert into emp11 VALUES(100, 'park','사장',100);
insert into emp11 VALUES(100, 'kim','사장',100);
select * from emp11;


drop table emp11;
desc emp11;


create table emp12(
    empno NUMBER,
    ename VARCHAR2(20),
    job VARCHAR2(20),
    deptno NUMBER
);

alter table dept01 add CONSTRAINT dept01_department_id_pk PRIMARY key(DEPARTMENT_ID);
alter table emp12 add CONSTRAINT emp12_deptno_pk FOREIGN key(deptno)
    REFERENCES dept01(DEPARTMENT_ID);
    
insert into emp12 VALUES(10,'승우','개발자',30);

delete from emp12 where deptno = 30;
delete from dept01 where department_id=30;


create table emp13(
    empno NUMBER,
    ename VARCHAR2(20),
    job VARCHAR2(20),
    deptno NUMBER REFERENCES dept01(DEPARTMENT_ID)
    on DELETE CASCADE
);


insert into emp13 VALUES(100,'kim','웹개발자',20);
delete from dept01 where department_id = 20;
select * from emp13;



create table emp14(
    ename VARCHAR2,
    deptno NUMBER
);

























