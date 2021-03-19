USE Harry;
GO



CREATE TABLE Entity.Invoice1
(
   Invoice1Id INT NOT NULL PRIMARY KEY
);
GO



DROP TABLE Entity.InvoiceLineItem;
GO

CREATE TABLE Entity.InvoiceLineItem
(
   InvoiceLineItemId INT NOT NULL PRIMARY KEY,
   InvoiceLineNUmber SMALLINT NOT NULL,
   Invoice1Id INT NOT NULL
   CONSTRAINT FKInvoiceLineItem_Ref_Invoice1
     REFERENCES Entity.Invoice1 (Invoice1Id)
	 ON DELETE CASCADE
	 ON UPDATE NO ACTION,
	 CONSTRAINT AKInvoiceLineItemCombination UNIQUE (Invoice1Id, InvoiceLineNumber)
);
GO


INSERT INTO Entity.Invoice1 (Invoice1Id) VALUES (1), (2), (3);

INSERT INTO Entity.InvoiceLineItem (InvoiceLineItemId, Invoice1Id, InvoiceLineNUmber)
VALUES (1,1,1), (2,1,2), (3,2,1);

SELECT * FROM Entity.Invoice1
     FULL OUTER JOIN Entity.InvoiceLineItem ON Invoice1.Invoice1Id = InvoiceLineItem.Invoice1Id;
GO

DELETE Entity.Invoice1 WHERE Invoice1Id = 1;

UPDATE Entity.Invoice1 SET Invoice1Id = 4 WHERE Invoice1Id = 1;

---catalog Table to store unique codes

CREATE TABLE Entity.Code
(
 Code VARCHAR(10) NOT NULL PRIMARY KEY
);
GO

CREATE TABLE Entity.CodedItem
(
  Code VARCHAR(10) NOT NULL
     CONSTRAINT FKCodedItem_Ref_Code
	    REFERENCES Entity.Code (Code)
		  ON UPDATE CASCADE
);
GO

INSERT INTO Entity.Code (Code) VALUES ('Black');

INSERT INTO Entity.CodedItem (Code) VALUES ('Black');

SELECT Code.Code, CodedItem.Code AS CodedItemCode
FROM Entity.Code FULL OUTER JOIN Entity.CodedItem ON Code.Code = CodedItem.Code;
GO

   
