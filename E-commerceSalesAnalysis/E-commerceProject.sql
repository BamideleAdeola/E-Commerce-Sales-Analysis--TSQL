
/*
SETTING UP AN E-COMMERCE PROJECT 
I will walk you through a structured way I created an E-commerce Sales Analysis project in SQL Server, 
focusing on database setup, data population, and practical queries to showcase various SQL functionalities. 
Each step will cover a specific part of the project and offer sample queries to demonstrate your proficiency.
*/

												------------------------------------
												--STEP 1: CREATE DATABASE AND TABLES
												------------------------------------

-- Database 
CREATE DATABASE EcommerceSales;
USE EcommerceSales;

-- Creating the different tables to store the data


-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    JoinDate DATE
);


-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2)
);

-- Create Order_Items table
CREATE TABLE Order_Items (
    OrderItemID INT PRIMARY KEY IDENTITY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    TotalPrice AS (Quantity * UnitPrice) PERSISTED
);

-- Create Inventory table
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES Products(ProductID),
    Stock INT
);



												------------------------------------
												-- STEP 2: INSERTING SAMPLE DATE
								--This is about populating the table with sample data to test
												------------------------------------
-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email, JoinDate)
VALUES
('bams', 'Delumba', 'bamsdelumba@example.com', '2022-01-15'),
('Jane', 'Smith', 'janesmith@example.com', '2022-03-20'),
('Alice', 'Johnson', 'alicej@example.com', '2022-05-10');

-- Insert sample data into Products
INSERT INTO Products (ProductName, Category, Price)
VALUES
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Accessories', 150.00),
('Smartphone', 'Electronics', 800.00);

-- Insert sample data into Inventory
INSERT INTO Inventory (ProductID, Stock)
VALUES
(1, 100), -- Laptop
(2, 200), -- Headphones
(3, 150); -- Smartphone

-- Insert sample data into Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2022-07-12', 1350.00),
(2, '2022-08-05', 150.00);

-- Insert sample data into Order_Items
INSERT INTO Order_Items (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 1200.00), -- 1 Laptop
(1, 2, 1, 150.00),  -- 1 Headphones
(2, 2, 1, 150.00);  -- 1 Headphones


												------------------------------------
												-- STEP 3: QUERY FOR ANALYSIS
									--Since the setup is complete. We can now query the tables
												------------------------------------
--1a. Total Revenue of orders Calculation
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders;

--1b.  Monthly Sales Summary -  Calculate sales amount per month
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalAmount) AS MonthlySales
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;


