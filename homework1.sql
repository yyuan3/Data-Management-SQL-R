-- Ye Yuan
-- Data Management
-- SQL Assignment 1

use AdventureWorks2014;

--Problem 1, Part A
select DISTINCT p.JobTitle
FROM HumanResources.Employee p
order by p.JobTitle

--Problem 1, Part B
select DISTINCT p.JobTitle
FROM HumanResources.Employee p
where p.JobTitle like '%Manager%'
or p.JobTitle like '%Supervisor%'
or p.JobTitle like '%Chief%'
or p.JobTitle like '%Vice President%'
Order by p.JobTitle

--Problem 1, Part C
select count(p.JobTitle) as Managers
FROM HumanResources.Employee p
where p.JobTitle like '%Manager%'
or p.JobTitle like '%Supervisor%'
or p.JobTitle like '%Chief%'
or p.JobTitle like '%Vice President%'

--Problem 1, Part D
select p.BusinessEntityID as EmployeeID, p.JobTitle,P.BirthDate
FROM HumanResources.Employee p
where DATEDIFF(YEAR,p.BirthDate,CURRENT_TIMESTAMP)>=60
order by p.BirthDate DESC

--Problem 1, Part E
select p.BusinessEntityID as EmployeeID, p.JobTitle, p.HireDate, DATEDIFF(YEAR,p.HireDate,'2019-09-05') as EmploymentYears
FROM HumanResources.Employee p
where DATEDIFF(YEAR,p.BirthDate,CURRENT_TIMESTAMP)>=60
and DATEDIFF(YEAR,p.HireDate,CURRENT_TIMESTAMP)>=7
order by EmploymentYears DESC,HireDate

--Problem 2, Part A
select p.ProductID, P.Name,p.ListPrice,p.SafetyStockLevel,p.SellEndDate
FROM Production.Product p
where p.FinishedGoodsFlag =1
and (DATEDIFF(day,CURRENT_TIMESTAMP,p.SellEndDate) >0 
or p.SellEndDate IS NULL)
order by p.Name ASC

--Problem 2, Part B
select P.Name,P.Color
FROM Production.Product p
where p.name like '%yellow%'
and (color not like '%Yellow%' 
OR Color is null)
order by p.Name 

--Problem 2, Part C
select P.Name,P.SellStartDate
FROM Production.Product p
where p.SellStartDate >= '2013-01-01'
and p.SellStartDate <= '2013-05-31'
order by p.Name 

--Problem 2, Part D
select P.name,P.SellStartDate,DATEPART(dw ,P.SellStartDate) as 'the day of the week'
FROM Production.Product p
where DATEPART(dw ,P.SellStartDate)>=4
order by p.SellStartDate ASC ,
p.Name 









