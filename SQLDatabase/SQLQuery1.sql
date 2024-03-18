use VeganFoodStore
go


CREATE TABLE Supplier
(SupplierId INT PRIMARY KEY, 
Name varchar(50),
ContactPhone varchar(11),
Adress varchar(60) )

CREATE TABLE Promotions
(PromotionId INT PRIMARY KEY ,
Name varchar(60),
Valability varchar(12) )

CREATE TABLE Products
(ProductId INT PRIMARY KEY,
Name varchar(50),
Price int,
SupplierId int FOREIGN KEY REFERENCES Supplier(SupplierId) ,
PromotionId int FOREIGN KEY REFERENCES Promotions(PromotionId) )

CREATE TABLE Inventory
(InventoryId INT PRIMARY KEY ,
ProductId int FOREIGN KEY REFERENCES Products(ProductId) ,
PurchaseDate DATETIME,
QuantityInStock int )

CREATE TABLE Customers
(CustomerId int PRIMARY KEY ,
Name varchar(40),
Phone varchar(30) )

CREATE TABLE CustomersProducts 
( CustomerId int FOREIGN KEY REFERENCES Customers(CustomerId),
ProductId int FOREIGN KEY REFERENCES Products(ProductId),
CONSTRAINT pk_CustomersProducts PRIMARY KEY (CustomerId, ProductId) )

CREATE TABLE Reviews
(ReviewId INT PRIMARY KEY,
CustomerId INT FOREIGN KEY REFERENCES Customers(CustomerId),
ReviewDate DATETIME,
Rating INT CHECK (Rating >= 0 AND Rating <= 5) )



CREATE TABLE Orders
(OrderId INT PRIMARY KEY,
OrderStatus varchar(30),
TotalAmount int,
CustomerId INT FOREIGN KEY REFERENCES Customers(CustomerId) )

CREATE TABLE StoreLocations
(StoreId INT PRIMARY KEY,
Adress varchar(50),
OpenHours varchar(50) )

CREATE TABLE StorePromotion
(StoreId int FOREIGN KEY REFERENCES StoreLocations(StoreId),
PromotionId int FOREIGN KEY REFERENCES Promotions(PromotionId),
CONSTRAINT pk_StorePromotion PRIMARY KEY (StoreId, PromotionId) )

CREATE TABLE Employee
(EmployeeId int PRIMARY KEY,
Name varchar(40),
Position varchar(40),
Salary int,
WorkingHours int,
StoreId int FOREIGN KEY REFERENCES StoreLocations(StoreId) )

CREATE TABLE StaffShifts
(ShiftId INT PRIMARY KEY,
Date DATETIME,
Time varchar(50) )

CREATE TABLE EmployeeShifts
(EmployeeId int FOREIGN KEY REFERENCES Employee(EmployeeId),
ShiftId int FOREIGN KEY REFERENCES StaffShifts(ShiftId),
CONSTRAINT pk_EmployeeShifts PRIMARY KEY (EmployeeId, ShiftId) )

ALTER TABLE Promotions
ALTER COLUMN Valability VARCHAR(30);

ALTER TABLE Inventory
ALTER COLUMN PurchaseDate DATE;

ALTER TABLE StaffShifts
ALTER COLUMN Date DATE;


