use AdventureWorks2014
--Problem 1, part A
select 	st.Name, count(e.SubTotal)as territoryrevenue
From Sales.SalesOrderHeader e
Inner join Sales.SalesTerritory st
on e.TerritoryID = st.TerritoryID
group by st.Name
order by territoryrevenue Desc

--Problem 1, part B
select st.Name, Datepart(MM,e.ModifiedDate)as Month, Datepart(yy,e.ModifiedDate)as Year,count(e.SubTotal)as territoryrevenue
From Sales.SalesOrderHeader e
Inner join Sales.SalesTerritory st
on e.TerritoryID = st.TerritoryID
group by st.Name,Datepart(MM,e.ModifiedDate), Datepart(yy,e.ModifiedDate)
having Datepart(yy,e.ModifiedDate) = '2013'
order by st.Name ,Datepart(MM,e.ModifiedDate)

--Problem 1, part C
select 	Distinct st.Name AS AwardWinners
From Sales.SalesOrderHeader e
Inner join Sales.SalesTerritory st
on e.TerritoryID = st.TerritoryID
where Datepart(yy,e.ModifiedDate) = '2013'
GROUP BY st.Name, MONTH(e.OrderDate)
HAVING SUM(e.SubTotal)> 750000
ORDER BY st.Name ASC;

--Problem 1, part D
select 	Distinct st.Name 
From Sales.SalesOrderHeader e
Inner join Sales.SalesTerritory st
on e.TerritoryID = st.TerritoryID
where Datepart(yy,e.ModifiedDate) = '2013'
GROUP BY st.Name, MONTH(e.OrderDate)
HAVING SUM(e.SubTotal)< 750000
ORDER BY st.Name ASC;


--Problem 2, part A
select p.Name, sum(sod.OrderQty) as total_number_units_order
from Production.Product p
INNER JOIN sales.SalesOrderDetail sod
on p.ProductID=sod.ProductID
where FinishedGoodsFlag=1
group by p.name
HAVING SUM(sod.OrderQty) < 50
ORDER BY SUM(sod.OrderQty) ASC;

--Problem 2, part B
SELECT CountryRegionName, MAX(tax.TaxRate) AS TaxRate
FROM Sales.SalesTaxRate tax
INNER JOIN Person.StateProvince sp
ON tax.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.vStateProvinceCountryRegion cr
ON sp.StateProvinceCode = cr.StateProvinceCode
GROUP BY cr.CountryRegionName
ORDER BY TaxRate DESC

--Problem 2, part C
SELECT DISTINCT(a.Name) AS StoreName, st.Name AS TerritoryName
FROM Sales.SalesOrderDetail sod 
INNER JOIN Production.Product p 
ON sod.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
INNER JOIN
(SELECT s.BusinessEntityID, s.Name, c.CustomerID,c.StoreID,c.TerritoryID
FROM Sales.Store s
INNER JOIN Sales.Customer c 
ON s.BusinessEntityID = c.StoreID) a 
ON soh.CustomerID = a.CustomerID
WHERE p.Name LIKE '%Helmet%'
AND soh.ShipDate BETWEEN '2014-02-01' AND '2014-02-05'
ORDER BY TerritoryName, StoreName ASC




