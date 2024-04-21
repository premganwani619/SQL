--DAY 3 Assignment Questions
--Practice Question
CREATE DATABASE Day3;
USE Day3;
GO
CREATE TABLE Salary(
ID INT PRIMARY KEY,
FIRST_NAME VARCHAR(10) NOT NULL,
LAST_NAME VARCHAR(10) NOT NULL,
GENDER VARCHAR(10) NOT NULL, 
SALARY INT NOT NULL
);
INSERT INTO Salary(ID,FIRST_NAME,LAST_NAME,GENDER,SALARY)
VALUES(8,'Jhon','Stanmore','Male',80000),
(1,'Ben','Hoskins','Male',70000),
(4,'Ben','Hoskins','Male',70000),
(2,'Mark','Hastings','Male',60000),
(3,'Steve','Pound','Male',45000),
(5,'Philip','Hastings','Male',45000),
(7,'Valarie','Vikings','Female',35000),
(6,'Mary','Lambeth','FeMale',30000);
--Que 1. Select 2nd Highest salary from the Table.
SELECT TOP 1 * FROM Salary WHERE SALARY != (SELECT MAX(SALARY) FROM Salary)
ORDER BY SALARY DESC;
--Que 2. Find the date and the day for the current decade.
SELECT day(GETDATE()) 'Day';
SELECT getdate()'Date';


CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255)
);

INSERT INTO Suppliers (supplier_id, supplier_name, city, state)
VALUES
    (100, 'Microsoft', 'Redmond', 'Washington'),
    (200, 'Google', 'Mountain View', 'California'),
    (300, 'Oracle', 'Redwood City', 'California'),
    (400, 'Kimberly-Clark', 'Irving', 'Texas'),
    (500, 'Tyson Foods', 'Springdale', 'Arkansas'),
    (600, 'google', 'Racine', 'Wisconsin'),
    (700, 'google', 'Westlake Village', 'California'),
    (800, 'google', 'Thomasville', 'Georgia'),
    (900, 'Electronic Arts', 'Redwood City', 'California');
--Que 3.  Write the Query to get the first 3 Alphabets of Column State.
Select left(state,3) from Suppliers;
--	Que 4. Write a query to display the first day of the month (in datetime format) 
--three months before the current month.
Select DATEADD(MONTH,-3,DATEADD(DAY,-DAY(GETDATE())+1, GETDATE()))
AS FirstDayOfMonthBeforeThreeMonths;

--Que 5. Write a query to display the last day of the month (in datetime format) three
--months before the current month.
Select DATEADD(MONTH,-3,EOMONTH(GETDATE()))
AS LastDayOfMonthBeforeThreeMonths;
--Que 6. Write a query to get the first day of the current year.
SELECT DATEFROMPARTS(YEAR(GETDATE()), 1, 1) AS FirstDayOfCurrentYear;
--Que 7. Write a query to calculate the age in year.
DECLARE @DOB DATE = '2002-7-17';
SELECT DATEDIFF(YEAR,@DOB,GETDATE()) AS AGE;
--Que 8. Write a query to get the current date in the following format.
--Input - 2014-09-04
--Output Format - September 4, 2014
SELECT DATENAME(MONTH,GETDATE()) AS Month_Name , DATENAME(DAY,GETDATE()) AS Day_Name ,DATENAME(YEAR,GETDATE()) AS Year_Name;
--Que 9. Write a query to extract the year from the current date.
SELECT YEAR(GETDATE()) AS Cur_YEAR;
--Que 10. Find the Index of ‘@’ in the Given String
--Input – adventureworks@database.com
 SELECT CHARINDEX('@','adventureworks@database.com') AS Char_Index;

 -- Inserting data into the Employees table
CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY,
    Name VARCHAR(255),
    Salary INT,
    EmailId VARCHAR(255)
);

INSERT INTO Employees (EmployeeId, Name, Salary, EmailId)
VALUES
    (1, 'John', 1000, 'John@abc.com'),
    (2, 'Ben', 2000, 'Ben@xyz.com'),
    (3, 'Mark', 3000, 'Mark@abc.com'),
    (4, 'Steve', 2000, 'Steve@asd.com'),
    (5, 'Philip', 5000, 'Philip@xyz.com'),
    (6, 'Mary', 6000, 'Mary@qwe.com');
	
