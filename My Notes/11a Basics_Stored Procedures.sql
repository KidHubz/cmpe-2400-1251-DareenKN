-- Week 14 Day 01 02.12.2025: 
-- PL/SQL , Stored Procedures
-- SQL Programming basic
/*
1. How to declare variables?
2. Control Flow Statements
	2a. Branching: if, if else, case
	2b. Looping: while loop
3. User Defined functions/ Stored Procedure
*/

--1. How to declare variables?
   -- declare @name dataType = value -- Declaration and initialization
   -- declare @name dataType		 -- Declaration
   -- set @name = value              -- Assigning value to variable SET keyword is important

	declare @age int = 20
	-- print this value

	print @age

	declare @nameOfStudent varchar(40)
	set @nameOfStudent = 'Simran'

	print 'Name of the student = ' + @nameOfStudent

--2. Control Flow Statements
-- 2a. Branching: if, if else, case
-- 2b. Looping: while loop

declare @marks int = 60

if @marks >= 50  -- No parenthesis around condition
	print 'You are pass'  -- no curly brackets if there is a single statement
else
	print 'Come again in the next term'
go

declare @marks int = 40 
declare @grade char 

	if @marks >= 50 
		begin 
			set @grade = 'E'
			print 'You are pass'
		end 
	else
		begin
			set @grade = 'F'
			print 'Come again in the next term'
		end
print 'Your Grade = ' + @grade

-- case which is similar to switch statement in C#
-- First Version
/*
	case Startingvalue
		when comparisonvalue  then action 1
		when comparisonvalue1 then action 2
		..
		..
		else action n
	end
*/
declare @caseResultValue varchar(30)
set @caseResultValue = case len('TEST')
							when 1 then 'Length is 1'
							when 2 then 'length is 2'
							when 3 then 'length is 3'
							when 4 then 'length is 4'
							else 'Over 4'
						end -- to end your case statement
print @caseResultValue

-- Second version of case
/*
	case 
		when booleanExpression  then action 
		when booleanExpression  then action1
		...

		else action n
	end
*/

declare @marks int = 85

print case  
		when @marks >= 91 and  @marks <=100 
			then 'Grade is A+'
		when @marks >=81 and @marks <= 90
			then 'Grade is A'
		else  -- default case in switch statement
			'Grade is F'
	  end 



-- 2b. Looping: while loop
declare @i int = 1
declare @sum int = 0
print 'Numbers from 1 to 10 '

while @i <= 10 
	begin 
		print @i
		set @sum = @sum + @i
		set @i = @i + 1
	end

print 'Sum of numbers = ' + convert(varchar(10),@sum)


--3. User Defined functions/ Stored Procedure

use dkinganjatou1_pubs
go 
-- Alternative 1
drop procedure if exists SP_AuthorNames
go

-- Alternative 2
if exists 
(
	select [name]
	from sysobjects
	where [name] = 'SP_AuthorNames'
)
drop procedure SP_AuthorNames
go

-- Define a stored procedure 

create procedure SP_AuthorNames
as
	select au_fname + ' '+ au_lname as 'AuthorName' from dkinganjatou1_pubs.dbo.authors
go

-- To run stored procedure 
execute SP_AuthorNames
-- short form
exec SP_AuthorNames



-- Making sure to drop procedure
drop procedure if exists SP_TitlesInfo
go

-- Create procedure with parameter
                                           -- Default value for parameter
create procedure SP_TitlesInfo (@TitleId  varchar(6) = 'BU1032' )
-- you can inlcude paramenters
as
	select * 
	from dkinganjatou1_pubs.dbo.titles t
	where t.title_id = @TitleId 
go

exec SP_TitlesInfo  'BU1111'

exec sp_help titles

