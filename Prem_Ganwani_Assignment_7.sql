/*
Database Management System - Assignments
Session 2
Assignment 1:
Write SQL scripts for the following:
1. Create all tables of eCommerce Application: StoreFront covered in 
Session 1 Assignments. (Write all CREATE commands in a SQL file 
and run that SQL File).
2. Write a command to display all the table names present in 
StoreFront.
*/
create database dbmsas2;
use dbmsas2;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    StockQuantity INT,
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    ParentCategoryID INT, -- For nesting categories
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE ProductCategories (
    ProductID INT,
    CategoryID INT,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY,
    ProductID INT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(255),
    UserType VARCHAR(50) CHECK (UserType IN ('Shopper', 'Administrator'))
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    UserID INT,
    OrderDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    OrderStatus VARCHAR(50) CHECK (OrderStatus IN ('Shipped', 'Cancelled', 'Returned')),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE ShippingAddresses (
    AddressID INT PRIMARY KEY,
    UserID INT,
    Address VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


INSERT INTO Products (ProductID, ProductName, StockQuantity) VALUES
(1, 'Product A', 10),
(2, 'Product B', 20),
(3, 'Product C', 15);

INSERT INTO Categories (CategoryID, CategoryName, ParentCategoryID) VALUES
(1, 'Electronics', NULL),
(2, 'Clothing', NULL),
(3, 'Mobile Phones', 1),
(4, 'Laptops', 1),
(5, 'Men''s Clothing', 2),
(6, 'Women''s Clothing', 2);

INSERT INTO ProductCategories (ProductID, CategoryID) VALUES
(1, 3),
(2, 4),
(1, 5),
(2, 6);

INSERT INTO ProductImages (ImageID, ProductID, ImageURL) VALUES
(1, 1, 'image_url_1'),
(2, 1, 'image_url_2'),
(3, 2, 'image_url_3');

INSERT INTO Users (UserID, UserName, UserType) VALUES
(1, 'Shopper1', 'Shopper'),
(2, 'Admin1', 'Administrator');

INSERT INTO Orders (OrderID, UserID, OrderDate) VALUES
(1, 1, '2023-10-13 08:00:00'),
(2, 1, '2023-10-14 09:30:00');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, OrderStatus) VALUES
(1, 1, 2, 'Shipped'),
(1, 2, 1, 'Cancelled'),
(2, 1, 3, 'Shipped');

INSERT INTO ShippingAddresses (AddressID, UserID, Address) VALUES
(1, 1, '123 Main St, City1'),
(2, 1, '456 Oak St, City2');


SELECT * FROM Products;
SELECT * FROM Categories;
SELECT * FROM ProductCategories;
SELECT * FROM ProductImages;
SELECT * FROM Users;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM ShippingAddresses;

-- Write a command to remove the Product table of the StoreFront database.


DROP TABLE Products;
-- Create the Product table again (SQL for creating the Products table has been provided earlier).
--same code

-- Assignment 2: Insert sample data, display product information

-- SQL for inserting sample data into tables (execute SQL file).

-- Display Id, Title, Category Title, and Price of active products, with recently added products at the top.
SELECT P.ProductID AS Id, P.ProductName AS Title, C.CategoryName AS CategoryTitle, P.Price
FROM Products P
JOIN ProductCategories PC ON P.ProductID = PC.ProductID
JOIN Categories C ON PC.CategoryID = C.CategoryID
WHERE P.IsActive = 1
ORDER BY P.DateAdded DESC;

-- Display the list of products that don't have any images.
SELECT P.ProductID AS Id, P.ProductName AS Title
FROM Products P
WHERE NOT EXISTS (SELECT 1 FROM ProductImages PI WHERE P.ProductID = PI.ProductID);

-- Display all Id, Title, and Parent Category Title for all the Categories listed, sorted by Parent Category Title and then Category Title.
WITH CategoryHierarchy AS (
    SELECT C.CategoryID AS Id, C.CategoryName AS Title, C.ParentCategoryID,
           COALESCE(P.CategoryName, 'Top Category') AS ParentCategoryTitle
    FROM Categories C
    LEFT JOIN Categories P ON C.ParentCategoryID = P.CategoryID
)
SELECT Id, Title, ParentCategoryTitle
FROM CategoryHierarchy
ORDER BY ParentCategoryTitle, Title;

-- Display Id, Title, Parent Category Title of all the leaf Categories (categories that are not parents of any other category).
WITH LeafCategories AS (
    SELECT C.CategoryID AS Id, C.CategoryName AS Title, C.ParentCategoryID,
           P.CategoryName AS ParentCategoryTitle
    FROM Categories C
    LEFT JOIN Categories P ON C.CategoryID = P.ParentCategoryID
    WHERE P.CategoryID IS NULL
)
SELECT Id, Title, ParentCategoryTitle
FROM LeafCategories;

-- Display Product Title, Price, and Description for products that fall into the "Mobile" category.
SELECT P.ProductName AS Title, P.Price, P.Description
FROM Products P
JOIN ProductCategories PC ON P.ProductID = PC.ProductID
JOIN Categories C ON PC.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Mobile';

-- Display the list of products whose Quantity on hand (Inventory) is under 50.
SELECT P.ProductName AS Title, P.StockQuantity AS Inventory
FROM Products P
WHERE P.StockQuantity < 50;




-- Assignment 3: Display order information, shopper information, and order items

-- Display the recent 50 orders (Id, Order Date, Order Total).
SELECT TOP 50 OrderID AS Id, OrderDate, 
    (SELECT SUM(Quantity * Price) FROM OrderItems WHERE OrderItems.OrderID = Orders.OrderID) AS OrderTotal
FROM Orders
ORDER BY OrderDate DESC;

-- Display the 10 most expensive orders.
SELECT TOP 10 OrderID AS Id, OrderDate, 
    (SELECT SUM(Quantity * Price) FROM OrderItems WHERE OrderItems.OrderID = Orders.OrderID) AS OrderTotal
FROM Orders
ORDER BY OrderTotal DESC;

-- Display all orders that are more than 10 days old and have one or more items that are not shipped.
SELECT O.OrderID AS Id, O.OrderDate
FROM Orders O
WHERE DATEDIFF(DAY, O.OrderDate, GETDATE()) > 10
AND O.OrderID IN (
    SELECT OI.OrderID
    FROM OrderItems OI
    WHERE OI.OrderStatus <> 'Shipped'
);

-- Display a list of shoppers who haven't ordered anything since last month.
SELECT U.UserID AS ShopperID, U.UserName AS ShopperName
FROM Users U
WHERE U.UserType = 'Shopper'
AND U.UserID NOT IN (
    SELECT DISTINCT O.UserID
    FROM Orders O
    WHERE DATEDIFF(MONTH, O.OrderDate, GETDATE()) = 1
);

-- Display a list of shoppers along with the orders placed by them in the last 15 days.
SELECT U.UserID AS ShopperID, U.UserName AS ShopperName, O.OrderID AS OrderID, O.OrderDate
FROM Users U
JOIN Orders O ON U.UserID = O.UserID
WHERE U.UserType = 'Shopper'
AND DATEDIFF(DAY, O.OrderDate, GETDATE()) <= 15;

-- Display a list of order items that are in the "shipped" state for a particular Order ID (e.g., 1020).
SELECT OI.ProductID, P.ProductName, OI.Quantity, OI.OrderStatus
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
WHERE OI.OrderID = 1020 AND OI.OrderStatus = 'Shipped';

-- Display a list of order items along with the order placed date for products with prices between Rs 20 and Rs 50.
SELECT OI.ProductID, P.ProductName, O.OrderDate AS OrderPlacedDate, P.Price
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
JOIN Orders O ON OI.OrderID = O.OrderID
WHERE P.Price BETWEEN 20 AND 50;
