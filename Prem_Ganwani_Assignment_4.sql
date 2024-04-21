use day4;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);
​
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Doe', 'HR', 50000.00),
    (2, 'Jane', 'Smith', 'IT', 60000.00),
    (3, 'Bob', 'Johnson', 'Finance', 55000.00),
    (4, 'Alice', 'Williams', 'Marketing', 48000.00);
  ​
​
--Que 1. Write a simple stored procedure named GetEmployeeCount that returns the total number of employees in the "Employees" table.
CREATE PROCEDURE GetEmployeeCount
@employee_count int OUTPUT
AS
begin
SELECT @employee_count = COUNT(EmployeeID) FROM Employees
end;

DECLARE @result INT
EXECUTE GetEmployeeCount @employee_count = @result OUTPUT
SELECT @result AS EmployeeCOunt

​
-- QUe 2. Create a stored procedure named GetEmployeesByDepartment that takes a department name as input and returns all the employees
-- who belong to that department.
CREATE PROC GetEmployeesByDepartment
@department VARCHAR(50)
AS
begin
SELECT EmployeeID, FirstName, LastName FROM Employees WHERE Department = @department
end;​​
​
Exec GetEmployeesByDepartment @department = 'HR'
​
-- Que 3.Write a stored procedure named GetEmployeeInfo that takes an employee ID as input and returns the employee's name, 
-- job title, and hire date using output parameters.
​
create PROCEDURE GetEmployeeInfo
@employee_id VARCHAR(50),
@emp_name VARCHAR(50) OUTPUT
AS
begin
SELECT @emp_name = FirstName FROM Employees WHERE EmployeeID = @employee_id
end;
​
DECLARE @temp VARCHAR(50) 
EXECUTE GetEmployeeInfo '2', @temp OUTPUT
if(@temp is NULL)
	Print 'emp_name is null'
else
	Print @temp
​
-- Que 4. Create a stored procedure named InsertEmployee that inserts a new employee into the "Employees" table. However,
-- if the insertion fails due to duplicate employee ID or any other reason, the procedure should return an error message.
​
CREATE PROCEDURE InsertEmployee
@id INT
AS
begin
INSERT INTO Employees(EmployeeID) VALUES (@id)
end;
​
EXECUTE InsertEmployee @id = 7
Select *from Employees
​
-- Que 5. Design a stored procedure named TransferFunds that transfers a specified amount from one bank account to another. 
-- The procedure should handle transactions to ensure data consistency in case of failures.
​
-- Create the BankAccount table
CREATE TABLE BankAccount (
    AccountID INT PRIMARY KEY,
    AccountHolderName VARCHAR(255) NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL
);
​
INSERT INTO BankAccount (AccountID, AccountHolderName, Balance)
VALUES
    (1, 'John Doe', 1500.00),
    (2, 'Jane Smith', 2500.50),
    (3, 'Bob Johnson', 10000.75);
​
-- Que 6. Write a stored procedure named GetEmployeeByFilter that allows the user to search for employees based on different filters,
-- such as name, job title, and department. The procedure should use dynamic SQL to construct the query based on the provided filter
-- values.
​
-- Create the EmployeeData table
CREATE TABLE EmployeeData (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    JobTitle VARCHAR(100),
    Department VARCHAR(100)
);
​
-- Insert values into the EmployeeData table
INSERT INTO EmployeeData (EmployeeID, Name, JobTitle, Department)
VALUES
    (1, 'John Doe', 'Software Engineer', 'IT'),
    (2, 'Jane Smith', 'HR Manager', 'Human Resources'),
    (3, 'Bob Johnson', 'Sales Representative', 'Sales'),
    (4, 'Alice Brown', 'Data Analyst', 'Finance');

​
-- Que 7. Implement a stored procedure named GetEmployeeHierarchy that takes an employee ID as input and returns the hierarchical
-- structure of employees under the given employee. Assume that the "Employees" table has a self-referencing foreign key to
-- represent the manager-subordinate relationship.
​
-- Que 8. Create a stored procedure named InsertEmployees that takes a table-valued parameter containing employee data 
-- (employee ID, name, department, etc.) and inserts multiple employees into the "Employees" table in a single call.
​
CREATE Table EmployeeTableType
(
    EmployeeID INT,
    FirstName VARCHAR(50),
    Department VARCHAR(50)
);

