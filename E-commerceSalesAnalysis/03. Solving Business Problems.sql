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
