--Queries Simples
--1
SELECT * FROM SalesLT.Customer;
SELECT CustomerID,LastName,FirstName,CompanyName FROM SalesLT.Customer;
--2
SELECT [Name],ProductNumber,Color FROM SalesLT.Product;
--3
SELECT CustomerID,SalesOrderID FROM SalesLT.SalesOrderHeader;
--4

--Ejercicios de filtado de datos -------------------------------------------------
-- 1
USE AdventureWorks2008R2
SELECT BusinessEntityID,LoginID,JobTitle FROM HumanResources.Employee
SELECT BusinessEntityID,LoginID,JobTitle FROM HumanResources.Employee
WHERE JobTitle = 'Research and Development Engineer'
--2
SELECT FirstName,MiddleName,LastName,BusinessEntityID FROM Person.Person
WHERE MiddleName = 'J';
--3
SELECT * FROM Production.ProductCostHistory
--                   AÑO, MES, DÍA
WHERE ModifiedDate= '2003-06-17';
--4
USE AdventureWorks2008R2
SELECT BusinessEntityID,LoginID,JobTitle FROM HumanResources.Employee
WHERE JobTitle <> 'Research and Development Engineer'
--5
SELECT BusinessEntityID, FirstName,MiddleName,LastName,ModifiedDate FROM Person.Person
WHERE ModifiedDate > '2000-11-29'
ORDER BY ModifiedDate;
--6
SELECT BusinessEntityID, FirstName,MiddleName,LastName,ModifiedDate FROM Person.Person
WHERE ModifiedDate <> '2000-11-29'
ORDER BY ModifiedDate;
--7
SELECT BusinessEntityID, FirstName,MiddleName,LastName,ModifiedDate FROM Person.Person
WHERE ModifiedDate BETWEEN '2001-12-01' AND '2001-12-31'  
ORDER BY ModifiedDate;

SELECT BusinessEntityID, FirstName,MiddleName,LastName,ModifiedDate FROM Person.Person
WHERE ModifiedDate BETWEEN '20011201' AND '20011231'  
ORDER BY ModifiedDate;
--8
--9
--Ejercicios de filtrado con comodines-----------------------------------------------------------------------------------------
--1
SELECT ProductID,[Name] FROM Production.Product
WHERE [Name] LIKE 'chain%';
--2
SELECT ProductID,[Name] FROM Production.Product
WHERE [Name] LIKE '%helmet%';
--3
SELECT ProductID,[Name] FROM Production.Product
WHERE [Name] NOT LIKE '%helmet%';
--4
SELECT * FROM Person.Person
WHERE MiddleName  = 'E' OR MiddleName = 'B';

--Filtrado con múltiples predicados--------------------------------------------------------------------------------
--1 
SELECT SalesOrderID,OrderDate,TotalDue FROM Sales.SalesOrderHeader
WHERE (OrderDate BETWEEN '2005-09-1' AND '2005-09-30')
AND TotalDue >1000;
--2
SELECT SalesOrderID,OrderDate,TotalDue FROM Sales.SalesOrderHeader
WHERE (OrderDate BETWEEN '2005-09-1' AND '2005-09-3')
AND TotalDue >1000;

SELECT SalesOrderID,OrderDate,TotalDue FROM Sales.SalesOrderHeader
WHERE (OrderDate BETWEEN '2005-09-1' AND '2005-09-3')
AND TotalDue >1000;

SELECT SalesOrderID,OrderDate,TotalDue FROM Sales.SalesOrderHeader
WHERE (OrderDate BETWEEN '2005-09-1' AND '2005-09-3')
AND TotalDue >1000;
--3
SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 1000 AND (SalesPersonID=279 OR TerritoryID=6);
--4
SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 1000 AND (SalesPersonID=279 OR TerritoryID=6OR TerritoryID=4);