--1. Count of Employees who have same Domain.
SELECT RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1) AS Domain, COUNT(*) AS CountOfEmployees
FROM Employees
GROUP BY RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1)
HAVING COUNT(*) > 1;
--2. Count of Employee who have same salary.
SELECT Salary, COUNT(*) AS CountOfEmployees
FROM Employees
GROUP BY Salary  
HAVING COUNT(*) > 1;
--3. Count of Employee who have same domain and same salary.
SELECT RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1) AS Domain, Salary, COUNT(*) AS CountOfEmployees
FROM Employees
GROUP BY RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1), Salary
HAVING COUNT(*) > 1;

--4. Select Name and Id of Employee who have same domain.
SELECT Name, EmployeeId
FROM Employees
WHERE RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1) IN (
    SELECT RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1)
    FROM Employees
    GROUP BY RIGHT(EmailId, CHARINDEX('@', REVERSE(EmailId)) - 1)
    HAVING COUNT(*) > 1
);

/* Que 12. Create a Table named ‘Example’ which have the following structure:
If User doesn’t fill gender or dob, make sure those values are set to today’s date 
and ‘Male’ by default.
No Column should have null values, and id column should be the primary key.*/

CREATE TABLE Example (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dob DATE NOT NULL DEFAULT GETDATE(),
    gender VARCHAR(10) NOT NULL DEFAULT 'MALE'
);
INSERT INTO Example (id, name, dob, gender)
VALUES (1, 'Student1', '2023-02-20', 'MALE'),
       (2, 'Student2', '1999-01-01', 'FEMALE');
select * from Example;


--Que 13. Select all the records from the table for which the state Column starts with
--alphabet W
CREATE TABLE InputTable (
    supplier_id INT,
    supplier_name VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255)
);

INSERT INTO InputTable (supplier_id, supplier_name, city, state)
VALUES (100, 'Microsoft', 'Redmond', 'Washington'),
       (200, 'Google', 'Mountain View', 'California'),
       (300, 'Oracle', 'Redwood City', 'California'),
       (400, 'Kimberly-Clark', 'Irving', 'Texas'),
       (500, 'Tyson Foods', 'Springdale', 'Arkansas'),
       (600, 'SC Johnson', 'Racine', 'Wisconsin'),
       (700, 'Dole Food Company', 'Westlake Village', 'California'),
       (800, 'Flowers Foods', 'Thomasville', 'Georgia'),
       (900, 'Electronic Arts', 'Redwood City', 'California');
SELECT *
FROM InputTable
WHERE state LIKE 'W%';

 /*
Que 14. You are given a table, Projects, containing three 
columns: Task_ID, Start_Dateand End_Date. It is guaranteed that the difference 
between the End_Dateand the Start_Dateis equal to 1day for each row in the 
table.
Column Type
Id Integer 
Start_Date Date
End_Date Date
If the End_Dateof the tasks are consecutive, then they are part of the same project.
Suraj is interested in finding the total number of different projects completed.
Write a query to output the start and end dates of projects listed by the number of 
days it took to complete the project in ascending order. If there is more than one 
project that have the same number of completion days, then order by the start date
of the project.
*/

CREATE TABLE Projects (
    Id INT UNIQUE,
    Start_Date DATE,
    End_Date DATE
);

INSERT INTO Projects (Id, Start_Date, End_Date)
VALUES (1, '2023-01-10', '2023-01-11'),
       (2, '2023-01-11', '2023-01-12'),
       (3, '2023-01-12', '2023-01-13'),
       (4, '2023-01-25', '2023-01-26'),
       (5, '2023-01-26', '2023-01-27'),
       (6, '2023-01-30', '2023-01-31'),
       (7, '2023-02-01', '2023-02-02')

	   select 
	
/*
Que 15. You are given two tables: Students and Grades. Students contains
three columns ID, Name and Marks.
Grades contains the following data:
Grade 1 for marks 0-9
Grade 2 for marks 10-19 and so on.
Similarly Grade 10 for marks 90-100
 
Write a query to Generate a report containing three columns: Name, Grade
and Mark. Don’t print the NAMES of those students who received a grade 
lower than 8.
The report must be in descending order by grade -- i.e., higher grades are 
entered first.
If there is more than one student with the same grade (8-10) assigned to 
them, order those students by their name alphabetically.
Finally, if the grade is lower than 8, use "NULL" as their name and list 
them by their grades in descending order. If there is more than one 
student with the same grade (1-7) assigned to them, order those students 
by their marks in ascending order.
*/
CREATE TABLE Grades (
    Grade INT PRIMARY KEY,
    Min_Mark INT,
    Max_Mark INT
);

