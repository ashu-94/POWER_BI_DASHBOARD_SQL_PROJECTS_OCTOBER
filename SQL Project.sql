---Create Database

Create Database OnlineRetailDB;

--Use the Database
USE OnlineRetailDB;
Go

---Create the Customer Table
Create Table Customers(
CustomerID INT Primary Key IDENTITY(1,1),
FirstName NVarchar(50),
LastName NVarchar(50),
Email NVarchar(100),
Phone  NVarchar(50),
Address NVarchar(255),
City NVarchar(100),
State NVarchar(50),
ZipCode NVarchar(50),
Country NVarchar(50),
CreatedAt DATETIME DEFAULT GETDATE()
);

---Create the Products table

CREATE TABLE PRODUCTS(
ProductID INT Primary KEY Identity(1,1),
ProductName NVarchar(100),
CategoryID INT,
Price Decimal(10,2),
Stock INT,
CreatedAt DATETIME DEFAULT GETDATE(),
);

Drop table PRODUCTS;

---Create the Categories table
Create Table Categories(
CategoryID INT Primary Key IDENTITY(1,1),
CategoryName NVarchar(100),
Description NVarchar(255)
);

---Create the Order Table
Create table Orders(
OrderId INT Primary Key IDENTITY(1,1),
CustomerId INT,
OrderDate DATETIME DEFAULT GETDATE(),
TotalAmount DECIMAL (10,2),
FOREIGN KEY(CustomerId)REFERENCES Customers(CustomerID)
);

--Create the OrderItems Table

Create or Alter Table OrderItems(
OrderItemId INT Primary Key IDENTITY(1,1),
OrderID INT,
ProductID INT,
Quantity INT,
Price Decimal(10,2)
Foreign Key(ProductID)References PRODUCTS(ProductID),
Foreign Key(OrderID)References Orders (OrderId),
);

---alter/Rename the column name
--VERY VERY IMP--Exec sp_rename 'OnlineRetailDB.dbo.Orders.CustomerId','CustomerID','COLUMN';

Exec sp_rename 'OnlineRetailDB.dbo.Orders.CustomerId','CustomerID','COLUMN';

---Insert sample data into Categories

Insert into Categories(CategoryName,Description) 
Values
('Electronics','Devices and Gadgets'),
('Clothing','Apparels and Accessories'),
('Books','Devices and Gadgets'),
('Electronics','Printed and Electronic books');

Select * from Categories

---Insert sample data into Product table

Insert into PRODUCTS(ProductName,CategoryID,Price,Stock)
values
('Smartphone',1,699.99,50),
('Laptop',1,999.99,30),
('T-Shirts',2,19.99,100),
('Jeans',2,49.99,60),
('Fiction Novel',3,14.99,200),
('Science Journal',3,29.99,150);

select * from Products

---Insert Sample Data into Customer Table

Insert into Customers(FirstName,LastName,Email,Phone,Address,City,State,ZipCode,Country)
values('Sameer','Khanna','sameer.khanna@gmail.com','123-456-9872','123 Elm St.','Springfield','IL',
'62701','USA'),
('Jane','Smith','jane.smith@example.com','234-567-8910','456 Oak St.','Madison','W.I','53703','U.S.A'),
('Rohit','Sharma','sharma.rohit@example.com','345-678-9101','789 Dalal St.','Mumbai','Maharashtra','657035','India');

---Insert sample data into Order Table
Insert Into Orders(CustomerID,OrderDate,TotalAmount)
Values(1,GETDATE(),719.98),
(2,GETDATE(),49.99),
(3,GETDATE(),44.98);

---Insert sample data into OrderItems table

Insert into OrderItems(OrderID,ProductID,Quantity,Price)
values(1,1,1,699.99),
(1,3,1,19.99),
(2,4,1,49.99),
(3,5,1,14.99),
(3,6,1,29.99);

---Query1: Retrive all orders for a specific customer.

