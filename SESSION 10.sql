USE Harry;
GO

CREATE TABLE Entity.ErrorTesting
(
   ErrorTestingId INT NOT NULL CONSTRAINT PKErrorTesting PRIMARY KEY,
   PositiveInteger INT NOT NULL
           CONSTRAINT CHKErrorTesting_PositiveInteger CHECK (PositiveInteger > 0)
);
GO

CREATE PROCEDURE Entity.ErrorTesting_InsertTwo
AS
   SET NOCOUNT ON;
   DECLARE @Location nvarchar(30);

     BEGIN TRY 
	      SET @Location = 'First statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (6,3);

		  SET @Location = 'Second statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (7,-1);

		  SET @Location = 'First statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (8,1);
	END TRY

	   BEGIN CATCH 
	         SELECT ERROR_PROCEDURE() AS ErrorProcedure, @Location AS ErrorLocation
			 SELECT ERROR_MESSAGE() AS ErrorMessage;
			 SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
			        ERROR_LINE() AS ErrorLine;
	   END CATCH
GO

DROP PROCEDURE Entity.ErrorTesting_InsertTwo;
GO

CREATE PROCEDURE Entity.ErrorTesting_InsertTwo
AS
   SET NOCOUNT ON;
   DECLARE @Location nvarchar(30);

     BEGIN TRY 
	      SET @Location = 'First statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (6,3);

		  SET @Location = 'Second statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (7,-1);

		  SET @Location = 'First statement';
		  INSERT INTO Entity.ErrorTesting(ErrorTestingId, PositiveInteger)
		  VALUES (8,1);
	END TRY

	   BEGIN CATCH 
	         SELECT ERROR_PROCEDURE() AS ErrorProcedure, @Location AS ErrorLocation
			 SELECT ERROR_MESSAGE() AS ErrorMessage;
			 SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
			        ERROR_LINE() AS ErrorLine;
	   END CATCH
GO

EXECUTE Entity.ErrorTesting_InsertTwo;
GO

CREATE TABLE Entity.Worker
(
  WorkerId INT NOT NULL IDENTITY(1,1) CONSTRAINT PKWorker PRIMARY KEY,
  WorkerName nvarchar(50) NOT NULL CONSTRAINT AKWorker UNIQUE
);
GO

CREATE TABLE Entity.WorkerAssignment 
(
   WorkerAssignmentId INT IDENTITY(1,1) CONSTRAINT PKWorkerAssignment PRIMARY KEY,
   WorkerId INT NOT NULL,
   CompanyName NVARCHAR(50) NOT NULL
   CONSTRAINT CHKWorkerAssignment_CompanyName CHECK (CompanyName<> 'Contoso, Ltd.'),
   CONSTRAINT AKWorkerAsignment UNIQUE (WorkerId, CompanyName)
);
GO

CREATE PROCEDURE Entity.Worker_AddWithAssignment
    @WorkerName nvarchar(50),
	@CompanyName nvarchar(50)
AS
   SET NOCOUNT ON;

   IF @WorkerName IS NULL OR @CompanyName IS NULL
   THROW 50000, 'Both parameters must be not null', 1;

DECLARE @Location nvarchar(30), @NewWorkerId INT;
BEGIN TRY
         BEGIN TRANSACTION;

		 SET @Location = 'Creating Worker Row';
		 INSERT INTO Entity.Worker(WorkerName)
		 VALUES (@WorkerName);

		 SELECT @NewWorkerId = SCOPE_IDENTITY(),
		        @Location = 'Creating WorkerAssignment Row';

		 INSERT INTO Entity.WorkerAssignment(WorkerId, CompanyName)
		 VALUES (@NewWorkerId, @CompanyName);

		 COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	       IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

		   DECLARE @ErrorMessage nvarchar(4000);
		   SET @ErrorMessage = CONCAT('Error occured during : ''', @Location, '''', 'System Error: ', ERROR_NUMBER(), ':', ERROR_MESSAGE
		   ());
	THROW 50000, @ErrorMessage, 1;
END CATCH;
GO


EXEC Entity.Worker_AddWithAssignment @Workername = NULL, @CompanyName = NULL;
GO

EXEC Entity.Worker_AddWithAssignment @WorkerName ='David So', @CompanyName='Margie''s Travel';
GO

EXEC Entity.Worker_AddWithAssignment @WorkerName='David so', @CompanyName='Margie''s Travel';
GO

EXEC Entity.Worker_AddWithAssignment  @WorkerName='Iam Palangio', @CompanyName = 'Contoso, Ltd.';
EXEC Entity.Worker_AddWithAssignment  @WorkerName='Iam Palangio', @CompanyName = 'Humongeous Insurance';
GO

SELECT * FROM Entity.Worker;
SELECT * FROM Entity.WorkerAssignment;
GO
