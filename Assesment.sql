
--Assessment Questions
--Total Time: 5.5 Hrs
--Date: 11 Aug 2023
--Name: Prem Ganwani

CREATE DATABASE assesment;
USE assesment;

--Que 1. 

CREATE TABLE Worker (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(10),
    LAST_NAME VARCHAR(10),
    SALARY INT,
    JOINING_DATE DATETIME,
    DEPARTMENT VARCHAR(10)
);

INSERT INTO Worker (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT)
VALUES
(001, 'Monika', 'Arora', 100000, '2014-02-20 09:00:00', 'HR'),
(002, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(004, 'Amitabh', 'Singh', 500000, '2014-02-20 09:00:00', 'Admin'),
(005, 'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

CREATE TABLE Bonus (
    WORKER_REF_ID INT,
    BONUS_DATE DATETIME,
    BONUS_AMOUNT INT
);

INSERT INTO Bonus (WORKER_REF_ID, BONUS_DATE, BONUS_AMOUNT)
VALUES
(1, '2016-02-20 00:00:00', 5000),
(2, '2016-06-11 00:00:00', 3000),
(3, '2016-02-20 00:00:00', 4000),
(1, '2016-02-20 00:00:00', 4500),
(2, '2016-06-11 00:00:00', 3500);

CREATE TABLE Title (
    WORKER_REF_ID INT,
    WORKER_TITLE VARCHAR(10),
    AFFECTED_FROM DATETIME
);

INSERT INTO Title (WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
VALUES
(1, 'Manager', '2016-02-20 00:00:00'),
(2, 'Executive', '2016-06-11 00:00:00'),
(8, 'Executive', '2016-06-11 00:00:00'),
(5, 'Manager', '2016-06-11 00:00:00'),
(4, 'Asst. Manager', '2016-06-11 00:00:00'),
(7, 'Executive', '2016-06-11 00:00:00'),
(6, 'Lead', '2016-06-11 00:00:00'),
(3, 'Lead', '2016-06-11 00:00:00');

--1. Write an SQL query to print details of the Workers who are also Managers.

SELECT w.* FROM Worker AS w
INNER JOIN
Title AS t
ON w.WORKER_ID = t.WORKER_REF_ID
WHERE t.WORKER_TITLE='Manager';

--2. Write an SQL query to show only odd rows from Worker table.
SELECT * FROM Worker
WHERE WORKER_ID%2=1;

--3. Write an SQL query to print the name of employees having the highest salary in each
--department.

SELECT t.WORKER_TITLE,w.FIRST_NAME,MAX(w.SALARY) OVER(PARTITION BY t.worker_title) AS salary FROM Worker AS w
INNER JOIN Title AS t
ON w.WORKER_ID = t.WORKER_REF_ID

--4. Write an SQL query to fetch three max salaries from a table.

SELECT TOP 3 FIRST_NAME, SALARY FROM Worker ORDER BY
SALARY DESC;

/*
Que 2.
Write a query identifying the type of each record in the TRIANGLES table using its three side
lengths. Output one of the following statements for each record in the table:
• Equilateral: It's a triangle with sides of equal length.
• Isosceles: It's a triangle with sides of equal length.
• Scalene: It's a triangle with sides of differing lengths.
• Not A Triangle: The given values of A, B, and C don't form a triangle.
*/
CREATE TABLE triangles (
    A INT,
    B INT,
    C INT
);

INSERT INTO triangles (A, B, C)
VALUES (20, 20, 23),
       (20, 20, 20),
       (20, 21, 22),
       (13, 14, 30);

CREATE FUNCTION GetTriangleType(@a INT, @b INT, @c INT)
RETURNS INT
AS
BEGIN
    DECLARE @result NVARCHAR(25)
    IF @a=@b AND @b=@c
        SET @result = 1
    ELSE IF (@a =@b AND @b !=@c) OR (@b =@c AND @c !=@a) OR (@a = @c AND @c != @b)
        SET @result = 2
    ELSE IF @a!= @b AND @a!= @c AND @b!= @c
        SET @result = 3
    ELSE
        SET @result = 0
    RETURN @result
END

SELECT
CASE
WHEN dbo.GetTriangleType(A, B, C) = 1 THEN 'Equilateral'
WHEN dbo.GetTriangleType(A, B, C) = 2 THEN 'Isosceles'
WHEN dbo.GetTriangleType(A, B, C) = 3 THEN 'Scalene'
ELSE 'Not A Triangle'
END AS Triangle_Type
FROM TRIANGLES;

/*
QUE 3. 
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and
displayed underneath its corresponding Occupation. The output column headers should be
Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation.
*/

CREATE TABLE Workers (
    Name VARCHAR(50),
    Occupation VARCHAR(50)
);


INSERT INTO Workers (Name, Occupation)
VALUES
    ('Samantha', 'Doctor'),
    ('Julia', 'Actor'),
    ('Maria', 'Actor'),
    ('Meera', 'Singer'),
    ('Ashley', 'Professor'),
    ('Ketty', 'Professor'),
    ('Christeen', 'Professor'),
    ('Jane', 'Actor'),
    ('Jenny', 'Doctor'),
    ('Priya', 'Singer');

SELECT [doctor], [singer],[professor], [actor]
FROM(
SELECT name,occupation ,row_number() over (partition by occupation order by name) as row_
FROM Workers
)AS SourceData
PIVOT(
max(name)
 FOR occupation IN ([doctor], [singer],[professor], [actor])    
)AS PivotTable;

/*
Que 4.
The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a
query to print the hacker_id, name, and total score of the hackers ordered by the descending
score. If more than one hacker achieved the same total score, then sort the result by ascending
hacker_id. Exclude all hackers with a total score of from your result.
*/

CREATE TABLE Hackers (
    hacker_id INT,
    name VARCHAR(50)
);

INSERT INTO Hackers (hacker_id, name)
VALUES
    (4071, 'Rose'),
    (4806, 'Angela'),
    (26071, 'Frank'),
    (49438, 'Patrick'),
    (74842, 'Lisa'),
    (80305, 'Kimberly'),
    (84072, 'Bonnie'),
    (87868, 'Michael'),
    (92118, 'Todd'),
    (95895, 'Joe');

CREATE TABLE Submissions (
    submission_id INT,
    hacker_id INT,
    challenge_id INT,
    score INT
);

INSERT INTO Submissions (submission_id, hacker_id, challenge_id, score)
VALUES
(67194, 74842, 63132, 76),
(64479, 74842, 19797, 98),
(40742, 26071, 49593, 20),
(17513, 4806, 49593, 32),
(69846, 80305, 19797, 19),
(41002, 26071, 89343, 36),
(52826, 49438, 49593, 9),
(31093, 26071, 19797, 2),
(81614, 84072, 49593, 100),
(44829, 26071, 89343, 17),
(75147, 80305, 49593, 48),
(14115, 4806, 48593, 76),
(6943, 4071, 19797, 95),
(12855, 4806, 25917, 13),
(73343, 80305, 49593 ,48),
(14115, 4806, 49593, 76),
(6943, 4071, 19797, 95),
(12855,4806, 25917, 13),
(73343, 80305, 49593, 42),
(84264,84072, 63132, 0),
(9951, 4071, 49593, 43 ),
(45104, 49438, 25917, 34),
(53795, 74842, 19797, 5),
(26363, 26071, 19797 ,29),
(10063,4071,49593, 96);

select h.hacker_id,h.name,sum(sscore) as total_score
from Hackers h inner join 
(select s.hacker_id,s.challenge_id,max(score) as sscore from Submissions s group by s.hacker_id,s.challenge_id) as st
on h.hacker_id=st.hacker_id
group by h.hacker_id,h.name
having sum(sscore)>0
order by total_score desc,h.hacker_id asc;

/*
Que 5.
Write a query to print all prime numbers less than or equal to 1000. Print your result on a single
line and use the ampersand (&) character as your separator (instead of a space).
*/
declare @i INT = 2;
declare @PRIME INT = 0;
declare @PrimeNumbers VARCHAR(MAX) = '';

WHILE @I <= 1000
BEGIN
    DECLARE @J INT = @I - 1;
    SET @PRIME = 1;
    WHILE @J > 1
    BEGIN
        IF @I % @J = 0
        BEGIN
            SET @PRIME = 0;
        END
        SET @J = @J - 1;
    END
    IF @PRIME = 1
    BEGIN
        IF @PrimeNumbers = ''
            SET @PrimeNumbers = CAST(@I AS VARCHAR(10));
        ELSE
            SET @PrimeNumbers = @PrimeNumbers + '&' + CAST(@I AS VARCHAR(10));
    END
    SET @I = @I + 1;
END
SELECT @PrimeNumbers AS PrimeNumbers;


/*
Que 6. Write a query to output the names of those students whose best friends got offered a higher
salary than them. Names must be ordered by the salary amount offered to the best friends. It is
guaranteed that no two students will get the same salary offer.
*/

Select S.Name
From Students S join Friends F
 join Packages P1 on S.ID=P1.ID
 join Packages P2 on F.Friend_ID=P2.ID
Where P2.Salary > P1.Salary
Order By P2.Salary;
/*Que 7. Query - Write a SQL query to retrieve all the CustomerName and their OrderDate for each
order if applicable. If no order date then print 1900-01-01.
*/
CREATE TABLE Customers (
    CustomerID INT,
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, City)
VALUES
    (1, 'Alice', 'New York'),
    (2, 'Bob', 'Los Angeles'),
    (3, 'Charlie', 'Chicago');

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
    (101, 1, '2023-01-10'),
    (102, 2, '2023-02-15'),
    (103, 1, '2023-03-20');
	
SELECT
    c.CustomerName,
    COALESCE(o.OrderDate, '1900-01-01') AS OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID;

/* Que 8.
Query - Write a SQL query to retrieve the names of all the employees along with the names of
their managers wherever applicable
*/

CREATE TABLE Employees (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    ManagerID INT
);

INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID)
VALUES
    (1, 'Alice', NULL),
    (2, 'Bob', 1),
    (3, 'Charlie', 1),
    (4, 'David', 2);

	select  e2.EmployeeName as employee,e1.EmployeeName as manager  from Employees as e1 right join Employees as e2
	on e1.EmployeeID = e2.ManagerID

/*
Que 9. 
*/

CREATE TABLE Students (
    StudentID INT,
    StudentName VARCHAR(50),
    Age INT
);

INSERT INTO Students (StudentID, StudentName, Age)
VALUES
    (1, 'Alice', 20),
    (2, 'Bob', 21),
    (3, 'Charlie', 19);

CREATE TABLE Courses (
    CourseID INT,
    CourseName VARCHAR(50)
);

INSERT INTO Courses (CourseID, CourseName)
VALUES
    (101, 'Math'),
    (102, 'Science'),
    (103, 'History');

CREATE TABLE Enrollments (
    StudentID INT,
    CourseID INT
);

INSERT INTO Enrollments (StudentID, CourseID)
VALUES
    (1, 101),
    (1, 102),
    (2, 101),
    (3, 102);
/*
1. Write a SQL query to retrieve the StudentName and the list of courses each student
is enrolled in.
*/
select s.StudentName,c.CourseName from Students as s inner join Enrollments as e
on s.StudentID = e.StudentID
inner join
Courses as c
on e.CourseID = c.CourseID
/*
2. Write a query to show StudentName, courseName (retrieved in Q. 1) along with the
count of courses.
*/
select s.StudentName,string_agg(c.CourseName,',') as CourseName, count(c.CourseName) as CourseCount from Students as s inner join Enrollments as e
on s.StudentID = e.StudentID
inner join
Courses as c
on e.CourseID = c.CourseID
group by s.StudentName

/*
Que 10.
*/
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'Alice', 'Johnson', 101),
    (2, 'Bob', 'Smith', 102),
    (3, 'Charlie', 'Brown', 101),
    (4, 'David', 'Lee', 103);

CREATE TABLE Departments (
    DepartmentID INT,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'HR'),
    (102, 'Finance'),
    (103, 'IT');

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT
);

INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES
    (1, 201),
    (2, 202),
    (1, 203),
    (3, 201),
    (2, 204),
    (4, 205);

CREATE TABLE Projects (
    ProjectID INT,
    ProjectName VARCHAR(50)
);

INSERT INTO Projects (ProjectID, ProjectName)
VALUES
    (201, 'Project A'),
    (202, 'Project B'),
    (203, 'Project C'),
    (204, 'Project D'),
    (205, 'Project E');
/*
Query - Write a SQL query to retrieve the following information for each employee:
Employee Name (concatenation of FirstName and LastName) Department Name List of Project
Names they are working on
*/

select concat(e.FirstName,' ', e.LastName) as Employee_Name, d.DepartmentName, string_agg(p.ProjectName,',') as ProjectName from Employees  as e
inner join Departments as d
on e.DepartmentID = d.DepartmentID
inner join EmployeeProjects as ep
on e.EmployeeID = ep.EmployeeID
inner join Projects as p
on ep.ProjectID=p.ProjectID
group by concat(e.FirstName,' ', e.LastName) , d.DepartmentName
order by Employee_Name

/*
Que 11.
*/
CREATE TABLE Orders (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 101, 2, 10.00),
    (2, 102, 3, 5.00),
    (3, 101, 5, 8.00),
    (4, 103, 1, 20.00);

