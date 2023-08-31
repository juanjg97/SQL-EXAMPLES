--1
SELECT TOP(3) ProductID,[Name],Color,StandardCost,ListPrice,Size,[Weight] FROM SalesLT.Product;
SELECT * FROM [AdventureWorksLT2008R2].[dbo].[demoProduct]

INSERT INTO [AdventureWorksLT2008R2].[dbo].[demoProduct]
SELECT ProductID,[Name],StandardCost,ListPrice,Size,[Weight] FROM SalesLT.Product
WHERE ProductID= 707

INSERT INTO [AdventureWorksLT2008R2].[dbo].[demoProduct]
SELECT 123 AS ProductID,[Name],'Blue' AS Color,StandardCost,ListPrice,NULL as Size,[Weight] FROM SalesLT.Product
WHERE ProductID= 707

--2
INSERT INTO [AdventureWorksLT2008R2].[dbo].[demoProduct]
SELECT ProductID,[Name],Color,StandardCost,ListPrice,Size,[Weight] FROM SalesLT.Product
ORDER BY ProductID
OFFSET 20 rows
FETCH NEXT 5 ROWS ONLY;
--3
SELECT * FROM AdventureWorksLT2008R2.DBO.demoSalesOrderHeader
INSERT INTO AdventureWorksLT2008R2.DBO.demoSalesOrderHeader ([SalesOrderID],[OrderDate],[CustomerID],[SubTotal],[TaxAmt],[Freight])
SELECT [SalesOrderID],[OrderDate],[CustomerID],[SubTotal],[TaxAmt],[Freight] FROM SalesLT.SalesOrderHeader
--4

SELECT CustomerID,COUNT(SalesOrderID) AS 'Número de pedidos',SUM(TotalDue) AS 'Deuda total' 
INTO dbo.tempCustomerSales
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID;

SELECT * FROM AdventureWorksLT2008R2.dbo.tempCustomerSales;
--5

SELECT * FROM AdventureWorksLT2008R2.dbo.demoProduct;
SELECT * FROM SalesLT.Product;

--6
SELECT * FROM dbo.demoAddress;
SELECT * FROM SalesLT.Address;

SELECT * FROM AdventureWorksLT2008R2.DBO.demoSalesOrderHeader
SET IDENTITY_INSERT AdventureWorksLT2008R2.dbo.demoAddress ON
INSERT INTO AdventureWorksLT2008R2.dbo.demoAddress ([AddressID],[AddressLine1],[AddressLine2],[City],[StateProvince],[CountryRegion],[PostalCode])
SELECT [AddressID],[AddressLine1],[AddressLine2],[City],[StateProvince],[CountryRegion],[PostalCode] FROM SalesLT.Address


--Borrando Filas -----------------------------------------------------------------------------------------------------------------------------------
--1
SELECT * FROM dbo.demoCustomer WHERE LastName LIKE 'L%';

DELETE FROM dbo.demoCustomer
WHERE LastName LIKE 'L%'
--2
SELECT * FROM dbo.demoCustomer
SELECT * FROM dbo.demoSalesOrderHeader WHERE TotalDue < 1000;

SELECT dc.CustomerID,FirstName,TotalDue FROM dbo.demoCustomer dc
INNER JOIN dbo.demoSalesOrderHeader dsoh
ON dc.CustomerID=dsoh.CustomerID
WHERE TotalDue<1000

DELETE FROM dbo.demoCustomer
WHERE CustomerID IN 
	(SELECT dc.CustomerID FROM dbo.demoCustomer dc
	INNER JOIN dbo.demoSalesOrderHeader dsoh
	ON dc.CustomerID=dsoh.CustomerID
	WHERE TotalDue<1000)

--3
SELECT * FROM dbo.demoProduct;

-- Actualizar filas existentes-----------------------------------------------------------------------
--1
SELECT * FROM dbo.demoAddress

UPDATE dbo.demoAddress
SET AddressLine2='N/A'
WHERE AddressLine2 IS NULL

--2
SELECT ListPrice FROM dbo.demoProduct;

