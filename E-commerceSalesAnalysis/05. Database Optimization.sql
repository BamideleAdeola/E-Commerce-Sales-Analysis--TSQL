
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
