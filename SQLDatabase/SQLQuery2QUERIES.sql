use VeganFoodStore
go


--a. 2 queries with the union operation; use UNION [ALL] and OR;
-- All orders that have been shipped or are in delivery process
SELECT *
FROM Orders
WHERE OrderStatus = 'Shipped' OR OrderStatus = 'In delivery'


-- Employeers id that are managers or have a salary grater thatn 4000
SELECT e.EmployeeId
from Employee e
where Position='Manager'
UNION
SELECT e2.EmployeeId
from Employee e2
where Salary > 4000



--b. 2 queries with the intersection operation; use INTERSECT and IN;
-- Find customers who have both made reviews and placed orders
SELECT CustomerId, Name
FROM Customers
WHERE CustomerId IN (
    SELECT CustomerId FROM Reviews
    INTERSECT
    SELECT CustomerId FROM Orders
)
ORDER BY CustomerId;

--Compute the price with tax for products that come from supplier with id 8 , 9
SELECT Name, Price, (Price * 1.2) AS PriceWithTAX
FROM Products
WHERE SupplierId IN (8, 9) AND Price > 15;



--c. 2 queries with the difference operation; use EXCEPT and NOT IN;
--Firt holiday promotion that does not last just until the christmas day
SELECT top 1 p1.PromotionId, p1.Name
FROM Promotions p1
WHERE Name like 'Holiday%'
EXCEPT 
SELECT p2.PromotionId, p2.Name
FROM Promotions p2
WHERE Valability like '2023-12-10 to 2023-12-25'

--customers who haven't place any online orders
SELECT DISTINCT c.Name
FROM Customers c
WHERE c.CustomerId NOT IN (SELECT o.CustomerId FROM Orders o);



--d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); one query will join at least 3 tables, while another one will join at least two many-to-many relationships
-- promotion of 10% on products from Summer Sale
SELECT *, (p.Price * 0.9) AS DiscountedPrice
FROM Products p 
INNER JOIN Promotions pr ON p.PromotionId = pr.PromotionId
      AND pr.Name = 'Summer Sale';

-- all customers asociated with their online order (NULL for customers who did not place any order)
SELECT c.Name AS CustomerName, o.OrderId
FROM Customers c
LEFT JOIN Orders o ON c.CustomerId = o.CustomerId
ORDER BY OrderId


-- all cashiers that work on the specified date	(many to many)
SELECT	*
FROM Employee e
RIGHT JOIN EmployeeShifts es ON e.EmployeeId = es.EmployeeId
RIGHT JOIN StaffShifts s ON es.ShiftId = s.ShiftId
WHERE e.Position = 'Cashier' AND s.Date = '2023-08-10';

-- products with their suppliers and the promotion they are part of (3 tables)
SELECT p.Name AS ProductName, s.Name AS SupplierName, pr.Name AS PromotionName
FROM Products p
FULL JOIN Supplier s ON p.SupplierId = s.SupplierId
FULL JOIN Promotions pr ON p.PromotionId = pr.PromotionId;


--e. 2 queries with the IN operator and a subquery in the WHERE clause; in at least one case, the subquery must include a subquery in its own WHERE clause;
-- Retrieve customers who have placed orders with a total amount exceeding the average total amount of all orders
SELECT Name
FROM Customers
WHERE CustomerId IN (
    SELECT CustomerId
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- Retrieve distinct store locations with at least one employee working as a 'Manager'
SELECT DISTINCT Adress
FROM StoreLocations
WHERE StoreId IN (
    SELECT StoreId
    FROM Employee
    WHERE Position = 'Manager'
);


--f.2 queries with the EXISTS operator and a subquery in the WHERE clause;
-- firts 2 products that have an associated promotion
SELECT TOP 2 Name AS ProductName
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Promotions pr
    WHERE p.PromotionId = pr.PromotionId
);

-- Retrieve stores with at least two employees
SELECT *
FROM StoreLocations sl
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.StoreId = sl.StoreId
    GROUP BY e.StoreId
    HAVING COUNT(*) >= 2
);


--g. 2 queries with a subquery in the FROM clause;      
-- Retrieve the total number of orders placed by each customer
SELECT c.CustomerId, c.Name AS CustomerName, COUNT(o.OrderId) AS TotalOrders
FROM Customers c LEFT JOIN (
    SELECT CustomerId, OrderId
    FROM Orders
)o ON c.CustomerId = o.CustomerId
GROUP BY c.CustomerId, c.Name;


