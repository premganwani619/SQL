/*
Day 4  Assignment Questions 
1.Write a simple stored procedure named GetEmployeeCount that returns 
the total number of employees in the "Employees" table.
*/
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2),
    PRIMARY KEY (EmployeeID)
);

INSERT INTO Employees (EmployeeID,FirstName, LastName, Department, Salary)
VALUES
    (1,'John', 'Doe', 'HR', 50000.00),
    (2,'Jane', 'Smith', 'IT', 60000.00),
    (3,'Robert', 'Johnson', 'Sales', 55000.00),
    (4,'Emily', 'Davis', 'Marketing', 52000.00);

create procedure GetEmployeeCount
@emp_count int out
as 
begin
select @emp_count = count(EmployeeID) from Employees;
end;

declare @variable int 
exec GetEmployeeCount @variable out;
/*
2.Create a stored procedure named GetEmployeesByDepartment that 
takes a department name as input and returns all the employees who 
belong to that department.
*/
create procedure GetEmployeeCountByDepartment
@dept_name nvarchar (10)
as 
begin
declare @emp_count_by_dept int 
select @emp_count_by_dept = count(EmployeeID) from Employees where department = @dept_name;
return @emp_count_by_dept
end;

declare @dept nvarchar(10) = 'HR'
declare @count int;
exec  @count = GetEmployeeCountByDepartment @dept_name= @dept;

/*
3.Write a stored procedure named GetEmployeeInfo that takes an employee
ID as input and returns the employee's name, job title, and hire date using 
output parameters.
*/
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    JobTitle NVARCHAR(50),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, JobTitle, HireDate)
VALUES
    (1, 'John', 'Doe', 'Manager', '2020-01-15'),
    (2, 'Jane', 'Smith', 'Developer', '2019-05-10'),
    (3, 'Robert', 'Johnson', 'Sales Associate', '2018-08-20'),
    (4, 'Emily', 'Davis', 'Marketing Specialist', '2021-03-05');


create procedure GetEmployeeInfo
@emp_id int,
@emp_name nvarchar(10) out,
@emp_job nvarchar(10) out,
@emp_hire_date date out
as 
begin
select @emp_name = FirstName from Employees where EmployeeID = @emp_id;
select @emp_job = JobTitle from Employees where EmployeeID = @emp_id;
select @emp_hire_date = HireDate from Employees where EmployeeID = @emp_id;
end;

declare @id int =1;
declare @name nvarchar(10);
declare @job nvarchar(10);
declare @date date;
exec GetEmployeeInfo @emp_id = @id , @emp_name = @name out, @emp_job = @job out, @emp_hire_date = @date out;

/*
4.Create a stored procedure named InsertEmployee that inserts a new 
employee into the "Employees" table. However, if the insertion fails due to 
duplicate employee ID or any other reason, the procedure should return an 
error message.
*/
alter proc InsertEmployee
@emp_id int,
@emp_fname nvarchar(10),
@emp_lname nvarchar(10),
@emp_job nvarchar(10),
@emp_hire_date date
as 
begin
begin try 
insert into Employees(EmployeeID, FirstName, LastName, JobTitle, HireDate)
values(@emp_id,@emp_fname,@emp_lname,@emp_job,@emp_hire_date)
end try
begin catch 
 DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'insertion failed';
		print error_message();
        RAISERROR(@ErrorMessage, 16, 1);
end catch
end;

exec InsertEmployee @emp_id = 1, @emp_fname = 'John', @emp_lname = 'Doe', @emp_job = 'Manager',@emp_hire_date= '2020-01-15'
/*
5.Design a stored procedure named TransferFunds that transfers a specified
amount from one bank account to another. The procedure should handle 
transactions to ensure data consistency in case of failures.
*/
CREATE TABLE BankAccounts (
    AccountID INT PRIMARY KEY,
    AccountNumber VARCHAR(20),
    Balance DECIMAL(10, 2)
);

INSERT INTO BankAccounts (AccountID, AccountNumber, Balance)
VALUES (1, '1234567890', 1000.00),
(2, '0987654321', 500.00);

ALTER PROCEDURE TransferFunds
    @id1 INT,
    @id2 INT,
    @amount DECIMAL(10, 2)
AS
BEGIN
IF @amount > (SELECT Balance FROM BankAccounts WHERE AccountID = @id1)
    BEGIN
		raiserror('Insufficient Balance',16,1)
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE BankAccounts
        SET Balance = Balance - @amount
        WHERE AccountID = @id1;

        UPDATE BankAccounts
        SET Balance = Balance + @amount
        WHERE AccountID = @id2;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(400);
        SET @ErrorMessage = 'An error occurred while transferring funds.';
        THROW 51000, @ErrorMessage, 1;
    END CATCH
