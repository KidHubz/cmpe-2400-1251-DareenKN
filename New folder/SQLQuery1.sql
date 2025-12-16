use dkinganjatou1_ClassTrak
go

drop procedure if exists SP_StudentClass
go

create procedure SP_StudentClass
	@FromClassId int, 
	@ToClassId int,
	@StudentLastName varchar(30),
	@StudentFirstName varchar(30)
as
begin
	declare @rowCount int = null
	if exists(
				select *
				from Students s
					join class_to_student cs
						on cs.student_id = s.student_id
					join Classes c
						on cs.class_id = c.class_id
				where c.class_id = @FromClassId
				and lower(s.last_name) = lower(@StudentLastName)
				and s.first_name like @StudentFirstName + '%'
				)
	begin
		set @rowCount = @@ROWCount
		if @rowCount = 0
		begin 
			return -140
		end

		else if @rowCount > 1
		begin
			return -273
		end

		else if @rowCount = 1
		begin
			if exists	(
							select 1
							from Classes c
							where c.class_id = @ToClassId
						)
			begin
			if exists   (
							select 1
							from Students s
								join class_to_student cs
									on cs.student_id = s.student_id
								join Classes c
									on cs.class_id = c.class_id
							where c.class_id = @ToClassId
							and lower(s.last_name) = lower(@StudentLastName)
							and s.first_name like @StudentFirstName + '%'
						) 
				begin
					begin try
						begin transaction
							delete s
							from Students s
								join class_to_student cs
									on cs.student_id = s.student_id
								join Classes c
									on cs.class_id = c.class_id
							where c.class_id = @FromClassId
							and lower(s.last_name) = lower(@StudentLastName)
							and s.first_name like @StudentFirstName + '%'

							delete r
							from Results r							
								join Students s
									on r.student_id = s.student_id
								join class_to_student cs
									on cs.student_id = s.student_id
								join Classes c
									on cs.class_id = c.class_id
							where c.class_id = @FromClassId
							and lower(s.last_name) = lower(@StudentLastName)
							and s.first_name like @StudentFirstName + '%'
						commit transaction
						return 0
					end try

					begin catch
						if @@TRANCOUNT > 0
						rollback
						return -427
					end catch
				end
				else 
				begin
					begin try
						begin transaction
							delete r
							from Results r							
								join Students s
									on r.student_id = s.student_id
								join class_to_student cs
									on cs.student_id = s.student_id
								join Classes c
									on cs.class_id = c.class_id
							where c.class_id = @FromClassId
							and lower(s.last_name) = lower(@StudentLastName)
							and s.first_name like @StudentFirstName + '%'

							update class_to_student 
							set class_id = @ToClassId
							where class_id = (	select c.class_id
												from Students s
													join class_to_student cs
														on cs.student_id = s.student_id
													join Classes c
														on cs.class_id = c.class_id
												where c.class_id = @FromClassId
												and lower(s.last_name) = lower(@StudentLastName)
												and s.first_name like @StudentFirstName + '%')
						commit transaction
						return 0
					end try

					begin catch
						if @@TRANCOUNT > 0
						rollback
						return -427
					end catch
				end
			end

			else
			begin
				return -327
			end
		end
	end
end
go

select	s.last_name,
		s.first_name,
		c.class_id
from Students s
	join class_to_student cs
		on cs.student_id = s.student_id
	join Classes c
		on cs.class_id = c.class_id
where c.class_id = 88
and lower(s.last_name) = lower('Baziuk')
and s.first_name like 'Mat' + '%'

select *
from Classes c
where c.class_id = 88

/*
Here are some test cases for your code:

Mark Abbott is transferring from Class 83 to Class 87. This should succeed.
John Bebe is transferring from Class 127 to Class 83. This should succeed.
John Bebe is transferring from Class 111 to Class 85. This should fail with error -140
*/

declare @FromClassId int, 
		@ToClassId int,
		@StudentLastName varchar(30),
		@StudentFirstName varchar(30)