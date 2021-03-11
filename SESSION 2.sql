USE Harry;

CREATE TABLE Entity.UniquenessConstraint
(
	PrimaryUniqueValue INT NOT NULL,
	AlternateUniqueValue1 INT NULL,
	AlternateUniqueValue2 INT NULL
);

INSERT INTO Entity.UniquenessConstraint VALUES (1,1,1);
INSERT INTO Entity.UniquenessConstraint VALUES (2,1,1);
INSERT INTO Entity.UniquenessConstraint VALUES (3,1,1);
-- SELECT * FROM Entity.UniquenessConstraint;
-- DELETE FROM Entity.UniquenessConstraint;

ALTER TABLE Entity.UniquenessConstraint
	ADD CONSTRAINT PKUniquenessConstraint PRIMARY KEY (PrimaryUniqueValue);
	
CREATE TABLE Entity.Invoice
(
	InvoiceId INT NOT NULL CONSTRAINT PKInvoice PRIMARY KEY
);
GO

CREATE TABLE Entity.DiscountType
(
	DiscountTypeId INT NOT NULL CONSTRAINT PKDiscountType PRIMARY KEY
);
GO
-- DROP TABLE IF EXISTS Entity.InvoiceLineItem;
CREATE TABLE Entity.InvoiceLineItem
(
	InvoiceLineItemId INT NOT NULL CONSTRAINT PKInvoiceLineItem PRIMARY KEY,
	InvoiceId INT NOT NULL CONSTRAINT FKInvoiceLineItem_Ref_Invoice REFERENCES Entity.Invoice (InvoiceId),
	DiscountTypeId INT NULL CONSTRAINT FKInvoiceLineItem_Ref_DiscountType REFERENCES Entity.DiscountType (DiscountTypeId)
);
GO

CREATE INDEX IDX_InvoiceLineItem_InvoiceId ON Entity.InvoiceLineItem (InvoiceId);
GO

CREATE INDEX IDX_InvoiceLineItem_DiscountTypeId ON Entity.InvoiceLineItem (DiscountTypeId)
	WHERE DiscountTypeId IS NOT NULL;
GO

CREATE UNIQUE INDEX IDX_InvoiceLineItem_InvoiceColumns ON Entity.InvoiceLineItem (InvoiceId, InvoiceLineItemId);
GO;

SELECT * FROM Entity.InvoiceLineItem WHERE DiscountTypeId IS NULL;
SELECT * FROM Entity.InvoiceLineItem WHERE DiscountTypeId = 100;

USE [WideWorldImporters];
GO

SELECT *
FROM Sales.CustomerTransactions
WHERE PaymentMethodID = 4;

-- CREATING RECOMMENDED INDEX
CREATE NONCLUSTERED INDEX IDX_CustomerTransactions_PaymentMethodId
ON [Sales].[CustomerTransactions] ([PaymentMethodID])
INCLUDE ([CustomerTransactionID],[CustomerID],[TransactionTypeID],[InvoiceID],[AmountExcludingTax],[TaxAmount],[TransactionAmount],[OutstandingBalance],[FinalizationDate],[IsFinalized],[LastEditedBy],[LastEditedWhen])
GO

-- STOPPING POINT ON SLIDES 1.2 PAGE 27