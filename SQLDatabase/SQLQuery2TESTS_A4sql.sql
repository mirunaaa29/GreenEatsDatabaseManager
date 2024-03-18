SELECT * FROM Tests
SELECT * FROM Tables
SELECT * FROM TestTables
SELECT * FROM Views 
SELECT * FROM TestViews 
SELECT * FROM TestRuns
SELECT * FROM TestRunTables 
SELECT * FROM TestRunViews
GO

-- StoreLocations(PK), Employee(PK,FK), EmployeeShifts(2 PK)

-- create views
CREATE OR ALTER VIEW ViewOneTable
AS
	SELECT * FROM StoreLocations
GO

CREATE OR ALTER VIEW ViewTwoTables
AS
	SELECT E.EmployeeId, Name, Position , ShiftId
	FROM Employee E INNER JOIN EmployeeShifts ES on E.EmployeeId=ES.EmployeeId
GO

CREATE OR ALTER VIEW ViewGroupBy
AS
	SELECT SL.StoreId , SL.Adress, COUNT(E.EmployeeId) AS TotalEmployee
	FROM StoreLocations SL
	LEFT JOIN Employee E ON SL.StoreId = E.StoreId
	group by SL.StoreId , SL.Adress;
GO

--insert into Tables
DELETE FROM Tables
INSERT INTO Tables VALUES ('StoreLocations'),('Employee'),('EmployeeShifts')
go

DELETE FROM Views
INSERT INTO Views VALUES ('ViewOneTable'),('ViewTwoTables'),('ViewGroupBy')
go

CREATE OR ALTER PROCEDURE delete_table
	@no_of_rows INT,
	@table_name VARCHAR(30)
AS
BEGIN
	DECLARE @last_row INT

	IF @table_name='StoreLocations'
	BEGIN
	IF (SELECT COUNT(*) FROM StoreLocations)<@no_of_rows
	BEGIN
		PRINT ('Too many rows to delete')
		RETURN 1
	END
	ELSE
	BEGIN
		SET @last_row = (SELECT MAX(StoreId) FROM StoreLocations) - @no_of_rows

		DELETE FROM StoreLocations
		WHERE StoreId>@last_row
	END
	END

	ELSE IF @table_name='Employee'
	BEGIN
	IF (SELECT COUNT(*) FROM Employee)<@no_of_rows
	BEGIN
		PRINT ('Too many rows to delete')
		RETURN 1
	END
	ELSE
	BEGIN
		SET @last_row = (SELECT MAX(EmployeeId) FROM Employee) - @no_of_rows

		DELETE FROM Employee
		WHERE EmployeeId>@last_row
	END
	END

	ELSE IF @table_name='EmployeeShifts'
	BEGIN
	IF (SELECT COUNT(*) FROM EmployeeShifts)<@no_of_rows
	BEGIN
		PRINT ('Too many rows to delete')
		RETURN 1
	END
	ELSE
	BEGIN
		SET @last_row = (SELECT MAX(EmployeeId) FROM EmployeeShifts) - @no_of_rows

		DELETE FROM EmployeeShifts
		WHERE EmployeeId>@last_row
	END
	END

	ELSE
	BEGIN
		PRINT('Not a valid table name')
		RETURN 1
	END
END
GO


CREATE OR ALTER PROCEDURE insert_table
	@no_of_rows INT,
	@table_name VARCHAR(30)
AS
BEGIN
	DECLARE @input_id INT
	IF @table_name='StoreLocations'
	BEGIN
		WHILE @no_of_rows > 0
		BEGIN
			INSERT INTO StoreLocations(Adress, OpenHours) VALUES('Strada VASILE Alecsandri', '07:30-22:00')
			SET @no_of_rows=@no_of_rows-1
		END
	END

	ELSE IF @table_name='Employee'
	BEGIN
	DECLARE @maxEmployeeId INT
    SELECT @maxEmployeeId = ISNULL(MAX(EmployeeId), 0) FROM Employee
	SET @input_id = @maxEmployeeId + 1
	

	DECLARE @fk1 INT
	SET @fk1=(SELECT TOP 1 StoreId FROM StoreLocations)

		WHILE @no_of_rows > 0
		BEGIN
			INSERT INTO Employee(EmployeeId,Name,Position,Salary,StoreId) VALUES(@input_id, 'Gina Georgiana', 'manager', 1000 ,@fk1)
			-- also insert into staff shifts so you have data for employee shifts
			INSERT INTO StaffShifts(Date,Time) values ('2021-10-23','10:00-23:00')
			SET @input_id=@input_id+1
			SET @no_of_rows=@no_of_rows-1
		END
	END

	ELSE IF @table_name='EmployeeShifts'
	BEGIN
	WHILE @no_of_rows > 0
    BEGIN
        INSERT INTO EmployeeShifts (EmployeeId, ShiftId)
        SELECT TOP 1 E.EmployeeId, SS.ShiftId
        FROM Employee E
        CROSS JOIN StaffShifts SS
        LEFT JOIN EmployeeShifts ES ON E.EmployeeId = ES.EmployeeId AND SS.ShiftId = ES.ShiftId
        WHERE ES.EmployeeId IS NULL
        ORDER BY E.EmployeeId, SS.ShiftId

        SET @no_of_rows = @no_of_rows - 1
    END
	END

	ELSE
	BEGIN
		PRINT('Not a valid table name')
		RETURN 1
	END
