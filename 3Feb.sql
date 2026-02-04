CREATE TABLE oltp.public.retail_orders_oltp (
    order_id VARCHAR(10),
    order_timestamp DATETIME,
    order_status VARCHAR(20),

    customer_id VARCHAR(10),
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(15),
    customer_city VARCHAR(50),
    customer_state VARCHAR(10),

    product_id VARCHAR(10),
    product_name VARCHAR(100),
    product_category VARCHAR(50),

    store_id VARCHAR(10),
    store_city VARCHAR(50),
    store_state VARCHAR(10),
    store_region VARCHAR(20),

    quantity INT,
    unit_price INT,
    discount_amount INT,
    payment_type VARCHAR(20),

    record_created_at DATETIME,
    record_updated_at DATETIME
);

INSERT INTO oltp.public.retail_orders_oltp VALUES
-- O1001
('O1001','2023-06-01 10:15:00','COMPLETED',
 'C001','Rahul Sharma','rahul.sharma@gmail.com','9876543210','Mumbai','MH',
 'P101','iPhone 14','Electronics',
 'S01','Mumbai','MH','West',
 1,70000,2000,'CARD',
 '2023-06-01 10:15:05','2023-06-01 10:15:05'),

-- O1002
('O1002','2023-06-01 10:45:00','COMPLETED',
 'C001','Rahul Sharma','rahul.sharma@gmail.com','9876543210','Mumbai','MH',
 'P102','AirPods','Electronics',
 'S01','Mumbai','MH','West',
 2,15000,0,'UPI',
 '2023-06-01 10:45:03','2023-06-01 10:45:03'),

-- O1003
('O1003','2023-06-02 11:30:00','CANCELLED',
 'C002','Anita Mehta','anita.mehta@yahoo.com','9123456789','Bangalore','KA',
 'P103','Office Chair','Furniture',
 'S02','Bangalore','KA','South',
 1,12000,1000,'CARD',
 '2023-06-02 11:30:02','2023-06-02 11:30:02'),

-- O1004
('O1004','2023-06-03 09:20:00','COMPLETED',
 'C003','John Dsouza','john.ds@gmail.com','9988776655','Delhi','DL',
 'P104','Running Shoes','Fashion',
 'S03','Delhi','DL','North',
 1,5000,500,'NETBANKING',
 '2023-06-03 09:20:04','2023-06-03 09:20:04'),

-- O1005
('O1005','2023-06-03 21:10:00','FAILED',
 'C002','Anita Mehta','anita.mehta@yahoo.com','9123456789','Bangalore','KA',
 'P101','iPhone 14','Electronics',
 'S02','Bangalore','KA','South',
 1,70000,0,'CARD',
 '2023-06-03 21:10:01','2023-06-03 21:10:01'),

-- O1006 (Customer email + city change)
('O1006','2023-06-04 08:05:00','COMPLETED',
 'C001','Rahul Sharma','rahul.new@gmail.com','9876543210','Pune','MH',
 'P105','Study Table','Furniture',
 'S04','Pune','MH','West',
 1,18000,2000,'UPI',
 '2023-06-04 08:05:03','2023-06-04 08:05:03'),

-- O1007 (Late arriving)
('O1007','2023-05-28 19:30:00','COMPLETED',
 'C004','Priya Iyer','priya.iyer@gmail.com','9001122334','Chennai','TN',
 'P106','Smart Watch','Electronics',
 'S05','Chennai','TN','South',
 1,22000,1000,'CARD',
 '2023-06-05 09:00:00','2023-06-05 09:00:00'),

-- Duplicate O1004 (DQ issue)
('O1004','2023-06-03 09:20:00','COMPLETED',
 'C003','John Dsouza','john.ds@gmail.com','9988776655','Delhi','DL',
 'P104','Running Shoes','Fashion',
 'S03','Delhi','DL','North',
 1,5000,500,'NETBANKING',
 '2023-06-03 09:20:04','2023-06-03 10:00:00');

select * from oltp.public.retail_orders_oltp;

CREATE TABLE oltp.public.product_type_lookup (
    payment_type VARCHAR(20),
    is_digital CHAR(1)
);

INSERT INTO oltp.public.product_type_lookup (payment_type, is_digital) VALUES
('CARD', 'Y'),
('UPI', 'Y'),
('NETBANKING', 'Y'),
('COD', 'N');

SELECT * FROM oltp.public.product_type_lookup;

CREATE TABLE oltp.public.payment_type_lookup (
    payment_type VARCHAR(20),
    is_digital CHAR(1)
);

