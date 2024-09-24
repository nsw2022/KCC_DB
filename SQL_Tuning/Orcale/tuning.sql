-- ���̺�� �������� �̹� �����ϴ� ��� ����
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users PURGE';
    EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

-- ������ ����
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;

-- ���̺� ����
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR2(100),
    age INT
);


-- ������ ����
BEGIN
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '�ڹ̳�', 26);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '�����', 23);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '�����', 21);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '������',  24);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '���α�', 23);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '�����', 22);
    INSERT INTO users (id, name, age) VALUES (users_seq.nextVAL, '������', 22);
    COMMIT;
END;

-- ���� ��ȹ ����
EXPLAIN PLAN FOR
SELECT * FROM users WHERE age = 23;

-- ���� ��ȹ ���
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ���� ��ȹ ������
-- ��Ƽ �÷� �ε��� ����
CREATE INDEX idx_name_age ON users (name, age);

-- ���� ��ȹ �缳�� �� ���
EXPLAIN PLAN FOR
SELECT * FROM users WHERE name = '�����' AND age = 23;

-- ���� ��ȹ ���
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
