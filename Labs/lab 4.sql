-- Question 1
/*
Use your own copy of the Northwind database. You may wish to copy the below script into SSMS before entering any responses to work on it there. All responses must be entered into Mobius.

You will create a stored procedure that will accept a terminated employee id and a new employee's last and first name, and replace all orders, territories and supervisees from the former employee to the new employee. Finally, the script will delete the former employee's record.

This question will guide you through the journey... please fill in the parts that are indicated.

Stored procedure is to be named "replaceEmployee"

--conditional drop statement for the replaceEmployee procedure
*/
drop procedure if exists replaceEmployee
go

create procedure replaceEmployee
--integer parameter oldId
    @oldId int = null,
--varchar size 30 parameter newLast
    @newLast varchar(30) = null,
--varchar size 30 parameter newFirst
    @newFirst varchar(30) = null
as
   declare @numRows int = 0
   --check if former employee record exists
   --@numRows will have 0 if not exists, 1 if exists. Due to PK 
   --it shouldn't have any other number
   select @numRows = count(*)
   from Employees
   where EmployeeID = @oldId  --fill in the where clause

   if @numRows != 1
   begin
      print 'Old employee not found'
      return -1
   end

   --check if new employee is already in db
   declare @newEmployee int
   --populate @newEmployee using the below select statement
   select @newEmployee = e.EmployeeID
   from Employees e
   where e.FirstName = @newFirst
   and e.LastName = @newLast

   --store the number of rows returned by the above select
   --using the appropriate system function
   set @numRows = @@ROWCOUNT

   if @numRows > 1
   begin
      print 'Too many employees found that match new employee name'
      return -2
   end
   --start handling transactions now - all update/insert/delete transactions
   --must succeed or fail together
   begin transaction
      if @numRows = 0
      begin
         --insert record into Employees. Catch any errors and handle appropriately
         begin try
            insert into Employees (LastName,FirstName)
            values (@newLast, @newFirst)
            --store new employeeid using system function into @newEmployee
            set @newEmployee = SCOPE_IDENTITY()
         end try

         begin catch
            print 'Error inserting new employee ' + Error_Message()
            --handle transaction appropriately
            rollback  
            return -3
         end catch
      end
      
      --now we have @newEmployee, so reassign all orders from the terminated
      --employee to the new employee
      begin try
         update Orders
         set EmployeeID = @newEmployee
         where EmployeeID = @oldId
      end try
      
      begin catch
         print 'Update Orders failed ' + Error_Message()
         rollback
         return -4
      end catch

      --assign the new employee the territories from the terminated employee
      begin try
         update EmployeeTerritories
         set EmployeeID = @newEmployee  
         where EmployeeID = @oldId
      end try

      begin catch
         print 'Update EmployeeTerritories failed ' + Error_Message()
         rollback
         return -5
      end catch 

      --ensure if anyone reports to the terminated employee,
      --that they now report to the new employee
      begin try
         update Employees
         set ReportsTo = @newEmployee
         where ReportsTo = @oldId
      end try

      begin catch
         print 'Update Employees failed ' + Error_Message()
         rollback
         return -6
      end catch

      --delete the former employee
      begin try
         delete from Employees
         where EmployeeID = @oldId      
      end try
      begin catch
         print 'Delete Employees failed ' + Error_Message()
         rollback
         return -7
      end catch

      --handle the transaction appropriately
      commit
      return 0 --no error occurred
go

-- Question 2
/*
This question involves a stored procedure and transactions.

Northwind Traders is experimenting with using sensors, and has provided you with some tables. You are requested to complete some work in regards to this experiment.

** Ensure you are using your LOCAL Northwind Database before running any code for this question. **

Part 1: Copy and paste this code into a blank Query window: [required]. Note these tables will be used in your stored procedure - refer to them as needed!

--USE YOUR LOCAL NORTHWIND!!

drop table if exists Readings
go

drop table if exists Sensors
go

create table Sensors 
(
    SensorId        tinyint            not null    
        primary key clustered,
    [Description]    varchar(50)        not null,
    Location        varchar(50)        not null
)
go

create table Readings 
(
    SensorId        tinyint            not null
        constraint FK_SensorId foreign key references Sensors(SensorId),
    TimeStampValue    datetime        not null,
    [Value]            smallint        not null,    constraint PK_SensorId_TimeStampValue 
        primary key clustered (SensorId,TimeStampValue) --composite primary key
)
go
*/