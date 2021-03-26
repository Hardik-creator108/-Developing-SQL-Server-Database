USE Harry;
GO

USE WideWorldImporters;
GO

CREATE FUNCTION Sales.Customers_ReturnOrderCount
(
  @CustomerID int,
  @OrderDate date = null
)
RETURNS INT
WITH RETURNS NULL ON NULL INPUT,
SCHEMABINDING
AS
   BEGIN DECLARE @OutputValue int

   SELECT @OutputValue = COUNT(*)
   FROM Sales.Orders
   WHERE CustomerID = @CustomerID
      AND (OrderDate = @OrderDate OR @OrderDate IS NULL);

	   RETURN @OutputValue
 END;
GO

SELECT Sales.Customers_ReturnOrderCount(905,'2013-01-01');
GO

SELECT Sales.Customers_ReturnOrderCount(905, DEFAULT);
GO

SELECT CustomerID, Sales.Customers_ReturnOrderCount(CustomerID, DEFAULT) AS ALLORDERS
FROM Sales.Customers;
GO


SELECT N'CPO' + RIGHT (N'00000000' + CustomerPurchaseOrderNumber, 8), CustomerPurchaseOrderNumber
FROM Sales.Orders;
GO

CREATE FUNCTION Sales.Orders_ReturnFormattedCPO
(
   @CustomerPurchaseOrderNumber nvarchar(20)
)
RETURNS nvarchar(20)
WITH RETURNS NULL ON NULL INPUT
AS
   BEGIN
       RETURN (N'CPO' + RIGHT (N'00000000' + @CustomerPurchaseOrderNumber, 8));
   END;
GO

SELECT Sales.Orders_ReturnFormattedCPO('12345')as CustomerPurchaseOrderNumber;
GO

SELECT Sales.Orders_ReturnFormattedCPO('12345678')as CustomerPurchaseOrderNumber;
GO

SELECT ORDERId, CustomerPurchaseOrderNumber, Sales.Orders_ReturnFormattedCPO(CustomerPurchaseOrderNumber)
FROM Sales.Orders
WHERE Sales.Orders_ReturnFormattedCPO(CustomerPurchaseOrderNumber) = 'CPO00019998';
GO

CREATE FUNCTION Sales.Customers_ReturnOrderCountSetSimple
(
   @CustomerID int,
   @OrderDate date null
)
RETURNS TABLE
AS
RETURN ( SELECT COUNT(*) AS SalesCount,
                 CASE WHEN MAX(BackorderOrderID) IS NOT NULL   
				            THEN 1 ELSE 0 END AS HasBackOrderFlag
		 FROM Sales.Orders
		 WHERE CustomerID = @CustomerID
		 AND   (OrderDate = @OrderDate
		               OR @OrderDate IS NULL));
GO

SELECT * FROM Sales.Customers_ReturnOrderCountSetSimple(905,'2013-01-01');
GO

SELECT * FROM Sales.Customers_ReturnOrderCountSetSimple(905,DEFAULT);
GO

SELECT CustomerId, FirstDaySales.SalesCount, FirstDaySales.HasBackorderFlag
FROM Sales.Customers
     OUTER APPLY Sales.Customers_ReturnOrderCountSetSimple
	           (CustomerId, AccountOpenedDate) as FirstDaySales
WHERE FirstDaySales.SalesCount > 0;
GO

CREATE FUNCTION Sales.Customers_ReturnOrderCountSetMulti
(
    @CustomerID INT,
	@OrderDate DATE = NULL
)
RETURNS @OutputValue TABLE (SalesCount int not null,
							 HasBackorderFlag BIT NOT NULL)
AS
   BEGIN 
       INSERT INTO @OutputValue (SalesCount, HasBackorderFlag)
	   SELECT COUNT(*) AS SalesCount,
	            CASE WHEN MAX(BackorderOrderId) IS NOT NULL
				       THEN 1 ELSE 0 END AS HasBackorderFlag
	   FROM Sales.Orders
	   WHERE CustomerID = @CustomerID
	   AND (OrderDate = @OrderDate  OR @OrderDate is null)

	   RETURN;
END;
GO

SELECT CustomerId, FirstDaySales.SalesCount, FirstDaySales.HasBackorderFlag
FROM Sales.Customers
    OUTER APPLY Sales.Customers_ReturnOrderCountSetMulti(CustomerId, AccountOpenedDate) as FirstDaySales
WHERE FirstDaySales.SalesCount > 0;
GO