​
CREATE TYPE EmployeeType AS TABLE
(
    EmployeeID INT,
    FirstName VARCHAR(50),
    Department VARCHAR(50)
);

​
CREATE PROCEDURE InsertEmployees1
	@insert EmployeeType READONLY 
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO EmployeeTableType (EmployeeID, FirstName, Department)
	SELECT EmployeeId, FirstName, Department FROM @insert
END
​
DECLARE @inserting AS EmployeeType
INSERT INTO @inserting(EmployeeID,FirstName,Department) VALUES (1, 'Nimesh', '4000000'), (2, 'Sudhir', '100000'), (3, 'Chirayu', '343443');
EXEC InsertEmployees1 @inserting
​
SELECT *FROM EmployeeTableType
​
-- Que 9. Write a stored procedure named GetEmployeeProjects that takes an employee ID as input and returns two result sets:
-- The first result set should contain the employee's details (name, department, etc.).
-- The second result set should contain all the projects the employee is currently working on.
​
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    ProjectID INT,
    ProjectName VARCHAR(50),
    Description VARCHAR(255),
);
​
INSERT INTO EmployeeProjects VALUES (1, 'John', 'Doe', 'IT', 101, 'Project A', 'Description A');
INSERT INTO EmployeeProjects VALUES (1, 'John', 'Doe', 'IT', 102, 'Project B', 'Description B');
INSERT INTO EmployeeProjects VALUES (2, 'Jane', 'Smith', 'HR', 102, 'Project B', 'Description B');

​
-- Create the stored procedure
CREATE PROCEDURE GetEmployeeProjects
    @EmployeeID INT
AS
BEGIN
    SELECT
        EP.EmployeeID,
        EP.FirstName,
        EP.LastName,
        EP.Department,
        EP.ProjectID,
        EP.ProjectName,
        EP.Description
    FROM EmployeeProjects AS EP
    WHERE EP.EmployeeID = @EmployeeID;
END;
​
EXEC GetEmployeeProjects 1;
​
--	Que 10.	Design a stored procedure named GetEmployeesByProject that takes a project ID as input and returns the employees who are 
-- working on that project. The number of columns and their data types should be dynamic, based on the number and types of 
-- attributes in the "Employees" table.
-- Create a single table for employees and projects
CREATE TABLE EmployeeProjects2 (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    ProjectID INT,
    ProjectName VARCHAR(50),
    Description VARCHAR(255),
    PRIMARY KEY (EmployeeID, ProjectID)
);
​
INSERT INTO EmployeeProjects2 VALUES (1, 'John', 'Doe', 'IT', 101, 'Project A', 'Description A');
INSERT INTO EmployeeProjects2 VALUES (1, 'John', 'Doe', 'IT', 102, 'Project B', 'Description B');
INSERT INTO EmployeeProjects2 VALUES (2, 'Jane', 'Smith', 'HR', 102, 'Project B', 'Description B');

​
CREATE PROCEDURE GetEmployeesByProject
    @ProjectID INT
AS
BEGIN
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Department
    FROM EmployeeProjects2
    WHERE ProjectID = @ProjectID;
END;
​
DECLARE @ProjectID INT;
SET @ProjectID = 102; 
​EXEC GetEmployeesByProject @ProjectID;

-- Q11) Create a UDF named GetFullName that concatenates the first name and last name of an employee with a space in
-- between and Write a query to get the full names of all employees using the GetFullName UDF.

