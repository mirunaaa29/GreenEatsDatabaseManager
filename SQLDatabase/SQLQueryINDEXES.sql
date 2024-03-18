use VeganFoodStore

create table Ta
(
	aid INT PRIMARY KEY,
	a2 INT UNIQUE,
	name VARCHAR(20)
)
GO

create table Tb
(
	bid INT PRIMARY KEY,
	b2 INT
	)
GO

create table Tc
(
	cid INT PRIMARY KEY,
	aid INT FOREIGN KEY REFERENCES Ta(aid),
	bid INT FOREIGN KEY REFERENCES Tb(bid)
)
GO

INSERT INTO Ta (aid, a2, name)
VALUES 
    (1, 101, 'Alice'),
    (2, 102, 'Bob'),
    (3, 103, 'Charlie'),
    (4, 104, 'David'),
    (5, 105, 'Eva');

INSERT INTO Tb (bid, b2)
VALUES 
    (201, 301),
    (202, 302),
    (203, 303),
    (204, 304),
    (205, 305);

INSERT INTO Tc (cid, aid, bid)
VALUES 
    (1, 1, 201),
    (2, 2, 202),
    (3, 3, 203),
    (4, 4, 204),
    (5, 5, 205);

SELECT * FROM Ta	
SELECT * FROM Tb
SELECT * FROM Tc

-- a 
--clustered index scan
SELECT * from Ta ORDER BY aid

--clusterd index seek
SELECT * from Ta WHERE a2 < 104

CREATE NONCLUSTERED INDEX Ta_index1 on Ta(name) INCLUDE (a2)
DROP INDEX Ta_index1 ON Ta -- no difference 

--nonclustered index scan
SELECT name from Ta where a2 = 103

--nonclustered index seek
SELECT a2 FROM Ta WHERE name LIKE 'A%'

-- key lookup
SELECT name FROM Ta WHERE aid = 2


-- b

SELECT * FROM Tb WHERE b2=304

CREATE NONCLUSTERED INDEX Tb_index_1 ON Tb(b2) -- better CPU cost
DROP INDEX Tb_index_1 ON Tb
GO

--c
CREATE VIEW TbTcJoinedView AS
SELECT Tb.bid, Tb.b2, Tc.cid, Tc.aid
FROM Tb
INNER JOIN Tc ON Tb.bid = Tc.bid;
GO

select * from TbTcJoinedView
Go

CREATE NONCLUSTERED INDEX Tb_index_bid on Tb(bid)
DROP INDEX Tb_index_bid on Tb
