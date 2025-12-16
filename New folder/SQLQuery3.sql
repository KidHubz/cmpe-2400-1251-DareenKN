use dkinganjatou1_Northwind
go

begin transaction 
	insert into Customers
		(CustomerID ,CompanyName, ContactName, ContactTitle)
	 select upper(left(e.FirstName,5)),e.FirstName + ' - ' + e.LastName,e.LastName + ', ' + e.FirstName,'Teacher'
	from Employees e
commit
rollback

select *
from Employees

select *
from Customers
where ContactTitle like 'Teacher'


insert into Customers
	(CustomerID ,CompanyName, ContactName, ContactTitle)
values 
	((select upper(left(e.FirstName,5)) from Employees e),
	(select e.LastName from Employees e) + ' - ' + (select e.FirstName from Employees e),
	(select e.LastName from Employees e) + ', ' + (select e.FirstName from Employees e),
	'Teacher ')

select upper(left(e.FirstName,5)) from Employees e