-- Trabajando con vacíos y nulos-------------------------------------------------
--1
SELECT ProductID, [Name], Color FROM Production.Product
WHERE Color IS NULL;
--2
SELECT ProductID, [Name], Color FROM Production.Product
WHERE Color <> 'Blue';
--3
SELECT ProductID, [Name], Style, Size, Color FROM Production.Product
WHERE (Color IS NOT NULL OR Style IS NOT NULL OR Size IS NOT NULL);

-- Ordenando los datos -------------------------------------------------
--1
SELECT LastName, FirstName, MiddleName,BusinessEntityID FROM Person.Person
ORDER BY LastName,FirstName, MiddleName DESC ;
--2
SELECT LastName, FirstName, MiddleName,BusinessEntityID FROM Person.Person
ORDER BY LastName, FirstName, MiddleName ASC ;

-- Escribir expresiones con operadores-------------------------------------------------
--1
SELECT AddressLine1+', '+City+', '+PostalCode AS Dirección_Completa FROM [Person].[Address];
--2
SELECT ProductID,[Name],ISNULL(COLOR,'Sin color') FROM Production.Product;
SELECT * FROM Production.Product;
--3
SELECT ProductID, [Name]+': '+ISNULL(COLOR,'') AS Descripción FROM Production.Product;
--4
SELECT (CAST(ProductID AS varchar(255)))+': '+[Name] AS Descripción  FROM Production.Product;
--5

--Uso de operadores matemático---------------------------------------------------------------
--1
SELECT [Description],SpecialOfferID,(MinQty-MaxQty) AS Diferencia FROM Sales.SpecialOffer;
--2
SELECT [Description],SpecialOfferID,(MinQty*DiscountPct) AS Producto FROM Sales.SpecialOffer;
--3
SELECT *,(ISNULL(MaxQty,10)*DiscountPct) AS Producto FROM Sales.SpecialOffer;
--4

--Uso de funciones de cadena-----------------------------------------------------------------
--1
SELECT AddressLine1 FROM Person.[Address];
SELECT AddressLine1,SUBSTRING(AddressLine1,1,10) FROM Person.[Address];
--2
SELECT AddressLine1,SUBSTRING(AddressLine1,10,15) FROM Person.[Address];
--3
SELECT UPPER(FirstName),UPPER(LastName) FROM Person.person;
--4
SELECT * FROM Person.[Address];
--Uso de funciones fecha---------------------------------------------------------------------
--1
SELECT * FROM Sales.SalesOrderHeader;
SELECT SalesOrderID,OrderDate,ShipDate,ABS(CAST((OrderDate-ShipDate) AS INT)) AS Días_de_diferencia FROM Sales.SalesOrderHeader;
--2
SELECT CONVERT(DATE,OrderDate) AS Fecha_sin_hora FROM Sales.SalesOrderHeader;
--3
SELECT CONVERT(DATE,OrderDate), CONVERT(DATE,DATEADD(month,6,OrderDate)) AS Six_Months_more FROM Sales.SalesOrderHeader;
--4
SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes,DAY(OrderDate) AS Día,SalesOrderID, OrderDate FROM Sales.SalesOrderHeader;
-- Funciones matemáticas-----------------------------------------------------------------------
--1
SELECT SubTotal,ROUND(SubTotal,2) AS SubRedondeado FROM Sales.SalesOrderHeader;
--2
SELECT SubTotal,ROUND(SubTotal,2) AS SubRedondeado,ROUND(SubTotal,0) FROM Sales.SalesOrderHeader;
--3
SELECT SalesOrderID,ROUND(SQRT(SalesOrderID),2) AS Raíz_cuadrada FROM Sales.SalesOrderHeader;
--4
--SELECT FLOOR(RAND()*(end-start)+start);
SELECT FLOOR(RAND()*(10-1)+1);

-- Uso de funciones en WHERE y clausulas en el ORDER BY
SELECT * FROM Sales.SalesOrderHeader;
--1
SELECT SalesOrderID,OrderDate FROM Sales.SalesOrderHeader 
WHERE Orderdate BETWEEN '2005-01-01' AND '2005-12-31'
ORDER BY OrderDate
--2
SELECT * FROM Sales.SalesOrderHeader 
--3

