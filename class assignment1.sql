use AdventureWorks2014
-- what are the highest, lowest and average list prices among our finished goods products?
SELECT ROUND(MAX(p.ListPrice), 2) AS 'HighestPrice', 
    ROUND(MIN(p.ListPrice), 2) AS 'LowestPrice', 
    ROUND(AVG(p.ListPrice), 2) AS 'AveragePrice'
FROM Production.Product p 
WHERE p.FinishedGoodsFlag = 1

--create a report showing the number of current employees at Adventureworks by marital status
select
  CASE e.MaritalStatus	
  when's' then 'Single'
  when'm' then 'Married'
  End as 'Married Satatus',
  count(*) as 'Number of Employees'
From HumanResources.Employee e
where e.CurrentFlag=1
group by e.MaritalStatus

--The marketing Department is preparing an email promotion that will be sent to all people who opted in
--provide them with a list of first names, last names and email addresses for eligible individuals
SELECT pp.FirstName, pp.LastName, ea.EmailAddress
FROM Person.Person pp
INNER JOIN Person.EmailAddress ea
ON pp.BusinessEntityID = ea.BusinessEntityID
WHERE EmailPromotion = 1

--The sales manager would like to know which products were sold at unit prices that are 50% or less of the list price
--show each unique product name and discount rate.
SELECT DISTINCT p.Name, FORMAT(((p.ListPrice - sod.UnitPrice)/p.ListPrice),'P') as 'Discount Rate'
FROM Production.Product p 
INNER JOIN Sales.SalesOrderDetail sod
ON p.ProductID = sod.ProductID
WHERE sod.UnitPrice <= 0.5 * p.ListPrice
ORDER BY 'Discount Rate'

--Produce a list of current employees who have not changed their password since the breach. Include names, password change dates and email addresses
SELECT p.FirstName + p.lastName as EmpName, pass.ModifiedDate, ea.emailAddress
FROM Person.Password pass
INNER JOIN Person.Person p
ON pass.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.EmailAddress ea
ON p.BusinessEntityID = ea.BusinessEntityID
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID
WHERE DATEPART(yy,pass.ModifiedDate) <= 2007
AND e.CurrentFlag = 1;

--The production Manager would like a listing of finished goods products that are still for sale but have never sold
--product names in alphabetical order
Select p.ProductID,p.Name
From Production.Product p
Left Join Sales.SalesOrderDetail s
on p.ProductID=s.ProductID
where p.FinishedGoodsFlag=1
and p.SellEndDate is null
and s.ProductID is null;

--which departments have 10 or more employees currently assigned to them?
--sort the list in descending order of employee
SELECT hv.Department, COUNT(hv.BusinessEntityID) as no_employee
FROM HumanResources.Employee he
INNER JOIN HumanResources.vEmployeeDepartment hv
ON he.BusinessEntityID = hv.BusinessEntityID
WHERE he.CurrentFlag = 1
GROUP BY hv.Department
HAVING count(hv.BusinessEntityID) > 10
ORDER BY hv.Department ASC; 

--The plant supervisor asked for a report showing all products that have fallen below 25% of their safety stock levels.
--produce a report showing the quantity needed, product name and location for all such products.
--sort it by location alphabetically and then in descending order of quantity needed.
select pi.quantity, p.SafetyStockLevel, p.Name, l.name
from production.product p
join production.ProductInventory pi on p.ProductID = pi.ProductID
join Production.location l on pi.locationID= l.LocationID
where pi.Quantity< 0.25*p.SafetyStockLevel
order by l.name, p.SafetyStockLevel;

-- some clothing items were mislabeled and management will inform customers
--Prepare a list of affected customers with phone number, product names and order dates. Sort by last name and then by first name
--The issue applies to all orders for shorts placed online after July 7,2008
SELECT 
    per.LastName,
    per.FirstName,
    ph.PhoneNumber,
    pro.Name,
    soh.OrderDate
FROM Person.Person per
INNER JOIN Person.PersonPhone ph 
ON per.BusinessEntityID = ph.BusinessEntityID
INNER JOIN Sales.Customer cus 
ON ph.BusinessEntityID = cus.PersonID
INNER JOIN Sales.SalesOrderHeader soh 
ON cus.CustomerID = soh.CustomerID 
INNER JOIN Sales.SalesOrderDetail sod 
ON soh.SalesOrderID = sod.SalesOrderID 
INNER JOIN Production.Product pro
ON sod.ProductID = pro.ProductID 
WHERE pro.Name like '%shorts%'