INSERT INTO oltp.public.payment_type_lookup (payment_type, is_digital) VALUES
('CARD', 'Y'),
('UPI', 'Y'),
('NETBANKING', 'Y'),
('COD', 'N');

CREATE TABLE oltp.public.store_region_lookup (
    store_region VARCHAR(20),
    region_head VARCHAR(50)
);

INSERT INTO oltp.public.store_region_lookup (store_region, region_head) VALUES
('West',  'West Zone'),
('South', 'South Zone'),
('North', 'North Zone');

CREATE TABLE oltp.public.product_category_lookup (
    product_category VARCHAR(50),
    category_description VARCHAR(200)
);


INSERT INTO oltp.public.product_category_lookup (product_category, category_description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Furniture',   'Home and office furniture'),
('Fashion',     'Clothing and lifestyle products');

-- DATA MODEL:

CREATE or replace TABLE dwh.public.Dim_customer_scd2 (
    PK_CustomerKey NUMBER PRIMARY KEY,
    customer_id VARCHAR(8),
    customer_name VARCHAR(32),
    customer_email VARCHAR(64),
    customer_phone VARCHAR(16),
    customer_city VARCHAR(32),
    customer_state VARCHAR(16),

    START_DATE DATE,
    END_DATE DATE,
    version NUMBER,
    flag CHAR(1)
);

CREATE TABLE dwh.public.Dim_product_scd1 (
    PK_ProductKey NUMBER PRIMARY KEY,
    product_id VARCHAR(8),
    product_name VARCHAR(32),
    product_category VARCHAR(32),
    created_date date,
    updated_date date
);

CREATE TABLE dwh.public.Dim_store_scd1 (
    PK_StoreKey NUMBER PRIMARY KEY,
    store_id VARCHAR(8),
    store_city VARCHAR(32),
    store_state VARCHAR(16),
    store_region VARCHAR(16),
    created_date date,
    updated_date date
);

CREATE TABLE dwh.public.Dim_payment_type_lookup (
    PK_PaymentKey NUMBER PRIMARY KEY,
    payment_type VARCHAR(20),
    is_digital CHAR(1),
    created_date date,
    updated_date date
);

CREATE TABLE dwh.public.Dim_product_category_lookup (
    PK_product_category_key NUMBER PRIMARY KEY,
    product_category VARCHAR(32),
    category_description VARCHAR(128),
    created_date date,
    updated_date date
);

CREATE TABLE dwh.public.Dim_store_region_lookup (
    PK_store_region_key NUMBER PRIMARY KEY,
    store_region VARCHAR(16),
    region_head VARCHAR(32),
    created_date date,
    updated_date date
);


CREATE TABLE dwh.public.Dim_date (
    PK_DateKey NUMBER PRIMARY KEY,
    date DATE,
    day_number NUMBER,
    month_num NUMBER,
    year NUMBER,
    day_name VARCHAR(16),
    created_date date,
    updated_date date
);


CREATE or replace TABLE dwh.public.fact_order (
    FK_CustomerKey int,
    FK_ProductKey int,
    FK_StoreKey int,
    FK_PaymentKey int,
    FK_DateKey int,

    order_id VARCHAR(16),
    quantity int,
    order_timetamp date,
    discount_amount int,

    created_at DATE
);

-- SILVER LAYER:

CREATE or replace TABLE dwh.public.silver_customers (
    customer_id VARCHAR(8) NOT NULL,
    customer_name VARCHAR(32) NOT NULL,
    customer_email VARCHAR(64) NOT NULL,
    customer_phone VARCHAR(16) not null,
    customer_city VARCHAR(32) not null,
    customer_state VARCHAR(16) not null,
    record_updated_at DATETIME
);


create or replace table dwh.public.silver_products(
    product_id VARCHAR(8) not null,
    product_name VARCHAR(32) not null,
    product_category VARCHAR(32) not null,
    product_description varchar(128) not null,
    record_updated_at DATETIME
);

CREATE or replace TABLE dwh.public.silver_stores (
    store_id VARCHAR(8) NOT NULL,
    store_city VARCHAR(32) NOT NULL,
    store_state VARCHAR(16) NOT NULL,
    store_region VARCHAR(16) NOT NULL,
    region_head varchar(32) not null,
    record_updated_at DATETIME
);

CREATE or replace TABLE dwh.public.silver_orders (
    order_id VARCHAR(16) NOT NULL,
    quantity int NOT NULL,
    discount_amount int not null,
    order_timetamp date not null,
    record_updated_at DATETIME
);




-- INSERTION FROM OLTP TO SILVER LAYER:

select * from oltp.public.retail_orders_oltp;

INSERT INTO dwh.public.silver_customers
SELECT DISTINCT
    TRIM(customer_id)     AS customer_id,
    TRIM(customer_name)   AS customer_name,
    TRIM(customer_email)  AS customer_email,
    TRIM(customer_phone)  AS customer_phone,
    TRIM(customer_city)   AS customer_city,
    TRIM(customer_state)  AS customer_state,
    record_updated_at
FROM oltp.public.retail_orders_oltp
WHERE 
  LENGTH(customer_id)    <= 8
  AND LENGTH(customer_name)  <= 32
  AND LENGTH(customer_email) <= 64
  AND LENGTH(customer_phone) <= 16
  AND LENGTH(customer_city)  <= 32
  AND LENGTH(customer_state) <= 16;



drop table dwh.public.silver_customers;

SELECT * FROM dwh.public.silver_customers;


INSERT INTO dwh.public.silver_products
SELECT DISTINCT
    TRIM(o.product_id)               AS product_id,
    TRIM(o.product_name)             AS product_name,
    TRIM(o.product_category)         AS product_category,
    TRIM(l.category_description)     AS product_description,
    record_updated_at
FROM oltp.public.retail_orders_oltp o
INNER JOIN oltp.public.product_category_lookup l
    ON o.product_category = l.product_category
WHERE 
  LENGTH(o.product_id)           <= 8
  AND LENGTH(o.product_name)         <= 32
  AND LENGTH(o.product_category)     <= 32
  AND LENGTH(l.category_description) <= 200;

drop table dwh.public.silver_products;

SELECT * FROM dwh.public.silver_products;


INSERT INTO dwh.public.silver_stores
SELECT DISTINCT
    TRIM(r.store_id)     AS store_id,
    TRIM(r.store_city)   AS store_city,
    TRIM(r.store_state)  AS store_state,
    TRIM(r.store_region) AS store_region,
    TRIM(s.region_head)  AS region_head,
    record_updated_at
FROM oltp.public.retail_orders_oltp r
INNER JOIN oltp.public.store_region_lookup s
    ON TRIM(r.store_region) = TRIM(s.store_region)
WHERE 
  LENGTH(r.store_id)     <= 8
  AND LENGTH(r.store_city)   <= 32
  AND LENGTH(r.store_state)  <= 16
  AND LENGTH(r.store_region) <= 16
  AND LENGTH(s.region_head)  <= 32;

SELECT * FROM dwh.public.silver_stores;
drop table dwh.public.silver_stores;



INSERT INTO dwh.public.silver_orders
SELECT DISTINCT
    TRIM(order_id)              AS order_id,
    quantity,
    discount_amount,
    CAST(order_timestamp AS DATE) AS order_timestamp,
    record_updated_at
FROM oltp.public.retail_orders_oltp
WHERE quantity > 0
  AND order_id IS NOT NULL
  AND LENGTH(order_id) <= 16;

SELECT * FROM dwh.public.silver_orders;
drop table dwh.public.silver_orders;



-- INCREMENTAL LOGIC:

MERGE INTO dwh.public.silver_customers AS tgt
USING (
    SELECT DISTINCT
        TRIM(customer_id)     AS customer_id,
        TRIM(customer_name)   AS customer_name,
        TRIM(customer_email)  AS customer_email,
        TRIM(customer_phone)  AS customer_phone,
        TRIM(customer_city)   AS customer_city,
        TRIM(customer_state)  AS customer_state,
        record_updated_at
    FROM oltp.public.retail_orders_oltp
) AS src
ON tgt.customer_id = src.customer_id
WHEN MATCHED AND src.record_updated_at > tgt.record_updated_at THEN
    UPDATE SET
        customer_name  = src.customer_name,
        customer_email = src.customer_email,
        customer_phone = src.customer_phone,
        customer_city  = src.customer_city,
        customer_state = src.customer_state,
        record_updated_at = src.record_updated_at
WHEN NOT MATCHED THEN
    INSERT (customer_id, customer_name, customer_email, customer_phone, customer_city, customer_state, record_updated_at)
    VALUES (src.customer_id, src.customer_name, src.customer_email, src.customer_phone, src.customer_city, src.customer_state, src.record_updated_at);

SELECT * FROM dwh.public.silver_customers;



MERGE INTO dwh.public.silver_products AS tgt
USING (
    SELECT DISTINCT
        TRIM(o.product_id) AS product_id,
        TRIM(o.product_name) AS product_name,
        TRIM(o.product_category) AS product_category,
        TRIM(l.category_description) AS product_description,
        record_updated_at
    FROM oltp.public.retail_orders_oltp o
    JOIN oltp.public.product_category_lookup l
        ON o.product_category = l.product_category
) AS src
ON tgt.product_id = src.product_id
WHEN MATCHED AND src.record_updated_at > tgt.record_updated_at THEN
    UPDATE SET
        product_name = src.product_name,
        product_category = src.product_category,
        product_description = src.product_description,
        record_updated_at = src.record_updated_at
WHEN NOT MATCHED THEN
    INSERT (product_id, product_name, product_category, product_description, record_updated_at)
    VALUES (src.product_id, src.product_name, src.product_category, src.product_description, src.record_updated_at);


MERGE INTO dwh.public.silver_stores AS tgt
USING (
    SELECT DISTINCT
        TRIM(r.store_id) AS store_id,
        TRIM(r.store_city) AS store_city,
        TRIM(r.store_state) AS store_state,
        TRIM(r.store_region) AS store_region,
        TRIM(s.region_head) AS region_head,
        record_updated_at
    FROM oltp.public.retail_orders_oltp r
    JOIN oltp.public.store_region_lookup s
        ON r.store_region = s.store_region
) AS src
ON tgt.store_id = src.store_id
WHEN MATCHED AND src.record_updated_at > tgt.record_updated_at THEN
    UPDATE SET
        store_city = src.store_city,
        store_state = src.store_state,
        store_region = src.store_region,
        region_head = src.region_head,
        record_updated_at = src.record_updated_at
WHEN NOT MATCHED THEN
    INSERT (store_id, store_city, store_state, store_region, region_head, record_updated_at)
    VALUES (src.store_id, src.store_city, src.store_state, src.store_region, src.region_head, src.record_updated_at);


MERGE INTO dwh.public.silver_orders AS tgt
USING (
    SELECT DISTINCT
        TRIM(order_id) AS order_id,
        quantity,
        discount_amount,
        CAST(order_timestamp AS DATE) AS order_timestamp,
        record_updated_at
    FROM oltp.public.retail_orders_oltp
) AS src
ON tgt.order_id = src.order_id
WHEN MATCHED AND src.record_updated_at > tgt.record_updated_at THEN
    UPDATE SET
        quantity = src.quantity,
        discount_amount = src.discount_amount,
        order_timetamp = src.order_timestamp,
        record_updated_at = src.record_updated_at
WHEN NOT MATCHED THEN
    INSERT (order_id, quantity, discount_amount, order_timetamp, record_updated_at)
    VALUES (src.order_id, src.quantity, src.discount_amount, src.order_timestamp, src.record_updated_at);


-- ADD DATA TO GOLD LAYER:

INSERT INTO dwh.public.Dim_customer_scd2 (
    PK_CustomerKey,
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    START_DATE,
    END_DATE,
    version,
    flag
)
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS PK_CustomerKey,
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    CURRENT_DATE       AS START_DATE,
    '9999-12-31'       AS END_DATE,
    1                  AS version,
    'Y'                AS flag
FROM dwh.public.silver_customers;



select * from dwh.public.Dim_customer_scd2 ;


INSERT INTO dwh.public.Dim_product_scd1 (
    PK_ProductKey,
    product_id,
    product_name,
    product_category,
    created_date,
    updated_date
)
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS PK_ProductKey,
    product_id,
    product_name,
    product_category,
    CURRENT_DATE,
    CURRENT_DATE
FROM dwh.public.silver_products;


INSERT INTO dwh.public.Dim_store_scd1 (
    PK_StoreKey,
    store_id,
    store_city,
    store_state,
    store_region,
    created_date,
    updated_date
)
SELECT
    ROW_NUMBER() OVER (ORDER BY store_id) AS PK_StoreKey,
    store_id,
    store_city,
    store_state,
    store_region,
    CURRENT_DATE,
    CURRENT_DATE
FROM dwh.public.silver_stores;


INSERT INTO dwh.public.Dim_payment_type_lookup (
    PK_PaymentKey,
    payment_type,
    is_digital,
    created_date,
    updated_date
)
SELECT
    ROW_NUMBER() OVER (ORDER BY payment_type) AS PK_PaymentKey,
    payment_type,
    is_digital,
    CURRENT_DATE,
    CURRENT_DATE
FROM oltp.public.payment_type_lookup;



INSERT INTO dwh.public.Dim_product_category_lookup (
    PK_product_category_key,
    product_category,
    category_description,
    created_date,
    updated_date
)
SELECT
    ROW_NUMBER() OVER (ORDER BY product_category) AS PK_product_category_key,
    product_category,
    category_description,
    CURRENT_DATE,
    CURRENT_DATE
FROM oltp.public.product_category_lookup;



