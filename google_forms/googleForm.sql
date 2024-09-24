-- 시퀀스 생성
CREATE SEQUENCE survey_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE survqust_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE qustopt_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE answer_seq START WITH 1 INCREMENT BY 1;

-- 설문 조사 테이블
CREATE TABLE SURVEY (
    surv_no int PRIMARY KEY,
    surv_title VARCHAR2(100) NOT NULL,
    surv_desc CLOB,
    useYn CHAR(1) DEFAULT 'Y',
    delYn CHAR(1) DEFAULT 'N',
    reg_Id VARCHAR2(20),
    reg_date DATE DEFAULT SYSDATE,
    mod_date DATE DEFAULT SYSDATE
);

-- 설문 질문 내용 테이블
CREATE TABLE SURVQUST (
    qust_no int PRIMARY KEY,
    surv_no int NOT NULL,
    qust_cont VARCHAR2(200),
    qust_type VARCHAR2(10),
    qust_seq int,
    FOREIGN KEY (surv_no) REFERENCES SURVEY(surv_no)
);


-- 제공 답변 테이블
CREATE TABLE QUSTOPT (
    opt_no int PRIMARY KEY,
    qust_no int NOT NULL,
    opt_cont VARCHAR2(100) NOT NULL,
    opt_seq int,
    FOREIGN KEY (qust_no) REFERENCES SURVQUST(qust_no)
);

-- 응답 결과 테이블
CREATE TABLE ANSWER (
    answ_no int PRIMARY KEY,
    qust_no int NOT NULL,
    mem_id VARCHAR2(20) NOT NULL,
    answ_cont VARCHAR2(100),
    answ_long CLOB,
    answ_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (qust_no) REFERENCES SURVQUST(qust_no),
    FOREIGN KEY (mem_id) REFERENCES MEMBER(mem_id)
);

-- 회원 테이블
CREATE TABLE MEMBER (
    mem_id VARCHAR2(20) PRIMARY KEY,
    mem_pw VARCHAR2(200) NOT NULL,
    mem_nick VARCHAR2(20) NOT NULL
);

