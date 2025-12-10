-- Week 14 Day 03 05.12.2025: 
-- PL/SQL , Stored Procedures
-- SQL Programming basic
-- More Practice

use dkinganjatou1_Northwind
go

drop procedure if exists SP_InsertNewCategory
go

create or alter procedure SP_InsertNewCategory
	@CatName  varchar(30) = null,   -- default value
	@Message varchar (100) output -- it will make this variable as output type so that you can return more than one value
as
	if @CatName is null  or len(@CatName) = 0 or len(@CatName) > 30
		begin 
			--print 'Please provide Category Name | maximum 30 characters are allowed'
			set @Message = 'Please provide Category Name | maximum 30 characters are allowed'
			return -1  -- -1 means Parameters are empty
		end
	else
		begin
			-- Alernative  II : Comment out the folliwing block 
			/*
			  if exists (select * from dkinganjatou1_Northwind.dbo.Categories c where c.CategoryName = @CatName)
			  begin
				--print 'Inside If item is already there ' + cast(@rowCount as varchar)  + ' Rows affected'
					set @Message = 'Item is Already in the Database'
					return 1   -- 1 means item is already there in database table
			  end
			 */
			-- Alternative 1 to check if item is already there
			-- Comment out the following one and uncomment the above to test with alternative II
			select * 
			from dkinganjatou1_Northwind.dbo.Categories c
			where c.CategoryName = @CatName

			-- Super Global : @@identity, @@Rowcount, @@Error
			declare @rowCount int = @@ROWCOUNT   -- Number of rows affected by last executed query

			if @rowCount > 0
				begin 
					--print 'Inside If item is already there ' + cast(@rowCount as varchar)  + ' Rows affected'
					set @Message = 'Item is Already in the Database'
					return 1   -- 1 means item is already there in database table
				end
			 -- Commented out till this point
			else
				begin
					-- If that category is not part of the table, insert it
					begin transaction 

						insert into dkinganjatou1_Northwind.dbo.Categories (CategoryName)
						values (@CatName)

						if @@ERROR = 0   -- There is no error when last query was executed
							begin
								commit   -- making the changed saved in DB
								--print 'New Category is inserted successfully'
								set @Message = 'New Category is inserted successfully'
								return  2  -- 2 means inserted successfully
							end
						else
							begin
								rollback   -- ignoring any changes made during last transaction
								                -- Error_Number / @@Error : Gives the error number    Error_Message() gives the actual error message
								set @Message = 'Error ' + cast( ERROR_NUMBER() as varchar) + 'Message ' + ERROR_MESSAGE()
								return 3 -- 3 means error
								
							end
				end
		end
go

declare @retunedValue int 
declare @myMessage varchar(100)

exec @retunedValue = SP_InsertNewCategory @CatName= 'CMPE1667', @Message = @myMessage output  

print @retunedValue
print @myMessage

select * from Categories
exec sp_help Categories

-- BREAK TIME 09:00 
/* 
use use dkinganjatou1_IQSchool Database copy for this one
Create a SP to delete a club based on provided club id

Make sure club id is not empty , Return 1 in that case

If club does not already exists Return 2

To Delete a club you need to make sure to delete entries 
from some other tables as well [May be check Activity Table]

If there is an error give me error number back
Handle Transaction if something goes wrong give me database in consistent state 
before this operation

Otherwise save those changes permanently in db and retun 0

*/

use dkinganjatou1_IQSchool
go 

drop procedure if exists SP_DeleteClub
go

create procedure SP_DeleteClub
	@ClubID varchar(10) = null
as
	
	if @ClubID is null 
		begin
			print 'Need to provide club id'
			return 1
		end
	else
		begin
			print 'inside Else '
			if not exists (select * from club where ClubId = @ClubID)
				begin
					print 'No such club exists'
					return 2
				end
			else 
				begin
					-- Delete entries here

					-- Delete from activiy table - CHILD TABLE
					begin transaction 
						delete from Activity
						where ClubId = @ClubID

						if @@ERROR <> 0
							begin
								print 'Error while deleting from activiy table'
								rollback
								return @@ERROR
							end
						else 
							begin 
								-- Delete entry from club table -- Parent table

									delete from club
									where ClubId = @ClubID

									if @@ERROR  <>0
										begin
											rollback
											print 'Error while deleting from Club table'
											return @@Error
										end
									else
										begin
											commit 
											print 'Deleted successfully from both tables'
											return 0
										end
							end
				end
		end
	
go

declare @returnedValue int 
exec   @returnedValue = SP_DeleteClub  'Nasa'

print  @returnedValue


select * from Club where ClubId = 'NASA'
select * from Activity where ClubId = 'NASA'
exec sp_help club