Select o.OrderID,o.OrderDate,o.TotalAmount,oi.ProductID,p.ProductName,oi.Quantity,oi.Price
From Orders o 
JOIN OrderItems oi 
ON o.OrderID=oi.OrderID
Join PRODUCTS p 
On oi.ProductID=p.ProductID
where o.CustomerID=1;

---Query2: Find the total sales for each prpduct

Select p.ProductID,p.ProductName,SUM(oi.Quantity*oi.Price)As 'TotalSales'
From OrderItems oi 
Join PRODUCTS P
ON oi.ProductID=p.ProductID
Group BY p.ProductID,p.ProductName
Order By TotalSales DESC;

---Query3: Calculate the average order value
Select AVG(TotalAmount)as 'Average OrderValue' from Orders;

---Query4: List the top 5 customer by total spending..
----customer buy (buy means spending means Order)
SELECT CustomerID,FirstName,LastName,TotalSpending,Rn
from(
Select c.CustomerID,c.FirstName,c.LastName, SUM(o.totalamount)as TotalSpending,
ROW_NUMBER() over(Order By SUM(o.TotalAmount) DESC) as rn
From Customers c
Join Orders o
On c.CustomerID=o.CustomerID
Group By c.CustomerID,c.FirstName,c.LastName)
sub where rn<=5
--Query5: Retrieve  the most popular product category.
Select CategoryID,CategoryName,TotalQuantitySold,Rn
from(
Select c.CategoryID,c.CategoryName,SUM(oi.Quantity) as TotalQuantitySold,
ROW_NUMBER()OVER(ORDER BY SUM(oi.Quantity)DESC) AS rn
From OrderItems oi
JOIN Products p
on oi.ProductID=p.ProductID
Join Categories c
on p.CategoryID=c.CategoryID
Group By c.CategoryID,c.CategoryName)sub
WHERE rn=1

--to insert a product with zero stock
Insert into Products(ProductId,ProductName,CategoryID,Price,Stock)
values(7,'Keyboard',1,39.99,0);

Select * from products

---Query6: List all products that are out of stock, i.e stock=0

Select * from Products
where stock=0;

select ProductID,ProductName,Stock from Products where stock=0

--with category Name
select p.ProductID,p.ProductName,c.CategoryName,p.Stock 
from Products p
Join Categories c
on p.CategoryID=c.CategoryID
where Stock=0;


---Query7: Find customer who placed orders in the last 30 days

Select C.CustomerID,C.FirstName,C.LastName,C.Phone,C.Email
From Customers C
join Orders O
ON C.CUSTOMERID=O.CustomerID
WHERE O.OrderDate>=DATEADD(DAY,-30,GETDATE());

--Query 8: Calculate the total number of order placed each month.
Select COUNT(OrderID) as TotalOrders,YEAR(OrderDate) as OrderYear,
MONTH(Orderdate)as OrderMonth
From Orders
Group BY Year(OrderDate),MONTH(OrderDate);


Select YEAR(Orderdate) as OrderYear,
Month(OrderDate) as OrderMonth,
COUNT(OrderID) as TotalOrders
From Orders
Group By YEAR(OrderDate),MONTH(OrderDate)
Order By OrderYear,OrderMonth

---Query 9: Retrieve the details of the most recent order.

Select TOP 1 o.OrderID,o.OrderDate,o.TotalAmount,c.FirstName,c.LastName
From Orders O
join Customers c
on o.OrderID=c.CustomerID
Order By o.OrderDate desc;
---Query 10: Find the average price of product in each category.
---For  Refrence query 6
Select c.CategoryID,c.CategoryName,AVG(p.Price)as AveragePrice
from  Categories c
join PRODUCTS p
on c.CategoryID=p.CategoryID
Group By c.CategoryID,c.CategoryName 

---Query 11.List customer who have never placed an order
Select C.CustomerID,C.FirstName,C.LastName,C.Phone,C.Email,O.OrderID,O.TotalAmount
From Customers C
Full join Orders O
ON C.CUSTOMERID=O.CustomerID 
WHERE O.OrderID is Null;