--4
SELECT PersonType,FirstName,MiddleName,LastName FROM Person.Person
ORDER BY
(CASE
	WHEN PersonType = 'IN' OR PersonType = 'SP' OR PersonType = 'SC' THEN  LastName
	ELSE  FirstName
END );

-- Uso de Inner Joins----------------------------------------------------------------------------
--1
SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;
SELECT JobTitle,BirthDate,FirstName,LastName FROM HumanResources.Employee hre
INNER JOIN Person.Person pp
ON hre.BusinessEntityID = pp.BusinessEntityID;
--2
SELECT * FROM Person.Person;
SELECT * FROM Sales.Customer;
SELECT pp.BusinessEntityID AS pk,sc.PersonID AS fk,StoreID,TerritoryID,FirstName,LastName FROM Person.person pp
INNER JOIN
Sales.Customer sc
ON pp.BusinessEntityID = sc.PersonID;
--3
SELECT pp.BusinessEntityID AS pk,sc.PersonID AS fk,StoreID,
SalesOrderID,sc.TerritoryID,FirstName,LastName FROM Person.person pp
INNER JOIN Sales.Customer sc
ON pp.BusinessEntityID = sc.PersonID
INNER JOIN Sales.SalesOrderHeader ssoh
ON sc.CustomerID = ssoh.CustomerID;
--4
SELECT SalesOrderID,SalesQuota,Bonus FROM Sales.SalesOrderHeader ssoh
INNER JOIN Sales.SalesPerson ssp
ON ssoh.SalesPersonID = ssp.BusinessEntityID;
--5
SELECT FirstName,LastName,SalesOrderID,SalesQuota,Bonus FROM Sales.SalesOrderHeader ssoh
INNER JOIN Sales.SalesPerson ssp
ON ssoh.SalesPersonID = ssp.BusinessEntityID
INNER JOIN Person.Person pp
ON ssp.BusinessEntityID = pp.BusinessEntityID;
--6
SELECT * FROM Production.ProductModel;
SELECT * FROM Production.Product;

SELECT CatalogDescription, Color, Size FROM Production.ProductModel ppm
INNER JOIN Production.Product pp
ON ppm.ProductModelID = pp.ProductID;

-- Uso de OuterJoins
--1

SELECT SalesOrderID,ssod.ProductID,[Name] FROM Sales.SalesOrderDetail ssod
RIGHT JOIN Production.Product  pp
ON ssod.ProductID = pp.ProductID;
--2
SELECT SalesOrderID,ssod.ProductID,[Name] FROM Sales.SalesOrderDetail ssod
RIGHT JOIN Production.Product  pp
ON ssod.ProductID = pp.ProductID
WHERE ssod.ProductID IS NULL;
--3
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Sales.SalesOrderHeader;

SELECT ssoh.SalesOrderID, ssp.* FROM Sales.SalesPerson ssp
LEFT JOIN Sales.SalesOrderHeader ssoh
ON ssp.BusinessEntityID = ssoh.SalesOrderID;
--4
SELECT * FROM Person.Person;
SELECT FirstName,ssoh.SalesOrderID, ssp.* FROM Sales.SalesPerson ssp
LEFT JOIN Sales.SalesOrderHeader ssoh
ON ssp.BusinessEntityID = ssoh.SalesOrderID
INNER JOIN Person.Person pp
ON ssp.BusinessEntityID = pp.BusinessEntityID;
--5
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.CurrencyRate;
SELECT * FROM Purchasing.ShipMethod;

SELECT * FROM Sales.SalesOrderHeader ssoh
LEFT JOIN Sales.CurrencyRate scr
ON ssoh.CurrencyRateID = scr.CurrencyRateID
LEFT JOIN Purchasing.ShipMethod psm
ON ssoh.rowguid = psm.rowguid;
--6
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Production.Product;

