create database employee;
use employee;

create table employees(
emp_id int primary key,
emp_name varchar(100) not null,
dob date,
address varchar(100),
phonenumber int
);

create table emp_dept(
dept_id int primary key,
dept_name varchar(100),
emp_id int,
foreign key(emp_id) references employees(emp_id)
);

create table emp_dept_1(
dept_id int primary key,
dept_name varchar(100),
emp_id int,
constraint emp_id_constraint foreign key(emp_id) references employees(emp_id)
);

ALTER TABLE orders
DROP FOREIGN KEY fk_orders_customer;

insert into employees values (1,"jignesh","2003-11-28","Ongole",910025681);
select * from employees;

create table orders(
order_id int primary key auto_increment,
order_details varchar(128) not null
);


INSERT INTO orders (order_details)
VALUES ("pineapple"),("custardapple"),("chilly"),("guava"),("strawberry");

select * from orders;

create table emp_1(
emp_id int primary key auto_increment,
emp_name varchar(16),
emp_dob date,
emp_phoneno varchar(16),
emp_addr varchar(32),
emp_bloodgrp varchar(8)
);

create table emp_2(
id int primary key auto_increment,
name varchar(16),
dob date,
phoneno varchar(16),
addr varchar(32),
bloodgrp varchar(8)
);

create table emp_3(
id int primary key,
name varchar(16),
dob date,
phoneno varchar(16),
addr varchar(32),
bloodgrp varchar(8)
);


select * from emp_1;
insert into emp_1 values (1,"Jignesh","2003-11-28","9100256817","Ongole","O+"),(2,"Arun","2004-11-28","9100256117","Hyderabad","O-"),(3,"Narayana","2005-11-28","9100256217","AP","AB-");

select * from emp_2;
insert into emp_3 values (5,"Kenny","1990-11-28","12345678890","Bangalore","O+"),(6,"karuna","1999-11-28","0987654321","Telangana","O-");
insert into emp_3 (name,dob,phoneno,addr,bloodgrp)values ("Kenny","1990-11-28","12345678890","Bangalore","O+");


insert into emp_2(name,dob,phoneno,addr,bloodgrp) select emp_name,emp_dob,emp_phoneno,emp_addr,emp_bloodgrp from emp_1 ; 

update emp_2 set name = "Ram" where addr = "AP";
set sql_safe_updates=0;


-- prod : id name price
-- orders : o_id, pid,qnty,sales_value

create table products (
p_id int primary key auto_increment,
p_name varchar(16),
p_price decimal(10,2)
);

INSERT INTO products (p_name, p_price) VALUES
("Apple", 120.50),
("Banana", 40.00),
("Grapes", 90.75),
("Mango", 150.00),
("Orange", 60.25);
INSERT INTO products (p_name, p_price) VALUES
("Strawberry","2222.89");
select * from products;

create table orders(
o_id int primary key auto_increment,
p_id int not null,
constraint p_id_constraint foreign key(p_id) references products(p_id),
sales_value decimal(10,2)
);

UPDATE orders SET quantity = 10, sales_value = 0 WHERE p_id = 1; -- Apple
UPDATE orders SET quantity = 25, sales_value = 0 WHERE p_id = 2; -- Banana
UPDATE orders SET quantity = 12, sales_value = 0 WHERE p_id = 3; -- Grapes
UPDATE orders SET quantity = 8,  sales_value = 0 WHERE p_id = 4; -- Mango
UPDATE orders SET quantity = 20, sales_value = 0 WHERE p_id = 5; -- Orange


INSERT INTO orders (p_id, sales_value) VALUES
(1, 0),
(2, 0),
(3, 0),
(4, 0),
(5, 0);

select * from orders;

update orders as o inner join products as p on p.p_id=o.p_id set o.sales_value=p.p_price*o.quantity;

delete p from products as p join orders as o on p.p_id!=o.p_id;

-- PREDEFINED FUNCTIONS :substring concat regex length

select concat(p_id," ",o_id," ",sales_value) as new_col from orders;

-- id,fn,ls,c_date,sal
create table slaves (
id int primary key auto_increment,
fname varchar(8),
lname varchar(8),
joining_date date,
salary decimal(10,2)
);

INSERT INTO slaves (fname, lname, joining_date, salary) VALUES
("Ravi",   "Kumar",  "2021-06-15", 25000.00),
("Anil",   "Reddy",  "2020-03-10", 30000.00),
("Sita",   "Devi",   "2022-01-20", 28000.00),
("Manoj",  "Sharma", "2019-11-05", 35000.00),
("Priya",  "Singh",  "2023-07-01", 22000.00);

SELECT * FROM slaves;

select concat_ws(' ',id,fname, lname, joining_date, salary) as new_col from slaves;