INSERT INTO Grades (Grade, Min_Mark, Max_Mark)
VALUES
    (1, 0, 9),
    (2, 10, 19),
    (3, 20, 29),
    (4, 30, 39),
    (5, 40, 49),
    (6, 50, 59),
    (7, 60, 69),
    (8, 70, 79),
    (9, 80, 89),
    (10, 90, 100);

CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Marks INT
);

INSERT INTO Students (ID, Name, Marks)
VALUES
    (1, 'IronMan', 83),
    (2, 'Captain', 77),
    (3, 'Thor', 100),
    (4, 'Scarlett', 68),
    (5, 'Hulk', 63),
    (6, 'DrStrange', 87);

SELECT CASE
			WHEN Grades.Grade<8 
			then NULL
			ELSE StudentS.Name 
			END as StudentName,
			Grades.Grade, Students.Marks
FROM   Students,Grades
WHERE   Students.marks between Grades.MIN_MARK AND Grades.MAX_MARK
ORDER BY Grades.Grade desc, Students.Name ;



--QUE 16.
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(255),
    city VARCHAR(255),
    grade INT,
    salesman_id INT
);

INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id)
VALUES
    (3002, 'Nick Rimando', 'New York', 100, 5001),
    (3007, 'Brad Davis', 'New York', 200, 5001),
    (3005, 'Graham Zusi', 'California', 200, 5002),
    (3008, 'Julian Green', 'London', 300, 5002),
    (3004, 'Fabian Johnson', 'Paris', 300, 5006),
    (3009, 'Geoff Cameron', 'Berlin', 100, 5003),
    (3003, 'Jozy Altidor', 'Moscow', 200, 5007),
    (3001, 'Brad Guzan', 'London', NULL, NULL);

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(255),
    commission FLOAT
);

INSERT INTO salesman (salesman_id, name, city, commission)
VALUES
    (5001, 'James Hoog', 'New York', 0.15),
    (5002, 'Nail Knite', 'Paris', 0.13),
    (5005, 'Pit Alex', 'London', 0.11),
    (5006, 'Mc Lyon', 'Paris', 0.14),
    (5007, 'Paul Adam', 'Rome', 0.13),
    (5003, 'Lauson Hen', 'San Jose', 0.12);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt FLOAT,
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES
    (70001, 150.5, '2012-10-05', 3005, 5002),
    (70009, 270.65, '2012-09-10', 3001, 5005),
    (70002, 65.26, '2012-10-05', 3002, 5001),
    (70004, 110.5, '2012-08-17', 3009, 5003),
    (70007, 948.5, '2012-09-10', 3005, 5002),
    (70005, 2400.6, '2012-07-27', 3007, 5001),
    (70008, 5760, '2012-09-10', 3002, 5001),
    (70010, 1983.43, '2012-10-10', 3004, 5006),
    (70003, 2480.4, '2012-10-10', 3009, 5003),
    (70012, 250.45, '2012-06-27', 3008, 5002),
    (70011, 75.29, '2012-08-17', 3003, 5007),
    (70013, 3045.6, '2012-04-25', 3002, 5001);
--	1. From the customer and salesman tables, find all salespersons and customer who located in 
--‘London’ city.
SELECT cust_name AS Name, city
FROM customer
WHERE city = 'London'
UNION
SELECT name AS Name, city
FROM salesman
WHERE city = 'London';
/*2. From the customer and salesman table, find those salespersons who have same cities 
where customer lives as well as do not have customers in their cities and indicate it by 
‘NO MATCH’. Sort the result set on 2nd column (i.e. name) in descending order. Return 
salesperson ID, name, customer name, commission.*/
SELECT CASE
        WHEN customer.city = salesman.city THEN customer.city
        ELSE 'NO MATCH'
    END AS MatchStatus,
    salesman.salesman_id,salesman.name,customer.cust_name,salesman.commission
FROM salesman LEFT JOIN customer  ON salesman.city = customer.city
ORDER BY salesman.name DESC;

/*3. From the customer and salesman tables, appends strings to the selected fields, indicating 
whether a specified city of any salesperson was matched to the city of any customer. 
Return salesperson ID, name, city, MATCHED/NO MATCH.
*/

SELECT 
salesman.salesman_id,salesman.name,salesman.city,
CASE
        WHEN customer.city IS NOT NULL THEN 'MATCHED'
        ELSE 'NO MATCH'
    END AS MatchStatus
