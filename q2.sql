-- Create Tables
CREATE TABLE Customer (CustomerID INT PRIMARY KEY, Name VARCHAR(50), Email VARCHAR(100), Phone VARCHAR(15));
CREATE TABLE Product (ProductID INT PRIMARY KEY, ProductName VARCHAR(50), Price DECIMAL(10,2), Stock INT);
CREATE TABLE Orders (OrderID INT PRIMARY KEY, CustomerID INT, OrderDate DATE, FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID));
CREATE TABLE OrderDetails (OrderID INT, ProductID INT, Quantity INT, FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), FOREIGN KEY (ProductID) REFERENCES Product(ProductID));
CREATE TABLE Payment (PaymentID INT PRIMARY KEY, OrderID INT, Amount DECIMAL(10,2), Status VARCHAR(20), FOREIGN KEY (OrderID) REFERENCES Orders(OrderID));

-- Insert Data
INSERT INTO Customer VALUES (1,'Arun','arun@gmail.com','9999999999'),(2,'Anu','anu@gmail.com','8888888888');
INSERT INTO Product VALUES (101,'Laptop',50000,10),(102,'Mouse',500,50),(103,'Keyboard',1500,20);
INSERT INTO Orders VALUES (201,1,'2026-04-20'),(202,2,'2026-04-21');
INSERT INTO OrderDetails VALUES (201,101,1),(201,102,2),(202,103,1);
INSERT INTO Payment VALUES (301,201,51000,'Paid'),(302,202,1500,'Pending');

-- 2. View all products
SELECT * FROM Product;

-- 3. Customer Orders with Product Details
SELECT c.Name,o.OrderID,p.ProductName,od.Quantity FROM Customer c JOIN Orders o ON c.CustomerID=o.CustomerID JOIN OrderDetails od ON o.OrderID=od.OrderID JOIN Product p ON od.ProductID=p.ProductID;

-- 4. Total Order Amount per Customer
SELECT c.Name,SUM(p.Price*od.Quantity) AS TotalAmount FROM Customer c JOIN Orders o ON c.CustomerID=o.CustomerID JOIN OrderDetails od ON o.OrderID=od.OrderID JOIN Product p ON od.ProductID=p.ProductID GROUP BY c.Name;

-- 5. Products with Low Stock
SELECT * FROM Product WHERE Stock < 20;

-- 6. Paid Orders
SELECT * FROM Orders o JOIN Payment p ON o.OrderID=p.OrderID WHERE p.Status='Paid';

-- 7. View (multi-line needed)
CREATE VIEW OrderSummary AS
SELECT c.Name,o.OrderID,p.ProductName,od.Quantity,(p.Price*od.Quantity) AS Total
FROM Customer c
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN OrderDetails od ON o.OrderID=od.OrderID
JOIN Product p ON od.ProductID=p.ProductID;

-- 8. Trigger (multi-line required)
DELIMITER //
CREATE TRIGGER update_stock
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
UPDATE Product SET Stock = Stock - NEW.Quantity WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- 9. Index
CREATE INDEX idx_product_name ON Product(ProductName);