create database DWH;
use DWH;
create table Dim_product(
PK_ProductKey int primary key auto_increment,
product_id varchar(8),
product_name varchar(16),
product_price int,
product_brand varchar(16),
product_category varchar(16)
);

create table Dim_customer(
PK_CustomerKey int primary key auto_increment,
customer_id varchar(8),
customer_name varchar(16),
customer_email varchar(32),
customer_phone varchar(16),
customer_city varchar(16),
customer_state varchar(16),
customer_country varchar(16),
created_date date,
updated_date date
);

create table Dim_store(
PK_StoreKey int primary key auto_increment,
store_id varchar(8),
store_name varchar(16),
store_city varchar(16),
store_state varchar(16),
store_country varchar(16),
created_date date,
updated_date date
);

create table Dim_payment(
PK_PaymentKey int primary key auto_increment,
payment_mode varchar(16),
created_date date,
updated_date date
);

create table Dim_Date(
PK_Date int primary key,
Date date,
day_number int,
month_num int,
Year int,
day_name varchar(16),
created_date date,
updated_date date
);

create table fact_Order (
PK_Order_Key int primary key auto_increment,
FK_Product int,
FK_Customer int,
FK_Store int,
FK_Payment int,
FK_Date int,
quantity int,
transaction_date date,
order_id varchar(8),
created_date date,
foreign key(FK_Product) references Dim_product(PK_ProductKey),
foreign key(FK_Customer) references Dim_customer(PK_CustomerKey),
foreign key(FK_Store) references Dim_store(PK_StoreKey),
foreign key(FK_Payment) references Dim_payment(PK_PaymentKey),
foreign key(FK_Date) references Dim_Date(PK_Date)
);

 create database OLTP;
 use OLTP;

CREATE TABLE sales (
    transaction_id VARCHAR(8),
    order_id VARCHAR(8),
    order_date DATE,
    customer_id VARCHAR(8),
    customer_name VARCHAR(16),
    customer_email VARCHAR(32),
    customer_phone VARCHAR(16),
    customer_city VARCHAR(16),
    customer_state VARCHAR(16),
    customer_country VARCHAR(16),
    product_id VARCHAR(8),
    product_name VARCHAR(16),
    product_category VARCHAR(16),
    product_brand VARCHAR(16),
    store_id VARCHAR(8),
    store_name VARCHAR(16),
    store_city VARCHAR(16),
    store_state VARCHAR(16),
    store_country VARCHAR(16),
    quantity INT,
    unit_price INT,
    payment_mode VARCHAR(16)
);


INSERT INTO sales VALUES
('T001','O1001','2024-02-10','C001','Amit Sharma','amit@gmail.com','9876543210',
 'Bengaluru','KA','India','P001','iPhone 14','Mobile','Apple',
 'S001','Reliance Digital','Bengaluru','KA','India',1,70000,'Credit Card'),

('T002','O1001','2024-02-10','C001','Amit Sharma','amit@gmail.com','9876543210',
 'Bengaluru','KA','India','P003','AirPods Pro','Accessories','Apple',
 'S001','Reliance Digital','Bengaluru','KA','India',1,25000,'Credit Card'),

('T003','O1002','2024-02-11','C002','Neha Verma','neha@gmail.com','9123456780',
 'Pune','MH','India','P002','Galaxy S23','Mobile','Samsung',
 'S002','Croma','Pune','MH','India',1,65000,'UPI'),

('T004','O1003','2024-03-05','C003','Rahul Mehta','rahul@gmail.com','9988776655',
 'Mumbai','MH','India','P001','iPhone 14','Mobile','Apple',
 'S002','Croma','Pune','MH','India',2,70000,'Debit Card'),

('T005','O1004','2024-03-07','C004','Pooja Nair','pooja@gmail.com','9011223344',
 'Kochi','KL','India','P004','OnePlus 11','Mobile','OnePlus',
 'S003','Reliance Digital','Kochi','KL','India',1,60000,'UPI');
 
 select * from sales;

use dwh;

insert into dwh.Dim_payment (payment_mode,created_date,updated_date) select distinct payment_mode,now()as created_date,null as updated_date from OLTP.sales ;

