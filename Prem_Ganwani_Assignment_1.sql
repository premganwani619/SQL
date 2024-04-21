-- DAY 1 Assignment Questions
-- Practice question

-- Que 1. Create a Database with Name “Test".
CREATE DATABASE test;
USE test;

-- Que 2. Create a Schema under the Database Test with Name “TestSchema”.
CREATE SCHEMA TestSchema;

-- Que 3. Create a Table with Name “Students” in “Test” Database with scheme “TestSchema”. 
-- Table should have the following columns – StudentId, Name, DOB, AdmissionDate.
CREATE TABLE TestSchema.Students(
    StudentId INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    AdmissionDate DATE
);

-- Que 4.
-- 1. Create Table Employee Containing Columns EmployeeId, Name, Salary, ManagerId, JobRole, and insert the data.
CREATE TABLE Employee (
    EmployeeId INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Salary INT NOT NULL,
    ManagerId INT,
    JobRole VARCHAR(20)
);

INSERT INTO Employee(EmployeeId, Name, Salary, ManagerId, JobRole)
VALUES
(1, 'Prem Ganwani', 100000, 100, 'Intern'),
(2, 'Nimesh Parik', 100000, 101, 'Intern'),
(3, 'Janvi Jain', 100000, 102, 'Intern');

-- 2. Add Columns in Employee Table Mail_id and Grade and insert the data for two newly added columns.
ALTER TABLE Employee 
ADD Mail_id VARCHAR(50),
    Grade VARCHAR(3);

UPDATE Employee
SET Mail_id = 'premsoni0474@gmail.com', Grade = 'A++' WHERE EmployeeId = 1;

UPDATE Employee
SET Mail_id = 'nimeshparik45@gmail.com', Grade = 'A++' WHERE EmployeeId = 2;

UPDATE Employee
SET Mail_id = 'janvijain87@gmail.com', Grade = 'A++' WHERE EmployeeId = 3;

SELECT * FROM Employee;

-- 3. Truncate the Employee Table.
TRUNCATE TABLE Employee;

SELECT * FROM Employee;

-- 4. Delete a specific record from a table.
DELETE FROM Employee WHERE EmployeeId = 3;

SELECT * FROM Employee;

-- 5. DROP the Employee Table.
DROP TABLE Employee;

-- Que 5. Write an Update statement to change the Supplier_name to google for id 600, 700, and 800.
CREATE TABLE Supplier(
    num INT NOT NULL,
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20)
);

INSERT INTO Supplier(num, supplier_id, supplier_name, city, state)
VALUES
(1, 100, 'Microsoft', 'Redmond', 'Washington'),
(2, 200, 'Google', 'Mountain View', 'California'),
(3, 300, 'Oracle', 'Redwood City', 'California'),
(4, 400, 'Kimberly-Clark', 'Irving', 'Texas'),
(5, 500, 'Tyson Foods', 'Springdale', 'Arkansas'),
(6, 600, 'SC Johnson', 'Racine', 'Wisconsin'),
(7, 700, 'Dole Food Company', 'Westlake Village', 'California'),
(8, 800, 'Flowers Food', 'Thomsonville', 'Georgia'),
(9, 900, 'Electronic Arts', 'Redwood City', 'California');

UPDATE Supplier 
SET supplier_name = 'Google' WHERE supplier_id IN (600, 700, 800);

SELECT * FROM Supplier;

-- Que 6. Write a query that prints a list of employee names (i.e., the name attribute) for employees 
-- in Employee having a salary greater than $200 per month who have been employees for less than 10 
-- months. Sort your result by ascending employee_id as already created.

CREATE TABLE Employee (
    Employee_Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Months INT NOT NULL, 
    Salary INT NOT NULL
);

INSERT INTO Employee(Employee_id, name, months, salary)
VALUES
(12228, 'Rose', 15, 1968),
(33645, 'Angela', 1, 3443),
(45692, 'Frank', 17, 1608),
(56118, 'Patrick', 7, 1345),
(59725, 'Lisa', 11, 2330),
(74197, 'Kimberly', 16, 4372),
(78454, 'Bonnie', 8, 1771),
(83565, 'Michael', 6, 2017),
(98607, 'Todd', 5, 3396),
(99989, 'Joe', 9, 3573);

SELECT Employee_Id, Name
FROM Employee
WHERE Salary > 200
  AND Months < 10
ORDER BY Employee_Id ASC;

DROP TABLE Employee;

-- Solve the below Queries using this data set.

-- Q1 Create Table & Insert Data.
CREATE TABLE Employee(id INT PRIMARY KEY, Name VARCHAR(20), Department VARCHAR(10), Salary INT);

