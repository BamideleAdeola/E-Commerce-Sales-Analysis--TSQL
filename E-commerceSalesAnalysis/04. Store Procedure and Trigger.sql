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
