Use school_db;

CREATE TABLE PUPIL (
	student_id INT auto_increment primary key,
	name varchar(50) not null,
	address varchar(150),
	class varchar(5),
	phone_number varchar(15),
	blood_group varchar(4),
	dob date,
	age int,
	gender varchar(1)
);

show tables;

create TABLE teachers (
	t_id int auto_increment primary key,
	name varchar(50),
	email varchar(50),
	phone_number varchar(15),
	subject varchar(30)
);

create table subject (
	subject_id int auto_increment primary key,
	subject_name varchar(30) not null,
	teacher_id int,
	foreign key (teacher_id) references teachers(t_id)
);

alter table PUPIL
add column subject_id int,
add constraint student_subject
	FOREIGN key (subject_id) references subject(subject_id);

show tables;

INSERT INTO teachers (name, email, phone_number, subject) VALUES
('John Smith', 'john.smith@school.com', '555-0101', 'Mathematics'),
('Maria Garcia', 'm.garcia@school.com', '555-0102', 'Science'),
('Robert Chen', 'r.chen@school.com', '555-0103', 'History'),
('Sarah Cook', 's.cook@school.com', '555-0104', 'English'),
('Michael Brown', 'm.brown@school.com', '555-0105', 'Physics'),
('Emily Davis', 'e.davis@school.com', '555-0106', 'Chemistry'),
('David Wilson', 'd.wilson@school.com', '555-0107', 'Biology'),
('Linda Taylor', 'l.taylor@school.com', '555-0108', 'Geography'),
('James Moore', 'j.moore@school.com', '555-0109', 'Art'),
('Anna White', 'a.white@school.com', '555-0110', 'Computer Science');

INSERT INTO subject (subject_name, teacher_id) VALUES
('Algebra', 1),
('Biology 101', 7),
('World History', 3),
('Literature', 4),
('Quantum Physics', 5),
('Organic Chemistry', 6),
('Physical Geography', 8),
('Fine Arts', 9),
('Python Programming', 10),
('Geometry', 1);

INSERT INTO PUPIL (name, address, class, phone_number, blood_group, dob, age, gender, subject_id) VALUES
('Alice Johnson', '123 Maple St', '10-A', '555-1001', 'A+', '2009-05-14', 15, 'F', 1),
('Bob Miller', '456 Oak Ave', '10-B', '555-1002', 'O-', '2009-08-22', 15, 'M', 2),
('Charlie Davis', '789 Pine Rd', '11-A', '555-1003', 'B+', '2008-01-10', 16, 'M', 3),
('Diana Prince', '101 Cedar Ln', '10-A', '555-1004', 'AB+', '2009-11-30', 15, 'F', 4),
('Ethan Hunt', '202 Birch Blvd', '12-C', '555-1005', 'O+', '2007-03-25', 17, 'M', 5),
('Fiona Shrek', '303 Swamp Dr', '11-B', '555-1006', 'A-', '2008-07-12', 16, 'F', 6),
('George King', '404 Palace Ct', '10-C', '555-1007', 'B-', '2009-02-14', 15, 'M', 7),
('Hannah Abbott', '505 Hufflepuff Way', '12-A', '555-1008', 'O+', '2007-09-05', 17, 'F', 8),
('Ian Wright', '606 Stadium Rd', '11-A', '555-1009', 'A+', '2008-12-20', 16, 'M', 9),
('Jenny Scott', '707 Highland Dr', '10-B', '555-1010', 'AB-', '2009-04-03', 15, 'F', 10);


select * from PUPIL
where blood_group = 'A+';

SELECT * FROM PUPIL 
WHERE gender = 'F' AND class = '10-B'
ORDER BY name ASC;

SELECT DISTINCT blood_group FROM PUPIL;

SELECT name, dob FROM PUPIL
ORDER BY dob ASC
LIMIT 3 OFFSET 2;

SELECT class, COUNT(student_id) AS total_students
FROM PUPIL
GROUP BY class;

SELECT blood_group, COUNT(*) as count
FROM PUPIL
GROUP BY blood_group
HAVING count > 1;



create database omniCart;
USE omniCart;

create table customers(
	cust_id int auto_increment primary key,
	name varchar(100),
	email varchar(100),
	city varchar(20),
	created_at DATE 
);

create table products(
	p_id int primary key auto_increment,
	product_name varchar(100),
	category varchar(50),
	price decimal(10,2)
);

create table orders (
	order_id int primary key auto_increment,
	customer_id int,
	order_date DATE,
	total_amount decimal(10,2),
	foreign key (customer_id) references customers(cust_id)
);


CREATE DATABASE Company_db;
use Company_db;

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept VARCHAR(20),
    salary INT,
    location VARCHAR(30)
);

INSERT INTO Employees (emp_id, name, dept, salary, location) VALUES
(1, 'Rahul', 'IT', 45000, 'Chennai'),
(2, 'Ankit', 'HR', 45000, 'Chennai'),
(3, 'John', 'IT', 75000, 'BLR'),
(4, 'Meera', 'Finance', 50000, 'Mumbai'),
(5, 'Suresh', 'HR', 55000, 'BLR');


select * from Employees 
where dept = 'IT' and location = 'BLR';

select * from Employees 
where dept = 'HR' and location = 'BLR' or salary > 70000;

alter table Employees
modify salary decimal(10,2);


select * from Employees
where dept = 'HR' and salary > 50000;

select * from Employees
where dept in ('IT','HR');


select * from Employees
where salary between 50000 and 70000;

select * from Employees
where salary not between 50000 and 70000;

select name from Employees
where name like 'R%';

select * from Employees
where name like '%a';

select count(*) as total_employees
from Employees;

select sum(salary) as it_total_salary
from Employees
where dept = 'IT';

select dept, avg(salary) as avg_salary
from Employees
group by dept;

select min(salary) as min_salary from Employees;

select max(salary) as max_salary from Employees;

ALTER TABLE Employees 
ADD email VARCHAR(100);

UPDATE Employees SET email = 'ankit@company.com' WHERE emp_id = 2;
UPDATE Employees SET email = 'john_it@company.com' WHERE emp_id = 3;
UPDATE Employees SET email = 'suresh.hr@company.com' WHERE emp_id = 5;

select * from employees
where dept in ('HR','IT') and location in ('BLR','chennai') and salary between 50000 and 80000
and email is not null;


select location, count(*) from employees 
group by location;

select count(*) as total_no_of_employees, count(email) as emp_with_email
from employees;

select distinct dept, avg(salary) as avg_salary from employees 
where dept != 'Finance' and location = 'blr'
group by dept 
having count(*)>1 and avg_salary>50000;

select dept
from employees
group by dept 
having count(*) - count(email) >1;

select location
from employees
group by location
having avg(salary)>60000 and count(*)>2;

select name, salary
from employees e1
where salary > (select avg(salary) as avg_salary from employees e2 where e1.dept = e2.dept);




