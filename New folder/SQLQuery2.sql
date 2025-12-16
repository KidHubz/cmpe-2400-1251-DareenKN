use dkinganjatou1_Northwind
go

begin transaction
	insert into Categories 
		(CategoryName, Description)
	values
		('Chocolate','All Chocolate Always'),
		('Coach ','Coach Snackies')
commit

delete c
from Categories c
where c.CategoryID = 12



select c.CategoryID,
	   c.CategoryName,
	   c.Description
from Categories c
order by c.CategoryID desc