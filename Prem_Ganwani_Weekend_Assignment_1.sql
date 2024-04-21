--Weekend Assignment Questions (Week-1)
Create Database Weekend_1;
use weekend_1;
--Que. 1 Write a solution to find the employees who earn more than their managers,
--who is the manager and with their salaries.

CREATE TABLE employee (
    id INT,
    name VARCHAR(255),
    salary INT,
    managerId INT,
    PRIMARY KEY (id)
);

INSERT INTO employee (id, name, salary, managerId)
VALUES
    (1, 'Alice Brown', 60000, 2),
    (2, 'Charlie Green', 70000, 1),
    (3, 'David White', 80000, 1),
    (4, 'Eve Gray', 55000, 3),
    (5, 'Frank Black', 90000, 3),
    (6, 'Grace Red', 75000, 2);

CREATE TABLE manager (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT
);

INSERT INTO manager (id, name, salary)
VALUES
    (1, 'John Doe', 75000),
    (2, 'Jane Smith', 80000),
    (3, 'Bob Johnson', 90000);


select e.name as Employee_Name ,e.salary as Employee_Salary,
m.name as Manager_Name, m.salary as manager_salary from
employee as e inner join manager as m
on e.managerid = m.id
where e.salary>m.salary;


--Que 2. Write a Query to retrieve the following result set:
--StartStoppage | EndStoppage | DurationinHours | Date |TrainNumber
-- Create a table to store train stoppage data
CREATE TABLE TrainStoppage (
    TrainNumber INT,
    StoppageName VARCHAR(255),
    StoppageDateTime DATETIME,
);
INSERT INTO TrainStoppage (TrainNumber, StoppageName, StoppageDateTime)
VALUES
    (12309, 'Jaipur', '2023-08-01 10:00:00'),
    (12309, 'Ajmer', '2023-08-01 12:00:00'),
    (12310, 'Bhilwara', '2023-08-01 15:10:00'),
    (12310, 'Udaipur', '2023-08-01 17:30:00'),
    (12311, 'Bikaner', '2023-08-01 20:30:00'),
    (12311, 'Jaisalmer', '2023-08-02 01:00:00'),
    (12312, 'Jodhpur', '2023-08-02 10:00:00');

--StartStoppage | EndStoppage | DurationinHours | Date |TrainNumber

select t1.StoppageName as sStartStoppage, t2.StoppageName as EndStoppage, DATEDIFF(HOUR,t1.StoppageDateTime,t2.StoppageDateTime)'Duration Hours',DATEDIFF(MINUTE,t1.StoppageDateTime,t2.StoppageDateTime)-(DATEDIFF(HOUR,t1.StoppageDateTime,t2.StoppageDateTime)*60) 'Duration Minutes', CONVERT(date, t1.StoppageDateTime) 'Date' , t1.TrainNumber from TrainStoppage as t1 cross join TrainStoppage as t2
where t1.StoppageDateTime<t2.StoppageDateTime and t1.TrainNumber = t2.TrainNumber;


--Que 3. Create a Stored Procedure with take input parameter as table name and then
--return the total count of the rows in that table in the form a output parameter.

