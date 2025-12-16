-- Question 2
/*
This question involves a stored procedure and transactions.

Northwind Traders is experimenting with using sensors, and has provided you with some tables. You are requested to complete some work in regards to this experiment.

** Ensure you are using your LOCAL Northwind Database before running any code for this question. **

Part 1: Copy and paste this code into a blank Query window: [required]. Note these tables will be used in your stored procedure - refer to them as needed!

--USE YOUR LOCAL NORTHWIND!!
*/
use dkinganjatou1_NorthWind
go

drop table if exists Readings
go

drop table if exists Sensors
go

create table Sensors 
(
    SensorId        tinyint            not null    primary key clustered,
    [Description]   varchar(50)        not null,
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

/*
Part 2: Write a stored procedure, utilizing a transaction, whose objective is to store data readings from a remote sensor when the procedure is called.

The procedure has 5 parameters:

Description	Datatype	    Parameter Type
ID of the Sensor	        tinyint	Input
Description of the Sensor	varchar(50)	Input
Location of the Sensor	    varchar(50)	Input
Value read from the Sensor	smallint	Input
Status Message	            varchar(50)	Output
Assume that the input parameters will always be present. 

Conditions:

Include code to drop your procedure if it already exists before creating it
A record in the sensor table needs to be created ONLY if the sensor has not yet been defined. If the passed SensorId value exists in a row of the Sensors table, then the sensor has been defined already and the procedure must not attempt to insert it into the Sensors table again. If the sensor does not yet exist, it needs to be inserted before attempting to store a reading (in Readings)
Whether or not a new record is inserted in Sensors, a record should always be inserted in Readings. Records stored in "Readings" should be timestamped by supplying the current date and time to the TimeStampValue column
All data changes (1 or 2 records created) must be coded inside a stored procedure and utilize a transaction to ensure that no changes occur unless all operations are successful. Further, on detecting an error, a simple message should be sent back to the caller and a return code of -1 sent back. If no errors are detected, a simple success message and return code of 0 should be sent back.
Be sure that every exit from your transaction is accounted for before you execute the procedure. Otherwise you will encounter strange errors.
Part 2 Step 1: [15 marks]

Place your procedure code here:
*/
drop procedure if exists SP_SensorReading
go

create procedure SP_SensorReading
    @sensorId tinyint = null,
    @description varchar(50) = null,
    @location varchar(50) = null,
    @valueFromSensor smallint = null,
    @StatusMessage varchar(50) output 
as
    begin  
        declare @numRows int = 0

        begin try
            begin transaction  
                select @numRows = count(*) from Sensors
                where SensorId = @sensorId

                if @numRows = 0
                begin  
                    insert into Sensors (SensorId, [Description], [Location])
                    values (@sensorId, @description, @location)
                end

                insert into Readings (SensorId, TimeStampValue, [Value])
                values (@sensorId, getdate(), @valueFromSensor)        

                commit

                set @StatusMessage = 'Sensor reading successfully stored!'   
                return 0       
        end try 

        begin catch
            rollback  
            set @StatusMessage = 'An Error Occurred'
            return -1
        end catch
    end
go

/*
Part 2 Step 2 - Testing - [5 marks] - submit test code at bottom

Procedure testing: Write the execute statement that passes the following information as parameters:

Sensor ID = 97
Sensor Description = Temperature Sensor 15
Location = Building 332
Value Read From Sensor = 780

Use the following code as part of your testing - insert your execute statement where indicated:

declare @Status        varchar(50),
        @ReturnCode    int

--------------------- PLACE YOUR EXECUTE STATEMENT HERE ----------------------

print    ''
select    * 
from    Sensors
select    * 
from    Readings
print    @Status
print    ''
print    'The code returned from the procedure was: ' + cast(@ReturnCode as varchar)
go

Your results should appear like this:

(1 row affected)

(1 row affected)
 
SensorId Description                                        Location
-------- -------------------------------------------------- -------------------------------------------
97       Temperature Sensor 15                              Bldg 332

(1 row affected)

SensorId TimeStampValue          Value
-------- ----------------------- ------
97       2021-04-19 19:30:09.537 780

(1 row affected)

Sensor reading successfully stored!
 
The code returned from the procedure was: 0

Submit your Execute Statement per above specification below:
*/
declare @Status varchar(50), @ReturnCode int

exec @ReturnCode = SP_SensorReading
    @sensorId = 97,
    @description = 'Temperature Sensor 15',
    @location = 'Building 332',
    @valueFromSensor = 780,
    @statusMessage = @Status output

print    ''
select * from Sensors
select * from Readings
print @Status
print ''
print 'The code returned from the procedure was: ' + cast(@ReturnCode as varchar)
go

exec sp_help sensors
select * from Sensors

exec sp_help readings
select * from Readings