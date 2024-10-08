---Indexes are crucial for optimizing the performance of your SQL SERVER DATABASE, especially for
---read-heavy operations like Select queries...

---Create indexes for the OnlineRetailDB database to improve query performance.

---A. Indexes on Categories Table
   ----1. Clustered Index on CategoryID : Usually created with the primary key.

---B. Indexes on Products Table.

---1.Clustered Index on ProductID: This is usually created automatically when 
---the primary key is defined.
Use OnlineRetailDB 
GO

---- Indexes on Product Table.


---Clustered Index on Categories Table (CategoryID)...

 Create Clustered INDEX IDX_Categories_CategoryID
 ON Categories(CategoryID);
 GO

---2.Non-Clustered Index on Category ID: To speed up queries filtering by CategoryID.
---3.Non-Clustered Index on Price: To speed up queries filtering or sorting by Price.


---- Indexes on Product table.

---Drop Foreign Key Constraint from order Items table---ProductID

Alter table OrderItems
Drop Constraint FK__OrderItem__Price__45F365D3

---Clustered index on Product table

--Create Clustered INDEX IDX_Products_ProductID
 --ON Products(ProductID);
 --GO

 ---Create Non Clustered Index on CategoryID: to speed up queries filtering by category ID

Create NonClustered index IDX_Products_CategoryID
on PRoducts(CategoryID);
go

---Create Non Clustered Index on Price: to speed up queries filtering by Price

Create NonClustered index IDX_Products_Price
on PRoducts(Price);
go

Create Clustered index IDX_Products_ProductID
on PRoducts(ProductID);
go

---Recreate Foreign Key Constraints on orderitems table(ProductID Column).
ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Produrcts
FOREIGN KEY(ProductID)references Products(ProductID)

---indexes on orders table

---Drop Foreign Key Constraint from OrderItems Table ---OrderID
ALTER TABLE OrderItems Drop Constraint FK__OrderItem__Order__46E78A0C;

---clustered  index on order id
CREATE CLUSTERED INDEX IDX_Orders_OrderID
on Orders(OrderID);
Go
---create  Non Clustered Index on CustomerID
Create NonClustered index IDX_Orders_CustomerID
on Orders(CustomerID);
go

---Create Non Clustered Index on OrderDate: to speed up queries filtering by OrderDate

Create NonClustered index IDX_Orders_OrderDate
on Orders(OrderDate);
go


---Recreate Foreign Key Constraints on orderitems table(OrderID Column).
ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_OrderID
FOREIGN KEY(OrderID)references Orders(OrderID)

----Create Clustered Index on OrderItemsID

CREATE CLUSTERED INDEX IDX_OrderItems_OrderItemID
on OrderItems(OrderItemID);
Go

--create  Non Clustered Index on OrderID
Create NonClustered index IDX_OrderItem_OrderID
on OrderItems(OrderID);
go

---Create Non Clustered Index on ProductID: to speed up queries filtering by ProductID

Create NonClustered index IDX_OrderItems_ProductID
on OrderItems(ProductID);
go