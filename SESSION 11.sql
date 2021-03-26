USE Harry;
GO

CREATE TABLE Entity.AccountContact
(
   AccountContactId INT NOT NULL PRIMARY KEY,
   AccountId CHAR(4) NOT NULL,
   PrimaryContactFlag BIT NOT NULL
);
GO

SELECT AccountId, SUM(CASE WHEN PrimaryContactFlag = 1 THEN 1 ELSE 0 END) AS COUNT
FROM Entity.AccountContact
GROUP BY AccountId
HAVING SUM(CASE WHEN PrimaryContactFlag = 1 THEN 1 ELSE 0 END) <> 1;
GO

CREATE TRIGGER Entity.AccountContact_TriggerAfterInsertUpdate
ON Entity.AccountContact
AFTER INSERT, UPDATE
AS
    SET NOCOUNT ON;
	SET ROWCOUNT 0;
	BEGIN TRY
	   IF EXISTS (SELECT AccountId  FROM Entity.AccountContact
	              WHERE EXISTS ( SELECT * FROM inserted WHERE inserted.AccountId = AccountContact.AccountId
				  UNION ALL
				  SELECT * FROM deleted WHERE deleted.AccountId = AccountContact.AccountId
				  )
			GROUP BY AccountId
			HAVING SUM(CASE WHEN PrimaryContactFlag = 1 THEN 1 ELSE 0 END) <>1)
			THROW 50000, 'Accounts do not have only one primary contact.', 1;
	END TRY
	BEGIN CATCH
	     IF XACT_STATE() <>0
		    ROLLBACK TRANSACTION;
			THROW;
	END CATCH
	GO

INSERT INTO Entity.AccountContact(AccountContactId, AccountId, PrimaryContactFlag)
VALUES (1,1,1);

INSERT INTO Entity.AccountContact(AccountContactId, AccountId, PrimaryContactFlag)
VALUES (2,2,1), (3,3,3);

INSERT INTO Entity.AccountContact(AccountContactId, AccountId, PrimaryContactFlag)
VALUES (4,4,1), (5,4,0);

INSERT INTO Entity.AccountContact(AccountContactId, AccountId, PrimaryContactFlag)
VALUES (6,5,1),(7,5,1);
GO

INSERT INTO Entity.AccountContact(AccountContactId, AccountId, PrimaryContactFlag)
VALUES (8,6,8), (9,6,0);
GO

SELECT * FROM Entity.AccountContact;
GO


CREATE TABLE Entity.Promise
(
   PromiseId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
   PromiseAmount MONEY NOT NULL
);
GO

CREATE TABLE Entity.VerifyPromise
(
    VerifyPromiseId INT NOT NULL PRIMARY KEY,
	PromiseId INT NOT NULL UNIQUE
);
GO

DROP TABLE Entity.VerifyPromise;
GO

CREATE TABLE Entity.VerifyPromise
(
    VerifyPromiseId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	PromiseId INT NOT NULL UNIQUE
);
GO

CREATE TRIGGER Entity.Promise_TriggerInsertUpdate
ON Entity.Promise
AFTER INSERT, UPDATE
AS     
     SET NOCOUNT ON;
	 SET ROWCOUNT 0;
	 BEGIN TRY
	         INSERT INTO Entity.VerifyPromise
			 SELECT PromiseId
			 FROM inserted
			 WHERE PromiseAmount > 10000.00
			    AND NOT EXISTS (
				    SELECT * FROM VerifyPromise WHERE VerifyPromise.PromiseId = inserted.PromiseId
					 )
	 END TRY
	 BEGIN CATCH
	     IF XACT_STATE()<>0
		    ROLLBACK TRANSACTION;
		  THROW;
	  END CATCH
GO

INSERT INTO Entity.Promise VALUES (100);

INSERT INTO Entity.Promise VALUES (1000);

INSERT INTO Entity.Promise VALUES (10000);

INSERT INTO Entity.Promise VALUES (10001);
GO

SELECT * FROM Entity.Promise;
GO

SELECT * FROM Entity.VerifyPromise;
GO

CREATE TABLE Entity.Items
(
  ItemId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  Value VARCHAR(100) NOT NULL,
  RowCreatedDateTime DATETIME2(0) NOT NULL DEFAULT(SYSDATETIME()),
  RowLastModifiedDateTime DATETIME2(0) NOT NULL DEFAULT(SYSDATETIME())
);
GO


CREATE TRIGGER Entity.Items_TriggerInsteadOfInsert
ON Entity.Items
INSTEAD OF INSERT
AS
    SET NOCOUNT ON;
	SET ROWCOUNT 0;
	BEGIN TRY 
	        INSERT INTO Entity.Items ([Value])
			SELECT [Value] FROM inserted;
	END TRY
	BEGIN CATCH
	   IF XACT_STATE() <>0
	        ROLLBACK TRANSACTION;
			THROW
	END CATCH
GO

INSERT INTO Entity.Items (Value, RowCreatedDateTime, RowLastModifiedDateTime)
VALUES ('Monitor', '1900-01-01', '1900-01-01');
GO

INSERT INTO Entity.Items (Value, RowCreatedDateTime)
VALUES ('KEYBOARD', '1900-01-01');
GO


INSERT INTO Entity.Items (Value)
VALUES ('Laptop');
GO

SELECT * FROM Entity.Items;
GO

CREATE TRIGGER Entity.Items_TriggerInsteadOfUpdate
ON Entity.Items
INSTEAD OF UPDATE
AS
      SET NOCOUNT ON;
	  SET ROWCOUNT 0;
	  BEGIN TRY
	      UPDATE Entity.Items
		  SET Value = inserted.Value,
		  RowLastModifiedDateTime = DEFAULT
		  FROM Entity.Items JOIN inserted ON Items.ItemId = inserted.ItemId;
	 END TRY
	 BEGIN CATCH
	   IF XACT_STATE() <>0
	      ROLLBACK TRANSACTION;
		  THROW;
	END CATCH
GO

UPDATE Entity.Items
SET Value = '4k Monitor',
    RowCreatedDateTime = '1900-01-01',
	RowLastModifiedDateTime = '1900-01-01'
WHERE ItemId = 1;
GO

SELECT * FROM Entity.Items;
GO