select length(fname) from slaves;
select char_length(fname) from slaves;
select concat_ws(" ",substring(fname,1,3),substring(lname,length(lname)-1)) from slaves; 

select * from slaves where fname REGEXP '^Ra';
select * from slaves where fname REGEXP 'vi$';
select * from slaves where fname REGEXP 'av ?';
select * from slaves where fname REGEXP 'ni|av';
select * from slaves where fname REGEXP '[a-z]';
select * from slaves where fname REGEXP '[a-g]-[d]';
select * from slaves where fname REGEXP '[^ravi]';

create table slaves_1 (
id int primary key auto_increment,
created_date datetime,
joining_date date,
leaving_year year,
birthday timestamp
);

INSERT INTO slaves_1 (created_date, joining_date, leaving_year, birthday) VALUES
("2021-06-15 09:30:00", "2021-06-20", 2024, "1998-04-12 00:00:00"),
("2020-03-10 10:00:00", "2020-03-15", 2023, "1995-11-08 00:00:00"),
("2022-01-20 08:45:00", "2022-01-25", NULL, "2000-07-19 00:00:00"),
("2019-11-05 11:15:00", "2019-11-10", 2022, "1992-01-03 00:00:00"),
("2023-07-01 09:00:00", "2023-07-05", NULL, "2001-09-27 00:00:00");


select * from slaves_1;

describe slaves_1;

select date(now()),curdate(),curtime(),extract( second from now());

select date_add(now(), interval -1.5 year);

select date(created_date) as date from slaves_1;

select datediff(joining_date,date(created_date)) from slaves_1;


CREATE TABLE slaves_2 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(16),
    salary DECIMAL(10,2),
    height FLOAT,
    weight DOUBLE
);

INSERT INTO slaves_2 (name, salary, height, weight) VALUES
("Ravi", 25000.50, 5.7, 68.5),
("Sita", 30000.00, 5.4, 55.2),
("Anil", 28000.75, 5.9, 72.8);

select * from slaves_2;

select round(salary,1) as roundedvalue, ceil(salary) as ceilvalue, floor(salary) as floorvalue from slaves_2;

SELECT
    CASE
		WHEN height <= 5.4 THEN 5
        WHEN height > 5.4 THEN 6
    END AS height_category
FROM slaves_2;

CREATE TABLE MemberData (
    MemberId INT PRIMARY KEY,
    MemberName VARCHAR(16),
    SSN VARCHAR(16),
    Gender VARCHAR(1),
    insurance_id INT,
    expirydate DATETIME,
    CONSTRAINT fk_insurance_id
        FOREIGN KEY (insurance_id)
        REFERENCES insurance_provider(insurance_id)
);

INSERT INTO MemberData (MemberId, MemberName, SSN, Gender, insurance_id, expirydate) VALUES
(101, "Ravi",   "SSN101", "M", 1, "2026-12-31 23:59:59"),
(102, "Sita",   "SSN102", "F", 2, "2025-06-30 23:59:59"),
(103, "Anil",   "SSN103", "M", 3, "2027-03-15 23:59:59"),
(104, "Priya",  "SSN104", "F", 4, "2026-09-10 23:59:59");


CREATE TABLE insurance_provider (
    insurance_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(40),
    category VARCHAR(20),
    Insurancecost DECIMAL(10,2)
);

INSERT INTO insurance_provider (plan_name, category, Insurancecost) VALUES
("Health Basic", "Health", 12000.00),
("Health Premium", "Health", 25000.00),
("Life Secure", "Life", 18000.00),
("Family Plus", "Health", 30000.00);


select * from MemberData as m inner join insurance_provider  i on m.insurance_id=i.insurance_id;

select * from MemberData as m left join insurance_provider  i on m.insurance_id=i.insurance_id;

select * from MemberData as m right join insurance_provider  i on m.insurance_id=i.insurance_id;

SELECT *
FROM MemberData m
LEFT JOIN insurance_provider i
ON m.insurance_id = i.insurance_id

UNION

SELECT *
FROM MemberData m
RIGHT JOIN insurance_provider i
ON m.insurance_id = i.insurance_id;


CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,
    CONSTRAINT fk_manager
        FOREIGN KEY (manager_id)
        REFERENCES Employee(emp_id)
);

INSERT INTO Employee VALUES (1, 'David', 1000.00, NULL);
INSERT INTO Employee VALUES (2, 'John', 800.00, 1);
INSERT INTO Employee VALUES (3, 'Ramesh', 500.00, 2);

SELECT 
    e1.emp_name AS employee_name,
    e2.emp_name AS manager_name
FROM Employee e1
LEFT JOIN Employee e2
ON e1.manager_id = e2.emp_id;


select * from employee;










