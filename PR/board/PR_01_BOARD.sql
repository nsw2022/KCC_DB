-- 12 버전부터는 생성할때가능하다고함
--CREATE TABLE tbl_board (
--    seq NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
--    title VARCHAR2(255),
--    content CLOB,
--    author VARCHAR2(100),
--    created_date DATE DEFAULT SYSDATE,
--    PRIMARY KEY (seq)
--);


CREATE TABLE board (
    board_seq NUMBER PRIMARY KEY,
    title VARCHAR2(255),
    content CLOB,
    author VARCHAR2(100),
    created_date DATE DEFAULT SYSDATE,
    update_date DATE
);


DROP TABLE tbl_borad;

CREATE SEQUENCE board_seq
    START WITH 1
    INCREMENT BY 1;
    
    
BEGIN
  FOR i IN 1..121 LOOP
    INSERT INTO tbl_board (board_seq, title, content, author, created_date)
    VALUES (
      board_seq.NEXTVAL,
      'Title ' || TO_CHAR(i),
      'This is a sample content ' || DBMS_RANDOM.STRING('x', 100), -- 랜덤 문자열 생성
      'Author ' || TO_CHAR(DBMS_RANDOM.VALUE(1, 10), 'FM999'), -- 랜덤 숫자를 문자열로 변환
      SYSDATE - DBMS_RANDOM.VALUE(0, 365) -- 최대 365일 전 날짜
    );
  END LOOP;
  COMMIT;
END;