-- Calculate the total value of products in stock
SELECT SUM(ip.TotalValue) AS TotalStockValue
FROM (
    SELECT p.ProductId, p.Price * i.QuantityInStock AS TotalValue
    FROM Products p
    JOIN Inventory i ON p.ProductId = i.ProductId
) AS ip;



--h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;
--List the total number of products that each supplier provides, and show only those with at least 2 products.
SELECT p.SupplierId, s.Name AS SupplierName, COUNT(p.ProductId) AS TotalProductsInStock
FROM Products p
JOIN Supplier s ON p.SupplierId = s.SupplierId
GROUP BY p.SupplierId, s.Name
HAVING COUNT(p.ProductId) >= 2; 

--Calculate the average salary for each store location and show only locations where the average salary is above the overall average salary of all store locations.
SELECT e.StoreId, sl.Adress AS StoreAddress, AVG(e.Salary) AS AverageSalary
FROM Employee e
JOIN StoreLocations sl ON e.StoreId = sl.StoreId
GROUP BY e.StoreId, sl.Adress
HAVING AVG(e.Salary) > (
    SELECT AVG(Salary)
    FROM Employee
);


--List the customers who have submitted at least 2 reviews with an average rating of at least 4.
SELECT c.CustomerId, c.Name AS CustomerName
FROM Customers c
WHERE c.CustomerId IN (
    SELECT r.CustomerId
    FROM Reviews r
    GROUP BY r.CustomerId
    HAVING COUNT(r.ReviewId) > 1
       AND r.CustomerId IN (
           SELECT r.CustomerId
           FROM Reviews r
           GROUP BY r.CustomerId
           HAVING AVG(r.Rating) >= 4
       )
);


--List the total number of products for each supplier
SELECT p.SupplierId, s.Name AS SupplierName, COUNT(p.ProductId) AS TotalProducts
FROM Products p
JOIN Supplier s ON p.SupplierId = s.SupplierId
GROUP BY p.SupplierId, s.Name;



-- 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator);
-- all orders that cost less than the maximum order
SELECT *
FROM Orders o
WHERE o.TotalAmount < ANY(
		SELECT o1.TotalAmount
		from Orders o1
		where o.OrderId <> o1.OrderId)


--retrieve products with prices greater than any product's price offered by the same supplier.
SELECT P.ProductId,P.Name AS ProductName, P.Price, S.Name AS SupplierName
FROM Products AS P
JOIN Supplier AS S ON P.SupplierId = S.SupplierId
WHERE P.Price > ANY (
    SELECT Price
    FROM Products
    WHERE SupplierId = P.SupplierId
);


-- first order with the maximum price
SELECT TOP 1*
FROM Orders AS O1
WHERE O1.TotalAmount >= ALL (
       SELECT O2.TotalAmount
       FROM Orders AS O2
       WHERE O2.CustomerId <> O1.CustomerId );

-- return reviews with maximum rating
SELECT *
FROM Reviews as r1
where r1.Rating >= ALL (
	   SELECT R2.Rating
       FROM Reviews AS R2
       WHERE R2.ReviewId <> r1.ReviewId );


--rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.
-- all orders that cost less than the maximum order
SELECT *
FROM Orders o
WHERE o.TotalAmount < (
    SELECT MAX(o1.TotalAmount)
    FROM Orders o1
);

SELECT TOP 1 P.ProductId, P.Name AS ProductName, P.Price, S.Name AS SupplierName
FROM Products AS P
JOIN Supplier AS S ON P.SupplierId = S.SupplierId
WHERE P.Price >= (
    SELECT MAX(Price)
    FROM Products
);


-- return reviews with maximum rating
SELECT *
FROM Reviews as r1
WHERE r1.Rating IN (
    SELECT DISTINCT R2.Rating
    FROM Reviews AS R2
    WHERE R2.ReviewId <> r1.ReviewId
);

-- first order with the maximum price
SELECT *
FROM Orders AS O1
WHERE O1.TotalAmount IN (
    SELECT TOP 1 TotalAmount
    FROM Orders AS O2
    ORDER BY TotalAmount DESC
);