SELECT BusinessEntityID,ProductID FROM Sales.SalesPerson ssp
LEFT JOIN Production.Product pp
ON ssp.BusinessEntityID = pp.ProductID;

--Subconsultas-----------------------------------------------------------------
--1
SELECT ProductID,[Name] FROM Production.Product
WHERE ProductID IN (
	SELECT ProductID FROM Sales.SalesOrderDetail
	);
--2
SELECT ProductID,[Name] FROM Production.Product
WHERE ProductID NOT IN (
	SELECT ProductID FROM Sales.SalesOrderDetail
	);
--3
USE AdventureWorks2008R2;
GO
IF OBJECT_ID('Production.ProductColor') IS NOT NULL BEGIN DROP TABLE 
Production.ProductColor;
END
CREATE table Production.ProductColor
(Color nvarchar(15) NOT NULL PRIMARY KEY)
GO
--Insert most of the existing colors 
INSERT INTO Production.ProductColor 
	SELECT DISTINCT COLOR FROM Production.Product
	WHERE Color IS NOT NULL and Color <> 'Silver'
--Insert some additional colors 
INSERT INTO Production.ProductColor VALUES ('Green'),('Orange'),('Purple');

---------
SELECT * FROM Production.ProductColor;
SELECT DISTINCT(COLOR) AS COLORES FROM Production.Product WHERE COLOR IS NOT NULL;

SELECT pp.COLOR  FROM Production.ProductColor pp
WHERE pp.COLOR  NOT IN (
	SELECT COLOR FROM Production.Product WHERE COLOR IS NOT NULL
	);

--4
SELECT pp.COLOR  FROM Production.ProductColor pp
WHERE pp.COLOR IN (
	SELECT DISTINCT(COLOR) AS COLORES FROM Production.Product WHERE COLOR IS NOT NULL
	);

--5
SELECT BusinessEntityID,ModifiedDate, 'Fecha Modificación' Tipo FROM Person.Person
UNION
SELECT BusinessEntityID,HireDate, 'Fecha Contratación' Tipo FROM HumanResources.Employee;

--Exploración de tablas derivadas y expresiones de tablas comunes-------------------------
--1
SELECT ssod.SalesOrderID,ssoh.OrderDate,ssod.ProductID FROM 
	(SELECT SalesOrderID,ProductID FROM Sales.SalesOrderDetail) AS ssod 
INNER JOIN Sales.SalesOrderHeader ssoh
ON ssod.SalesOrderID = ssoh.SalesOrderID;
--2
WITH DatosDeOrden AS (
	SELECT ssod.SalesOrderID,ssoh.OrderDate,ssod.ProductID FROM 
		(SELECT SalesOrderID,ProductID FROM Sales.SalesOrderDetail) AS ssod 
	INNER JOIN Sales.SalesOrderHeader ssoh
	ON ssod.SalesOrderID = ssoh.SalesOrderID
	)

SELECT * FROM DatosDeOrden;
--3
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Sales.SalesOrderHeader;

-- Funciones de agregado
--1
SELECT COUNT(CustomerID) AS Número_de_clientes  FROM Sales.Customer;
--2
SELECT SUM(OrderQty) AS Total_productos_pedidos FROM Sales.SalesOrderDetail;
--3
SELECT MAX(UnitPrice) AS Precio_producto_más_caro FROM Sales.SalesOrderDetail;
--4
SELECT AVG(freight) AS Importe_promedio FROM Sales.SalesOrderHeader;
--5
SELECT MAX(ListPrice) AS Máximo, MIN(ListPrice) AS Mínimo, AVG(ListPrice) AS Promedio FROM Production.Product;

