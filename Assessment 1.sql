CREATE DATABASE ORGDIG;
USE ORGDIG;
CREATE TABLE CustomersDIG (
CustomerID INT Primary key,
Name VARCHAR (255),
Email Varchar (255),
JoinDate DATE
);
Create table ProductsDIG (
ProductID Int Primary key,
Name Varchar (255),
Category varchar (255),
Price Decimal (10,2)
);
CREATE Table OrdersDIG (
OrderID INT Primary key,
CustomerID Int,
OrderDate Date,
TotalAmount Decimal (10,2),
Foreign Key (CustomerID) References Customers(CustomerID)
);
Create Table OrderDetailsDIG (
OrderDetailID Int Primary Key,
OrderID Int,
ProductID Int,
Quantity Int,
Priceperunit Decimal (10,2),
Foreign key (OrderID) References Orders(OrderID),
Foreign Key (ProductID) References Products(ProductID)
);
INSERT INTO CustomersDIG (CustomerID, Name, Email, JoinDate) VALUES
(1, 'Vineetha V', 'vineethav@gmail.com', '2023-01-10'),
(2, 'Rajeev S', 'Rajeevs@gmail.com', '2023-02-10'),
(3, 'Rajiv V', 'rajivv@gmail.com', '2023-03-10'),
(4, 'Rajni K', 'rajnik@gmail.com', '2023-04-10'),
(5, 'Jaya M', 'jayam@gmail.com', '2023-05-10'),
(6, 'Jaya J', 'jayaj@gmail.com', '2023-06-10'),
(7, 'Vineetha K', 'vineethak@gmail.com', '2023-07-10'),
(8, 'Vineetha P', 'vineethap@gmail.com', '2023-08-10'),
(9, 'Vineetha N', 'vineethan@gmail.com', '2023-09-10'),
(10, 'Vineetha S', 'vineethas@gmail.com', '2023-10-10');

INSERT INTO ProductDIG (ProductID, Name, Category, Price) VALUES
(1, 'Laptop', 'electronics', 50000),
(2, 'Mouse', 'accessories', 1000),
(3, 'Smartphone', 'electronics', 1500000),
(4, 'Laptop Bag', 'accessories', 1500),
(5, 'Kettle', 'electronics', 4599),
(6, 'Headphone', 'accessories', 700),
(7, 'Mobile cover', 'accessories', 3500),
(8, 'Ipod', 'electronics', 5000),
(9, 'Ipad', 'electronics', 70000),
(10, 'Laptop cover', 'accessories', 2599);

INSERT INTO OrderDIG (OrderID, CustomerID, Orderdate, Totalamount) VALUES
(1, 1, '2023-10-10', 50000),
(2, 2, '2023-10-11', 1000),
(3, 3, '2023-10-12', 1500000),
(4, 4, '2023-10-10', 1500),
(5, 5, '2023-10-11', 4599),
(6, 6, '2023-10-12', 700),
(7, 7, '2023-10-10', 3500),
(8, 8, '2023-10-10', 5000),
(9, 9, '2023-10-11', 70000),
(10, 10, '2023-10-12', 2599);

INSERT INTO OrderDetailsDIG (OrderDetailsID, OrderID, ProductID, Quantity, Priceperunit) VALUES
(1, 1, 1, 4, 40999),
(2, 2, 1, 5, 5999),
(3, 3, 3, 2, 99999),
(4, 4, 2, 4, 999),
(5, 5, 5, 7, 4599),
(6, 6, 7, 5, 2669),
(7, 7, 9, 5, 67999),
(8, 8, 2, 2, 4799),
(9, 9, 1, 3, 40999),
(10, 10, 4, 8, 1499);

#list of all customers 
SELECT * FROM CustomersDIG;
#Product where all catergories is Electronics
SELECT * FROM ProductsDIG WHERE Category = 'electronics';
#Find te total number of order placed
SELECT COUNT(*) AS TotalOrders FROM OrdersDIG;
#Display the details of most recent order
SELECT * FROM OrdersDIG ORDER BY OrderDate DESC LIMIT 1;
#List all products along with the names of the customers who ordered them
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    c.Name AS CustomerName
FROM 
    ProductsDIG p
JOIN 
    OrderDetailsDIG od ON p.ProductID = od.ProductID
