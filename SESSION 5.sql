USE Harry;
GO

CREATE TABLE Entity.GadgetType
(
   GadgetType VARCHAR(10) NOT NULL PRIMARY KEY,
   Description VARCHAR(200) NOT NULL
);
GO

SELECT * FROM Entity.GadgetType;
GO

INSERT INTO Entity.GadgetType (GadgetType, Description)
VALUES ('Manual', 'No batteries'),
       ( 'Electronic', 'Lots of batteries');

ALTER TABLE Entity.Gadget
      ADD CONSTRAINT FKGadget_GadgetType
	  FOREIGN KEY (GadgetType) REFERENCES Entity.GadgetType (GadgetType);
GO

CREATE VIEW Entity.GadgetExtension
AS 
   SELECT Gadget.GadgetId, Gadget.GadgetNumber, Gadget.GadgetType,
          GadgetType.GadgetType AS DomainGadgetType, GadgetType.Description AS GadgetTypeDescription
   FROM Entity.Gadget JOIN Entity.GadgetType ON Gadget.GadgetType = GadgetType.GadgetType;
GO

SELECT * FROM Entity.GadgetExtension;
GO

INSERT INTO Entity.GadgetExtension(GadgetId, GadgetNumber, GadgetType, DomainGadgetType, GadgetTypeDescription)
VALUES(7, '00000007', 'Acoustic', 'Acoustic', 'Sound');
GO

--Both columns belong to GadgetType
INSERT INTO Entity.GadgetExtension(DomainGadgetType, GadgetTypeDescription)
VALUES('Acoustic', 'Sound');
VALUES('')
GO
--SELECT * FROM Entity.GadgetType;

--SELECT * FROM Entity.Gadget
INSERT INTO Entity.GadgetExtension(GadgetId, GadgetNumber, GadgetType)
VALUES(7,'00000007', 'Acoustic'),
      (8, '0000008', 'Manual');
GO

--UPDATE Specify which columns to modigy
UPDATE Entity.GadgetExtension
SET GadgetTypeDescription = 'Uses AA battries'
WHERE GadgetId = 8;

DELETE FROM Entity.GadgetExtension
WHERE GadgetId = 7;
GO

--Partitioned Views
CREATE TABLE Entity.Invoices_NorthAmerica
(
  InvoiceId INT NOT NULL PRIMARY KEY
  CONSTRAINT CHK_Invoices_PartKey CHECK (InvoiceId BETWEEN 1 AND 10000),
  CustomerId INT NOT NULL,
  InvoiceDate DATE NOT NULL
);
GO

CREATE TABLE Entity.Invoices_Europe
(
  InvoiceId INT NOT NULL PRIMARY KEY
  CONSTRAINT CHK_Invoices_PartKey2 CHECK (InvoiceId BETWEEN 10001 AND 20000),
  CustomerId INT NOT NULL,
  InvoiceDate DATE NOT NULL
);
GO

--IMPORT DATA FROM ANOTHER DATABASE
INSERT INTO	Entity.Invoices_NorthAmerica (InvoiceId, CustomerId, InvoiceDate)
SELECT InvoiceId, CustomerId, InvoiceDate
FROM WideWorldImporters.Sales.Invoices
WHERE InvoiceId BETWEEN 1 AND 10000;

INSERT INTO	Entity.Invoices_Europe (InvoiceId, CustomerId, InvoiceDate)
SELECT InvoiceId, CustomerId, InvoiceDate
FROM WideWorldImporters.Sales.Invoices
WHERE InvoiceId BETWEEN 10001 AND 20000;

SELECT * FROM Entity.Invoices_NorthAmerica;
SELECT * FROM Entity.Invoices_Europe;
GO

CREATE VIEW Entity.InvoicesPartitioned
AS
   SELECT InvoiceId, CustomerId, InvoiceDate
   FROM Entity.Invoices_NorthAmerica
   UNION ALL
   SELECT InvoiceId, CustomerId, InvoiceDate
   FROM Entity.Invoices_Europe;
GO

--Includes all the records from the two tables as if it was one table
-- Filtering by PRIMARY KEY uses only one index because PRIMARY KEYs become indexes
SELECT * FROM Entity.InvoicesPartitioned WHERE InvoiceId = 4000;
GO

--Filtering by any other non-indexed column will require more processing
SELECT * FROM Entity.InvoicesPartitioned WHERE InvoiceDate = '2013-01-03';
GO

USE WideWorldImporters;
GO

--VIEW WITH aggregate functions and count
CREATE VIEW Sales.InvoiceCustomerInvoiceAggregates
WITH SCHEMABINDING
AS
   SELECT Invoices.CustomerId,
          SUM(ExtendedPrice * Quantity) AS SumCost,
		  SUM(LineProfit) AS SumProfit,
		  COUNT_BIG(*) AS TotalItemCount
   FROM Sales.Invoices
                 JOIN Sales.InvoiceLines
				      ON Invoices.InvoiceID = InvoiceLines.InvoiceID
	GROUP BY Invoices.CustomerID;
GO

SELECT * FROM Sales.InvoiceCustomerInvoiceAggregates;
GO

CREATE UNIQUE CLUSTERED INDEX XPKInvoiceCustomerInvoiceAggregates ON Sales.InvoiceCustomerInvoiceAgrregates(CustomerID);
GO