--Practice Question
--Que 1.Create a view named vwSalesData that includes the following columns:
--OrderDate
--ProductCategory
--SalesAmount
--Quantity
create database Practice;
use practice;
go

CREATE TABLE tblSalesData (
    OrderDate DATE,
    ProductCategory VARCHAR(20),
    SalesAmount DECIMAL(10, 2),
    Quantity INT,
	ProductRegion nvarchar(20),
);
INSERT INTO tblSalesData (OrderDate, ProductCategory, SalesAmount, Quantity,ProductRegion)
VALUES
    ('2023-10-01', 'Electronics', 1000.50, 5,'India'),
    ('2023-10-02', 'Clothing', 500.25, 3,'India'),
    ('2023-10-03', 'Electronics', 750.75, 2,'US'),
    ('2023-10-04', 'Books', 300.00, 4,'UK'),
	('2023-10-04', 'Electronics', 300.00, 4,'India');

CREATE view vwSalesData as
Select OrderDate,ProductCategory,SalesAmount,Quantity,ProductREGION from tblSalesData;
go


Select * from vwsalesdata;
--Que 2. Create a stored procedure named spGetSalesSummary that takes two 
--parameters: @Region (nvarchar) and @Category (nvarchar). This procedure 
--should do the following:
--2.1) Use the vwSalesData view to retrieve the sales data for the specified 
--region and product category.
--2.2Calculate the total sales amount and total quantity sold for each 
--combination of OrderDate, ProductCategory.
--2.3)Insert the results into a temporary table named 
    CREATE TABLE TempSalesSummary (
        OrderDate DATE,
        ProductCategory NVARCHAR(255),
        TotalSalesAmount DECIMAL(10, 2),
        TotalQuantitySold INT
    );
create proc spGetSalesSummary
@Region nvarchar(20),
@Category nvarchar(20)
as 
begin

INSERT INTO TempSalesSummary (OrderDate,ProductCategory, TotalSalesAmount, TotalQuantitySold)
	SELECT 
		OrderDate,
        ProductCategory,
        SUM(SalesAmount) AS TotalSalesAmount,
        SUM(Quantity) AS TotalQuantitySold
		from vwSalesData
		where productregion= @Region and ProductCategory = @Category
		group by orderdate , Productcategory;
		SELECT * FROM TempSalesSummary;

end;
EXEC spGetSalesSummary @Region = 'India', @Category = 'Electronics';


--Que 3. Create a user-defined function named udfGetAverageSales that takes no 
--parameters. This function should do the following:
--Calculate the average sales amount based on the data in the 
--TempSalesSummary temporary table.
--Return the average sales amount.
CREATE FUNCTION udfGetAverageSales()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AvgSales DECIMAL(10, 2);

    SELECT @AvgSales = AVG(TotalSalesAmount)
    FROM TempSalesSummary;

    RETURN @AvgSales;
END;

DECLARE @AverageSales DECIMAL(10, 2);

SET @AverageSales = dbo.udfGetAverageSales();

SELECT @AverageSales AS AverageSales;



--Cannot access temporary tables from within a function.
--so i used normal table


--Que 4. Finally, execute the stored procedure spGetSalesSummary with the 
--parameters 'Northwest' for region and 'Bikes' for product category. Then, call the 
--user-defined function udfGetAverageSales to retrieve the average sales 
--amount.
    CREATE TABLE TempSalesSummary (
        OrderDate DATE,
        ProductCategory NVARCHAR(255),
        TotalSalesAmount DECIMAL(10, 2),
        TotalQuantitySold INT
    );


DECLARE @Region NVARCHAR(20) = 'Northwest';
DECLARE @Category NVARCHAR(20) = 'Bikes';

INSERT INTO TempSalesSummary
EXEC spGetSalesSummary @Region, @Category;

DECLARE @AverageSales DECIMAL(10, 2);
SET @AverageSales = dbo.udfGetAverageSales();

SELECT 'Average Sales Amount' AS Description, @AverageSales AS AverageSales;

DROP TABLE TempSalesSummary;