FROM salesman LEFT JOIN customer  ON salesman.city = customer.city
ORDER BY salesman.name DESC;

/*
4. From the customer table, create a union of two queries that shows the customer id, cities, 
and ratings of all customers. Those with a rating of 300 or greater will have the words 
‘High Rating’, while the others will have the words ‘Low Rating’.
*/

-- Union of two queries to categorize customers based on their ratings


SELECT customer_id, city, 'HIGH RATING' AS RatingStatus
FROM customer
WHERE grade >= 300
UNION
SELECT customer_id, city, 'LOW RATING' AS RatingStatus
FROM customer
WHERE grade < 300;

--QUE. 17 Consider the following example datasets:
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'Sales'),
    (102, 'Marketing'),
    (103, 'Finance');
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'John', 'Doe', 101),
    (2, 'Jane', 'Smith', 102),
    (3, 'Mike', 'Johnson', 101),
    (4, 'Emily', 'Brown', 103);
	
/*
• INNER JOIN: Write a query to display the FirstName, LastName, and DepartmentName 
of employees along with their corresponding department names. Exclude employees who are not 
assigned to any department. */
SELECT   Employees.FIRSTNAME, Employees.LASTNAME,Departments.DepartmentName FROM Employees INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENTId=DEPARTMENTS.DEPARTMENTID;
/*
• LEFT JOIN: Write a query to display the FirstName, LastName, and DepartmentName of
all employees, including those who are not assigned to any department. Display NULL for the 
DepartmentName for employees without a department.  */
SELECT   Employees.FIRSTNAME, Employees.LASTNAME,Departments.DepartmentName FROM Employees LEFT JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENTId=DEPARTMENTS.DEPARTMENTID;
/*
• RIGHT JOIN: Write a query to display the DepartmentName and the corresponding 
employee (FirstName and LastName) in the Marketing department. Include the departments even
if there are no employees assigned to them.
*/
SELECT   Employees.FIRSTNAME, Employees.LASTNAME,Departments.DepartmentName FROM Employees RIGHT JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENTId=DEPARTMENTS.DEPARTMENTID;

/*
• FULL JOIN: Write a query to display the FirstName, LastName, and DepartmentName 
of all employees and all departments, including those without a match. Display NULL for the 
FirstName and LastName of departments without any employees.
*/
SELECT   Employees.FIRSTNAME, Employees.LASTNAME,Departments.DepartmentName FROM Employees FULL JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENTId=DEPARTMENTS.DEPARTMENTID;

/*
• Self-Join: Consider an additional column in the Employees table: ReportsTo 
(EmployeeID of the manager). Write a query to display the employee's FirstName, LastName, 
*/
ALTER TABLE Employees
ADD ReportsTo INT;

UPDATE Employees
SET ReportsTo = 1; 
SELECT 
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID;


/*
and the FirstName and LastName of their manager.
• Multiple Joins: Consider an additional table: Projects
Table: Projects
ProjectID ProjectName EmployeeID
1 Project A 1
2 Project B 2
3 Project C 3
*/

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(255),
    EmployeeID INT
);

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID)
VALUES
    (1, 'Project A', 1),
    (2, 'Project B', 2),
    (3, 'Project C', 3),
    (4, 'Project D', 1);

	SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    D.DepartmentName,
    P.ProjectName
FROM Employees AS E
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
LEFT JOIN Projects AS P ON E.EmployeeID = P.EmployeeID;

/*• Write a query to display the FirstName, LastName, DepartmentName, and ProjectName 
for each employee who is assigned to a project. If an employee is not assigned to any project, 
still display their FirstName, LastName, and DepartmentName.
*/
SELECT
    E.FirstName,
    E.LastName,
    D.DepartmentName,
    P.ProjectName
FROM Employees AS E
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
LEFT JOIN Projects AS P ON E.EmployeeID = P.EmployeeID;

/*• Join with Aggregation: Write a query to find the number of employees in each 
department. Display the DepartmentName and the number of employees in that department.*/
SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS NumberOfEmployees
FROM Departments AS D
LEFT JOIN Employees AS E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;

/*• Using JOIN with WHERE Clause: Write a query to find the FirstName, LastName, and 
DepartmentName of employees working in the Sales department (DepartmentID = 1*/

SELECT
    E.FirstName,
    E.LastName,
    D.DepartmentName
FROM Employees AS E
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE E.DepartmentID = 1;
