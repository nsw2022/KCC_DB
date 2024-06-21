create table dept_const(
    deptno number(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

alter table dept_const
    add(
        CONSTRAINT DEPTCONST_DEPTNO_PK PRIMARY key (deptno),
        CONSTRAINT DEPTCONST_DNAME_UNQ UNIQUE (dname)
        
    )
    modify loc not null;
    
desc dept_const;

create table emp_const(
    empno number(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    tel VARCHAR2(20),
    hiredate Date,
    sal number(7),
    comm number(7),
    deptno number(2)
);

alter table emp_const
    add(
        CONSTRAINT EMPCONST_EMPNO_PK PRIMARY KEY(empno),
        CONSTRAINT EMPCONST_TEL_UNQ UNIQUE (tel),
        CONSTRAINT EMPCONST_SQL_CHK check(sal>=1000 and sal<=9999),
        CONSTRAINT EMPCONST_DEPTNO_FK FOREIGN key(deptno)
            REFERENCES dept_const(deptno)
    )
    modify ename CONSTRAINT EMPCONST_ENAME_NN not null;
    
desc emp_const;    
