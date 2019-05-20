use [ist722_hrdarji_stage]

--stage customers
SELECT [CustomerID],
        [CompanyName],
		[ContactName],
		[ContactTitle],
		[Address],
		[City],
		[Region],
		[PostalCode],
		[Country]
INTO [dbo].[stgNorthwindCustomers]
FROM  [Northwind].[dbo].[Customers]

SELECT [EmployeeID],
       [FirstName],
	   [LastName],
	   [Title]
FROM [Northwind].[dbo].[Employees]

--stage Employees
SELECT [EmployeeID],
       [FirstName],
	   [LastName],
	   [Title]
INTO [dbo].[stgNorthwindEmployees]
FROM  [Northwind].[dbo].[Employees]


SELECT [ProductID],
       [ProductName],
	   [Discontinued],
	   [CompanyName],
	   [CategoryName]
FROM [Northwind].[dbo].[Products] p
      join [Northwind].[dbo].Suppliers s
	    on p.[SupplierID]=s.[SupplierID]
	 join [Northwind].[dbo].Categories c
	 on c.[CategoryID]=p.[CategoryID]      


--stage Products	 
SELECT [ProductID],
       [ProductName],
	   [Discontinued],
	   [CompanyName],
	   [CategoryName]
INTO [dbo].[stgNorthwindProducts]
FROM [Northwind].[dbo].[Products] p
      join [Northwind].[dbo].Suppliers s
	    on p.[SupplierID]=s.[SupplierID]
	 join [Northwind].[dbo].Categories c
	 on c.[CategoryID]=p.[CategoryID]      

	 SELECT min(OrderDate),
	        max(OrderDate),
			min(ShippedDate),
			max(ShippedDate)
	FROM [Northwind].[dbo].[orders]


	--stage date
SELECT *
INTO [dbo].[stgNorthwindDates]
FROM [ExternalSources2].[dbo].[date_dimension]
WHERE Year between 1996 and 1998

--stage fact
SELECT [ProductID],
       d.[OrderID],
	   [CustomerID],
	   [EmployeeID],
	   [OrderDate],
	   [ShippedDate],
	   [UnitPrice],
	   [Quantity],
	   [Discount]
INTO [dbo].[stgNorthwindSales]
FROM [Northwind].[dbo].[Order Details] d
    join [Northwind].[dbo].[Orders] o
	on o.[OrderID]= d.[OrderID]

	DROP TABLE [dbo].[stgNorthwindShippers];

---stage Shippers       
SELECT [ShipperID],
       [CompanyName],
	   [Phone]
INTO  [dbo].[stgNorthwindShippers]
FROM [Northwind].[dbo].[Shippers]


--stage OrderFulfillment


SELECT [ProductID],
d.[OrderID],
[CustomerID],
[OrderDate],
[ShippedDate],
[Quantity],
[ShipVia] as ShipperID
INTO [dbo].[stgNorthwindOrderFulfilment]
FROM [Northwind].[dbo].[Order Details] d
join [Northwind].[dbo].[Orders] o
on o.[OrderID] = d.[OrderID] 


SELECT * FROM dbo.stgNorthwindOrderFulfilment