-- GROUP BY---------------------------------------------------------------
--1
SELECT ProductID,COUNT(OrderQty) AS Num_productos_vendidos FROM Sales.SalesOrderDetail
GROUP BY ProductID;
--2
SELECT * FROM Sales.SalesOrderDetail;
SELECT SalesOrderID,COUNT(SalesOrderDetailID) AS Lineas_de_detalle FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;
--3
SELECT * FROM Production.Product;
SELECT ProductID,COUNT(ProductLine) FROM Production.Product
GROUP BY ProductID;
--4
SELECT * FROM Sales.SalesOrderHeader;
SELECT CustomerID, Year(OrderDate) AS Año_de_venta, COUNT(SalesOrderID) AS Compras_Realizadas FROM Sales.SalesOrderHeader
GROUP BY CustomerID, Year(OrderDate)
ORDER BY CustomerID

-- Uso de Having-------------------------------------------------------------
--2
SELECT SalesOrderID,LineTotal FROM Sales.SalesOrderDetail
SELECT SalesOrderID,SUM(LineTotal) FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal)>1000;
--3
SELECT * FROM Production.Product ;
SELECT ProductModelID, COUNT(ProductID) AS 'Recuento de productos' FROM Production.Product
GROUP BY ProductModelID
HAVING COUNT(ProductID) = 1
--4
SELECT ProductModelID, COUNT(ProductID) AS 'Recuento de productos',Color FROM Production.Product
WHERE Color = 'Red' or Color = 'blue'
GROUP BY ProductModelID,Color
HAVING COUNT(ProductID) = 1

-- Uso de DISTINCT----------------------------------------------------------------------------------
--1
SELECT COUNT(DISTINCT(ProductID)) AS 'Número de valores ProductID diferentes' FROM Sales.SalesOrderDetail;
--2
SELECT CustomerID,TerritoryID FROM Sales.SalesOrderHeader;
SELECT CustomerID,TerritoryID,COUNT(DISTINCT(TerritoryID)) FROM Sales.SalesOrderHeader
GROUP BY CustomerID,TerritoryID;

-- Uso de consultas agregadas con más de una tabla.
--1
SELECT * FROM Person.Person;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;

SELECT pp.BusinessEntityID,sc.CustomerID,FirstName+' '+LastName AS 'Nombre del cliente',COUNT(SalesOrderID) AS 'Número de pedidos' FROM Person.Person pp
INNER JOIN Sales.Customer sc
ON pp.BusinessEntityID=sc.CustomerID
INNER JOIN Sales.SalesOrderHeader ssoh
ON sc.CustomerID=ssoh.CustomerID
GROUP BY  pp.BusinessEntityID,sc.CustomerID,FirstName,LastName;

--2
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.Product;

SELECT pp.ProductID,ssoh.OrderDate,COUNT(ssoh.SalesOrderID) AS 'Suma de productos' FROM Sales.SalesOrderHeader ssoh
INNER JOIN Sales.SalesOrderDetail ssod
ON ssoh.SalesOrderID = ssod.SalesOrderID
INNER JOIN Production.Product pp
ON ssod.ProductID = pp.ProductID
GROUP BY ssoh.OrderDate,pp.ProductID
ORDER BY ssoh.OrderDate;

SELECT pp.ProductID,CONVERT(DATE,ssoh.OrderDate) AS 'Fecha de orden',COUNT(ssoh.SalesOrderID) AS 'Suma de productos' FROM Sales.SalesOrderHeader ssoh
INNER JOIN Sales.SalesOrderDetail ssod
ON ssoh.SalesOrderID = ssod.SalesOrderID
INNER JOIN Production.Product pp
ON ssod.ProductID = pp.ProductID
GROUP BY CONVERT(DATE,ssoh.OrderDate),pp.ProductID
ORDER BY CONVERT(DATE,ssoh.OrderDate);

-- Importando nuevas filas.------------------------------------------------------------------------------------------------
--1
USE AdventureWorksLT2008R2
GO
SELECT TOP(3) ProductID,[Name],Color,StandardCost,ListPrice,Size,[Weight] FROM SalesLT.Product;
SELECT * FROM [AdventureWorksLT2008R2].[dbo].[demoProduct]

INSERT INTO [AdventureWorksLT2008R2].[dbo].[demoProduct]
(ProductID)
VALUES(1)


