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
  - JoinDate DATE: join date

**2. Products Table**
- Description: Holds information about each product in the catalog._
- Columns:
  - ProductID (INT, Primary Key): Unique identifier for each product.
  - ProductName (NVARCHAR): Name of the product.
  - Category (NVARCHAR): Product category for classification.
  - UnitPrice (DECIMAL): Price of a single unit of the product.

**3. Products Table**
- Description: Holds information about each product in the catalog._
- Columns:
  - ProductID (INT, Primary Key): Unique identifier for each product.
  - ProductName (NVARCHAR): Name of the product.
  - Category (NVARCHAR): Product category for classification.
  - UnitPrice (DECIMAL): Price of a single unit of the product.

Orders Table

Description: Records order-level information, such as order date and total amount.
Columns:
OrderID (INT, Primary Key): Unique identifier for each order.
CustomerID (INT, Foreign Key): Links to Customers.CustomerID.
OrderDate (DATE): Date the order was placed.
TotalAmount (DECIMAL): Total amount for the order.



