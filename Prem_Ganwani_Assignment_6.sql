--Database Management System -
--Assignments
--Session 1
/*

Participating Entities:

Product
Category
Image
User (Shopper and Admin)
Order
Shipping Address
Order Item

Relations:
Product to Category (many-to-many)
Product to Image (one-to-many)
User to Order (one-to-many)
Order to Product (many-to-many)
Product to Order Item (one-to-many)
Order to Shipping Address (one-to-ONE)

Key Attributes:
Product: ProductID (Primary Key)
Category: CategoryID (Primary Key)
Image: ImageID (Primary Key)
User: UserID (Primary Key)
Order: OrderID (Primary Key)
Shipping Address: AddressID (Primary Key)
Order Item: OrderItemID (Primary Key)

E-R Diagram (Entity-Relationship Diagram):

+-----------+    +-----------+
|  Product  |    |  Category |
+-----------+    +-----------+
     |               |
     |               |
     +---------------+
           |
           |
     +-----------+
     |  Image    |
     +-----------+
           |
           |
+-----------+     +---------+
|   User    |     |  Order  |
+-----------+     +---------+
    |                 |
    |                 |
    +-----------------+
            |
            |
     +-------------+
     | Ship. Addr. |
     +-------------+
            |
            |
     +------------+
     | Order Item |
     +------------+
*/

create database dbms;
use dbms;

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


/*
Assignment 2:

Normalization techniques are used to organize and structure a relational database to reduce redundancy and improve data integrity. Each level of normalization (e.g., 1NF, 2NF, 3NF) has specific rules and requirements for organizing data.

Example of 1NF 
Suppose you have a table named Orders with the following attributes: OrderID, CustomerName, Product1, Product2, Product3, and so on.
In this case, the table violates 1NF because it allows multiple values in a single column (e.g., Product1, Product2). To bring it into 1NF, you can create a new table for order items and link them to the Orders table using the OrderID.

Orders Table:
| OrderID | CustomerName | Product1 | Product2 | Product3 |
|---------|--------------|----------|----------|----------|
| 1       | Alice        | Apples   | Bananas  | Oranges  |
| 2       | Bob          | Grapes   | Apples   |          |

Orders Table (in 1NF):
| OrderID | CustomerName |
|---------|--------------|
| 1       | Alice        |
| 2       | Bob          |

OrderItems Table:
| OrderID | Product   |
|---------|-----------|
| 1       | Apples    |
| 1       | Bananas   |
| 1       | Oranges   |
| 2       | Grapes    |
| 2       | Apples    |



Example of 2NF
Suppose you have a table named OrderDetails with attributes: OrderID, ProductID, ProductName, and Quantity.

In this case, the table may have redundant data if multiple orders include the same product. To bring it into 2NF, you can create a separate Products table with ProductID and ProductName, and link it to the OrderDetails table using ProductID.

OrderDetails Table:
| OrderID | ProductID | ProductName | Quantity |
|---------|-----------|-------------|----------|
| 1       | 101       | Apples      | 5        |
| 1       | 102       | Bananas     | 3        |
| 2       | 103       | Grapes      | 2        |

OrderDetails Table (in 2NF):
| OrderID | ProductID | Quantity |
|---------|-----------|----------|
| 1       | 101       | 5        |
| 1       | 102       | 3        |
| 2       | 103       | 2        |

Products Table:
| ProductID | ProductName |
|-----------|-------------|
| 101       | Apples      |
| 102       | Bananas     |
| 103       | Grapes      |

*/

-- Create an initial table structure for Orders (not normalized)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product1 NVARCHAR(50),
    Product2 NVARCHAR(50),
    Product3 NVARCHAR(50)
);

INSERT INTO Orders (OrderID, CustomerName, Product1, Product2, Product3)
VALUES
    (1, 'Alice', 'Apples', 'Bananas', 'Oranges'),
    (2, 'Bob', 'Grapes', 'Apples', NULL);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    Product NVARCHAR(50)
);

INSERT INTO Orders (OrderID, CustomerName)
VALUES
    (1, 'Alice'),
    (2, 'Bob');

INSERT INTO OrderItems (OrderID, Product)
VALUES
    (1, 'Apples'),
    (1, 'Bananas'),
    (1, 'Oranges'),
    (2, 'Grapes'),
    (2, 'Apples');
CREATE DATABASE DBMS2;
USE dbms2;
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, ProductID, ProductName, Quantity)
VALUES
    (1, 101, 'Apples', 5),
    (1, 102, 'Bananas', 3),
    (2, 103, 'Grapes', 2);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50)
);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
    (1, 101, 5),
    (1, 102, 3),
    (2, 103, 2);

INSERT INTO Products (ProductID, ProductName)
VALUES
    (101, 'Apples'),
    (102, 'Bananas'),
    (103, 'Grapes');
