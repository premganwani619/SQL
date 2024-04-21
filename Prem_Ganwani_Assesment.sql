
--Assessment Questions
--Total Time: 5.5 Hrs
--Date: 11 Aug 2023
--Name: Prem Ganwani

CREATE DATABASE assesment;
USE assesment;

--Que 1. 

create table Worker (
Worker_id int primary key,
First_name  varchar(10),
Last_name varchar(10),
Salary  int,
Joining_date datetime,
Department   varchar(10)
);

insert into Worker(Worker_id, First_name, Last_name , Salary, Joining_date, Department)
values
(001,'Monika', 'Arora',100000, '2014-02-20 09:00:00', 'HR'),
 (002, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(004,'Amitabh', 'Singh',500000,    '2014-02-20 09:00:00', 'Admin'),
(005,'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

create table Bonus (
Worker_ref_id int,
Bonus_date datetime,
Bonus_amount int
);

INSERT INTO Bonus (Worker_ref_id, Bonus_date, Bonus_amount)
VALUES
(1,'2016-02-20 00:00:00',5000),
(2, '2016-06-11 00:00:00', 3000),
(3, '2016-02-20 00:00:00',4000),
(1,'2016-02-20 00:00:00', 4500),
(2, '2016-06-11 00:00:00', 3500);

create table Title (
Worker_ref_id int,
Worker_title varchar(15),
Affected_from datetime
);

insert into Title (Worker_ref_id, Worker_title, Affected_from)
values
(1, 'Manager', '2016-02-20 00:00:00'),
(2, 'Executive', '2016-06-11 00:00:00'),
(8, 'Executive', '2016-06-11 00:00:00'),
(5, 'Manager', '2016-06-11 00:00:00'),
(4, 'Asst. Manager', '2016-06-11 00:00:00'),
(7, 'Executive', '2016-06-11 00:00:00'),
(6, 'Lead', '2016-06-11 00:00:00'),
(3, 'Lead', '2016-06-11 00:00:00');

--1. Write an SQL query to print details of the Workers who are also Managers.

select w.*
from worker as w
inner join
title as t
on w.worker_id = t.worker_ref_id
where t.worker_title='Manager';

--2. Write an SQL query to show only odd rows from Worker table.

select * from Worker
where worker_id %2 =1;

--3. Write an SQL query to print the name of employees having the highest salary in each
--department.

select t.Worker_title,
w.First_name,
max(w.Salary) over(partition by t.Worker_title) as Salary from Worker as w
inner join Title as t
on w.worker_id = t.worker_ref_id

--4. Write an SQL query to fetch three max salaries from a table.

select top 3 First_name, Salary from worker order by
salary desc;

/*
Que 2.
Write a query identifying the type of each record in the TRIANGLES table using its three side
lengths. Output one of the following statements for each record in the table:
• Equilateral: It's a triangle with sides of equal length.
• Isosceles: It's a triangle with sides of equal length.
• Scalene: It's a triangle with sides of differing lengths.
• Not A Triangle: The given values of A, B, and C don't form a triangle.

*/

create table triangles (
    A int,
    B int,
    C int
);

insert into triangles (A, B, C)
values 
(20, 20, 23),
(20, 20, 20),
(20, 21, 22),
(13, 14, 30);

create function GetTriangleType(@a int, @b int, @c int)
returns int
as
begin
declare @result nvarchar(25)
if @a=@b AND @b=@c
set @result = 1
else if (@a=@b AND @b!=@c) OR (@b =@c AND @c!=@a) OR (@a =@c AND @c!= @b)
set @result = 2
else if @a!= @b AND @a!= @c AND @b!= @c
set @result = 3
else
set @result = 0
return @result
end

select
case
when dbo.GetTriangleType(A, B, C) = 1 then 'Equilateral'
when dbo.GetTriangleType(A, B, C) = 2 then 'Isosceles'
when dbo.GetTriangleType(A, B, C) = 3 then 'Scalene'
else 'Not A Triangle'
end as Triangle_Type
from triangles;

/*
QUE 3. 
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and
displayed underneath its corresponding Occupation. The output column headers should be
Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation.
*/

create table Workers (
    name varchar(50),
    Occupation varchar(50)
);


insert into Workers (name, Occupation)
values
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

SELECT doctor, singer,professor, actor
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

create table Hackers (
    Hacker_id int,
    Name varchar(50)
);

insert into Hackers (Hacker_id, Name)
values
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
Submission_id int,
Hacker_id int,
Challenge_id int,
Score int
);

insert into Submissions (Submission_id, Hacker_id, Challenge_id, Score)
values
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

select h.Hacker_id,h.Name,sum(sscore) as Total_score
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

declare @i int = 2;
declare @prime int = 0;
declare @prime_numbers nvarchar(max) = '';

while @i <= 1000
begin
declare @j int = @i - 1;
set @prime = 1;
while @j > 1
begin
if @i % @j = 0
begin
set @prime = 0;
end
set @j = @j - 1;
end
if @prime = 1
begin
if @prime_numbers= ''
set @prime_numbers =cast(@i as varchar(4));
else
set @prime_numbers= @prime_numbers+' & '+cast(@I as varchar(3));
end
set @i= @i+1;
end
select @prime_numbers as PrimeNumbers;

/*
Que 6. Write a query to output the names of those students whose best friends got offered a higher
salary than them. Names must be ordered by the salary amount offered to the best friends. It is
guaranteed that no two students will get the same salary offer.
*/

create table Students (
    ID int primary key,
    Name nvarchar(10)
);

insert into Students (Id, Name)
values(1, 'Ashley'),
    (2, 'Samantha'),
    (3, 'Julia'),
    (4, 'Scarlet');


create table Friends (
    Id int primary key,
    Friend_Id int
);


insert into Friends (Id, Friend_Id)
values
    (1, 2),
    (2, 3),
    (3, 4),
    (4, 1);


create table Packages (
    Id int primary key,
    Salary decimal(8, 2)
);


insert into Packages (Id, Salary)
values
    (1, 15.20),
    (2, 10.06),
    (3, 11.55),
    (4, 12.12);

	

select s.Name
from Students s
JOIN Friends f on s.ID = f.ID
JOIN Packages p on f.Friend_ID = p.ID
where p.Salary > (
select Salary
from Packages
where ID = s.ID
)
order by p.Salary

/*
Que 7. Query - Write a SQL query to retrieve all the CustomerName and their OrderDate for each
order if applicable. If no order date then print 1900-01-01.
*/

create table Customers (
    CustomerId int,
    CustomerName varchar(50),
    City varchar(50)
);

INSERT INTO Customers (CustomerId, CustomerName, City)
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
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerId;

/* Que 8.
Query - Write a SQL query to retrieve the names of all the employees along with the names of
their managers wherever applicable
*/

create table Employees (
EmployeeId int,
EmployeeName varchar(10),
ManagerId int
);

insert into Employees (EmployeeID, EmployeeName, ManagerID)
values
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2);

	select  e2.EmployeeName as employee,e1.EmployeeName as manager  from Employees as e1 right join Employees as e2
	on e1.EmployeeID = e2.ManagerID

