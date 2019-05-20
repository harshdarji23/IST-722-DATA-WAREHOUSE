/****** Object:  Database UNKNOWN    Script Date: 4/28/2019 6:26:15 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

Name: Harsh Darji	
Netid: hrdarji

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE UNKNOWN
GO
CREATE DATABASE UNKNOWN
GO
ALTER DATABASE UNKNOWN
SET RECOVERY SIMPLE
GO
*/
USE ist722_hrdarji_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA northwind
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.FactSales 
;



/* Drop table dbo.DimShipper */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimShipper') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimShipper 
;

/* Drop table dbo.FactOrderFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactOrderFulfillment 
;

/* Drop table northwind.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimCustomer 
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimDate 
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimProduct 
;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimEmployee') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.DimEmployee 
;


/* Create table northwind.DimCustomer */
CREATE TABLE northwind.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(5)   NOT NULL
,  [CompanyName]  nvarchar(40)   NOT NULL
,  [ContactName]  nvarchar(30)   NOT NULL
,  [ContactTitle]  nvarchar(30)   NOT NULL
,  [CustomerCountry]  nvarchar(15)   NOT NULL
,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
,  [CustomerCity]  nvarchar(15)   NOT NULL
,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimCustomer
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Customer', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimCustomer
exec sys.sp_addextendedproperty @name=N'Database Schema', @value=N'northwind', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimCustomer
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Customers dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimCustomer
;

SET IDENTITY_INSERT northwind.DimCustomer ON
;
INSERT INTO northwind.DimCustomer (CustomerKey, CustomerID, CompanyName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'NONE', 'No Customer', 'None', 'None', 'None', 'None', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Customer]'))
DROP VIEW [northwind].[Customer]
GO
CREATE VIEW [northwind].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CompanyName] AS [CompanyName]
, [ContactName] AS [ContactName]
, [ContactTitle] AS [ContactTitle]
, [CustomerCountry] AS [CustomerCountry]
, [CustomerRegion] AS [CustomerRegion]
, [CustomerCity] AS [CustomerCity]
, [CustomerPostalCode] AS [CustomerPostalCode]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimCustomer
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CompanyName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ContactName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ContactTitle', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerCountry', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerRegion', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerCity', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerPostalCode', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s company Name', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of contact at the company', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Contact''s job title', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Country of origin ', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'State or province', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s City', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s postal code', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'ALFKI', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Bon app''', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Pedro Alfanso', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Owner, Sales Rep.', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'USA', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'WA', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Seattle', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'13244', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TRUE, FALSE', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Customers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CustomerID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CompanyName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ContactName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ContactTitle', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Country', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Region', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'City', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'PostalCode', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
;





/* Drop table northwind.DimDate */
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--DROP TABLE northwind.DimDate 
;


/* Create table northwind.DimDate */
CREATE TABLE northwind.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimDate
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Date', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimDate
exec sys.sp_addextendedproperty @name=N'Database Schema', @value=N'northwind', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimDate
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Date dimension contains one row for every day, beginning at 1/1/2005. There may also be rows for "hasn''t happened yet."', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimDate
;

INSERT INTO northwind.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Date]'))
DROP VIEW [northwind].[Date]
GO
CREATE VIEW [northwind].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM northwind.DimDate
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DateKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'FullDateUSA', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfWeek', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfMonth', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfYear', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekOfYear', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthOfYear', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Quarter', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Year', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'IsWeekday', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Full date as a SQL date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'String expression of the full date, eg MM/DD/YYYY', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day of week; Sunday = 1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of week, eg Monday', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the month', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the year', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Week of year, 1..53', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Month name, eg January', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Month of year, 1..12', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar quarter, 1..4', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter name eg. First', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar year, eg 2010', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is today a weekday', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'20041123', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'38314', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'23-Nov-2004', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..7', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Sunday', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..31', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..365', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..52 or 53', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'November', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, …, 12', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, 4', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'November', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 0', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'In the form: yyyymmdd', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'FullDateUSA'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
;





/* Drop table northwind.DimProduct */
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--DROP TABLE northwind.DimProduct 
;

/* Create table northwind.DimProduct */
CREATE TABLE northwind.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(40)   NOT NULL
,  [Discontinued]  nchar(1)  DEFAULT 'N' NOT NULL
,  [SupplierName]  nvarchar(40)   NOT NULL
,  [CategoryName]  nvarchar(15)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimProduct
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Product', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimProduct
exec sys.sp_addextendedproperty @name=N'Database Schema', @value=N'northwind', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimProduct
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Products on an order (with supplier and category info)', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimProduct
;

