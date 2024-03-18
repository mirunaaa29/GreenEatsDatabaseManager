use VeganFoodStore
go



INSERT INTO Customers (CustomerId, Name, Phone)
VALUES (1, 'Mihalachi Miruna', '0755632491'),
       (2, 'Mirea Carla', '0763422101'),
       (3, 'Arseni Mihnea', '0754200123'),
       (4, 'Mirean Iulia-Elena', '0742191256');
-- PK Constraints
insert into Customers(CustomerId, Name, Phone) values (1, 'Mihai Constantin' , '0751123564');

SET IDENTITY_INSERT Customers Off;

SELECT * FROM Customers

 
INSERT INTO Reviews (ReviewId,CustomerId, ReviewDate, Rating)
VALUES (1,1, '2023-08-05', 4),
       (2,3, '2023-12-20', 5);


INSERT INTO Reviews (ReviewId,CustomerId, ReviewDate, Rating)
VALUES (3, 1, '2023-09-10',5);

SELECT * FROM Reviews

INSERT INTO Orders (OrderId,OrderStatus, TotalAmount, CustomerId)
VALUES (1,'Shipped', 50, 4),
       (2,'Processing', 70, 2),
	   (3,'In delivery', 120, 1);

SELECT * FROM Orders


INSERT INTO Supplier (SupplierId  ,Name, ContactPhone, Adress)
VALUES (1,'Aivia SRL', '1234567890', '123 Main Street'),
       (2,'Soligrano Distributors', '5555555', '456 Elm Avenue'),
	   (3,'Verdino SRL', '515467555', 'Dorobantilor 23');

SELECT * FROM Supplier

INSERT INTO Promotions (PromotionId, Name, Valability)
VALUES (1,'Summer Sale', '2023-08-01 to 2023-09-30'),
       (2,'Holiday Special', '2023-12-01 to 2023-12-31'),
	   (3,'2 for price of 1', '2023-11-06 to 2023-11-08');

SELECT * FROM Promotions

INSERT INTO Products (ProductId,Name, Price, SupplierId, PromotionId)
VALUES (1,'Vegan Burger Mix', 20, 1,2),
       (2,'Hummus', 30, 1, 3),
	   (3,'Egg replacement', 14, 2, 1),
	   (4,'Vegan Butter', 25, 3, 1);

SELECT * FROM Products

INSERT INTO Inventory (InventoryId,ProductId, PurchaseDate, QuantityInStock)
values (1,1, '2023-07-12', 45),
		(2,2, '2023-07-12', 55),
		(3,3, '2023-08-24', 23),
		(4,4, '2023-08-25', 45);


SELECT * FROM Inventory


INSERT INTO CustomersProducts (CustomerId, ProductId)
VALUES (1, 2),
       (2, 3),
	   (3, 3),
	   (2, 1);

SELECT * FROM CustomersProducts


INSERT INTO StoreLocations (StoreId,Adress, OpenHours)
VALUES (1,'123 Oak Street', 'Mon-Fri: 9 AM - 7 PM'),
       (2,'Calea Dorobantilor 23', 'Mon-Sat: 10 AM - 6 PM');

SELECT * FROM StoreLocations


INSERT INTO StorePromotion (StoreId, PromotionId)
VALUES (1, 1),
	   (1, 3),
       (2, 2);

SELECT * FROM StorePromotion


INSERT INTO Employee (EmployeeId,Name, Position,  Salary, StoreId)
VALUES (1,'Sarah Williams', 'Manager', 5000, 1),
		(2,'Alexandru Popescu', 'Cashier', 3400, 1),
       (3,'Michael Johnson', 'Sales Associate', 3500, 2);

SELECT * FROM Employee


INSERT INTO StaffShifts (ShiftId,Date, Time)
VALUES (1,'2023-08-10', '9 AM - 5 PM'),
       (2,'2023-08-10', '5 PM - 10 PM');

SELECT * FROM StaffShifts

INSERT INTO EmployeeShifts (EmployeeId, ShiftId)
VALUES (1, 1),
       (2, 2);

SELECT * FROM EmployeeShifts