/*
Que 9. 
*/
create table Students (
    StudentId int,
    StudentName varchar(10),
    Age int
);

insert into Students (StudentID, StudentName, Age)
values
    (1, 'Alice', 20),
    (2, 'Bob', 21),
    (3, 'Charlie', 19);

create table Courses (
    CourseId int,
    CourseName varchar(10)
);

insert into Courses (CourseID, CourseName)
values    (101, 'Math'),
    (102, 'Science'),
    (103, 'History');

create table Enrollments (
    StudentID int,
    CourseID int
);

insert into Enrollments (StudentID, CourseID)
values
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
select * from Employees
create table Employees (
    EmployeeId int,
    FirstName varchar(10),
    LastName varchar(10),
    DepartmentId int
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'Alice', 'Johnson', 101),
    (2, 'Bob', 'Smith', 102),
    (3, 'Charlie', 'Brown', 101),
    (4, 'David', 'Lee', 103);

create table Departments (
    DepartmentId int,
    DepartmentName varchar(50)
);
 
insert into Departments (DepartmentID, DepartmentName)
values    (101, 'HR'),
    (102, 'Finance'),
    (103, 'IT');

create table EmployeeProjects (
    EmployeeId int,
    ProjectId int
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

create table Orders (
    OrderId int,
    ProductId int,
    Quantity int,
    UnitPrice decimal(10, 2)
);

insert into Orders (OrderID, ProductId, Quantity, UnitPrice)
values
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

select dbo.CalculateTotalPrice(OrderID) as Price from Orders;

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

create table Employees (
    EmployeeId int,
    FirstName varchar(10),
    LastName varchar(10),
    DepartmentId int
);

insert into Employees (EmployeeId, FirstName, LastName, DepartmentId)
values
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

create table Products (
    ProductId int,
    ProductName varchar(10),
    Price decimal(10, 2)  
);

insert into Products (ProductId, ProductName, Price)
values
    (101, 'Apple', 1.00),
    (102, 'Banana', 0.75),
    (103, 'Orange', 0.50);

create table ProductUpdates (
    ProductId int,
    ProductName varchar(10),
    Price decimal(10, 2)
);

insert into ProductUpdates (ProductId, ProductName, Price)
values
    (102, 'Banana', 0.80),
    (104, 'Grape', 1.20),
    (105, 'Pineapple', 2.50);

select * from Products;

merge Products AS T
using ProductUpdates AS S
on T.ProductID = S.ProductID
when matched then
    update set T.ProductName = S.ProductName, T.Price = S.Price
when not matched by target then
    INSERT (ProductID, ProductName, Price) VALUES (S.ProductID, S.ProductName, S.Price)
when not matched by source then
    delete;

select * from Products;

/*
Que 15. We want to pivot the data to display total sales amounts for each product by region.
*/
create table Sales (
    SalesId int,
    Product varchar(10),
    Region varchar(10),
    Amount decimal(10, 2)  
);

insert into Sales (SalesId, Product, Region, Amount)
values
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

create table QuarterlySales (
    Product varchar(10),
    Q1 int,
    Q2 int,
    Q3 int,
    Q4 int
);

insert into QuarterlySales (Product, Q1, Q2, Q3, Q4)
values
    ('Apple', 100, 120, 90, 110),
    ('Banana', 150, 140, 130, 160),
    ('Orange', 200, 180, 220, 210);

select Product, Quarter, QuarterSale
from (
    select Product, Q1, Q2, Q3, Q4
    from QuarterlySales
) as SourceTable
unpivot (
    QuarterSale FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotedTable;

/*
Que 17.  Write a Query to show Number of Wins, Number of Losses, Total Match Played by each
team.
*/

create table Matches (
    Team1 varchar(10),
    Team2 varchar(10),
    Winner varchar(10)
);

insert into Matches (Team1, Team2, Winner)
values
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