UPDATE dbo.demoProduct
SET ListPrice=ListPrice+(ListPrice*0.1)
--3
SELECT UnitPrice,* FROM dbo.demoSalesOrderDetail;
SELECT ListPrice,* FROM dbo.demoProduct;

SELECT DISTINCT(dsod.ProductID),UnitPrice,ListPrice FROM dbo.demoSalesOrderDetail dsod
INNER JOIN dbo.demoProduct dp
ON dsod.ProductID=dp.ProductID
ORDER BY ProductID;

UPDATE dbo.demoSalesOrderDetail  
SET UnitPrice = (SELECT ListPrice FROM dbo.demoProduct dp WHERE dp.ProductID = dbo.demoSalesOrderDetail.ProductID)
FROM dbo.demoProduct

--UPDATE Customer_Info
--SET Code = (SELECT Customer_Code
--FROM Work_Tickets
--WHERE Work_Tickets.Customer_Contact = Customer_Info.Email)
--FROM Work_Tickets
--WHERE Code IS NULL

--4
SELECT * FROM dbo.demoSalesOrderHeader;
SELECT * FROM dbo.demoSalesOrderDetail;SELECT * FROM dbo.demoSalesOrderHeader;SELECT SalesOrderID,SUM(LineTotal) AS 'SumaLineTotal' FROM dbo.demoSalesOrderDetailGROUP BY SalesOrderID;UPDATE dbo.demoSalesOrderHeader  
SET SubTotal = 
	(SELECT SUM(LineTotal) AS 'SumaLineTotal' FROM dbo.demoSalesOrderDetail 	 WHERE dbo.demoSalesOrderHeader.SalesOrderID = dbo.demoSalesOrderDetail.SalesOrderID	 GROUP BY SalesOrderID)

-- Creación de tablas temporales-----------------------------------------------------------
--1
USE AdventureWorks2008R2
SELECT BusinessEntityID,FirstName,LastName,COUNT(SalesOrderID) AS 'CountOfSales',SUM(TotalDue) AS 'SumOfTotalDue' FROM Person.Person pp
INNER JOIN Sales.SalesOrderHeader ssoh
ON pp.BusinessEntityID = ssoh.CustomerID
GROUP BY BusinessEntityID,FirstName,LastName

CREATE TABLE #TabTemporal (
	CustomerID int primary key,
	FirstName varchar(255),
	LastName varchar(255),
	CountOfSales int,
	SumOfTotalDue money
)
SELECT * FROM #TabTemporal

INSERT INTO #TabTemporal (CustomerID,FirstName,LastName,CountOfSales,SumOfTotalDue)
	SELECT BusinessEntityID,FirstName,LastName,COUNT(SalesOrderID) AS 'CountOfSales',SUM(TotalDue) AS 'SumOfTotalDue' FROM Person.Person pp
	INNER JOIN Sales.SalesOrderHeader ssoh
	ON pp.BusinessEntityID = ssoh.CustomerID
	GROUP BY BusinessEntityID,FirstName,LastName;

--2
DECLARE  @TabTemporal1 TABLE (
	CustomerID int primary key,
	FirstName varchar(255),
	LastName varchar(255),
	CountOfSales int,
	SumOfTotalDue money
)

SELECT * FROM @TabTemporal1

INSERT INTO @TabTemporal1 (CustomerID,FirstName,LastName,CountOfSales,SumOfTotalDue)
	SELECT BusinessEntityID,FirstName,LastName,COUNT(SalesOrderID) AS 'CountOfSales',SUM(TotalDue) AS 'SumOfTotalDue' FROM Person.Person pp
	INNER JOIN Sales.SalesOrderHeader ssoh
	ON pp.BusinessEntityID = ssoh.CustomerID
	GROUP BY BusinessEntityID,FirstName,LastName;

SELECT * FROM @TabTemporal1

-- Creando tablas-------------------------------------------------------------------------------------------------------------------
--1
CREATE TABLE dbo.testCustomer(
	CustomerID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(255),
	LastName VARCHAR(255),
	Age INT CHECK (Age<120),
	ColumnaY CHAR DEFAULT ('Y') CHECK(ColumnaY IN ('X','Y')),
)

