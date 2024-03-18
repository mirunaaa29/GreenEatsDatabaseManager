use VeganFoodStore
go

INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('changeReviewDateType',0,1)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('removeWorkingHoursFromEmployee',1,2)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('addDefaultConstraintStaffShiftsTime',2,3)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('dropPrimaryKeyCustomersProducts',3,4)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('addCandidateKeyCustomersTable',4,5)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('addFKConstraintCustomerIdReviews',5,6)
INSERT INTO Previous_Versions(storedProcedure,versionFrom,versionTo) VALUES ('createPaidPartenershipTable',6,7)


--procedure that modifies version

CREATE OR ALTER PROCEDURE modifyVersion (@version INT)
AS
BEGIN

	DECLARE @current INT;
	SET @current=(SELECT currentVersion FROM Current_Version)

	
		BEGIN
	
		IF @version<0 OR @version>7
		BEGIN
			DECLARE @errorMsg VARCHAR(200)
			SET @errorMsg='Version has to be between 0 and 7'
			PRINT @errorMsg
			RETURN 
		END

		ELSE
		IF @version=@current
		BEGIN
			PRINT 'Already on this version!'
			RETURN 
		END	

		ELSE

		IF @version<@current
		BEGIN
			DECLARE @query VARCHAR(200)
			DECLARE @proc VARCHAR(50)
			DECLARE @vTo INT

			DECLARE versionCursor CURSOR SCROLL FOR
			SELECT storedProcedure,versionTo
			FROM Previous_Versions

			OPEN versionCursor
			PRINT 'Cursor opened'

			FETCH LAST
			FROM versionCursor
			INTO @proc,@vTo
			PRINT 'Fetched last'

			WHILE @vTo>@version AND @@FETCH_STATUS=0
			BEGIN
				IF @vTo<=@current
					BEGIN
					SET @query='undo_'+@proc
					EXEC @query
					PRINT 'Undo executed'
				
					UPDATE Current_Version SET currentVersion=@vTo-1
					PRINT 'Updated version'
				END
			
				FETCH PRIOR
				FROM versionCursor
				INTO @proc,@vTo
				PRINT 'Fetched prior'

			END

			IF(@version=0)
			BEGIN
				SET @query='undo_'+(SELECT storedProcedure FROM Previous_Versions WHERE versionFrom=0)
				EXEC @query
			END

			CLOSE versionCursor
			DEALLOCATE versionCursor
			PRINT 'Cursor deallocated'
		END
			
		ELSE
		BEGIN
			DECLARE @query2 VARCHAR(200)
			DECLARE @proc2 VARCHAR(50)
			DECLARE @vTo2 INT
			DECLARE @vFrom2 INT

			DECLARE versionCursor2 CURSOR FOR
			SELECT storedProcedure,versionTo,versionFrom
			FROM Previous_Versions

			OPEN versionCursor2
			PRINT 'Cursor opened'

			FETCH NEXT
			FROM versionCursor2
			INTO @proc2,@vTo2,@vFrom2
			PRINT 'Fetched first'

			WHILE @vFrom2<@version AND @@FETCH_STATUS=0
			BEGIN
				IF @vFrom2>=@current
					BEGIN
					SET @query2=@proc2
					EXEC @query2
					PRINT 'Do executed'
				
					UPDATE Current_Version SET currentVersion=@vFrom2+1
					PRINT 'Updated version'
				END
			
				FETCH NEXT
				FROM versionCursor2
				INTO @proc2,@vTo2,@vFrom2
				PRINT 'Fetched next'

			END

			

			CLOSE versionCursor2
			DEALLOCATE versionCursor2
			PRINT 'Cursor deallocated'
		END
	END
END
GO


EXEC modifyVersion 7
GO

SELECT * FROM Previous_Versions
SELECT * FROM Current_Version
GO

SELECT * FROM Employee