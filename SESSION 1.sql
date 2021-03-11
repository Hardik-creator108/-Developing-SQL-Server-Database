CREATE DATABASE Harry;
GO

USE Harry;
GO

--Create a sample schema
CREATE SCHEMA Entity;
GO

CREATE TABLE Entity.Widget
(
       WidgetCode VARCHAR(10) NOT NULL
	         CONSTRAINT PKWidget PRIMARY KEY,
	   WidgetName VARCHAR(100) NULL
);
GO

CREATE TABLE Entity.Widget
(
      WidgetCode VARCHAR(10) NOT NULL,
	  WidgetName VARCHAR(100) NULL,
	  CONSTRAINT PKWidget PRIMARY KEY (WidgetCode)
);
GO

ALTER TABLE Entity.Widget
  
       ADD NotNullableColumn INT NOT NULL
	   CONSTRAINT DFT_NotNullable DEFAULT ('SOME VALUE');
GO

ALTER TABLE Entity.Widget
      DROP CONSTRAINT DFT_NotNullable;
GO

ALTER TABLE Entity.Widget
       DROP COLUMN NotNullableColumn;
GO