Insert into Customers(FirstName,LastName,Email,Phone,Address,City,State,ZipCode,Country)
values('Virat','Kohli','kohli.virat@gmail.com','567-891-0112','123 Elm St.','Springfield','IL',
'62701','USA')
---Query 12: Retrive the total quantity sold for each product
Select p.ProductID,p.ProductName,Sum(oi.Quantity)as TotalQuantitySold
From OrderItems oi
Join PRODUCTS p
on oi.ProductID=p.ProductID
Group By p.ProductID,p.ProductName
Order By p.ProductName;

---Query 13: Calculate the total revenue generated from each category.
Select c.CategoryID,c.CategoryName,SUM(oi.Quantity*oi.Price) as TotalRevenue
From OrderItems oi
Join Products p
on  oi.ProductID=p.ProductID
JOIN Categories c
on c.CategoryID= p.CategoryID
Group By c.CategoryID,c.CategoryName
Order By TotalRevenue DESC;

---Query 14:Find the highest-priced product in each category

Select c.CategoryID,c.CategoryName,p.ProductID,p.ProductName,p.Price
From Categories c
JOIN PRODUCTS p
on c.CategoryID=p.CategoryID
where p.Price =(Select MAX(Price) from Products);


Select c.CategoryID,c.CategoryName,p1.ProductID,p1.ProductName,p1.Price
From Categories c
JOIN PRODUCTS p1
on c.CategoryID=p1.CategoryID
where p1.Price =(Select MAX(Price) from Products p2 Where p2.CategoryID=P1.CategoryID)
order BY p1.Price Desc;

---Query 15: Retrive orders with a total amount greater than a specific value(e.g., $200)
 Select o.OrderID,c.CustomerID,c.FirstName,c.LastName,o.TotalAmount
 From Orders o
 Join Customers c
 on o.CustomerID=c.CustomerID
where o.TotalAmount>=49.99
Order By o.TotalAmount Desc;


---Query 16: List products along with the number of orders they appear in

Select p.ProductID,p.ProductName,COUNT(oi.OrderID)as OrderCount
From Products p 
Join OrderItems oi
on p.ProductID=oi.ProductID
Group By p.ProductID,p.ProductName
Order By OrderCount Desc;

Insert into Orders(CustomerID,OrderDate,TotalAmount)
values(4,GETDATE(),3499.95)

Insert into OrderItems(OrderID,ProductID,Quantity,Price)
values(4,1,5,699.99)

Select * from OrderItems

---Query 17:Find the top 3 most frequently ordered products.
Select TOP 3 p.ProductID,p.ProductName,COUNT(oi.OrderId) as OrderCount
FRom OrderItems oi
JOIN PRODUCTS p
on p.ProductID=oi.ProductID
Group By  p.ProductID,p.ProductName
Order By OrderCount DESC;

---Query 18: Calculate the total number of customers from each country
Select Country,COUNT(CustomerID) as TotalCustomer
From Customers Group By Country
Order BY TotalCustomer DESC;

---Query 19: Retrieve the list of customers along with their total spending.
Select c.CustomerID,c.FirstName,c.LastName,SUM(o.TotalAmount) as TotalSpending
From Customers c Join
Orders o
on C.CustomerID=o.CustomerID
Group By c.CustomerID,c.FirstName,c.LastName
Order By TotalSpending DESC;

---QUERY 20 List orders with more than a specified number of items (e.g..,5 items)

 Select o.OrderId ,c.CustomerID,c.FirstName,c.LastName,Count(oi.OrderItemID)as NumberofItems
 From Orders o JOIN OrderItems oi
 on o.ORderID=oi.OrderID
 JOIN Customers c
on o.CustomerID=c.CustomerID
Group by o.OrderId, c.CustomerID,c.FirstName,c.LastName
 Having Count(oi.OrderItemID)>=2
 Order By NumberofItems;
 