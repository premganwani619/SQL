--Day 5 Assignment Questions 
--Que 1. From the given table write queries for the following
create database day5;
use day5;
go
CREATE TABLE Worker (
    WorkerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary MONEY,
    JoiningDate DATEtime,
    Time TIME,
    Department VARCHAR(50)
);

insert into worker(workerid, firstname, lastname, salary, joiningdate, department)VALUES
(001, 'Monika', 'Arora', 100000, '2014-02-20 09:00:00', 'HR'),
(002, 'Niharika', 'verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(004, 'Amitabh', 'Singh', 500000, '2014-02-20 09:00:00', 'Admin'),
(005, 'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');
CREATE TABLE Bonus (
    WORKER_REF_ID INT,
    BONUS_DATE DATEtime,
    BONUS_AMOUNT MONEY
);
insert into Bonus(worker_ref_id, bonus_date, bonus_amount)values
(1, '2016-02-20 00:00:00', 5000),
(2, '2016-06-11 00:00:00', 3000),
(3, '2016-02-20 00:00:00', 4000),
(1, '2016-02-20 00:00:00', 4500),
(2, '2016-06-11 00:00:00', 3500);
CREATE TABLE WorkerTitle (
    Worker_REF_ID INT PRIMARY KEY,
    Worker_Title VARCHAR(50),
    AFFECTED_FROM DATEtime
);
insert into WorkerTitle(Worker_REF_ID,Worker_Title,AFFECTED_FROM)
values
(1,'Manager','2016-2-20 00:00:00'),
(2,'Executive','2016-6-11 00:00:00'),
(8,'Executive','2016-6-11 00:00:00'),
(5,'Manager','2016-6-11 00:00:00'),
(4,'Manager','2016-6-11 00:00:00'),
(7,'Assit Manager','2016-6-11 00:00:00'),
(6,'Lead','2016-6-11 00:00:00'),
(3,'Lead','2016-6-11 00:00:00');
-- a. Write an SQL query to determine the nth (say n=5) highest salary from a table.
/*
SELECT SALARY FROM Worker 
ORDER BY Salary DESC
OFFSET 5 ROWS 
FETCH NEXT 1 ROWS ONLY;
*/
DECLARE @SQL NVARCHAR (150);
DECLARE @PARANS  NVARCHAR(10);
DECLARE @NTH_TERM INT;
SET @PARANS = 'NTH_TERM';
SET @NTH_TERM = 5;
SET @SQL = ' SELECT SALARY FROM Worker ' + 
' ORDER BY Salary DESC '
+' OFFSET ' + CAST(@NTH_TERM-1 AS NVARCHAR(10)) + ' ROWS '
+' FETCH NEXT 1 ROWS ONLY ';
EXEC SP_EXECUTESQL @SQL;
--b. Write an SQL query to fetch the list of employees with the same salary.
SELECT SALARY, STRING_AGG(FIRSTNAME, ', ') AS EmployeesWithSameSalary
FROM WORKER
GROUP BY SALARY
HAVING COUNT(*) > 1;

--c. Write an SQL query to show one row twice in results from a table.
SELECT * FROM Worker
UNION ALL
SELECT * FROM Worker
ORDER BY WorkerID ASC;
--d.Write an SQL query to fetch the first 50% records from a table.
SELECT TOP 50 PERCENT  * FROM WORKER 
--e.Write an SQL query to fetch three min salaries from a table.
SELECT TOP 3 SALARY FROM Worker ORDER BY SALARY ASC;
/*
QUE 2.Write an SQL query to display the records with three or more rows with consecutive id’s, and the number of 
people is greater than or equal to 100 for each.Return the result table ordered by Visit_date in ascending order.
*/
CREATE TABLE Stadium(
  id INT,
  visit_date DATE,
  people INT
);
INSERT INTO Stadium (id, visit_date, people)
VALUES (1, '2017-01-01', 10),
	   (2, '2017-01-02', 109),
	   (3, '2017-01-03', 150),
	   (4, '2017-01-04', 99),
	   (5, '2017-01-05', 145),
	   (6, '2017-01-06', 1455),
	   (7, '2017-01-07', 199),
	   (8, '2017-01-09', 188);


select id, visit_date, people from
( 
  select id, visit_date, people, count(*) over(partition by difference) as cnt from
    (
     select id, visit_date, people, (id - row_number() over(order by visit_date)) as difference
     from Stadium
     where people >= 100
    ) x
)y
where cnt >= 3
--Que 3 a. Write an SQL query to remove duplicates from a table without using a temporary table.


CREATE TABLE EmployeeSalary(
  EmpId INT NOT NULL,
  Project VARCHAR(10),
  Salary INT,
  Variable INT
);
INSERT INTO EmployeeSalary(EmpId, Project, Salary, Variable)
VALUES (121, 'P1', 8000, 500),
	   (321, 'P2', 10000, 1000),
	   (421, 'P1', 12000, 0);
DELETE e1
FROM EmployeeSalary e1
JOIN EmployeeSalary e2 ON e1.Project = e2.Project
    AND e1.Salary = e2.Salary
    AND e1.Variable = e2.Variable
    AND e1.EmpId > e2.EmpId;


--b.Write an SQL query to fetch duplicate records from EmployeeDetails (without considering the 
--primary key – EmpId).

SELECT EMPID, PROJECT, Salary, Variable
FROM EmployeeSalary
GROUP BY EMPID, PROJECT, Salary, Variable
HAVING COUNT(*) > 1;
--Que 4
-- a. Create the Employee and SalaryChange tables
CREATE TABLE Employee (
  employee_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  salary DECIMAL(10, 2)
);

CREATE TABLE SalaryChange (
  employee_id INT,
  old_salary DECIMAL(10, 2),
  new_salary DECIMAL(10, 2),
  change_date DATE,
  FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- b. Create a trigger that fires after an update on the employees table
CREATE TRIGGER after_employee_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
  INSERT INTO SalaryChange (employee_id, old_salary, new_salary, change_date)
  VALUES (OLD.employee_id, OLD.salary, NEW.salary, CURRENT_DATE);
END;

-- c. Insert sample data into the employees table
INSERT INTO Employee (employee_id, first_name, last_name, salary)
VALUES (1, 'John', 'Doe', 5000),
       (2, 'Jane', 'Smith', 6000),
       (3, 'Michael', 'Johnson', 7000);

-- d. Update an employee's salary
UPDATE Employee
SET salary = 8000
WHERE employee_id = 1;

--Que 5. -- Update rows from the source table when ProductID exists in the target table and there are changes in other columns
-- Update rows from the source table when ProductID exists in the target table and there are changes in other columns
CREATE TABLE SourceTable (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE TargetTable (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price DECIMAL(10, 2)
);
-- Insert data into SourceTable
INSERT INTO SourceTable (ProductID, ProductName, Price)
VALUES
    (1, 'Table', 100.00),
    (2, 'Desk', 80.00),
    (3, 'Chair', 50.00),
    (4, 'Computer', 300.00);

-- Insert data into TargetTable
INSERT INTO TargetTable (ProductID, ProductName, Price)
VALUES
    (2, 'Desk', 180.00),
    (3, 'Chair', 50.00),
    (4, 'Computer', 300.00),
    (5, 'Bed', 50.00),
    (6, 'Cupboard', 300.00);


-- Q: Update rows in the TargetTable based on changes in the SourceTable.
-- A: Update rows in the TargetTable
UPDATE TargetTable
SET 
    ProductName = s.ProductName,
    Price = s.Price
FROM SourceTable s
WHERE TargetTable.ProductID = s.ProductID
    AND (TargetTable.ProductName <> s.ProductName OR TargetTable.Price <> s.Price);

-- Q: Insert new rows into the TargetTable from the SourceTable.
-- A: Insert new rows into the TargetTable
INSERT INTO TargetTable (ProductID, ProductName, Price)
SELECT s.ProductID, s.ProductName, s.Price
FROM SourceTable s
WHERE NOT EXISTS (
    SELECT 1
    FROM TargetTable t
    WHERE t.ProductID = s.ProductID
);

-- Q: Delete rows from the TargetTable that don't exist in the SourceTable.
-- A: Delete rows from the TargetTable
DELETE FROM TargetTable
WHERE NOT EXISTS (
    SELECT 1
    FROM SourceTable s
    WHERE s.ProductID = TargetTable.ProductID
);

