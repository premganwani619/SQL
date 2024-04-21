--Day-2 Assignment Questions
create database day2;
use day2;
go
CREATE TABLE order_table(ord_no INT PRIMARY KEY , purch_amt FLoat not null, ord_date DATE not null , customer_id INT not null, salesman_id INT not null);

INSERT INTO order_table(ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES 
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6,'2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);
--1. write a SQL query to calculate total purchase amount of all orders. 
--Return total purchase amount.
select sum(purch_amt) as purchase_ammount from order_table;
--2. write a SQL query that counts the number of unique salespeople. 
--Return number of salespeople.
Select count (distinct salesman_id) as Employee_count from order_table;
select distinct salesman_id from order_table;
--3. List Of Customers who have spent more than 1000 rupees.
select salesman_id, purch_amt from order_table where purch_amt>1000.0;
--4. List the total revenue generated on a single date.
Select sum(purch_amt) as revenue, ord_date from order_table group by ord_date;
--5. List of the salesman who have done maximum and minimum sales.


Select top 1 sum(purch_amt) as purchase , salesman_id from order_table group by salesman_id order by purchase asc
Select top 1 sum(purch_amt) as purchase , salesman_id from order_table group by salesman_id order by purchase desc;



-- Solve these Following Queries by Using Adventure Works Database.
use AdventureWorksLT2017;
--1. List of all customers.
Select * from SalesLT.Customer;
--2. list of all customers where company name ending in N.
Select * from SalesLT.Customer where CompanyName like('%N');
--3. list of all customers who live in Berlin or London.
 Select sc.*, sa.City from SalesLT.Customer as sc inner join SalesLT.CustomerAddress as sca
on sc.CustomerID = sca.CustomerID inner join
SalesLT.Address as sa on sa.AddressID = sca.AddressID
where sa.City IN ('Berlin' , 'London');
--4. list of all customers who live in UK or USA.
 Select sc.*, sa.CountryRegion from SalesLT.Customer as sc inner join SalesLT.CustomerAddress as sca
on sc.CustomerID = sca.CustomerID inner join
SalesLT.Address as sa on sa.AddressID = sca.AddressID
where sa.CountryRegion IN ('United Kingdom' , 'United States');
--5. list of all products sorted by product name.
Select * from SalesLT.Product order by Name;
--6. list of all products where product name starts with an A
Select * from SalesLT.Product where Name like('A%');
--7. List of customers who placed an order.
SELECT sc.*, sp.name, sp.ProductID
FROM SalesLT.SalesOrderHeader AS soh
inner JOIN SalesLT.Customer AS sc
ON sc.CustomerID = soh.CustomerID
inner join SalesLT.SalesOrderDetail as sod
on sod.SalesOrderID = soh.SalesOrderID
inner join SalesLT.Product as sp
on sp.ProductID = sod.ProductID;
--8 list of Customers who live in London and have bought chain.
Select SC.CustomerID, SC.FirstName, SC.MiddleName, SC.LastName, SA.City, SP.Name as ProductName
from SalesLT.Customer as SC
inner join SalesLT.CustomerAddress as SCA on SC.CustomerID= SCA.CustomerID
inner join SalesLT.Address as SA on SCA.AddressID = SA.AddressID
INNER JOIN SalesLT.SalesOrderHeader AS SOH ON SOH.CustomerID = SC.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN SalesLT.Product AS SP ON sod.ProductID = sp.ProductID
where SA.City='London' and SP.Name='chain'

--9. List of customers who never place an order.
SELECT sc.*
FROM SalesLT.Customer AS sc
LEFT JOIN SalesLT.SalesOrderHeader AS soh ON sc.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;
--10. List of customers who ordered Tofu.
SELECT sc.*
FROM SalesLT.Customer AS sc
INNER JOIN SalesLT.CustomerAddress AS sca ON sc.CustomerID = sca.CustomerID
INNER JOIN SalesLT.Address AS sa ON sa.AddressID = sca.AddressID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID = sc.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN SalesLT.Product AS sp ON sod.ProductID = sp.ProductID
INNER JOIN SalesLT.ProductCategory AS spc ON sp.ProductCategoryID = spc.ParentProductCategoryID
WHERE spc.Name = 'tofu';
--11. Details of first order of the system
SELECT TOP 1 *
FROM SalesLT.SalesOrderDetail
ORDER BY SalesOrderDetailID;
--12. Find the details of the most expensive order date.
SELECT TOP 1 o.OrderDate,
    SUM(o.TotalDue) AS TotalOrderAmount
FROM SalesLT.SalesOrderHeader AS o
GROUP BY o.OrderDate
ORDER BY TotalOrderAmount DESC;
--13. For each order get the OrderID and Average quantity of items in that 
SELECT soh.SalesOrderID AS OrderID,
    AVG(sod.OrderQty) AS AverageQuantity
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID;
--14. For each order get the orderID, minimum quantity and maximum 
--quantity for that order
SELECT soh.SalesOrderID AS OrderID,
MIN(sod.OrderQty) AS MinimumQuantity,
MAX(sod.OrderQty) AS MaximumQuantity
from SalesLT.SalesOrderHeader as soh
inner join SalesLT.SalesOrderDetail as sod on  soh.SalesOrderID = sod.SalesOrderID
group by soh.SalesOrderID;
-- 15. Get a list of all managers and the total number of employees who 
--report to them.
CREATE TABLE EmployeeTable (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    ManagerID INT
);
INSERT INTO EmployeeTable (EmployeeID, Name, ManagerID)
VALUES
    (1, 'Prem Ganwani', NULL),          
    (2, 'Nimesh Parik', 1),           
    (3, 'Janvi jain', 1),         
    (4, 'Jayant', 2),         
    (5, 'Rohit Bansal', 2),        
    (6, 'Rajeshwar', 3),    
    (7, 'Shashank', 3);      

SELECT
    manager.EmployeeID AS ManagerID,
    manager.Name AS ManagerName,
    COUNT(employee.EmployeeID) AS NumberOfEmployees
FROM EmployeeTable AS manager
LEFT JOIN EmployeeTable AS employee ON manager.EmployeeID = employee.ManagerID
GROUP BY manager.EmployeeID, manager.Name;

--16. Get the OrderID and the total quantity for each order that has a total 
--quantity of greater than 300

SELECT soh.SalesOrderID AS OrderID,
    SUM(sod.OrderQty) AS TotalQuantity
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID
HAVING SUM(sod.OrderQty) > 300;
--17. list of all orders placed on or after 1996/12/31
Select * from SalesLT.SalesOrderHeader where OrderDate >'1996/12/31';
--18. list of all orders shipped to Canada


--Day-2 Assignment Questions
create database day2;
use day2;
go
CREATE TABLE order_table(ord_no INT PRIMARY KEY , purch_amt FLoat not null, ord_date DATE not null , customer_id INT not null, salesman_id INT not null);

INSERT INTO order_table(ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES 
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6,'2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);
--1. write a SQL query to calculate total purchase amount of all orders. 
--Return total purchase amount.
select sum(purch_amt) as purchase_ammount from order_table;
--2. write a SQL query that counts the number of unique salespeople. 
--Return number of salespeople.
Select count (distinct salesman_id) as Employee_count from order_table;
select distinct salesman_id from order_table;
--3. List Of Customers who have spent more than 1000 rupees.
select salesman_id, purch_amt from order_table where purch_amt>1000.0;
--4. List the total revenue generated on a single date.
Select sum(purch_amt) as revenue, ord_date from order_table group by ord_date;
--5. List of the salesman who have done maximum and minimum sales.


Select top 1 sum(purch_amt) as purchase , salesman_id from order_table group by salesman_id order by purchase asc
Select top 1 sum(purch_amt) as purchase , salesman_id from order_table group by salesman_id order by purchase desc;



-- Solve these Following Queries by Using Adventure Works Database.
use AdventureWorksLT2017;
--1. List of all customers.
Select * from SalesLT.Customer;
--2. list of all customers where company name ending in N.
Select * from SalesLT.Customer where CompanyName like('%N');
--3. list of all customers who live in Berlin or London.
 Select sc.*, sa.City from SalesLT.Customer as sc inner join SalesLT.CustomerAddress as sca
on sc.CustomerID = sca.CustomerID inner join
SalesLT.Address as sa on sa.AddressID = sca.AddressID
where sa.City IN ('Berlin' , 'London');
--4. list of all customers who live in UK or USA.
 Select sc.*, sa.CountryRegion from SalesLT.Customer as sc inner join SalesLT.CustomerAddress as sca
on sc.CustomerID = sca.CustomerID inner join
SalesLT.Address as sa on sa.AddressID = sca.AddressID
where sa.CountryRegion IN ('United Kingdom' , 'United States');
--5. list of all products sorted by product name.
Select * from SalesLT.Product order by Name;
--6. list of all products where product name starts with an A
Select * from SalesLT.Product where Name like('A%');
--7. List of customers who placed an order.
SELECT sc.*, sp.name, sp.ProductID
FROM SalesLT.SalesOrderHeader AS soh
inner JOIN SalesLT.Customer AS sc
ON sc.CustomerID = soh.CustomerID
inner join SalesLT.SalesOrderDetail as sod
on sod.SalesOrderID = soh.SalesOrderID
inner join SalesLT.Product as sp
on sp.ProductID = sod.ProductID;
--8 list of Customers who live in London and have bought chain.
SELECT SC.CustomerID, SC.FirstName, SC.MiddleName, SC.LastName, SA.City, SP.Name AS ProductName
FROM SalesLT.Customer AS SC
INNER JOIN SalesLT.CustomerAddress AS SCA ON SC.CustomerID = SCA.CustomerID
INNER JOIN SalesLT.Address AS SA ON SCA.AddressID = SA.AddressID
INNER JOIN SalesLT.SalesOrderHeader AS SOH ON SOH.CustomerID = SC.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN SalesLT.Product AS SP ON SOD.ProductID = SP.ProductID
WHERE SA.City = 'London'
  AND SP.Name = 'chain';
--9. List of customers who never place an order.
SELECT sc.*
FROM SalesLT.Customer AS sc
LEFT JOIN SalesLT.SalesOrderHeader AS soh ON sc.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;
--10. List of customers who ordered Tofu.
Select sc.*
from SalesLT.Customer as SC
inner join SalesLT.CustomerAddress as SCA on SC.CustomerID= SCA.CustomerID
inner join SalesLT.Address as SA on SCA.AddressID = SA.AddressID
INNER JOIN SalesLT.SalesOrderHeader AS SOH ON SOH.CustomerID = SC.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN SalesLT.Product AS SP ON sod.ProductID = sp.ProductID
where SP.Name='tofu'
--11. Details of first order of the system
SELECT TOP 1 *
FROM SalesLT.SalesOrderDetail
ORDER BY SalesOrderDetailID;
--12. Find the details of the most expensive order date.
SELECT TOP 1 SOD.OrderDate,
    SUM(SOD.TotalDue) AS TotalOrderAmount
FROM SalesLT.SalesOrderHeader AS SOD inner join
SalesLT.SalesOrderHeader as soh
on soh.SalesOrderID = sod.SalesOrderID
GROUP BY SOD.OrderDate
ORDER BY TotalOrderAmount DESC;
--13. For each order get the OrderID and Average quantity of items in that 
SELECT soh.SalesOrderID AS OrderID,
    AVG(sod.OrderQty) AS AverageQuantity
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID;
--14. For each order get the orderID, minimum quantity and maximum 
--quantity for that order
SELECT sod.SalesOrderID AS OrderID,
MIN(sod.OrderQty) AS MinimumQuantity,
MAX(sod.OrderQty) AS MaximumQuantity
from SalesLT.SalesOrderDetail as sod
group by SalesOrderID;
-- 15. Get a list of all managers and the total number of employees who 
--report to them.
CREATE TABLE EmployeeTable (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    ManagerID INT
);
INSERT INTO EmployeeTable (EmployeeID, Name, ManagerID)
VALUES
    (1, 'Prem Ganwani', NULL),          
    (2, 'Nimesh Parik', 1),           
    (3, 'Janvi jain', 1),         
    (4, 'Jayant', 2),         
    (5, 'Rohit Bansal', 2),        
    (6, 'Rajeshwar', 3),    
    (7, 'Shashank', 3);      

SELECT
    manager.EmployeeID AS ManagerID,
    manager.Name AS ManagerName,
    COUNT(employee.EmployeeID) AS NumberOfEmployees
FROM EmployeeTable AS manager
LEFT JOIN EmployeeTable AS employee ON manager.EmployeeID = employee.ManagerID
GROUP BY manager.EmployeeID, manager.Name;
--16. Get the OrderID and the total quantity for each order that has a total 
--quantity of greater than 300

SELECT sod.SalesOrderID AS OrderID,
    SUM(sod.OrderQty) AS TotalQuantity
FROM SalesLT.SalesOrderDetail AS sod
GROUP BY sod.SalesOrderID
HAVING SUM(sod.OrderQty) > 300;


--17. list of all orders placed on or after 1996/12/31
Select * from SalesLT.SalesOrderHeader where OrderDate >'1996/12/31';
--18. list of all orders shipped to Canada
Select * from SalesLT.SalesOrderHeader as  soh
inner join
SalesLT.CustomerAddress as sca  on soh.CustomerID = sca.CustomerID
inner join SalesLT.SalesOrderDetail as sod on sod.SalesOrderID = soh.SalesOrderID
inner join SalesLT.Address as sa on sa.AddressID = sca.AddressID
WHERE sa.CountryRegion = 'Canada';
--19. list of all orders with order total > 200
Select * from SalesLT.SalesOrderDetail as sod
inner join SalesLT.SalesOrderHeader as soh
on Sod.SalesOrderID= soh.SalesOrderID
where sod.LineTotal >200;
--20. List of countries and sales made in each country
select sum(SubTotal) as Total_Sales, sa.CountryRegion from SalesLT.SalesOrderHeader as soh
inner join SalesLT.Address as sa  on sa.AddressID = soh.ShipToAddressID
group by CountryRegion;