--2. Monthly Sales Growth
--  We can also calculate monthly sales and compare them to the previous month�s sales to find the growth rate.
SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS Month,
    SUM(TotalAmount) AS MonthlySales,
    LAG(SUM(TotalAmount)) OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM')) AS PreviousMonthSales,
    (SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM'))) * 100.0 /
        NULLIF(LAG(SUM(TotalAmount)) OVER (ORDER BY FORMAT(OrderDate, 'yyyy-MM')), 0) AS MonthlyGrowth
FROM Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY Month;

--3a. Top 5 Highest-Spending Customers
-- We can identify the top 1 customer based on their total spending.

SELECT TOP 5 
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, -- To have a fullname
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY TotalSpent DESC;

--3b. Customer Lifetime Value (LTV) - Calculate the total amount each customer has spent till date

SELECT 
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    SUM(O.TotalAmount) AS LifetimeValue
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY LifetimeValue DESC;


--4. Frequently Bought Together Products
-- We can analyze products frequently purchased together by finding products in the same order.

SELECT 
    A.ProductID AS Product1,
    B.ProductID AS Product2,
    COUNT(*) AS Frequency
FROM Order_Items A
JOIN Order_Items B ON A.OrderID = B.OrderID AND A.ProductID < B.ProductID
GROUP BY A.ProductID, B.ProductID
ORDER BY Frequency DESC;

--5a. Product Inventory Status
--Let's list products with low stock to manage inventory effectively with a case statement.

SELECT 
    P.ProductName,
    I.Stock,
    CASE 
        WHEN I.Stock < 20 THEN 'Low Stock'
        WHEN I.Stock BETWEEN 20 AND 50 THEN 'Moderate Stock'
        ELSE 'Sufficient Stock'
    END AS StockStatus
FROM Products P
JOIN Inventory I ON P.ProductID = I.ProductID;

--5b. Inventory Stock Analysis - Check products with low stock levels to manage reordering. 
-- Threshold = 200
SELECT 
    P.ProductName,
    I.Stock
FROM Inventory I
JOIN Products P ON I.ProductID = P.ProductID
WHERE I.Stock < 200
ORDER BY I.Stock ASC;

--6. Sales by Product Category - 
-- Calculate total sales for each product category to understand category performance.
SELECT 
    P.Category,
    SUM(OI.TotalPrice) AS CategorySales
FROM Order_Items OI
JOIN Products P ON OI.ProductID = P.ProductID
GROUP BY P.Category
ORDER BY CategorySales DESC;

-- 7. Average Order Value (AOV) by Month
-- Calculate the average order value per month.

SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    AVG(TotalAmount) AS AverageOrderValue
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

--8. New vs. Returning Customers by Month
-- Determine the count of new and returning customers each month.

SELECT 
    YEAR(O.OrderDate) AS Year,
    MONTH(O.OrderDate) AS Month,
    COUNT(DISTINCT CASE WHEN O.OrderDate = C.JoinDate THEN C.CustomerID END) AS NewCustomers,
    COUNT(DISTINCT CASE WHEN O.OrderDate > C.JoinDate THEN C.CustomerID END) AS ReturningCustomers
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate)
ORDER BY Year, Month;





												------------------------------------
												-- STEP 4: SOME ADVANCED SQL TECHNIQUES
											-- Creating a store procedures and Trigger
												------------------------------------
	--1. Creating a Stored Procedure for Monthly Sales Report
	--This stored procedure generates a monthly sales report for a given month and year.

CREATE PROCEDURE GetMonthlySalesReport
    @Year INT,
    @Month INT
AS
BEGIN
    SELECT 
        FORMAT(OrderDate, 'yyyy-MM') AS Month,
        SUM(TotalAmount) AS MonthlySales
    FROM Orders
    WHERE YEAR(OrderDate) = @Year AND MONTH(OrderDate) = @Month
    GROUP BY FORMAT(OrderDate, 'yyyy-MM');
END;

-- Let's Execute the store procedure for 2022 and July

EXEC GetMonthlySalesReport @Year = 2022, @Month = 7;
--OR
EXEC GetMonthlySalesReport 2022, 7;

	/*
	2. Setting Up a Trigger to Update Inventory on Order Creation
	This trigger updates the inventory when a new order is placed.
	*/

CREATE TRIGGER trg_UpdateInventory
ON Order_Items
AFTER INSERT
AS
BEGIN
    UPDATE Inventory
    SET Stock = Stock - i.Quantity
    FROM Inventory inv
    INNER JOIN Inserted i ON inv.ProductID = i.ProductID
END;


												------------------------------------
												-- STEP 5: DATABASE OPTIMIZATION 
												-------------------------------------
/*
1. Adding Indexes
Add indexes on foreign key columns to speed up joins and retrieval times.
*/

CREATE INDEX idx_CustomerID ON Orders(CustomerID);
CREATE INDEX idx_OrderID ON Order_Items(OrderID);


/*
2. Using Views for Frequent Reports
Create a view for commonly accessed data, like customer spending summaries.
*/
CREATE VIEW vw_CustomerSpending AS
SELECT 
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName;

--Querying the just created view
SELECT * FROM vw_CustomerSpending WHERE TotalSpent > 500;
