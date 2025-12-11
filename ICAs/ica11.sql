-- -- Question 1
-- /*
-- You found a stored procedure that is already built in to SQL Server! Look at the following execution samples, assuming NorthwindTraders database, and answer the following questions.
-- */
-- use NorthwindTraders
-- go 

-- -- exec sp_depends @objname = 'Order Details'

-- -- exec sp_depends 'Order Details'

-- -- exec sp_depends

-- /*
-- Which of the above executions will display dependencies for 'Order Details'	
-- - Execution on Line 1
-- - Execution on Line 3
-- - Execution on Line 5
-- - None of the Above
-- */

-- -- Question 2
-- /*
-- 3 people are buying a car together. Consider the following code which takes in 3 account numbers to debit three amounts from, and then credits an account with the total amount:
-- */

-- create or alter procedure ThreePartyPayment 
--     @Account1 int, @Account2 int, @Account3 int,
--     @Amount1 money, @Amount2 money, @Amount3 money,
--     @Recipient int
-- as
--     -- debit account #1
--     insert into Transactions (AccountNum, TxType, Amount)
--     values (@Account2, 'DEBIT', @Amount2)

--     -- debit account #2
--     insert into Transactions (AccountNum, TxType, Amount)
--     values (@Account2, 'DEBIT', @Amount2)

--     -- debit account #3
--     insert into Transactions (AccountNum, TxType, Amount)
--     values (@Account2, 'DEBIT', @Amount3)

--     -- credit account
--     insert into Transactions (AccountNum, TxType, Amount)
--     values (@Account2, 'CREDIT', @Amount1 + @Amount2 + @Amount3)
-- go

-- Question 3
/*
This question requires creating a stored procedure in your own DB, and referencing the globally available Northwind db in your stored procedure

Your stored procedure must be stored in your database
Reference a different database within that stored procedure by using the fully qualified database name
Create a procedure that will accept a city (exact match regardless of case), and return

the following stats as output parameters:

The number of orders from customers in that city
The most recent order date from customers in that city
The total order amount for all orders from customers in that city (UnitPrice*Qty less discount)
 

Paste your SQL statement below - this question will be graded manually by your instructor.

Include:

Use statement for your DB
drop procedure if it exists
create procedure
The 2 sample executions as shown below
*/

use dkinganjatou1_Northwind
go

drop procedure if exists OrderStats
go

create procedure OrderStats
   @City varchar(30) = null,
   @NumOfOrders int output,
   @RecentOrderDate datetime output,
   @TotalOrderAmt money output
as
   if @City is null 
   begin
      return -1
   end
   else
   begin
      if exists(  select 1 from NorthwindTraders.dbo.Customers c             
                  where c.City = @City )
      begin             
            select  @NumOfOrders = count(distinct o.OrderID),
                  @RecentOrderDate = max(o.OrderDate),
                  @TotalOrderAmt = sum(od.UnitPrice * od.Quantity * (1 - od.Discount))
            from NorthwindTraders.dbo.Orders o
               join NorthwindTraders.dbo.Customers c
                        on o.CustomerID = c.CustomerID
               join  NorthwindTraders.dbo.[Order Details] od
                  on o.OrderID = od.OrderID
            where lower(c.City) = lower(@City)
            group by c.City
      end  
   end
go

declare @numOrders  int 
declare @latestorder  Date 
declare @totalamount  money
 
exec OrderStats 'berlin', @numOrders  out, @latestorder  out, @totalamount out
select 'Berlin' 'City', @numOrders 'Number of Orders', @latestorder 'Last Order', @totalamount 'Total'

exec OrderStats 'VANCOUVER', @numorders out, @latestorder out, @totalamount out

select 'Vancouver' 'City', @numorders 'Number of Orders', @latestorder 'Last Order', @totalamount 'Total'

-- Question 4
/*
This question requires creating a stored procedure in your own DB, and referencing the globally available Northwind db in your stored procedure 

Create a procedure that will accept a parameter for CategoryName. The user can supply the start of a category name (ie Dairy instead of Dairy Products).

The procedure will display the CategoryName, ProductID, ProductName and UnitsInStock for all products that match the provided Category. If no category is entered, all products of all categories are returned. Order the results by CategoryName then ProductName. 

Paste your SQL statement below - this question will be graded manually by your instructor.

Include:

Use statement for your DB
drop procedure if it exists
create procedure
The 2 sample executions as shown below
*/

use dkinganjatou1_Northwind
go 

drop procedure if exists ProductsForCategories
go

create procedure ProductsForCategories
    @CategoryName varchar(30) = null
as
   begin
      if @CategoryName is null or len(@CategoryName) = 0
      begin
         select   c.CategoryName,
                  p.ProductID,
                  p.ProductName,
                  p.UnitsInStock
         from NorthwindTraders.dbo.Products p
            join NorthwindTraders.dbo.Categories c
               on c.CategoryID = p.CategoryID
         order by c.CategoryName, p.ProductName
         return            
      end  
      if exists(
                  select 1 from NorthwindTraders.dbo.Categories c
                  where c.CategoryName like @CategoryName + '%'
               )
      begin 
         select   c.CategoryName,
                  p.ProductID,
                  p.ProductName,
                  p.UnitsInStock
         from NorthwindTraders.dbo.Products p
            join NorthwindTraders.dbo.Categories c
               on c.CategoryID = p.CategoryID
         where c.CategoryName like @CategoryName + '%'
         order by c.CategoryName, p.ProductName
      end  
   end    
go  

exec ProductsForCategories

exec ProductsForCategories 'Dairy'
go

-- Question 5
/*
This question requires your own copy of NorthwindTraders 

Northwind has received many complaints about products sold in the Grains/Cereals category. Accounting wants to double all discounts for existing Order Details in that category to compensate. Any orders with no current discount remain unchanged.

Create a Stored Procedure that updates Order Details records per the above and returns the number of rows that have been updated. If an error occurs, the stored procedure must undo any work and return -1. 

Include the following:

Appropriate use statement for your DB
The stored procedure drop statement (if it exists)
Stored Procedure Create
A statement that executes the created stored procedure, stores the return value, and displays it to the screen
*/









    
