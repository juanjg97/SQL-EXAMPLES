SELECT * FROM HumanResources.Department;

SELECT FirstName,MiddleName,LastName,BusinessEntityID FROM Person.Person
WHERE MiddleName = 'J';

----------------------------------------------------------------------
USE AdventureWorks2008R2
SELECT BusinessEntityID,LoginID,JobTitle FROM HumanResources.Employee
WHERE JobTitle <> 'Research and Development Engineer';

SELECT BusinessEntityID, FirstName,MiddleName,LastName,ModifiedDate FROM Person.Person
WHERE ModifiedDate BETWEEN '20011201' AND '20011231'  
ORDER BY ModifiedDate;

--Ejercicios de filtrado con comodines
SELECT ProductID,[Name] FROM Production.Product --empieza con chain
WHERE [Name] LIKE 'chain%'; 

SELECT ProductID,[Name] FROM Production.Product --termina con chain
WHERE [Name] LIKE '%chain';


SELECT ProductID,[Name] FROM Production.Product 
WHERE [Name] NOT LIKE '%helmet%';

--Filtrado con múltiples predicados
SELECT TotalDue,SalesPersonID,TerritoryID FROM Sales.SalesOrderHeader
WHERE TotalDue > 1000 AND (SalesPersonID=279 OR TerritoryID=6);


-- Trabajando con vacíos y nulos
SELECT ProductID, [Name], Style, Size, Color FROM Production.Product
WHERE (Color IS NOT NULL OR Style IS NOT NULL OR Size IS NOT NULL);


SELECT LastName, FirstName, MiddleName,BusinessEntityID FROM Person.Person
ORDER BY LastName,FirstName, MiddleName DESC ; -- ascendente 5,6,7,8 descendente 8,7,6,5

-- Escribir expresiones con operadores-
SELECT * FROM [Person].[Address];
SELECT AddressLine1+', '+City+', '+PostalCode AS Dirección_Completa FROM [Person].[Address];


SELECT ProductID, [Name]+': '+ISNULL(COLOR,'') AS Descripción FROM Production.Product; --Si la columna COLOR es NULA deja espacio en blanco


SELECT (CAST(ProductID AS varchar(255)))+': '+[Name] AS Descripción  FROM Production.Product; --Convierte a VARCHAR


--Uso de operadores matemático
SELECT [Description],SpecialOfferID,MinQty,MaxQty,(MinQty-MaxQty) AS Diferencia FROM Sales.SpecialOffer;

SELECT *,(ISNULL(MaxQty,10)*DiscountPct) AS Producto FROM Sales.SpecialOffer; --Si es null se reemplaza por ese valor

--Uso de funciones de cadena
SELECT AddressLine1,SUBSTRING(AddressLine1,1,5) AS Primeros5Caracteres FROM Person.[Address]; --Obten del caracter 1 al 5


--Uso de funciones fecha
SELECT SalesOrderID,OrderDate,ShipDate,ABS(CAST((OrderDate-ShipDate) AS INT)) AS Días_de_diferencia FROM Sales.SalesOrderHeader;

SELECT OrderDate,CONVERT(DATE,OrderDate) AS Fecha_sin_hora FROM Sales.SalesOrderHeader;

SELECT CONVERT(DATE,OrderDate), CONVERT(DATE,DATEADD(month,6,OrderDate)) AS Six_Months_more FROM Sales.SalesOrderHeader;

SELECT YEAR(OrderDate) AS Año, MONTH(OrderDate) AS Mes,DAY(OrderDate) AS Día,SalesOrderID, OrderDate FROM Sales.SalesOrderHeader;


-- Funciones matemáticas
SELECT SubTotal,ROUND(SubTotal,3) AS Redondeado3Decimales,ROUND(SubTotal,2) AS Redondeado2Decimales, ROUND(SubTotal,1) AS Redondeado1Decimal FROM Sales.SalesOrderHeader;

SELECT SalesOrderID,ROUND(SQRT(SalesOrderID),2) AS Raíz_cuadrada FROM Sales.SalesOrderHeader;


--- JOINS
SELECT table_pp.BusinessEntityID AS 'BusinessEntity', table_sc.PersonID AS 'PersonId',FirstName,LastName 

FROM Person.person AS table_pp
INNER JOIN Sales.Customer AS table_sc

ON table_pp.BusinessEntityID = table_sc.PersonID;


--Subconsultas
SELECT ProductID,[Name] FROM Production.Product
WHERE ProductID IN (
	SELECT ProductID FROM Sales.SalesOrderDetail
	);

