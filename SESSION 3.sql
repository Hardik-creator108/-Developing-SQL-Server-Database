USE WideWorldImporters;
GO

SELECT CustomerId, OrderId, OrderDate, ExpectedDeliveryDate
FROM Sales.Orders
WHERE CustomerPurchaseOrderNumber = '16374'

USE [WideWorldImporters]
GO
CREATE NONCLUSTERED INDEX IDX_Orders_CustomerPurchaseOrderNumber
ON [Sales].[Orders] ([CustomerPurchaseOrderNumber])
GO

SELECT SalespersonPersonId, Orderdate
FROM Sales.Orders
ORDER BY SalespersonPersonId ASC, OrderDate DESC

CREATE INDEX IDX_Orders_SalespersonPersonID_OrderDate
ON Sales.Orders (SalespersonPersonId ASC, OrderDate DESC)
GO

SELECT OrderId, OrderDate, ExpectedDeliveryDate, People.FullName
FROM Sales.Orders  
       JOIN [Application].People
	         ON People.PersonID = Orders.ContactPersonID
Where People.PreferredName = 'Aakriti';

--INDEXED COLUMN
USE [WideWorldImporters]
GO

CREATE NONCLUSTERED INDEX IDX_People_PreferredName
ON [Application].[People] ([PreferredName])
GO

CREATE NONCLUSTERED INDEX IDX_ContactPersonId_Include_OrderDate_ExpectedDeliveryDate
ON Sales.Orders (ContactPersonId)
INCLUDE (OrderDate, ExpectedDeliveryDate)
ON USERDATE; -- THE PLACE WHERE THESE INCLUDED COLUMNS ARE SAVED
GO

--DROP INDEX IDX_People_PreferredName ON [Application].People;
CREATE NONCLUSTERED INDEX IDX_People_PreferredName
ON [Application].People (PreferredName)
INCLUDE (FullName)
ON USERDATA;
GO


CREATE VIEW sales.Orders12MonthsMultipleItems
AS
SELECT OrderId, CustomerId, SalespersonPersonId, OrderDate, ExpectedDeliveryDate
FROM Sales.Orders
WHERE OrderDate >= DATEADD(Month, -12, '2016-12-31')
AND (SELECT Count(*) FROM Sales.OrderLines WHERE OrderLines.OrderId = Orders.OrderId) > 1;
GO

SELECT * FROM Sales.Orders12MonthsMultipleItems