JOIN 
    OrdersDIG o ON od.OrderID = o.OrderID
JOIN 
    CustomersDIG c ON o.CustomerID = c.CustomerID;
    
#Show orders that include more than one product
SELECT 
    o.OrderID,
    COUNT(od.ProductID) AS NumberOfProducts
FROM 
    OrdersDIG o
JOIN 
    OrderDetailsDIG od ON o.OrderID = od.OrderID
GROUP BY 
    o.OrderID
HAVING 
    NumberOfProducts > 1;
#Find the total sales amount for each customer
SELECT 
    c.CustomerID,
    c.Name AS CustomerName,
    SUM(o.TotalAmount) AS TotalSalesAmount
FROM 
    CustomersDIG c
JOIN 
    OrdersDIG o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.Name;
    
# Calculate the total revenue generated by each product category:
SELECT 
    p.Category,
    SUM(od.Quantity * od.PricePerUnit) AS TotalRevenue
FROM 
    ProductsDIG p
JOIN 
    OrderDetailsDIG od ON p.ProductID = od.ProductID
GROUP BY 
    p.Category;
    
#3.2. Determine the average order value:
SELECT 
    AVG(TotalAmount) AS AverageOrderValue
FROM 
    OrdersDIG;
    
#3.3. Find the month with the highest number of orders
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    COUNT(*) AS NumberOfOrders
FROM 
    OrdersDIG
GROUP BY 
    Month
ORDER BY 
    NumberOfOrders DESC
LIMIT 1;
#. Identify customers who have not placed any orders:
SELECT 
    CustomerID,
    Name
FROM 
    CustomersDIG
WHERE 
    CustomerID NOT IN (SELECT DISTINCT CustomerID FROM OrdersDIG);
    
#Find products that have never been ordered:
SELECT 
    ProductID,
    Name
FROM 
    ProductsDIG
WHERE 
    ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetailsDIG);
    
#Show the top 3 best-selling products:
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    SUM(od.Quantity) AS TotalQuantitySold
FROM 
    ProductsDIG p
JOIN 
    OrderDetailsDIG od ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductID, p.Name
ORDER BY 
    TotalQuantitySold DESC
LIMIT 3;

#List orders placed in the last month
SELECT 
    *
FROM 
    OrdersDIG
WHERE 
    OrderDate >= CURDATE() - INTERVAL 1 MONTH;
    
# Determine the oldest customer in terms of membership duration:
SELECT 
    CustomerID,
    Name,
    JoinDate,
    DATEDIFF(CURDATE(), JoinDate) AS MembershipDuration
FROM 
    Customers
ORDER BY 
    MembershipDuration DESC
LIMIT 1;

# Rank customers based on their total spending:
SELECT 
    CustomerID,
    Name,
    SUM(TotalAmount) AS TotalSpending,
    RANK() OVER (ORDER BY SUM(TotalAmount) DESC) AS Rank
FROM 
    CustomersDIG c
JOIN 
    OrdersDIG o ON c.CustomerID = o.CustomerID
GROUP BY 
    CustomerID, Name
ORDER BY 
    TotalSpending DESC;
    
# Identify the most popular product category:
SELECT 
    Category,
    COUNT(*) AS TotalOrders
FROM 
    Products p
JOIN 
    OrderDetailsDIG od ON p.ProductID = od.ProductID
GROUP BY 
    Category
ORDER BY 
    TotalOrders DESC
LIMIT 1;

#Calculate the month-over-month growth rate in sales:
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(TotalAmount) AS MonthlySales,
    LAG(SUM(TotalAmount)) OVER (ORDER BY DATE_FORMAT(OrderDate, '%Y-%m')) AS PreviousMonthSales,
    (SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY DATE_FORMAT(OrderDate, '%Y-%m'))) / LAG(SUM(TotalAmount)) OVER (ORDER BY DATE_FORMAT(OrderDate, '%Y-%m')) * 100 AS GrowthRate
FROM 
    Orders
GROUP BY 
    Month
ORDER BY 
    Month;
    
#Add a new customer to the customer table:
INSERT INTO CustomersDIG (CustomerID, Name, Email, JoinDate)
VALUES (11, 'New Customer', 'newcustomer@example.com', '2024-01-12');
#Update the price of a specific product:
UPDATE ProductsDIG
SET Price = 799.99
WHERE ProductID = 1;