/*
Query - Create a scalar UDF named CalculateTotalPrice that takes an OrderID as input and
returns the total price (Quantity * UnitPrice) for that order.
*/
create function CalculateTotalPrice(@ID int)
returns decimal(10,2)
as
begin 
declare @var decimal(10,2);
select @var = Quantity*UnitPrice  from Orders where OrderID = @Id
return @var 
end

select dbo.CalculateTotalPrice(OrderID) as price from Orders;

/*
Que 12. 
 - Create a table-valued UDF named GetHighValueOrders that returns a table containing
orders with a total value greater than a given threshold.
*/
CREATE TABLE Orders (
    OrderID INT,
    TotalValue DECIMAL(10, 2)
);

INSERT INTO Orders (OrderID, TotalValue)
VALUES
    (1, 25.00),
    (2, 15.00),
    (3, 40.00),
    (4, 10.00);

create function GetHighValueOrders(@Threshold decimal(10,2))
returns table
as
return (
select * from Orders where TotalValue > @Threshold
);

declare @thresh decimal(10,2)=10.0
select * from dbo.GetHighValueOrders(@thresh);

/*
Que. 13.
Query- Create an inline table-valued UDF named GetEmployeesByDepartment that takes a
DepartmentID as input and returns the employees in that department
*/

CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'Alice', 'Johnson', 101),
    (2, 'Bob', 'Smith', 102),
    (3, 'Charlie', 'Brown', 101),
    (4, 'David', 'Lee', 103);

