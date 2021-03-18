USE Harry;
GO

CREATE TABLE Entity.WidgetList
(
    WidgetId INT NOT NULL PRIMARY KEY,
	RowLastModifiedTime DATETIME2(0)  NULL
);
GO

DROP TABLE Entity.WidgetList;
GO

CREATE TABLE Entity.WidgetList
(
  WidgetId INT NOT NULL PRIMARY KEY,
  RowLastModifiedTime DATETIME2(0) NOT NULL
);
GO

DROP TABLE Entity.WidgetList;
GO

CREATE TABLE Entity.WidgetList
(
  WidgetListId INT CONSTRAINT PKWidgetList PRIMARY KEY,
  RowLastModifiedTime DATETIME2(0) NOT NULL
);
GO

INSERT INTO Entity.WidgetList (WidgetListId, RowLastModifiedTime)
VALUES (1, SYSDATETIME());
INSERT INTO Entity.WidgetList (WidgetListId)
VALUES (1);

ALTER TABLE Entity.WidgetList
  ADD CONSTRAINT DFLTWidgetList_RowLastModifiedTime
     DEFAULT (SYSDATETIME()) FOR RowLastModifiedTime;
GO

--SELECT * FROM Entity.WidgetList;

INSERT INTO Entity.WidgetList(WidgetListId)
VALUES (2);
INSERT INTO Entity.WidgetList(WidgetListId)
VALUES (3);
GO

--SELECT * FROM Entity.WidgetList;

UPDATE Entity.WidgetList
SET RowLastModifiedTime = DEFAULT;
GO

ALTER TABLE Entity.WidgetList
      ADD EnabledFlag BIT NOT NULL CONSTRAINT DFLTWidgetList_EnabledFlag DEFAULT(1);

CREATE TABLE Entity.AllDefaulted
(
   AllDefaultedId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
   RowCreatedTime DATETIME2(0) NOT NULL CONSTRAINT DFLTAllDefaulted_RowCreatedTime DEFAULT (SYSDATETIME()),
   RowModifiedTime DATETIME2(0) NOT NULL CONSTRAINT DFLTAllDefaulted_RowModifiedTime DEFAULT (SYSDATETIME())
);
GO



INSERT INTO Entity.AllDefaulted
DEFAULT VALUES;
GO

SELECT * FROM Entity.AllDefaulted;
GO

DROP TABLE Entity.Gadget;
GO

CREATE TABLE Entity.Gadget
(
    GadgetId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	GadgetCode VARCHAR(10) NOT NULL
);
GO

INSERT INTO Entity.Gadget(GadgetCode)
VALUES ('Gadget'), ('Gadget'), ('Gadget');
GO

SELECT * FROM Entity.Gadget;
GO

DELETE FROM Entity.Gadget WHERE GadgetId in (2,3);
GO

ALTER TABLE Entity.Gadget
   ADD CONSTRAINT AKGadget UNIQUE (GadgetCode);
GO

SELECT * FROM Entity.Gadget;
GO

INSERT INTO Entity.Gadget(GadgetCode)
VALUES ('Widget'), ('Box'), ('Packet');
GO




CREATE TABLE Entity.GroceryItem
(
  ItemCost SMALLMONEY NULL
       CONSTRAINT CHKGroceryItem_ItemCost_ValidRange CHECK (ItemCost >0 AND ItemCost <1000)
);
GO

INSERT INTO Entity.GroceryItem
VALUES (3000.95);
GO

INSERT INTO Entity.GroceryItem
VALUES (100.95);
GO


CREATE TABLE Entity.Message
(
   MessageTag CHAR(5) NOT NULL,
   Comment NVARCHAR(MAX) NULL
);
GO

SELECT * FROM Entity.Message;
GO

ALTER TABLE Entity.Message
  ADD CONSTRAINT CHKMessage_MessageTagFormat CHECK (MessageTag LIKE '[A-Z]-[0-9][0-9][0-9]');
GO

ALTER TABLE Entity.Message
     ADD CONSTRAINT CHKMessage_CommentNotEmpty CHECK (LEN(COMMENT) > 0);
GO

SELECT * FROM Entity.Message;
GO

INSERT INTO Entity.Message (MessageTag, Comment)
VALUES ('Bad', '');
GO

INSERT INTO Entity.Message (MessageTag, Comment)
VALUES ('H-123', 'From Canada');
GO

SELECT * FROM Entity.Message;
GO

CREATE TABLE Entity.Customer
(
    ForcedDisabledFlag BIT NOT NULL,
	ForcedEnabledFlag BIT NOT NULL,
	CONSTRAINT CHKCustomer_ForcedStatusFlagCheck CHECK (NOT (ForcedDisabledFlag = 1 AND ForcedEnabledFlag = 1))
);
GO

DROP TABLE Entity.Customer;
GO

CREATE TABLE Entity.Customer
(
    ForcedDisabledFlag BIT NOT NULL,
	ForcedEnabledFlag BIT NOT NULL,
	CONSTRAINT CHKCustomer_ForcedStatusFlagCheckTrue CHECK (NOT (ForcedDisabledFlag = 1 AND ForcedEnabledFlag = 1)),
	CONSTRAINT CHKCustomer_ForcedStatusFlagCheckFalse CHECK (NOT (ForcedDisabledFlag = 0 AND ForcedEnabledFlag = 0))
);
GO

SELECT * FROM Entity.Customer;
GO

INSERT INTO Entity.Customer (ForcedDisabledFlag, ForcedEnabledFlag)
VALUES ('1', '1');
GO
INSERT INTO Entity.Customer (ForcedDisabledFlag, ForcedEnabledFlag)
VALUES ('0', '0');
GO

INSERT INTO Entity.Customer (ForcedDisabledFlag, ForcedEnabledFlag)
VALUES ('0', '1');
GO


SELECT * FROM Entity.Customer;
GO

