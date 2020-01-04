use AdventureWorks2014
select e.JobTitle
From HumanResources.Employee e
where e.JobTitle like '%Sales%'
UNION
SELECT e2.JobTitle
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice president%'

--NAMES AND SICK LEAVE BALANCES inner join
SELECT P.FirstName, p.LastName,e.VacationHours,e.SickLeaveHours
FROM Person.Person P
INNER JOIN HumanResources.Employee E
on p.BusinessEntityID=e.BusinessEntityID

--Job title and hurly rates for employees who have earned <20/hr
select e.JobTitle,eph.Rate
from HumanResources.EmployeePayHistory eph
INNER JOIN HumanResources.Employee E
ON EPH.BusinessEntityID=E.BusinessEntityID
WHERE eph.Rate<20
order by eph.rate DESC

--show employees with same birthday
select e.BusinessEntityID,e2.BusinessEntityID,e.BirthDate,e2.BirthDate
from HumanResources.Employee e
Inner join HumanResources.Employee e2
on e.birthdate =e2.BirthDate
--we have duplicates, same people has same birthday
--where e.BusinessEntityID<>e2.BusinessEntityID
where e.BusinessEntityID >e2.BusinessEntityID -- one is greater than the other


--every possible pair of emplyees
select *
from HumanResources.Employee e
cross join
HumanResources.Employee e2
--dont run!!!


--Names,genders,hashed passwords
--for all current employees
select p.FirstName,p.LastName,e.Gender,pswd.PasswordHash,e.CurrentFlag
from Person.Person p
INNER JOIN HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
Inner join person.Password pswd
on p.BusinessEntityID=pswd.BusinessEntityID
where e.CurrentFlag=1


-- show me the names,titles, and department names of all current employees in the R&D group.
select P.FirstName,P.MiddleName,P.LastName,E.JobTitle,D.Name
from person.Person p
Inner Join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
Inner join HumanResources.EmployeeDepartmentHistory edh
On e.BusinessEntityID=edh.BusinessEntityID
Inner join HumanResources.Department d
on edh.DepartmentID = d.DepartmentID
where e.CurrentFlag=1 and d.Name='Research and Development'
order by p.FirstName ASC;



--Job candidates, and for the hires,job title
select*
from HumanResources.JobCandidate jc
left outer join HumanResources.Employee e
on jc.BusinessEntityID=e.BusinessEntityID