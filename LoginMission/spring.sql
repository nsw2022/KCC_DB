CREATE TABLE mission_users (
    user_id  VARCHAR2(50) NOT NULL PRIMARY KEY,
    user_name    VARCHAR2(50) NOT NULL,
    user_pass    VARCHAR2(100) NOT NULL,
    user_reg_date DATE DEFAULT SYSDATE
);

INSERT INTO mission_users (user_id, user_name,  user_pass)
VALUES ('user1234', '노승우',  '1234');


drop table mission_users;
select * from mission_users;

select * from mission_users where user_id = 'tmddn3140' and user_pass = '!A12345678';


CREATE TABLE shopping_cart (
    cart_id NUMBER PRIMARY KEY,
    user_id VARCHAR2(50) NOT NULL,
    product_id VARCHAR2(255) NOT NULL,
    product_name VARCHAR2(255) NOT NULL,
    quantity NUMBER NOT NULL,
    price NUMBER NOT NULL,
    created_at DATE DEFAULT SYSDATE
);

CREATE SEQUENCE shopping_cart_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


ALTER TABLE shopping_cart ADD image_path VARCHAR2(500);

ALTER TABLE shopping_cart
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES product (product_id);

drop table shopping_cart;
drop SEQUENCE shopping_cart_seq;
INSERT INTO shopping_cart (cart_id, user_id, product_id, product_name, quantity, price, created_at, image_path)
VALUES (shopping_cart_seq.NEXTVAL, 'tmddn3410', 'prod001', '상품 1', 1, 10000, SYSDATE, '/resources/images/products/prod001.jpg');

INSERT INTO shopping_cart (cart_id, user_id, product_id, product_name, quantity, price, created_at, image_path)
VALUES (shopping_cart_seq.NEXTVAL, 'tmddn3410', 'prod002', '상품 2', 2, 20000, SYSDATE, '/resources/images/products/prod002.jpg');

INSERT INTO shopping_cart (cart_id, user_id, product_id, product_name, quantity, price, created_at, image_path)
VALUES (shopping_cart_seq.NEXTVAL, 'tmddn3410', 'prod003', '상품 3', 1, 15000, SYSDATE, '/resources/images/products/prod003.jpg');

INSERT INTO shopping_cart (cart_id, user_id, product_id, product_name, quantity, price, created_at, image_path)
VALUES (shopping_cart_seq.NEXTVAL, 'tmddn3410', 'prod004', '상품 4', 3, 30000, SYSDATE, '/resources/images/products/prod004.jpg');


select * from shopping_cart;



CREATE TABLE product (
    product_id VARCHAR2(255) PRIMARY KEY,
    product_name VARCHAR2(255) NOT NULL,
    price NUMBER NOT NULL,
    image_path VARCHAR2(500),
    description VARCHAR2(1000)
);

CREATE SEQUENCE product_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
INSERT INTO product (product_id, product_name, price, image_path, description)
VALUES ('prod001', '상품 1', 10000, '/resources/images/products/prod001.jpg', '상품 1에 대한 설명입니다.');

INSERT INTO product (product_id, product_name, price, image_path, description)
VALUES ('prod002', '상품 2', 20000, '/resources/images/products/prod002.jpg', '상품 2에 대한 설명입니다.');

INSERT INTO product (product_id, product_name, price, image_path, description)
VALUES ('prod003', '상품 3', 15000, '/resources/images/products/prod003.jpg', '상품 3에 대한 설명입니다.');

INSERT INTO product (product_id, product_name, price, image_path, description)
VALUES ('prod004', '상품 4', 30000, '/resources/images/products/prod004.jpg', '상품 4에 대한 설명입니다.');



