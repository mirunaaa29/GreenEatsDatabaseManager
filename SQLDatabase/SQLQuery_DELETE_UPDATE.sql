USE VeganFoodStore
go

-- Update the phone number for the customer named 'Mirea Carla' if their phone number is not null
-- AND, IS NOT NULL
UPDATE Customers
SET Phone = '077563451'
WHERE Name = 'Mirea Carla' AND Phone IS NOT NULL;

-- <, and, in
UPDATE Reviews
SET Rating=3
WHERE Rating < 3 AND CustomerId IN (1,2);

-- LIKE
UPDATE Products
SET Price = Price + 5
WHERE Name LIKE '%Vegan%';

SELECT * FROM Products

-- BETWEEN
DELETE FROM Reviews
WHERE Rating BETWEEN 1 AND 3

-- OR , <=
DELETE FROM Inventory
WHERE PurchaseDate <= '2023-07-11' OR QuantityInStock <= 25;

SELECT * FROM Inventory


UPDATE Products
SET PromotionId = NULL
WHERE Name = 'Vegan Butter';

UPDATE Products
SET Price=25
where Name = 'Hummus'