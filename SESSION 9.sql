USE Harry;
GO


CREATE TABLE Entity.SimpleTable
(
 SimpleTable INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 Value1 VARCHAR(20) NOT NULL,
 Value2 VARCHAR(20) NOT NULL
);
GO

DROP TABLE Entity.SimpleTable;
GO

CREATE TABLE Entity.SimpleTable
(
 SimpleTableiD INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 Value1 VARCHAR(20) NOT NULL,
 Value2 VARCHAR(20) NOT NULL
);
GO

CREATE PROCEDURE Entity.SimpleTable_Insert
   @Value1 VARCHAR(20),
   @Value2 VARCHAR(20)
AS
   INSERT INTO Entity.SimpleTable (value1, Value2) VALUES (@Value1, @Value2);
GO

CREATE PROCEDURE Entity.SimpleTable_Update
 @SimpleTableId INT,
 @Value1 VARCHAR(20),
 @Value2 VARCHAR(20)
AS
  SET NOCOUNT ON;
  UPDATE Entity.SimpleTable
      SET Value1 = @Value1,
	      Value2 = @Value2
	 WHERE SimpleTableiD = @SimpleTableId;
GO

CREATE PROCEDURE Entity.SimpleTable_Delete
    @SimpleTableId INT
AS 
   DELETE FROM Entity.SimpleTable
   WHERE SimpleTableiD = @SimpleTableId;
GO

CREATE PROCEDURE Entity.SimpleTable_Select
AS
   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   ORDER BY Value1;
GO

CREATE PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorz
AS
   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   ORDER BY Value1;
GO

DROP PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorz
GO

CREATE PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorz
AS
   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   ORDER BY Value1;

   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   WHERE Value1 LIKE 'Z%'
   ORDER BY Value1 DESC;
GO

DROP PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorz;
GO

CREATE PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorz
AS
   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   WHERE Value1 LIKE 'Q%'
   ORDER BY Value1;

   SELECT SimpleTableiD, Value1, Value2
   FROM Entity.SimpleTable
   WHERE Value1 LIKE 'Z%'
   ORDER BY Value1 DESC;
GO

CREATE PROCEDURE Entity.SimpleTable_SelectValue1StartWithQorzOnWeekday
AS
  IF DATENAME(weekday, getdate()) NOT IN ('Saturday', 'Sunday')
      SELECT SimpleTableiD, Value1, Value2
	  FROM Entity.SimpleTable
	  WHERE Value1 LIKE '[QZ]%'
	  Order BY Value1;
GO

EXECUTE Entity.SimpleTable_Select;
EXECUTE Entity.SimpleTable_SelectValue1StartWithQorz;


CREATE TABLE Entity.Parameter
(
  ParameterId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  Value1 VARCHAR(20) NOT NULL,
  Value2 VARCHAR(20) NOT NULL
);
GO

CREATE PROCEDURE Entity.Parameter_Insert
    @Value1 VARCHAR(20) = 'NO ENTRY GIVEN',
	@value2 VARCHAR(20) = 'NO ENTRY GIVEN'
AS
   SET NOCOUNT ON;
   INSERT INTO Entity.Parameter (Value1, Value2) VALUES (@Value1, @value2);
GO

EXEC Entity.Parameter_Insert;

EXEC Entity.Parameter_Insert 'My parameter 1';

EXEC Entity.Parameter_Insert 'My parameter 1', 'My parameter2';

EXEC Entity.Parameter_Insert @Value1 = 'Param1';

SELECT * FROM Entity.Parameter;
GO


ALTER PROCEDURE Entity.Parameter_Insert
   @Value1 VARCHAR(20) = 'NO ENTRY GIVEN',
   @Value2 VARCHAR(20) = 'NO ENTRY GIVEN' OUTPUT,
   @NewParameterId INT = NULL OUTPUT
AS
    SET NOCOUNT ON;
	SET @Value1 = UPPER(@Value1);
	SET @Value2 = LOWER(@Value2);

	INSERT INTO Entity.Parameter (Value1, Value2) VALUES (@Value1, @Value2);

	SET @NewParameterId = SCOPE_IDENTITY();
GO


DECLARE @Value1 VARCHAR(20) = 'Test Value1',
        @Value2 VARCHAR(20) = 'Test Value2',
		@NewParameterId INT = -200;

SELECT @NewParameterId, @Value1, @Value2;

EXEC Entity.Parameter_Insert @Value1, @Value2 OUTPUT, @NewParameterId OUTPUT;

SELECT @NewParameterId, @Value1, @Value2;

SELECT * FROM Entity.Parameter;
GO





   