INSERT INTO Employee(id, Name, Department, Salary)
VALUES 
(1, 'Vikas', 'CS', 10000),
(2, 'Praveen', 'CS', 10000),
(3, 'Abhisek', 'IT', 15000),
(4, 'Aakash', 'EC', 6000),
(5, 'Vishal', 'EC', 20000),
(6, 'Sunil', NULL, 25000),
(7, 'Vikrant', NULL, 2000);

-- 2. Select all the employees in the table in the order of highest to lowest salary; if the salary is the same, then sort it on the name A-Z.
SELECT * FROM Employee ORDER BY Salary DESC, Name;

-- 3. List all the employees whose names start with ‘A’ and end with ‘K’.
SELECT * FROM Employee WHERE Name LIKE 'A%K';

-- 4. List all the employees whose name starts with ‘V’ OR ends with ‘S’.
SELECT * FROM Employee WHERE Name LIKE 'V%' OR Name LIKE '%S';

-- 5. List all the employees who have the 4th Character as ‘A’ in the Name.
SELECT * FROM Employee WHERE SUBSTRING(Name, 4, 1) = 'A';

-- 6. List all the employees having salary between 5000 & 15000.
SELECT * FROM Employee WHERE Salary BETWEEN 5000 AND 15000;

-- 7. List all the employees having salary > 5000 & Salary < 15000.
SELECT * FROM Employee WHERE Salary > 5000 AND Salary < 15000;

-- 8. List all the employees that have a department.
SELECT * FROM Employee WHERE Department IS NOT NULL;

-- 9. Select all the employees that do not have a department.
SELECT * FROM Employee WHERE Department IS NULL;

-- 10. List all the employees where salary > 10000 or name starts with ‘A’ with the department or does not have a department.
SELECT * FROM Employee WHERE Salary > 10000 OR Name LIKE 'A%' OR Department IS NULL;

-- 11. Order of execution of select query clause.
SELECT Name FROM Employee WHERE Salary > 10000
AND Department = 'CS' ORDER BY Name ASC; -- From -> Where -> Select -> Order By

-- 12. List system function and identify their use cases.
/*
COUNT(): Counts the number of rows in a result set. Used for counting records, often with GROUP BY to get counts per group.
SUM(): Calculates the sum of numeric values in a column. Useful for calculating the total of a numeric column.
AVG(): Computes the average value of a numeric column. Often used for calculating average scores, ratings, or measurements.
MAX(): Retrieves the maximum value in a column. Useful for finding the highest value in a dataset.
MIN(): Retrieves the minimum value in a column. Useful for finding the lowest value in a dataset.
UPPER(): Converts a string to uppercase. Helpful for making data case-insensitive for comparisons or display.
LOWER(): Converts a string to lowercase. Similar to UPPER() but for lowercase.
CONCAT(): Concatenates strings together. Used to combine text values.
*/

-- 13. Select count of employees that start with the same letters.
SELECT LEFT(Name, 1) AS Starting_char, COUNT(*) AS Employee_count FROM Employee
GROUP BY LEFT(Name, 1);

-- 14. Select count of employees for the initial character of the name where count is >1 and salary is greater than 5000.
SELECT LEFT(Name, 1) AS Starting_char, COUNT(*) AS Employee_count FROM Employee
WHERE Salary > 5000
GROUP BY LEFT(Name, 1)
HAVING COUNT(*) > 1
ORDER BY Starting_char;

-- 15. Select the count of an employee for the initial character of the name where the count is >1 and salary less than 5000.
SELECT LEFT(Name, 1) AS Starting_char, COUNT(*) AS Employee_count FROM Employee
WHERE Salary < 5000
GROUP BY LEFT(Name, 1)
HAVING COUNT(*) > 1
ORDER BY Starting_char;

-- 16. List all employees in ascending order of department and descending order of salary. (Treat NULL as unknown)
SELECT * FROM Employee ORDER BY Department ASC, Salary DESC;

-- 17. List all employees in descending order of department and descending order of salary. (Treat NULL as unknown)
SELECT * FROM Employee ORDER BY Department DESC, Salary DESC;

-- 18. Get department-wise Max. Salary and Min. Salary.
SELECT Department, MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary FROM Employee GROUP BY Department;

-- 19. List of employees where Max. Salary < 20000 and Min. Salary > 5000.
SELECT Salary FROM Employee
WHERE Salary < 20000 AND Salary > 5000
GROUP BY Salary
HAVING MAX(Salary) < 20000 AND MIN(Salary) > 5000;