CREATE TABLE Employees3
(
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

-- Step 2: Insert values into the Employees table
INSERT INTO Employees3 (EmployeeID, FirstName, LastName)
VALUES
    (1, 'John', 'Doe'),
    (2, 'Jane', 'Smith'),
    (3, 'Robert', 'Johnson');

select* from employees3 

CREATE FUNCTION GetFullName(
@firstname nVARCHAR(50),
@lastname nVARCHAR(50)
)
RETURNS NVARCHAR(100)
AS 
BEGIN

DECLARE @fullname VARCHAR(50)
SET @fullname = @firstname + ' ' + @lastname
return @fullname
END;

SELECT dbo.GetFullName(firstname, lastname) as fullname FROM Employees3;


-- Q14) 11.	Create a UDF named GetFullName that concatenates the first name and last name of an employee with a space in between and Write a query to get the full names of all employees using the GetFullName UDF.
-- Create a UDF named GetSalaryGrade that takes an employee's salary as input and returns their salary grade based on the following conditions:
-- a. If the salary is less than 50000, return 'Low'.
-- b. If the salary is between 50000 and 80000 (inclusive), return 'Medium'.
-- c. If the salary is greater than 80000, return 'High'.
-- d. Write a query to get the EmployeeID, FullName, and SalaryGrade for all employees using the GetSalaryGrade UDF.
 
CREATE TABLE Employees4
(
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Step 2: Insert values into the Employees table
INSERT INTO Employees4 (EmployeeID, FirstName, LastName, Salary)
VALUES
    (1, 'John', 'Doe', 45000),
    (2, 'Jane', 'Smith', 65000),
    (3, 'Robert', 'Johnson', 90000);
Go;

CREATE FUNCTION GetSalaryGrade(@inp_salary DECIMAL)
RETURNS VARCHAR(10)
AS
BEGIN

DECLARE @ret VARCHAR(10) 
	If 
		@inp_salary < 50000 SET @ret = 'low'
	else if 
		@inp_salary BETWEEN 50000 AND 80000 SET @ret = 'medium'
	else 
		SET @ret = 'high'

RETURN @ret
END;

SELECT EmployeeID, dbo.GetFullName(firstname, lastname) as fullname, dbo.GetSalaryGrade(Salary) as grade from Employees4;

-- Q12) Create a UDF named GetAverageSalary that calculates and returns the average salary of all employees and Write a query
-- to get the average salary of all employees using the GetAverageSalary UDF.

alter FUNCTION GetAverageSalarys
()
RETURNS DECIMAL
AS 
BEGIN
    DECLARE @average DECIMAL
    SELECT @average = AVG(salary) FROM employees4
    RETURN @average
END;

-- Step 3: Use the UDF in a query
SELECT dbo.GetAverageSalarys() AS AverageSalary;

-- Q13) 13.	Create a Scalar UDF to calculate the discounted price for a product. The discount percentage is 10% and Use 
-- the Scalar UDF to get the discounted prices for all products. 

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
    (1, 'ProductA', 50.00),
    (2, 'ProductB', 75.00),
    (3, 'ProductC', 100.00);


CREATE FUNCTION CalculateDiscountedPrice (@OriginalPrice DECIMAL)
RETURNS DECIMAL
AS
BEGIN
  
    DECLARE @DiscountedPrice DECIMAL;

    SET @DiscountedPrice = @OriginalPrice - (@OriginalPrice * 0.10);

    RETURN @DiscountedPrice;
END;


SELECT ProductID, ProductName, Price, dbo.CalculateDiscountedPrice(Price) AS DiscountedPrice FROM Products;


-- Q14) 14.	Create a Table-Valued UDF to return all products within a specific price range and Use the Table-Valued UDF to get
-- products within a price range.
create FUNCTION GetProductsInPriceRange (@MinPrice DeciMAL, @MaxPrice DECIMAL)
RETURNS TABLE
AS
RETURN (
    SELECT ProductID, ProductName, Price
    FROM Products
    WHERE Price BETWEEN @MinPrice AND @MaxPrice
);

SELECT ProductID, ProductName, Price
FROM Products
WHERE Price BETWEEN MIN(Price) AND MAX(Price);
select *from products;

--Q15) 15.	Create an Inline Table-Valued UDF to get all products in a specific category and Use the Inline Table-Valued UDF 
-- to get all products from a specific category.
CREATE TABLE Products2 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(100)
);

-- Insert sample data into Products table
INSERT INTO Products2 (ProductID, ProductName, Price, Category)
VALUES
    (1, 'ProductA', 50.00, 'Electronics'),
    (2, 'ProductB', 75.00, 'Clothing'),
    (3, 'ProductC', 100.00, 'Electronics');

