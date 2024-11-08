# E-Commerce-Sales-Analysis-SQL

# Project Objective 
This project aimed to create a SQL-based analytical solution for an e-commerce dataset. The data is randomly generated data to bring out insights  into sales performance, customer behavior, and product trends, which will in turn enable data-driven decisions for a company 

# Database Schema
**Table Overview:**

**1. Customer Table**
- Description: Contains customer data for tracking orders and purchase patterns._
- Columns:
  - CustomerID (INT, Primary Key): Unique identifier for each customer.
  - FirstName (NVARCHAR): First name of the customer.
  - LastName (NVARCHAR): Last name of the customer.
  - Email (NVARCHAR): Contact email for the customer.
  - JoinDate DATE: The date the customer registered

**2. Products Table**
- Description: Holds information about each product in the catalog._
- Columns:
  - ProductID (INT, Primary Key): Unique identifier for each product.
  - ProductName (NVARCHAR): Name of the product.
  - Category (NVARCHAR): Product category for classification.
  - UnitPrice (DECIMAL): Price of a single unit of the product.

**3. Products Table**
- Description: Records order-level information, such as order date and total amount.
- Columns:
  - OrderID (INT, Primary Key): Unique identifier for each order.
  - CustomerID (INT, Foreign Key): Links to Customers.CustomerID.
  - OrderDate (DATE): The date the order was placed.
  - TotalAmount (DECIMAL): Total amount for the order.

**4. Order_Items Table**
- Description: Stores item-level details for each order.
- Columns:
  - OrderItemID (INT, Primary Key): Unique identifier for each order item.
  - OrderID (INT, Foreign Key): Links to Orders.OrderID.
  - ProductID (INT, Foreign Key): Links to Products.ProductID.
  - Quantity (INT): Quantity of the product in this order item.
  - UnitPrice (DECIMAL): Price per unit at the time of order.
  - TotalPrice (DECIMAL): Calculated as Quantity * UnitPrice to get the item total.


 **5. Inventory Table**
- Description: Tracks available stock for each product to manage inventory.
- Columns:
  - ProductID (INT, Primary Key, Foreign Key): Links to Products.ProductID.
  - Stock (INT): Available stock for each product.

<img width="410" alt="image" src="https://github.com/user-attachments/assets/c85f4dc6-a4cf-4a10-80fa-434b982b4ee6">

# **Appendix**
  - **Data Integrity:** Foreign key constraints enforce referential integrity across tables. Hence, CustomerID in Orders and Order_Items ensures orders and items are linked to valid customers and orders.
  - **Indexes:** Adding indexes on frequently joined or filtered columns (e.g., ProductID, CustomerID, OrderDate) can optimize performance, especially in large datasets.
  - **Stored Procedures and Views (Optional):** While this is optional, I have included stored procedures to automate frequent reports (e.g., monthly sales, low-stock alerts) and created  views that consolidate customer and order details for quick retrieval in reports or dashboards.
