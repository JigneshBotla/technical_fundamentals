create database db_29;
use db_29;


create table Employee (
emp_id int primary key,
name varchar(16),
dept varchar(16),
salary decimal(10,2)
);

insert into Employee values(101,"Amit","IT",70000),(102,"Ram","HR",60000),(103,"Suresh","IT",50000),(104,"Sita","Finance",90000);
insert into Employee values(105,"Amita","HR",80000),(106,"Sureekha","Finance",70000);

select * from Employee;

select * from employee where salary >(select avg(salary) from employee);

select avg(salary) from employee group by dept order by avg(salary);

select name,dept,salary from employee as e1 where e1.salary > (select avg(e2.salary) from employee as e2 group by dept having e1.dept=e2.dept);

select * from employee e1
join (select dept , avg(salary) as avg_salary from employee
group by dept) e2
on e1.dept = e2.dept
where e1.salary > e2.avg_salary;

with CTE as (select * from employee where salary >=60000) select * from CTE;

with CTE as (select dept as dept1,avg(salary) as avg1 from employee group by dept) select * from employee as e1 where salary> (select avg1 from CTE where e1.dept=dept1);

with CTE as (select dept as dept1,avg(salary) as avg1 from employee group by dept) select * from employee as e join CTE as c on e.dept=c.dept1 and e.salary>c.avg1;

create table users(
id int primary key,
email_id varchar(32)
);
drop table users;
insert into users values(1,"abc@gmail.com"),(2,"def@gmail.com"),(3,"abc@gmail.com"),(4,"def@gmail.com"),(5,"ghi@gmail.com"),(6,"abc@gmail.com");

select * from users;

with CTE as (select row_number() over(partition by email_id order by id asc) as RID,id,email_id from users) delete from users where id in (select id from CTE where RID>1) ; 

ALTER TABLE Employee
ADD manager_id INT,
ADD join_date DATE;

UPDATE Employee SET manager_id = 104, join_date = '2018-01-15' WHERE emp_id = 101; -- Amit → Sita
UPDATE Employee SET manager_id = 101, join_date = '2019-03-10' WHERE emp_id = 102; -- Ram → Amit
UPDATE Employee SET manager_id = 101, join_date = '2020-07-22' WHERE emp_id = 103; -- Suresh → Amit
UPDATE Employee SET manager_id = 105, join_date = '2017-05-01' WHERE emp_id = 104; -- Sita → Amita
UPDATE Employee SET manager_id = 104, join_date = '2021-09-18' WHERE emp_id = 105; -- Amita → Sita
UPDATE Employee SET manager_id = 104, join_date = '2022-02-12' WHERE emp_id = 106; -- Sureekha → Sita

select * from Employee;

insert into Employee values(109,"Amit9","Finance",50000,102,"2003-11-28");

select *,row_number() over(partition by dept order by salary desc) as RowID,rank() over(partition by dept order by salary desc) as RankID,dense_rank() over(partition by dept order by salary desc) as DenseRankID, lag(salary) over(order by salary asc) as lag1,
lead(salary) over(order by salary asc) as lead1,NTILE(4) over(order by salary desc) as quartile_NTILE,first_value(name) over(partition by dept order by salary desc) as First_name,last_value(name) over(partition by dept order by salary desc rows between unbounded preceding and unbounded following ) as Last_name 
from employee;


# merge or upsert table  


CREATE TABLE Employee_TGT (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept VARCHAR(50),
    salary INT
);

CREATE TABLE Employee_SRC (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept VARCHAR(50),
    salary INT
);

INSERT INTO Employee_TGT VALUES
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'IT', 60000),
(3, 'Charlie', 'Finance', 70000);


INSERT INTO Employee_SRC VALUES
(2, 'Bob', 'IT', 65000),        -- matched → update salary
(3, 'Charlie', 'Finance', 72000), -- matched → update salary
(4, 'David', 'HR', 55000);     -- not matched → insert


-- MERGE INTO Employee_TGT t
-- USING Employee_SRC s
-- ON (t.emp_id = s.emp_id)

-- WHEN MATCHED THEN
-- UPDATE SET
--     t.emp_name = s.emp_name,
--     t.dept     = s.dept,
--     t.salary   = s.salary

-- WHEN NOT MATCHED THEN
-- INSERT (emp_id, emp_name, dept, salary)
-- VALUES (s.emp_id, s.emp_name, s.dept, s.salary);

-- SELECT * FROM Employee_TGT;





