SELECT * FROM dbo.testCustomer

INSERT INTO dbo.testCustomer (FirstName,LastName,Age) 
VALUES ('Juan','Jasso',24)

INSERT INTO dbo.testCustomer (FirstName,LastName,Age,ColumnaY) 
VALUES ('Carlos','Jasso',19,'X'),('Mario','Jasso',27,'Y')

--2
CREATE TABLE dbo.testOrder(
	CustomerID INT FOREIGN KEY REFERENCES dbo.testCustomer(CustomerID),
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	OrderDate DATE DEFAULT GETDATE(),
	ColRow ROWVERSION
)

SELECT * FROM dbo.testOrder

INSERT INTO dbo.testOrder (CustomerID) 
VALUES (5),(6)
--3
CREATE TABLE dbo.testOrderDetail(
	OrderID INT FOREIGN KEY REFERENCES dbo.testOrder(OrderID),
	ItemID INT NOT NULL,
	Price INT NOT NULL,
	Qty INT,
	[PK]  AS (isnull((cast(OrderID as varchar)+cast(ItemID as varchar)),(0))) PRIMARY KEY,
	LineItemTotal AS Price*Qty
)

SELECT * FROM dbo.testOrderDetail
DROP TABLE dbo.testOrderDetail

INSERT INTO dbo.testOrderDetail (OrderID,ItemID,Price,Qty) 
VALUES (3,7,20,3)

-- CREACIÓN DE VISTAS------------------------------------------------------------
--1
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCostHistory;

CREATE VIEW [PriceHistory] AS
	SELECT pp.ProductID,[Name],StartDate,EndDate,ppch.StandardCost FROM Production.Product pp
	INNER JOIN Production.ProductCostHistory ppch
	ON pp.ProductID = ppch.ProductID

SELECT * FROM PriceHistory
WHERE ProductID IN (707,708)
--2

CREATE VIEW  [dbo.vw_CustomerTotals] AS
	SELECT CustomerID,COUNT(SalesOrderID) AS 'Número de compras',DATEPART(YEAR,OrderDate) AS [Year],DATEPART(MONTH,OrderDate) AS [Month],SUM(TotalDue) AS 'Deuda total' FROM Sales.SalesOrderHeader
	GROUP BY CustomerID,DATEPART(YEAR,OrderDate),DATEPART(MONTH,OrderDate) 

SELECT * FROM	[dbo.vw_CustomerTotals]
ORDER BY CustomerID

-- Creación de procedimientos almacenados ----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Production.Product;

CREATE PROCEDURE prueba_1_mostrar_producto
@ProductID  AS INT
AS
SELECT * FROM Production.Product WHERE ProductID=@ProductID;

EXECUTE prueba_1_mostrar_producto
@ProductID=1

--1
CREATE PROCEDURE  dbo.usp_CustomerTotals
AS
	SELECT pp.ProductID,[Name],StartDate,EndDate,ppch.StandardCost FROM Production.Product pp
	INNER JOIN Production.ProductCostHistory ppch
	ON pp.ProductID = ppch.ProductID

EXECUTE dbo.usp_CustomerTotals

--2
ALTER PROCEDURE dbo.usp_CustomerTotals
@ProductID AS INT
AS
	SELECT pp.ProductID,[Name],StartDate,EndDate,ppch.StandardCost FROM Production.Product pp
	INNER JOIN Production.ProductCostHistory ppch
	ON pp.ProductID = ppch.ProductID
WHERE pp.ProductID = @ProductID

EXECUTE dbo.usp_CustomerTotals
@ProductID=707

--3
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCostHistory;

CREATE PROCEDURE prueba5 (
    @ProductID INT,
    @ProductModelID INT OUTPUT
) AS
BEGIN
    SET @ProductModelID = (SELECT ProductModelID FROM Production.Product WHERE ProductID = @ProductID)
END

DECLARE @pmid INT
EXEC prueba5 707,@pmid output
SELECT @pmid
