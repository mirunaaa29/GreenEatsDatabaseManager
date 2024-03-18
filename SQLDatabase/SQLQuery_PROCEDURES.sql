use VeganFoodStore
go

CREATE TABLE Previous_Versions
(
	storedProcedure VARCHAR(50),
	versionFrom INT,
	versionTo INT,
	PRIMARY KEY(versionFrom,versionTo)
)
GO


CREATE TABLE Current_Version
(
	currentVersion INT DEFAULT 0
)
GO



--PROCEDURES



-- a. Modify the type of a column

CREATE OR ALTER PROCEDURE changeReviewDateType
AS 
BEGIN 
	ALTER TABLE Reviews
	ALTER COLUMN ReviewDate VARCHAR(25)
END
GO

EXEC changeReviewDateType
go

--undo
CREATE OR ALTER PROCEDURE undo_changeReviewDateType
AS 
BEGIN 
	ALTER TABLE Reviews
	ALTER COLUMN ReviewDate DATE
END
GO

EXEC undo_changeReviewDateType
go


--b. add / remove a column

CREATE OR ALTER PROCEDURE removeWorkingHoursFromEmployee
AS
BEGIN
	ALTER TABLE Employee
	DROP COLUMN WorkingHours
END
GO

EXEC removeWorkingHoursFromEmployee
GO

--undo

CREATE OR ALTER PROCEDURE undo_removeWorkingHoursFromEmployee
AS
BEGIN
	ALTER TABLE Employee
	add WorkingHours int
END
GO

EXEC undo_removeWorkingHoursFromEmployee
GO

-- c.add / remove a DEFAULT constraint;

CREATE OR ALTER PROCEDURE addDefaultConstraintStaffShiftsTime
AS
BEGIN
	ALTER TABLE StaffShifts
	ADD CONSTRAINT shift_time_default
	DEFAULT 6 FOR Time
END
GO

EXEC addDefaultConstraintStaffShiftsTime
GO

--undo

CREATE OR ALTER PROCEDURE undo_addDefaultConstraintStaffShiftsTime
AS
BEGIN
	ALTER TABLE StaffShifts
	DROP CONSTRAINT shift_time_default
END
GO

EXEC undo_addDefaultConstraintStaffShiftsTime
GO


-- d. add / remove a primary key;

CREATE OR ALTER PROCEDURE dropPrimaryKeyCustomersProducts
AS
BEGIN
	ALTER TABLE CustomersProducts
	DROP CONSTRAINT pk_CustomersProducts

END
GO

 EXEC dropPrimaryKeyCustomersProducts
 GO

--undo

CREATE OR ALTER PROCEDURE undo_dropPrimaryKeyCustomersProducts
AS
BEGIN
	ALTER TABLE CustomersProducts
	ADD CONSTRAINT pk_CustomersProducts PRIMARY KEY (CustomerId, ProductId)
END
GO

EXEC undo_dropPrimaryKeyCustomersProducts
Go

-- e. add / remove a candidate key;

CREATE OR ALTER PROCEDURE addCandidateKeyCustomersTable
AS
BEGIN
	ALTER TABLE Customers
	ADD CONSTRAINT UQ_NewCandiateKey_CustomersTable UNIQUE(CustomerId, Name)
END
GO

EXEC addCandidateKeyCustomersTable
GO

--undo 

CREATE OR ALTER PROCEDURE undo_addCandidateKeyCustomersTable
AS
BEGIN
	ALTER TABLE Customers
	DROP CONSTRAINT UQ_NewCandiateKey_CustomersTable
END
GO

EXEC undo_addCandidateKeyCustomersTable
GO



--f. add / remove a foreign key;


CREATE OR ALTER PROCEDURE addFKConstraintCustomerIdReviews
AS
BEGIN
	ALTER TABLE Reviews
	ADD CONSTRAINT FK_Reviews_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId);
END
GO

EXEC addFKConstraintCustomerIdReviews
GO

--undo
CREATE OR ALTER PROCEDURE undo_addFKConstraintCustomerIdReviews
AS
BEGIN
	ALTER TABLE Reviews
	DROP CONSTRAINT FK_Reviews_Customers
END
GO

EXEC undo_addFKConstraintCustomerIdReviews
GO

-- g. create/drop table
CREATE or ALTER PROCEDURE createPaidPartenershipTable
AS
BEGIN
	CREATE TABLE PaidPartenerships
	(
		PartenershipID SMALLINT NOT NULL PRIMARY KEY,
		InfluencerName VARCHAR(30)
	)
END
go

EXEC createPaidPartenershipTable
GO

--undo
CREATE OR ALTER PROCEDURE undo_createPaidPartenershipTable
AS
BEGIN
	DROP TABLE PaidPartenerships
END
GO

EXEC undo_createPaidPartenershipTable
go