SET IDENTITY_INSERT northwind.DimProduct ON
;
INSERT INTO northwind.DimProduct (ProductKey, ProductID, ProductName, Discontinued, SupplierName, CategoryName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', '?', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Product]'))
DROP VIEW [northwind].[Product]
GO
CREATE VIEW [northwind].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [Discontinued] AS [Discontinued]
, [SupplierName] AS [SupplierName]
, [CategoryName] AS [CategoryName]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimProduct
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Discontinued', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SupplierName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CategoryName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of product', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is the product discontinued?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of supplier for product', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Product''s category', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1,2,3,…', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Chi Tea', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'False', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Bigfoot Breweries', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Seafood', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TRUE, FALSE', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Products', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Products', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Products', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Suppliers', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Categories', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ProductID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ProductName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Discontinued', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'SupplierName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CategoryName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'int', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'ProductName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'bit', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'Discontinued'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'SupplierName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimProduct', @level2type=N'COLUMN', @level2name=N'CategoryName'; 
;





/* Drop table northwind.DimEmployee */
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimEmployee') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--DROP TABLE northwind.DimEmployee 
;

/* Create table northwind.DimEmployee */
CREATE TABLE northwind.DimEmployee (
   [EmployeeKey]  int IDENTITY  NOT NULL
,  [EmployeeID]  int   NOT NULL
,  [EmployeeName]  nvarchar(40)   NOT NULL
,  [EmployeeTitle]  nvarchar(30)   NOT NULL
,  [RowIsCurrent]  bit   DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimEmployee] PRIMARY KEY CLUSTERED 
( [EmployeeKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimEmployee
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Employee', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimEmployee
exec sys.sp_addextendedproperty @name=N'Database Schema', @value=N'northwind', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimEmployee
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Employee table', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimEmployee
;

SET IDENTITY_INSERT northwind.DimEmployee ON
;
INSERT INTO northwind.DimEmployee (EmployeeKey, EmployeeID, EmployeeName, EmployeeTitle, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimEmployee OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Employee]'))
DROP VIEW [northwind].[Employee]
GO
CREATE VIEW [northwind].[Employee] AS 
SELECT [EmployeeKey] AS [EmployeeKey]
, [EmployeeID] AS [EmployeeID]
, [EmployeeName] AS [EmployeeName]
, [EmployeeTitle] AS [EmployeeTitle]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimEmployee
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeTitle', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Employee''s Name', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Employee''s Job Title', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TRUE, FALSE', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Employees', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Employees', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Employees', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'EmployeeID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'EmployeeName', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'EmployeeTitle', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'int', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'varchar', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'DimEmployee', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
;
DROP TABLE northwind.DimShipper;

/* Create table northwind.DimShipper */
/* Create table northwind.DimShipper */
CREATE TABLE northwind.DimShipper (
   [ShipperKey]  int IDENTITY  NOT NULL
,  [ShipperID]  nvarchar(5)   NOT NULL
,  [CompanyName]  nvarchar(40)   NOT NULL
,  [Phone]  nvarchar(30)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_northwind.DimShipper] PRIMARY KEY CLUSTERED 
( [ShipperKey] )
) ON [PRIMARY]
;


--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimShipper
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DimShipper', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimShipper
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Shipper Dimension', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=DimShipper
;

SET IDENTITY_INSERT northwind.DimShipper ON
;
INSERT INTO northwind.DimShipper (ShipperKey, ShipperID, CompanyName,Phone, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT northwind.DimShipper OFF
;

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ShipperKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ShipperID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CompanyName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the Company', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Speedy Express', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Y, N', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD Type 2 Metadata', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD Type 2 Metadata', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD Type 2 Metadata', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD Type 2 Metadata', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Shippers', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'Shippers', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'ShipperID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'CompanyName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'int', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'ShipperID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'nvarchar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimShipper', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[DimShipper]'))
DROP VIEW [northwind].[Shipper]
GO
CREATE VIEW [northwind].[Shipper] AS 
SELECT [ShipperKey] AS [ShipperKey]
, [ShipperID] AS [ShipperID]
, [CompanyName] AS [CompanyName]
 , [Phone] as [Phone]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM northwind.DimShipper
GO





/* Drop table northwind.FactSales */
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
---DROP TABLE northwind.FactSales 
;

