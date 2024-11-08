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