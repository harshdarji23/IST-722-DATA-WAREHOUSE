use ist722_hrdarji_dw

SELECT [EmployeeID], [FirstName], [LastName], [Title]
   FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindEmployees]

   SELECT EmployeeID, Firstname + ' ' +LastName as EmployeeName, [Title]
          FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindEmployees]

-- load DimEmployee
INSERT INTO [northwind].[DimEmployee]
             ([EmployeeID],[EmployeeName],[EmployeeTitle])
SELECT EmployeeID, FirstName + ' ' + LastName as EmployeeName, [Title]
        FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindEmployees]

		SELECT * FROM [northwind].[DimEmployee]

--load  DimCustomer
INSERT INTO [Northwind].[DimCustomer]
  ([CustomerID],[CompanyName],[ContactName],[ContactTitle],
  [CustomerCountry], [CustomerRegion], [CustomerCity],[CustomerPostalCode])
SELECT 
    [CustomerID], [CompanyName], [ContactName], [ContactTitle], [Country],
	case when Region is null then 'N/A' else [Region] end,
	[City],
	case when [PostalCode] is null then 'N/A'else [PostalCode] end
  FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindCustomers]

  SELECT * FROM [northwind].[DimCustomer]

  
  --load DimProduct
  INSERT INTO [Northwind].[DimProduct]
  ([ProductID], [ProductName], [Discontinued],[SupplierName], [CategoryName])
  SELECT 
   [ProductID], [ProductName],
   case when [Discontinued]= '1' then 'Y' else 'N' END,
   [CompanyName], [CategoryName]
   FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindProducts]

   --Load DimDate
   SELECT * FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindDates]

   INSERT INTO [northwind].[DimDate]
   ([DateKey],[Date], [FullDateUSA], [DayOfWeek], [DayName], [DayOfMonth], [DayOfYear], [WeekOfYear], [MonthName], [MonthOfYear], 
    [Quarter], [QuarterName],[Year], [IsWeekday])
	SELECT 
	[DateKey],[Date], [FullDateUSA], [DayOfWeekUSA], [DayName], [DayOfMonth], [DayOfYear], [WeekOfYear], [MonthName], [Month], 
    [Quarter],[QuarterName], [Year], [IsWeekday]
	FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindDates]


	SELECT s.*, c.CustomerKey
	  FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindSales] s
	   join [ist722_hrdarji_dw].[northwind].DimCustomer c
	      on s.CustomerID=c.CustomerID

--loading FactSales
INSERT INTO [northwind].[FactSales]
([ProductKey], [CustomerKey], [EmployeeKey]
,[OrderDateKey]
,[ShippedDateKey]
,[OrderID]
,[Quantity]
,[ExtendedPriceAmount]
,[DiscountAmount]
,[SoldAmount])
SELECT p.ProductKey, c.CustomerKey, e.EmployeeKey,
[ExternalSources2].dbo.[getDateKey](s.OrderDate) as OrderDateKey,
case when [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) is null then -1
else [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) end as ShippedDateKey, 
s.OrderId,
Quantity,
Quantity*UnitPrice as ExtendedPriceAmount,
Quantity*UnitPrice*Discount as DiscountAmount,
Quantity*UnitPrice*(1-Discount) as SoldAmount
FROM [ist722_hrdarji_stage].dbo.stgNorthwindSales s
join [ist722_hrdarji_dw].northwind.DimCustomer c
on s.CustomerID = c.CustomerID
join [ist722_hrdarji_dw].northwind.DimEmployee e
on s.EmployeeID = e.EmployeeID
join [ist722_hrdarji_dw].northwind.DimProduct p
on s.ProductID = p.ProductID

--creating the view
CREATE VIEW [northwind].[SalesMart]
AS
SELECT s.OrderID, s.Quantity, s.ExtendedPriceAmount, s.DiscountAmount, s.SoldAmount,
c.CompanyName, c.ContactName, c.ContactTitle, c.CustomerCity,
c.CustomerCountry, c.CustomerRegion, c.CustomerPostalCode,
e.EmployeeName, e.EmployeeTitle,
p.ProductName, p.Discontinued, p.CategoryName, 
od.*
FROM northwind.FactSales s
join northwind.DimCustomer c on c.CustomerKey = s.CustomerKey
join northwind.DimEmployee e on e.EmployeeKey = s.EmployeeKey
join northwind.DimProduct p on p.ProductKey = s.ProductKey
join northwind.DimDate od on od.DateKey = s.OrderDateKey


--loading Shippers
INSERT INTO [northwind].[DimShipper]
            ([ShipperID], [CompanyName], [Phone])
Select [ShipperID], [CompanyName], [Phone] 
FROM [ist722_hrdarji_stage].[dbo].[stgNorthwindShippers];

--loading OrderFulfilment
INSERT INTO [northwind].[FactOrderFulfilment]
([ProductKey], [CustomerKey], [ShipperKey]
,[OrderDateKey]
,[ShippedDateKey]
,[OrderID] 
,[Quantity] 
,[DaysElapsed])
SELECT p.ProductKey, c.CustomerKey, s.ShipperKey,
   [ExternalSources2].dbo.[getDateKey](oful.OrderDate) as OrderDateKey,
   case when [ExternalSources2].[dbo].[getDateKey](oful.ShippedDate) is null then -1
   else [ExternalSources2].[dbo].[getDateKey](oful.ShippedDate) end as ShippedDateKey,
   oful.OrderID,
   Quantity,
   case when oful.ShippedDate is null then -1 else DATEDIFF(DAYOFYEAR, oful.OrderDate,oful.ShippedDate) end as 'Number of Days Elapsed'
FROM [ist722_hrdarji_stage].[dbo].stgNorthwindOrderFulfilment oful
join [ist722_hrdarji_dw].northwind.DimCustomer c
on oful.CustomerID = c.CustomerID
join [ist722_hrdarji_dw].northwind.DimShipper s
on oful.ShipperID = s.ShipperID
join [ist722_hrdarji_dw].northwind.DimProduct p
on oful.ProductID = p.ProductID

SELECT * FROM northwind.FactOrderFulfilment

DROP VIEW  [northwind].[OrderFulfilmentMart]

--craeting view
CREATE VIEW [northwind].[OrderFulfilmentMart]
AS
SELECT oful.OrderID, oful.Quantity, oful.DaysElapsed,
   c.CompanyName as 'Client Company', c.ContactName, c.CustomerCity,
   c.CustomerCountry, c.CustomerRegion, c.CustomerPostalCode,
   s.ShipperID, s.CompanyName as 'Shipper Name',
   p.ProductName, p.Discontinued, p.CategoryName,
   od.Date as 'OrderDate',
   sd.Date as 'Shipped Date'
FROM [northwind].[FactOrderFulfilment] oful
join northwind.DimCustomer c on c.CustomerKey = oful.CustomerKey
join northwind.DimShipper s on s.ShipperKey = oful.ShipperKey
join northwind.DimProduct p on p.ProductKey = oful.ProductKey
join northwind.DimDate od on od.DateKey = oful.OrderDateKey
join northwind.DimDate sd on sd.DateKey = oful.ShippedDateKey