END
GO


CREATE OR ALTER PROCEDURE select_view
	@view_name VARCHAR(30)
AS
BEGIN
	IF @view_name='ViewOneTable'
	BEGIN 
		SELECT * FROM ViewOneTable
	END

	ELSE IF @view_name='ViewTwoTables'
	BEGIN 
		SELECT * FROM ViewTwoTables
	END

	ELSE IF @view_name='ViewGroupBy'
	BEGIN 
		SELECT * FROM ViewGroupBy
	END

	ELSE
	BEGIN 
		PRINT('Not a valid view name')
		RETURN 1
	END
END
GO


delete from Tests
INSERT INTO Tests VALUES ('test_10'),('test_100'),('test_1000')
GO

DELETE FROM TestViews
INSERT INTO TestViews(TestID,ViewID) VALUES (1,7)
INSERT INTO TestViews(TestID,ViewID) VALUES (1,8)
INSERT INTO TestViews(TestID,ViewID) VALUES (1,9)
INSERT INTO TestViews(TestID,ViewID) VALUES (2,7)
INSERT INTO TestViews(TestID,ViewID) VALUES (2,8)
INSERT INTO TestViews(TestID,ViewID) VALUES (2,9)
INSERT INTO TestViews(TestID,ViewID) VALUES (3,7)
INSERT INTO TestViews(TestID,ViewID) VALUES (3,8)
INSERT INTO TestViews(TestID,ViewID) VALUES (3,9)
GO

DELETE FROM TestTables
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (1,7,10,1)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (1,8,10,2)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (1,9,10,3)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (2,7,100,1)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (2,8,100,2)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (2,9,100,3)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (3,7,1000,1)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (3,8,1000,2)
INSERT INTO TestTables(TestId, TableID, NoOfRows, Position) VALUES (3,9,1000,3)
GO

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews
GO


CREATE OR ALTER PROCEDURE mainTest
	@testID INT
AS
BEGIN
	INSERT INTO TestRuns VALUES ((SELECT Name FROM Tests WHERE TestID=@testID),GETDATE(),GETDATE())
	DECLARE @testRunID INT
	SET @testRunID=(SELECT MAX(TestRunID) FROM TestRuns)

	DECLARE @noOfRows INT
	DECLARE @tableID INT
	DECLARE @tableName VARCHAR(30)
	DECLARE @startAt DATETIME
	DECLARE @endAt DATETIME
	DECLARE @viewID INT
	DECLARE @viewName VARCHAR(30)

	DECLARE testDeleteCursor CURSOR FOR
	SELECT TableID,NoOfRows
	FROM TestTables
	WHERE TestID=@testID
	ORDER BY Position DESC

	OPEN testDeleteCursor

	FETCH NEXT 
	FROM testDeleteCursor
	INTO @tableID,@noOfRows

	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @tableName=(SELECT Name FROM Tables WHERE TableID=@tableID)

		EXEC delete_table @noOfRows,@tableName

		FETCH NEXT 
		FROM testDeleteCursor
		INTO @tableID,@noOfRows
	END

	CLOSE testDeleteCursor
	DEALLOCATE testDeleteCursor

	DECLARE testInsertCursor CURSOR FOR
	SELECT TableID,NoOfRows
	FROM TestTables
	WHERE TestID=@testID
	ORDER BY Position ASC

	OPEN testInsertCursor

	FETCH NEXT 
	FROM testInsertCursor
	INTO @tableID,@noOfRows

	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @tableName=(SELECT Name FROM Tables WHERE TableID=@tableID)

		SET @startAt=GETDATE()
		EXEC insert_table @noOfRows,@tableName
		SET @endAt=GETDATE()

		INSERT INTO TestRunTables VALUES (@testRunID,@tableID,@startAt,@endAt)

		FETCH NEXT 
		FROM testInsertCursor
		INTO @tableID,@noOfRows
	END

	CLOSE testInsertCursor
	DEALLOCATE testInsertCursor

	DECLARE testViewCursor CURSOR FOR
	SELECT ViewID
	FROM TestViews
	WHERE TestID=@testID

	OPEN testViewCursor

	FETCH NEXT 
	FROM testViewCursor
	INTO @viewID

	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @viewName=(SELECT Name FROM Views WHERE ViewID=@viewID)

		SET @startAt=GETDATE()
		EXEC select_view @viewName
		SET @endAt=GETDATE()

		INSERT INTO TestRunViews VALUES (@testRunID,@viewID,@startAt,@endAt)

		FETCH NEXT 
		FROM testViewCursor
		INTO @viewID
	END

	CLOSE testViewCursor
	DEALLOCATE testViewCursor

	UPDATE TestRuns
	SET EndAt=GETDATE()
	WHERE TestRunID=@testRunID

END
GO

EXEC mainTest 1
EXEC mainTest 2
EXEC mainTest 3

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

select * from EmployeeShifts
select * from StaffShifts
select * from StoreLocations