END;
select * from BankAccounts;
exec TransferFunds @id1 =1 , @id2 =2,@amount =800;
select * from BankAccounts;

/*
6.Write a stored procedure named GetEmployeeByFilter that allows the 
user to search for employees based on different filters, such as name, job 
title, and department. The procedure should use dynamic SQL to construct 
the query based on the provided filter values.
*/
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    JobTitle VARCHAR(50),
    Department VARCHAR(50)
);
INSERT INTO Employees (EmployeeID, FirstName, LastName, JobTitle, Department)
VALUES (1, 'John', 'Doe', 'Manager', 'Sales'),
       (2, 'Jane', 'Smith', 'Developer', 'IT'),
       (3, 'David', 'Johnson', 'Analyst', 'Finance'),
       (4, 'Sarah', 'Williams', 'Designer', 'Marketing');

CREATE PROCEDURE GetEmployeeByFilter
    @FirstName VARCHAR(50) = NULL,
    @LastName VARCHAR(50) = NULL,
    @JobTitle VARCHAR(50) = NULL,
    @Department VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = 'SELECT * FROM Employees WHERE 1 = 1';

    IF @FirstName IS NOT NULL
        SET @SQL = @SQL + ' AND FirstName = ''' + @FirstName + '''';

    IF @LastName IS NOT NULL
        SET @SQL = @SQL + ' AND LastName = ''' + @LastName + '''';

    IF @JobTitle IS NOT NULL
        SET @SQL = @SQL + ' AND JobTitle = ''' + @JobTitle + '''';

    IF @Department IS NOT NULL
        SET @SQL = @SQL + ' AND Department = ''' + @Department + '''';

    EXEC sp_executesql @SQL;
END;
/*
7.Implement a stored procedure named GetEmployeeHierarchy that takes 
an employee ID as input and returns the hierarchical structure of employees
under the given employee. Assume that the "Employees" table has a self-
referencing foreign key to represent the manager-subordinate relationship.
*/
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID)
VALUES (1, 'John', NULL),
       (2, 'Alice', 1),
       (3, 'Bob', 1),
       (4, 'Charlie', 2),
       (5, 'David', 2),
       (6, 'Eve', 3),
       (7, 'Frank', 3);

create proc GetEmployeeHierarchy
@emp_id int
as 
begin
select e2.* from Employees as e1 inner join 
Employees as e2
on e1.EmployeeID=e2.ManagerID
where e1.EmployeeID = @emp_id
end
exec GetEmployeeHierarchy @emp_id =1
/*
8.Create a stored procedure named InsertEmployees that takes a table-
valued parameter containing employee data (employee ID, name, 
department, etc.) and inserts multiple employees into the "Employees" 
table in a single call.
*/

Create Table Employees
(
 Id int primary key,
 Name nvarchar(50),
 Gender nvarchar(10)
)

CREATE TYPE EmpTableType AS TABLE
(
 Id INT PRIMARY KEY,
 Name NVARCHAR(50),
 Gender NVARCHAR(10)
)


CREATE PROCEDURE spInsertEmployees
@EmpTableType EmpTableType READONLY
AS
BEGIN
 INSERT INTO Employees
 SELECT * FROM @EmpTableType
END

DECLARE @EmployeeTableType EmpTableType 

INSERT INTO @EmployeeTableType VALUES (1, 'Mark', 'Male')
INSERT INTO @EmployeeTableType VALUES (2, 'Mary', 'Female')
INSERT INTO @EmployeeTableType VALUES (3, 'John', 'Male')
INSERT INTO @EmployeeTableType VALUES (4, 'Sara', 'Female')
INSERT INTO @EmployeeTableType VALUES (5, 'Rob', 'Male')

EXECUTE spInsertEmployees @EmployeeTableType
select * from Employees

/*
9.Write a stored procedure named GetEmployeeProjects that takes an 
employee ID as input and returns two result sets:
The first result set should contain the employee's details (name, 
department, etc.).
The second result set should contain all the projects the employee is 
currently working on.
*/

SELECT
    E.FirstName AS EmployeeFirstName,
    E.LastName AS EmployeeLastName,
    E.Department AS EmployeeDepartment,
    E.JobTitle AS EmployeeJobTitle,
    NULL AS ProjectName,
    NULL AS ProjectDescription,
    NULL AS StartDate,
    NULL AS EndDate
FROM Employees AS E
WHERE E.EmployeeID = @EmployeeID



SELECT
    NULL AS EmployeeFirstName,
    NULL AS EmployeeLastName,
    NULL AS EmployeeDepartment,
    NULL AS EmployeeJobTitle,
    P.ProjectName,
    P.ProjectDescription,
    P.StartDate,
    P.EndDate
FROM Projects AS P
INNER JOIN EmployeeProjects AS EP ON P.ProjectID = EP.ProjectID
WHERE EP.EmployeeID = @EmployeeID;