CREATE TABLE s1.SampleTable (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

INSERT INTO s1.SampleTable (ID, Name)
VALUES
    (1, 'John'),
    (2, 'Alice'),
    (3, 'Bob'),
    (4, 'Eve');

	CREATE PROCEDURE GetTotalRows
    @TableName NVARCHAR(128),
    @RowCount INT OUTPUT
AS
BEGIN
    DECLARE @SqlStatement NVARCHAR(MAX);
    
    SET @SqlStatement = 'SELECT @RowCountOUT = COUNT(*) FROM ' + QUOTENAME(@TableName);
    
    EXEC sp_executesql @SqlStatement, N'@RowCountOUT INT OUTPUT', @RowCount OUTPUT;
END;

DECLARE @countofrows INT; 
EXEC GetTotalRows @TableName = 'SampleTable', @RowCount = @countofrows OUTPUT;

PRINT 'Row count: ' + CAST(@countofrows AS NVARCHAR(10));

--Question 4.  (Use AdventureWorksDW2017 Database)
--Write a single SP for the following queries.
use AdventureWorksDW2017;
--1. Display the list of products (Id, Title, Count of Categories) which fall 
--in more than one Category.
CREATE PROCEDURE FindProductsInMultipleCategories
as 
begin
SELECT dp.ProductKey, dp.EnglishProductName
FROM DimProduct AS dp
INNER JOIN DimProductSubcategory AS dps
    ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN DimProductCategory AS dpc
    ON dpc.ProductCategoryKey = dps.ProductCategoryKey
GROUP BY dp.ProductKey, dp.EnglishProductName
HAVING COUNT(dpc.ProductCategoryKey) > 1;
end;
exec FindProductsInMultipleCategories;
--2. Display the Categories along with number of products under each
--category.
CREATE PROCEDURE categoryandproducts
as 
begin
SELECT dpc.EnglishProductCategoryName, dpc.ProductCategoryKey ,count(dp.ProductKey) as product_count FROM DimProduct AS dp
INNER JOIN DimProductSubcategory AS dps
    ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN DimProductCategory AS dpc
    ON dpc.ProductCategoryKey = dps.ProductCategoryKey
	group by dpc.ProductCategoryKey ,dpc.EnglishProductCategoryName,dpc.FrenchProductCategoryName;
end;
exec categoryandproducts;
--3. Display Count of products as per below price range:
-- Create the Employee table
create proc countofproductsbyrange
as
begin
SELECT
    SUM(CASE WHEN StandardCost BETWEEN 0 AND 100 THEN 1 ELSE 0 END) AS PriceRange0to100,
    SUM(CASE WHEN StandardCost BETWEEN 101 AND 500 THEN 1 ELSE 0 END) AS PriceRange101to500,
    SUM(CASE WHEN StandardCost > 500 THEN 1 ELSE 0 END) AS PriceRangeAbove500
FROM DimProduct;
end;
exec countofproductsbyrange;
--Question 5. Write an SQL query to determine the 5th highest salary without 
--using the TOP or limit method.
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employee (EmployeeID, EmployeeName, Salary)
VALUES
    (1, 'John Doe', 50000.00),
    (2, 'Jane Smith', 60000.00),
    (3, 'Bob Johnson', 55000.00),
    (4, 'Alice Brown', 62000.00),
    (5, 'David Lee', 57000.00),
    (6, 'Emily Davis', 64000.00),
    (7, 'Michael Wilson', 58000.00),
    (8, 'Sarah Johnson', 63000.00),
    (9, 'James Smith', 59000.00),
    (10, 'Olivia Taylor', 65000.00);

SELECT DISTINCT Salary
FROM Employee e1
WHERE 5 = (
    SELECT COUNT(DISTINCT Salary)
    FROM Employee e2
    WHERE e2.Salary >= e1.Salary
);


/*
Question 6. Use AdventureWorksDW2017 
1. Write a SQL query to retrieve the total sales amount for each year. 
Display the year and the corresponding total sales amount.
*/
SELECT YEAR(StartDate) AS Year, SUM(StandardCost) AS TotalSalesAmount
FROM DimProduct
GROUP BY YEAR(StartDate)
ORDER BY Year;

/*
2. Write a SQL query to find the number of employees hired in each 
year. Display the year and the count of employees hired in that year.
*/
Select hiredate,count(DimEmployee.EmployeeKey) as CountOfEmp from DimEmployee group by DimEmployee.HireDate;
/*
3. Write a SQL query to find the top 5 countries with the highest total 
sales amount for the year 2011
*/
select dg.EnglishCountryRegionName as Country, dr.YearOpened , sum(dr.AnnualSales) as AnnualSale from  DimReseller as dr inner join DimGeography as dg
on dr.GeographyKey= dg.GeographyKey
where dr.YearOpened = '2011'
group by dg.EnglishCountryRegionName, dr.YearOpened;
/*
2. Display the country name and the 
total sales amount, and consider only complete months (exclude any 
incomplete months).
*/
SELECT
    dg.EnglishCountryRegionName AS Country,
    SUM(dr.AnnualSales) AS AnnualSale
FROM
    DimReseller AS dr
INNER JOIN
    DimGeography AS dg
ON
    dr.GeographyKey = dg.GeographyKey
WHERE
    MONTH(dr.OrderMonth) is not null
GROUP BY
    dg.EnglishCountryRegionName

/*
4. Write a SQL query to find the top 5 customers who generated the 
highest total sales revenue in terms of the average sales per order for 
the year 2013.
*/
SELECT TOP 5
    dc.FirstName,
    SUM(fis.SalesAmount) AS TotalSalesRevenue,
    AVG(fis.SalesAmount) AS AvgSalesPerOrder
FROM
    DimCustomer AS dc
INNER JOIN
    FactInternetSales AS fis ON dc.CustomerKey = fis.CustomerKey
WHERE
    YEAR(fis.OrderDate) = 2013
GROUP BY
    dc.FirstName
ORDER BY
    AvgSalesPerOrder DESC;

/*
5. Write a SQL query to find the top 3 employees who achieved the 
highest total sales amount for the year 2011. 
*/


select distinct top 3 E.FirstName, fis.SalesAmount from DimEmployee as e
inner join FactInternetSales as fis
on fis.SalesTerritoryKey = e.SalesTerritoryKey
where year(fis.OrderDate)= 2011
order by fis.SalesAmount desc, e.FirstName;