select * from dwh.Dim_payment;

INSERT INTO dwh.Dim_product
(product_id, product_name, product_price, product_brand, product_category)
SELECT DISTINCT
    product_id,
    product_name,
    unit_price AS product_price,
    product_brand,
    product_category
FROM OLTP.sales;

select * from dwh.Dim_product;

INSERT INTO dwh.Dim_customer
(
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    customer_country,
    created_date,
    updated_date
)
SELECT DISTINCT
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    customer_country,
    CURDATE() AS created_date,
    NULL AS updated_date
FROM OLTP.sales;

SELECT * FROM dwh.Dim_customer;

INSERT INTO dwh.Dim_store
(
    store_id,
    store_name,
    store_city,
    store_state,
    store_country,
    created_date,
    updated_date
)
SELECT DISTINCT
    store_id,
    store_name,
    store_city,
    store_state,
    store_country,
    CURDATE() AS created_date,
    NULL AS updated_date
FROM OLTP.sales;

SELECT * FROM dwh.Dim_store;
SELECT
    p.PK_ProductKey,
    c.PK_CustomerKey,
    st.PK_StoreKey,
    pay.PK_PaymentKey,
    d.PK_Date,
    s.quantity,
    s.order_date AS transaction_date
FROM oltp.sales s
LEFT JOIN dwh.Dim_product p
    ON s.product_id = p.product_id
LEFT JOIN dwh.Dim_customer c
    ON s.customer_id = c.customer_id
LEFT JOIN dwh.Dim_store st
    ON s.store_id = st.store_id
LEFT JOIN dwh.Dim_payment pay
    ON s.payment_mode = pay.payment_mode
LEFT JOIN dwh.Dim_Date d
    ON s.order_date = d.Date;
    
create table Dim_product_scd2(
PK_ProductKey int primary key auto_increment,
product_id varchar(8),
product_name varchar(16),
product_price int,
product_brand varchar(16),
product_category varchar(16),
START_DATE date,
END_DATE date,
version int,
flag varchar(8)
);

create table Dim_customer_scd2(
PK_CustomerKey int primary key auto_increment,
customer_id varchar(8),
customer_name varchar(16),
customer_email varchar(32),
customer_phone varchar(16),
customer_city varchar(16),
customer_state varchar(16),
customer_country varchar(16),
START_DATE date,
END_DATE date,
version int,
flag varchar(8)
);

create table Dim_store_scd2(
PK_StoreKey int primary key auto_increment,
store_id varchar(8),
store_name varchar(16),
store_city varchar(16),
store_state varchar(16),
store_country varchar(16),
START_DATE date,
END_DATE date,
version int,
flag varchar(8)
);

-- Historical load:

INSERT INTO Dim_customer_scd2
(
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    customer_country,
    START_DATE,
    END_DATE,
    version,
    flag
)
SELECT DISTINCT
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    customer_city,
    customer_state,
    customer_country,
    CURDATE() AS START_DATE,
    NULL AS END_DATE,
    1 AS version,
    'Y' AS flag
FROM OLTP.sales;

select * from Dim_customer_scd2;

-- DO REMAINING 2:



-- SCD3:

create table Dim_store_scd3(
PK_StoreKey int primary key auto_increment,
store_id varchar(8),
store_name varchar(16),
store_city varchar(16),
store_state varchar(16),
store_country varchar(16),
prev_store_name varchar(16),
prev_store_city varchar(16),
prev_store_state varchar(16),
prev_store_country varchar(16),
created_date date,
updated_date date
);


INSERT INTO dwh.Dim_store_scd3
(
    store_id,
    store_name,
    store_city,
    store_state,
    store_country,
    prev_store_name,
    prev_store_city,
    prev_store_state,
    prev_store_country,
    created_date,
    updated_date
)
SELECT DISTINCT
    store_id,
    store_name,
    store_city,
    store_state,
    store_country,
    null,
    null,
    null,
    null,
    CURDATE() AS created_date,
    NULL AS updated_date
FROM OLTP.sales;

select * from Dim_store_scd3;







