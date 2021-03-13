USE WideWorldImporters;
GO

SELECT TOP 100 * FROM Sales.Orders12MonthsMultipleItems;

SELECT PersonId, IsPermittedToLogon, IsEmployee, IsSalesPerson
 FROM [Application].People
 GO

 CREATE VIEW [Application].PeopleEmployeeStatus
 AS
 SELECT PersonId, IsPermittedToLogon, IsEmployee, IsSalesPerson,
       CASE WHEN IsPermittedToLogon = 1 THEN 'Can Logon'
	        ELSE 'Can''t LogOn' END AS LogonRights,
        CASE WHEN IsEmployee = 1 AND IsSalesPerson = 1 THEN 'Sales Person'
		    When IsEmployee = 1 AND IsSalesPerson = 0 THEN 'Regular'
			ELSE 'Not an Employee' END AS EmployeeType
FROM [Application].People;
GO

SELECT * FROM [Application].PeopleEmployeeStatus;

CREATE SCHEMA REPORT
GO

CREATE VIEW Reports.InvoiceSummaryBasis
AS
SELECT Invoices.InvoiceId, CustomerCategories.CustomerCategoryName,
       Cities.CityName, StateProvinces.StateProvinceName,
	   StateProvinces.SalesTerritory,
	   Invoices.InvoiceDate,
	   SUM(InvoiceLines.LineProfit) AS InvoiceProfit,
	   SUM(InvoiceLines.ExtendedPrice) AS InvoiceExtendedPrice
FROM Sales.Invoices JOIN Sales.InvoiceLines ON Invoices.InvoiceID = InvoiceLines.InvoiceID
     JOIN Sales.Customers ON Customers.CustomerID = Invoices.CustomerID
	 JOIN Sales.CustomerCategories ON Customers.CustomerCategoryID = CustomerCategories.CustomerCategoryID
	 JOIN Application.Cities ON Customers.DeliveryCityID = Cities.CityID
	 JOIN Application.StateProvinces ON StateProvinces.StateProvinceID = Cities.StateProvinceID
GROUP BY Invoices.InvoiceID, CustomerCategories.CustomerCategoryName,
         Cities.CityName, StateProvinces.StateProvinceName,
		 StateProvinces.SalesTerritory,
		 Invoices.InvoiceDate;
GO

SELECT * FROM Reports.InvoiceSummaryBasis;

USE Harry
GO

CREATE TABLE Entity.Gadget
(
    GadgetId INT NOT NULL CONSTRAINT PKGadget PRIMARY KEY,
	GadgetNumber CHAR(8) NOT NULL CONSTRAINT AKGadget UNIQUE,
	GadgetType VARCHAR(10) NOT NULL
);
GO

INSERT INTO Entity.Gadget(GadgetId, GadgetNumber, GadgetType)
VALUES  (1, '00000001', 'Electronic	'),
        (2, '00000002', 'Manual'),
		(3, '00000003', 'Manual');
GO

CREATE VIEW Entity.ElectronicGadget
AS
  SELECT GadgetId, GadgetNumber, GadgetType,
       UPPER(GadgetType) AS UpperGadgetType
  FROM Entity.Gadget
  WHERE GadgetType = 'Electronic';
GO

SELECT * FROM Entity.Gadget;
GO
SELECT * FROM Entity.ElectronicGadget;
GO
SELECT ElectronicGadget.GadgetNumber as FromView, Gadget.GadgetNumber as FromTable,
       Gadget.GadgetType, ElectronicGadget.UpperGadgetType
FROM Entity.ElectronicGadget
     FULL OUTER JOIN Entity.Gadget
	      ON ElectronicGadget.GadgetId = Gadget.GadgetId;
GO

INSERT INTO Entity.ElectronicGadget(GadgetId, GadgetName, GadgetType)
             VALUES (4, '00000004', 'Electronic'),
			        (5, '00000005', 'Manual');
GO

ALTER VIEW Entity.ElectronicGadget
AS
   SELECT GadgetId, GadgetNumber, GadgetType, UPPER(GadgetType) AS UpperGadgetType
   FROM ENtity.Gadget
   WHERE GadgetType = 'Electronic'
   WITH CHECK OPTION;
GO

SELECT * FROM Entity.ElectronicGadget;
GO

INSERT INTO Entity.ElectronicGadget(GadgetId, GadgetNumber, GadgetType)
VALUES (6, '00000006', 'Manual');
GO