CREATE FUNCTION GetProductsByCategory (@Category VARCHAR(100))
RETURNS TABLE
AS
RETURN (
    SELECT ProductID, ProductName, Price
    FROM Products2
    WHERE Category = @Category
);

SELECT * FROM GetProductsByCategory('Electronics');

-- Q16) 

CREATE TABLE Orders2 (
    OrderId INT PRIMARY KEY,
    ProductId INT,
    Title VARCHAR(255),
    Price DECIMAL(10, 2),
    ShopperName VARCHAR(255),
    Email VARCHAR(255),
    OrderDate DATE,
    Status VARCHAR(50)
);

INSERT INTO Orders2 VALUES (3, 1, 'Product1', 10.99, 'Alice Johnson', 'alice@example.com', '2023-08-10', 'shipped');
INSERT INTO Orders2 VALUES (4, 2, 'Product2', 20.49, 'Bob Williams', 'bob@example.com', '2023-08-15', 'shipped');
INSERT INTO Orders2 VALUES (5, 1, 'Product1', 10.99, 'Charlie Davis', 'charlie@example.com', '2023-08-20', 'processing');
INSERT INTO Orders2 VALUES (6, 2, 'Product2', 20.49, 'David Miller', 'david@example.com', '2023-08-25', 'shipped');

-- a. Create a view displaying the order information (Id, Title, Price, Shopper’s 
-- name, Email, Orderdate, Status) with latest ordered items should be 
-- displayed first for last 60 days.

create VIEW LatestOrders AS
SELECT OrderId, Title, Price, ShopperName, Email, OrderDate, Status
FROM Orders2
WHERE OrderDate >= DATEADD(DAY, -60, GETDATE())

SELECT *FROM LatestOrders
ORDER BY OrderDate DESC; -- we cannot use order by in views, inline functions, derived table and a big error is there bro

-- b. Use the above view to display the Products(Items) which are in ‘shipped’ 
-- state.
SELECT *FROM LatestOrders WHERE Status = 'shipped';

-- c. Use the above view to display the top 5 most selling products.
SELECT
    OrderId,
    Title,
    Price,
    COUNT(*) AS TotalSales
FROM
    LatestOrders
GROUP BY
    OrderId, Title, Price
ORDER BY
    TotalSales DESC
OFFSET 0 ROWS -- for specifing the starting point 
FETCH FIRST 5 ROWS ONLY;

-- Q17) 
CREATE TABLE Department(id INT PRIMARY KEY, Name VARCHAR(30));
INSERT INTO Department(id, Name) values(1,'IT'),(2,'HR'),(3,'Sales');

CREATE TABLE Employee5 (
    id INT PRIMARY KEY,
    Name VARCHAR(30),
    Gender VARCHAR(30),
    DOB DATE,
    DeptID INT
);

INSERT INTO Employee5 (id, Name, Gender, DOB, DeptID) VALUES
(1, 'Pranaya', 'Male', '1996-02-29', 1),
(2, 'Priyanka', 'Female', '1995-05-25', 2),
(3, 'Anurag', 'Male', '1995-04-19', 2),
(4, 'Preety', 'Female', '1996-03-17', 3),
(5, 'Sambit', 'Male', '1997-01-15', 1),
(6, 'Hina', 'Female', '1995-07-12', 2);

--Q1) Create a view to retrieve all the columns from employee table.
CREATE VIEW EmployeeViews AS
SELECT * FROM Employee5;
SELECT * FROM EmployeeViews;

--Q2) Create a view to display name and dept id of the employee.
CREATE VIEW EmployeeNameDeptView AS
SELECT Name, DeptID FROM Employee5;
SELECT * FROM EmployeeNameDeptView;

-- Q3) Insert new data (7, ‘Rohit’, ‘Male’, ‘1995-04-19 10:53:27.060’, 3) in the view created in part a
INSERT INTO Employee5 (id, Name, Gender, DOB, DeptID)
VALUES (7, 'Rohit', 'Male', '1995-04-19', 3);

-- Q4) Update dept id of Rohit as 1 in the view.	
-- confused about how to do this like how to insert in view will discuss this