create function GetEmployeesByDepartment(@D_id int)
returns table
return (
select FirstName, DepartmentID from Employees where DepartmentID =@D_id
);

select * from dbo.GetEmployeesByDepartment(101);

/*
Que 14. 
Suppose we have two tables: Products and ProductUpdates. We want to update the Products
table based on the information in the ProductUpdates table. If a product exists in both tables,
update its price; if it only exists in ProductUpdates, insert it into the Products table.
*/

CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)  
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
    (101, 'Apple', 1.00),
    (102, 'Banana', 0.75),
    (103, 'Orange', 0.50);

CREATE TABLE ProductUpdates (
    ProductID INT,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);

INSERT INTO ProductUpdates (ProductID, ProductName, Price)
VALUES
    (102, 'Banana', 0.80),
    (104, 'Grape', 1.20),
    (105, 'Pineapple', 2.50);


MERGE Products AS T
USING ProductUpdates AS S
ON T.ProductID = S.ProductID
WHEN MATCHED THEN
    UPDATE SET T.ProductName = S.ProductName, T.Price = S.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price) VALUES (S.ProductID, S.ProductName, S.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


/*
Que 15. We want to pivot the data to display total sales amounts for each product by region.
*/
CREATE TABLE Sales (
    SalesID INT,
    Product VARCHAR(50),
    Region VARCHAR(50),
    Amount DECIMAL(10, 2)  
);

INSERT INTO Sales (SalesID, Product, Region, Amount)
VALUES
    (1, 'Apple', 'East', 100.00),
    (2, 'Banana', 'West', 150.00),
    (3, 'Orange', 'East', 200.00),
    (4, 'Apple', 'West', 120.00);

select Product , isnull(East,0)as East , isnull(West,2) as West from
(
select Product, Region, Amount from
Sales
) as source_tablee
pivot
(
SUM(Amount)
for region in ([West],[East])
) as pivot_table


/*
Que 16. 
Query - We want to unpivot the data to display sales data in a normalized format.
*/

CREATE TABLE QuarterlySales (
    Product VARCHAR(50),
    Q1 INT,
    Q2 INT,
    Q3 INT,
    Q4 INT
);

INSERT INTO QuarterlySales (Product, Q1, Q2, Q3, Q4)
VALUES
    ('Apple', 100, 120, 90, 110),
    ('Banana', 150, 140, 130, 160),
    ('Orange', 200, 180, 220, 210);

SELECT Product, Quarter, QuarterSale
FROM (
    SELECT Product, Q1, Q2, Q3, Q4
    FROM QuarterlySales
) AS SourceTable
UNPIVOT (
    QuarterSale FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotedTable;

/*
Que 17.  Write a Query to show Number of Wins, Number of Losses, Total Match Played by each
team.
*/

CREATE TABLE Matches (
    Team1 VARCHAR(50),
    Team2 VARCHAR(50),
    Winner VARCHAR(50)
);

INSERT INTO Matches (Team1, Team2, Winner)
VALUES
    ('RCB', 'MI', 'MI'),
    ('KKR', 'MI', 'KKR'),
    ('Punjab', 'GT', 'GT'),
    ('RR', 'MI', 'MI'),
    ('KKR', 'GT', 'KKR'),
    ('RCB', 'MI', 'RCB'),
    ('RCB', 'KKR', 'RCB'),
    ('GT', 'MI', 'GT');

select team,
count(case when Winner = team then 1 end) as Wins,
count(case when Winner <> team then 1 end) as Losses,
count(*) as TotalMatches
from (
select Team1 as team, Winner from Matches
union all
select Team2 as team, Winner from Matches
) as DerivedTable
group by team