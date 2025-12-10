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

create or alter procedure SP_CityOrdersInfo
    @City varchar(30) = null,
    @NumOfOrders int output,
    @RecentOrderDate date output,
    @TotalOrderAmt money output
as
    if @City is null 
        begin
            return -1
        end
    else
        begin
            if exists(select count(o.OrderID)
            from dkinganjatou1_Northwind.dbo.Orders o
                join dkinganjatou1_Northwind.dbo.Customers c
                    on o.CustomerID = c.CustomerID
            group by c.City
            having c.City = @City)


            -- select count(o.OrderID)
            -- from dkinganjatou1_Northwind.dbo.Orders o
            --     join dkinganjatou1_Northwind.dbo.Customers c
            --         on o.CustomerID = c.CustomerID
            -- group by c.City
            -- having c.City = @City

            -- declare @rowCount int = @@ROWCOUNT

            -- if @rowCount > 0
                begin  
                    return 1
                end  
            else  
                begin  
                    begin transaction  

                end  
        end
go

select count(o.OrderID)
from dkinganjatou1_Northwind.dbo.Orders o
    join dkinganjatou1_Northwind.dbo.Customers c
        on o.CustomerID = c.CustomerID
group by c.City
having c.City = 'Berlin'

select City
from dkinganjatou1_Northwind.dbo.Customers c
    