SELECT ProductID,[Name] FROM Production.Product
WHERE ProductID > ALL (
	SELECT ProductID FROM Sales.SalesOrderDetail
	);


---Funciones de agregado
SELECT MAX(ListPrice) AS Máximo, MIN(ListPrice) AS Mínimo, AVG(ListPrice) AS Promedio FROM Production.Product;

SELECT COUNT(CustomerID) AS Número_de_clientes  FROM Sales.Customer;

SELECT COUNT(DISTINCT(TerritoryID)) AS 'Número de territorios diferentes' FROM Sales.Customer;


-- GROUP BY----------
SELECT COUNT(OrderQty) AS 'Número de productos vendidos con id: ',ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID;


SELECT CustomerID, Year(OrderDate) AS Año_de_venta, COUNT(SalesOrderID) AS Compras_Realizadas FROM Sales.SalesOrderHeader
GROUP BY CustomerID, Year(OrderDate)
ORDER BY CustomerID

-- Uso de Having-------------------------------------------------------------
--2
SELECT SalesOrderID,LineTotal FROM Sales.SalesOrderDetail
SELECT SalesOrderID,SUM(LineTotal) FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal)>1000;

SELECT ProductModelID, COUNT(ProductID) AS RecuentoProductos ,Color FROM Production.Product
WHERE Color = 'Red' or Color = 'blue'
GROUP BY ProductModelID,Color
HAVING COUNT(ProductID) >4 

-- Uso de consultas agregadas con más de una tabla.
--1
SELECT BusinessEntityID,FirstName,LastName FROM Person.Person;
SELECT CustomerID FROM Sales.Customer;
SELECT SalesOrderID FROM Sales.SalesOrderHeader;

SELECT pp.BusinessEntityID,sc.CustomerID,pp.FirstName+' '+pp.LastName AS 'Nombre del cliente',COUNT(ssoh.SalesOrderID) AS 'Número de pedidos' 
FROM Person.Person pp
INNER JOIN Sales.Customer sc

ON pp.BusinessEntityID=sc.CustomerID

INNER JOIN Sales.SalesOrderHeader ssoh

ON sc.CustomerID=ssoh.CustomerID

GROUP BY  pp.BusinessEntityID,sc.CustomerID,FirstName,LastName;

-- USO DE INSERT
INSERT INTO [AdventureWorksLT2008R2].[dbo].[demoProduct]
SELECT ProductID,[Name],StandardCost,ListPrice,Size,[Weight] FROM SalesLT.Product
WHERE ProductID= 707

--Operaciones DDL
--BDD
CREATE DATABASE miBaseDeDatos;

ALTER DATABASE miBaseDeDatos RENAME TO nuevaBaseDeDatos;

DROP DATABASE miBaseDeDatos;

--TABLES
DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    edad INT,
    salario DECIMAL(10, 2)
);

--MODIFICACION DE COLUMNAS
ALTER TABLE empleados ADD COLUMN email VARCHAR(100);

ALTER TABLE empleados DROP COLUMN email;

ALTER TABLE empleados MODIFY COLUMN salario DECIMAL(12, 3);


--ELIMINAR  ESTRUCTURA Y ELIMINAR SÓLO DATOS
DROP TABLE empleados;
TRUNCATE TABLE empleados;

--
DROP INDEX idx_nombre ON empleados;

DROP INDEX idx_nombre ON empleados;

--Creación de una vista
CREATE VIEW vista_empleados_jovenes AS
SELECT nombre, edad
FROM empleados
WHERE edad < 30;


--Creación de un procedimiento almacenado
CREATE PROCEDURE 
InsertarEmpleado(IN p_nombre VARCHAR(50), IN p_edad INT, IN p_salario DECIMAL(10,2), OUT p_id INT)
BEGIN
    INSERT INTO empleados (nombre, edad, salario) VALUES (p_nombre, p_edad, p_salario);
    SET p_id = LAST_INSERT_ID();
END 

CALL InsertarEmpleado('Juan', 30, 5000.00, @nuevoID); --Llamada al procedimiento alacemando
SELECT @nuevoID;

--Operaciones DML
--INSERT
INSERT INTO empleados (nombre, edad, salario) 
VALUES 
    ('Carlos', 35, 5500.00),
    ('Beatriz', 40, 6000.00);

--UPDATE
UPDATE empleados 
SET salario = salario + 500 
WHERE nombre = 'Ana';

UPDATE empleados 
SET edad = 36 
WHERE nombre = 'Carlos';

--DELETE
DELETE FROM empleados WHERE nombre = 'Beatriz';

DELETE FROM empleados WHERE salario < 5000.00;