/* Create table northwind.FactSales */
CREATE TABLE northwind.FactSales (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [EmployeeKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [ExtendedPriceAmount]  money   NOT NULL
,  [DiscountAmount]  money  DEFAULT 0 NOT NULL
,  [SoldAmount]  money   NOT NULL
, CONSTRAINT [PK_northwind.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Fact', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactSales
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Sales', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactSales
exec sys.sp_addextendedproperty @name=N'Database Schema', @value=N'northwind', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactSales
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Sales order information', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactSales
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Sales]'))
DROP VIEW [northwind].[Sales]
GO
CREATE VIEW [northwind].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [EmployeeKey] AS [EmployeeKey]
, [OrderDateKey] AS [OrderDateKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [OrderID] AS [OrderID]
, [Quantity] AS [Quantity]
, [ExtendedPriceAmount] AS [ExtendedPriceAmount]
, [DiscountAmount] AS [DiscountAmount]
, [SoldAmount] AS [SoldAmount]
FROM northwind.FactSales
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ProductKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'OrderDateKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ShippedDateKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ShippedDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'OrderID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Quantity', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ExtendedPriceAmount', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DiscountAmount', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SoldAmount', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Product', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Customer', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Customer', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Date (for Orders)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Date (for Shipped)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ShippedDateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'The natural key for the fact table, if any (eg order number)', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Quantity sold of item on order', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Quantity * Unit Price of product', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended price * discount rate', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Extended price - Discount Amount', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'20120108', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'20120108', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ShippedDateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1,2,3…', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'3', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'10', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'2', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'14.9', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ShippedDateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimProduct.ProductKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ProductKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimCustomer.CustomerKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimEmployee.EmployeeKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimDate.DateKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderDateKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimDate.DateKey', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ShippedDateKey'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Source System', @value=N'Northwind', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Schema', @value=N'dbo', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'OrderDetails', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'OrderDetails', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'OrderDetails', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'OrderDetails', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Table', @value=N'OrderDetails', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'OrderID', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Quantity', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'UnitPrice', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'UnitPrice*Discount', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Field Name', @value=N'Quantity*(1-Discount)*UnitPrice', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'int', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'OrderID'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'smallint', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Quantity'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'money', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'ExtendedPriceAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'money', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DiscountAmount'; 
exec sys.sp_addextendedproperty @name=N'Source Datatype', @value=N'money', @level0type=N'SCHEMA', @level0name=N'northwind', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SoldAmount'; 
;






--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Fact', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactOrderFulfillment
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'FactOrderFulfillment', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactOrderFulfillment
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Order Fulfillment Fact', @level0type=N'SCHEMA', @level0name=northwind, @level1type=N'TABLE', @level1name=FactOrderFulfillment
;


/* Create table northwind.FactOrderFulfilment */
CREATE TABLE northwind.FactOrderFulfilment (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ShipperKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [Quantity]  smallint   NOT NULL
,  [DaysElapsed] int NOT NULL
, CONSTRAINT [PK_northwind.FactOrderFulfilment] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;




ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES northwind.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 

 -- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[OrderFulfilment]'))
DROP VIEW [northwind].[OrderFulfilment]
GO
CREATE VIEW [northwind].[OrderFulfilment] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [ShipperKey] AS [ShipperKey]
, [OrderDateKey] AS [OrderDateKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [OrderID] AS [OrderID]
, [Quantity] AS [Quantity]
FROM northwind.FactOrderFulfilment
GO

ALTER TABLE northwind.FactOrderFulfilment ADD CONSTRAINT
   FK_northwind_FactOrderFulfilment_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES northwind.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactOrderFulfilment ADD CONSTRAINT
   FK_northwind_FactOrderFulfilment_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES northwind.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactOrderFulfilment ADD CONSTRAINT
   FK_northwind_FactOrderFulfilment_ShipperKey FOREIGN KEY
   (
   ShipperKey
   ) REFERENCES northwind.DimShipper
   ( ShipperKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactOrderFulfilment ADD CONSTRAINT
   FK_northwind_FactOrderFulfilment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactOrderFulfilment ADD CONSTRAINT
   FK_northwind_FactOrderFulfilment_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;


 


ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES northwind.DimCustomer
   ( CustomerKey )	
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_EmployeeKey FOREIGN KEY
   (
   EmployeeKey
   ) REFERENCES northwind.DimEmployee
   ( EmployeeKey )	
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE northwind.FactSales ADD CONSTRAINT
   FK_northwind_FactSales_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES northwind.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
