USE Harry;
GO

CREATE TABLE Entity.Parent
(
    ParentId INT NOT NULL PRIMARY KEY
);
GO

CREATE TABLE Entity.Child
(
   ChildId INT NOT NULL PRIMARY KEY,
   ParentId INT NOT NULL
);
GO

INSERT INTO Entity.Child VALUES(1,10)
--DELETE FROM Entity.Child;
SELECT * FROM Entity.Parent;
SELECT * FROM Entity.Child;
GO


ALTER TABLE Entity.Child
     ADD CONSTRAINT FKChild_ParentId FOREIGN KEY (ParentId) REFERENCES Entity.Parent (ParentId);
GO

INSERT INTO Entity.Child VALUES(1,100);

INSERT INTO Entity.Parent VALUES (1), (2) , (3);
GO

INSERT INTO Entity.Child VALUES(1,1);
INSERT INTO Entity.Child VALUES(2,1);
INSERT INTO Entity.Child VALUES(3,2);
INSERT INTO Entity.Child VALUES(4,3);
INSERT INTO Entity.Child VALUES(5,3);
GO

SELECT * FROM Entity.Parent;
SELECT * FROM Entity.Child;
GO

CREATE TABLE Entity.TwoPartKey
(
    KeyColumn1 INT NOT NULL,
	KeyColumn2 INT NOT NULL,
	CONSTRAINT PKTwoPartKey PRIMARY KEY (KeyColumn1, KeyColumn2)
);
GO

CREATE TABLE Entity.TwoPartKeyReference
(
  RefKeyColumn1 INT NOT NULL,
  RefKeyColumn2 INT NOT NULL,
  CONSTRAINT FKTwoPartKeyReference FOREIGN KEY (RefKeyColumn1, RefKeyColumn2) REFERENCES Entity.TwoPartKey
);
GO


