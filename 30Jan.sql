create database db_30;
use db_30;
create table Employees (
emp_id int primary key,
emp_name varchar(16),
dept varchar(16),
gender varchar(8),
salary decimal(10,2),
manager_id varchar(8),
joining_date date
);

INSERT INTO Employees VALUES
(101, 'Amit',     'IT',      'Male',   70000.00, '104', '2019-01-15'),
(102, 'Ram',      'HR',      'Male',   60000.00, '105', '2020-03-10'),
(103, 'Suresh',   'IT',      'Male',   50000.00, '101', '2021-07-22'),
(104, 'Sita',     'Finance', 'Female', 90000.00, '105', '2018-05-01'),
(105, 'Amita',    'HR',      'Female', 80000.00, '104', '2017-09-18'),
(106, 'Sureekha', 'Finance', 'Female', 70000.00, '104', '2022-02-12');

select * from employees;

-- PIVOT : ROWS TO COLUMNS
CREATE TABLE emp_salary_pivoted AS
WITH cte AS (
    SELECT
        dept,
        SUM(CASE WHEN gender = 'Male' THEN salary ELSE 0 END) AS male_salary,
        SUM(CASE WHEN gender = 'Female' THEN salary ELSE 0 END) AS female_salary
    FROM employees
    GROUP BY dept
)
SELECT * FROM cte;

select * from emp_salary_pivoted;

-- UNPIVOT : COLUMNS TO ROWS
SELECT dept, male_salary AS 'gender', male AS salary
FROM emp_salary_pivoted

UNION ALL

SELECT dept, female_salary AS 'gender', female AS salary
FROM emp_salary_pivoted;

create table emp1(
emp_id int primary key,
details json,
xmldata TEXT
);

insert into emp1 values (101,'{"city":"Bangalore","name":"jignesh","Skill":"SQL"}','<employee>
    <id>101</id>
    <name>jignesh</name>
</employee>');

-- UPDATE emp1
-- SET xmldata = 
-- '<employee>
--     <id>101</id>
--     <name>jignesh</name>
-- </employee>'
-- WHERE emp_id = 101;

drop table emp1;

select xmldata.value('(employee/name)[2]','varchar(50)') as employee_name from emp1;
SELECT 
    EXTRACTVALUE(xmldata, '/employee/name') AS employee_name
FROM emp1;


select json_extract (details,'$.city') from emp1;

-- PROCEDURES

delimiter $$

create procedure getallemployees(in dept_name varchar(20))

begin

select * from employees where dept=dept_name;

end $$

delimiter ;


CALL getallemployees('IT');


DELIMITER $$

CREATE PROCEDURE getallemployees1 (
    IN dept_name VARCHAR(20)
)
BEGIN
select CONCAT( ' select * from employees where dept = ''',dept_name,'''') as generated_sql;

END $$

DELIMITER ;


call getallemployees1("HR");

-- delimiter $$

-- create procedure getemployeecount(out dept_name varchar(20))

-- begin

-- select * from employees where dept=dept_name;

-- end $$

-- delimiter ;


-- CALL getallemployees('IT');

create index idx_dept_salary on employees(dept,salary);


-- Historical data load:

create table t1(
id int primary key,
name varchar(16),
doj date
);

create table t2(
id int primary key,
name varchar(16),
doj date
);

insert into t1 values(1,"Ram","2003-11-28"),(2,"Sita","2004-1-28");
select * from t1;

-- Incremental data load:

insert into t1 values(3,"Raman","1990-11-28");

-- insert into t2 select * from t1 except select * from t2;

-- Full data load:

insert into t2(select * from t1);
select * from t2;

-- Change data capture:

update t1 set name="seeta" where id=2;
update t2 set name=(select name from t1 where id=2) where id=2;













