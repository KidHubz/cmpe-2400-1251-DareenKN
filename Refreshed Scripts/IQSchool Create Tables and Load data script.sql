/* IQSchool Table Creation and Load Data Script */
use master
go

drop database if exists [username_IQSchool]
go

create database [username_IQSchool]
go

use [username_IQSchool]
go


DROP TABLE if exists  Payment
DROP TABLE if exists  PaymentType
DROP TABLE if exists Registration
DROP TABLE if exists Offering
DROP TABLE if exists Semester
DROP TABLE if exists Activity
DROP TABLE if exists Staff
DROP TABLE if exists Course
DROP TABLE if exists Student
DROP TABLE if exists Club
DROP TABLE if exists Position
go

CREATE TABLE  Position
(
	PositionID tinyint not null constraint pk_Position Primary Key clustered,
	PositionDescription	varchar(50)	not null
)
go


CREATE TABLE  Club
(
	ClubId Varchar (10)constraint pk_Club Primary Key Clustered,
	ClubName Varchar (50) not null
)
go


CREATE TABLE  Student
(
	StudentID int Constraint pk_Student Primary Key clustered,
	FirstName varchar(25) not null,
	LastName varchar(35) not null,
	Gender char (1) not null,
	StreetAddress varchar (35) null,
	City varchar (30) null,
	Province char (2) null 
	Constraint DF_province default 'AB'
	Constraint CK_province check (Province like '[A-Z][A-Z]'),
	PostalCode char (6) null
	Constraint CK_postalCode check(PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Birthdate smalldatetime	not null,
	BalanceOwing decimal(7,2) null
	Constraint DF_balanceOwing default 0
	Constraint CK_balanceOwing check (BalanceOwing >= 0)
)
go


CREATE TABLE  Course
(
	CourseId char (7) Constraint PK_Course Primary Key,
	CourseName varchar (40) not null,	
	CourseHours smallint not null
	Constraint CK_courseHours check (CourseHours > 0),
	MaxStudents int null
	Constraint DF_maxStudents default 0
	Constraint CK_maxStudents check (MaxStudents >= 0),
	CourseCost decimal(6,2) not null
	Constraint DF_courseCost default 0
	Constraint CK_courseCost check (CourseCost >= 0)
)
go


CREATE TABLE  Staff
(
	StaffID smallint constraint pk_Staff Primary Key Clustered,
	FirstName varchar (25) not null,
	LastName varchar (35) not null,
	DateHired smalldatetime	not null
	Constraint DF_dateHired	default getdate(),
	DateReleased smalldatetime null,
	PositionID tinyint not null
	Constraint FK_staffToPosition references Position(PositionID),
	LoginID varchar (30) null,
	Constraint CK_loginID Check (DateReleased > DateHired)
)
go


CREATE TABLE  Activity
(
	StudentID int Constraint FK_ActivityToStudent references Student (StudentID), 
	ClubId varchar (10) Constraint FK_ActivityToClub references Club (ClubId),
	Constraint PK_Activity Primary Key Clustered (StudentID, ClubId)
)

CREATE TABLE Semester
(
SemesterCode char(5) not null constraint pk_Semester primary key clustered,
StartDate datetime not null,
EndDate datetime not null,
)

CREATE TABLE Offering
(
OfferingCode int not null constraint pk_Offering primary key clustered,
StaffID smallint not null constraint fk_OfferingToStaff references Staff(StaffID),
CourseID char(7) not null constraint fk_OfferingToCourse references Course(CourseID),
SemesterCode char(5) not null constraint fk_OfferingToSemester references Semester(SemesterCode),
)


CREATE TABLE Registration
(
	OfferingCode int not null constraint fk_RegistrationToOffering references Offering(OfferingCode),
	StudentID int Constraint fk_RegistrationToStudent references Student(StudentID),
	Mark decimal(5,2) null
	Constraint CK_mark check (Mark between 0 and 100),
	WithdrawYN char (1) null
	Constraint DF_WithdrawYN default 'N'
	Constraint CK_withdrawYN check (WithdrawYN in ('N','Y')),
	Constraint PK_Registration Primary Key Clustered (StudentID, OfferingCode)
)
go


CREATE TABLE  PaymentType
(
	PaymentTypeID tinyint constraint PK_PaymentType Primary Key Clustered,
	PaymentTypeDescription	varchar(40) null
)
go

			
CREATE TABLE  Payment
(
	PaymentID int Constraint PK_Payment Primary Key Clustered,
	PaymentDate datetime not null
	Constraint DF_paymentDate default getdate()
	Constraint CK_paymentDate check (PaymentDate >= getdate()),
	Amount decimal(6,2) not null
	Constraint DF_Amount default 0
	Constraint CK_Amount check (Amount >= 0),
	PaymentTypeID tinyint not null
	Constraint FK_paymentToPaymentType references PaymentType(PaymentTypeID),
	StudentID int not null
	Constraint FK_paymentToStudent references Student (StudentID)
)
go

/*Data Inserts */

--POSITION
Insert into Position(PositionID, PositionDescription)
Values(1, 'Dean')
Insert into Position(PositionID, PositionDescription)
Values(7, 'Assistant Dean')
Insert into Position(PositionID, PositionDescription)
Values(2, 'Program Chair')
Insert into Position(PositionID, PositionDescription)
Values(3, 'Assistant Program Chair')
Insert into Position(PositionID, PositionDescription)
Values(4, 'Instructor')
Insert into Position(PositionID, PositionDescription)
Values(5, 'Office Administrator')
Insert into Position(PositionID, PositionDescription)
Values(6, 'Technical Support Staff')

--STAFF
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(4, 'Nolan', 'Itall', 'Aug 12, 1993', null, 4, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(10, 'Chip', 'Andale', 'July 14, 2007', null, 6, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(2, 'Robert', 'Smith', 'June 12, 1990', null, 3, null)
insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(3, 'Tess', 'Agonor', 'Apr 25, 1992', 'May 22, 1996', 4, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(9, 'Nic', 'Bustamante', 'Jun 15, 2007', null, 2, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(6, 'Sia', 'Latter', 'Oct 30, 1996', null, 4, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(7, 'Hugh', 'Guy', 'Oct 10, 1998', null, 1, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(5, 'Jerry', 'Kan', 'Aug 15, 1995', null, 4, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(1, 'Donna', 'Bookem', 'Apr 17, 1988', null, 5, null)
Insert into Staff(StaffID, FirstName, LastName, DateHired, DateReleased, PositionID, LoginID)
Values(8, 'Cher', 'Power', 'May 30, 2000', null, 3, null)

--STUDENT
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(198933540, 'Winnie', 'Woo', 'F', '200 - 3 St. S.W', 'Calgary', 'AB', 'T9A1N1', 'Nov  4 1978', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(199899200, 'Ivy', 'Kent', 'F', '11044 -83 ST.', 'Edmonton', 'AB', 'T4N9A7', 'Dec 11 1979', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(199912010, 'Dave', 'Brown', 'M', '11206-106 St.', 'Edmonton', 'AB', 'T4J7H2', 'Jan  2 1976', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(199966250, 'Dennis', 'Kent', 'M', '11044 -83 ST.', 'Edmonton', 'AB', 'T3O1J1', 'Apr 29 1979', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200011730, 'Jay ', 'Smith', 'M', 'Box 761', 'Red Deer', 'AB', 'T6J7V3', 'May  6 1983', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200122100, 'Peter', 'Codd', 'M', '172 Downers Grove', 'Victoria', 'BC', 'V6E4R2', 'May  7 1981', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200312345, 'Mary', 'Jane', 'F', '11044 -83 Ave.', 'Edmonton', 'AB', 'T3Q9N5', 'Dec 11 1969', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200322620, 'Flying', 'Nun', 'F', 'Fantasy Land', 'Edmonton', 'AB', 'T9T4Z4', 'Oct 22 1962', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200494470, 'Minnie', 'Ono', 'F', '12003 -103 ST.', 'Edmonton', 'AB', 'T2W7P7', 'Dec 10 1970', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200494476, 'Joe', 'Cool', 'M', '12003 -103 ST.', 'Edmonton', 'AB', 'T2G6L7', 'Dec 10 1975', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200495500, 'Robert', 'Smith', 'M', 'Box 333', 'Leduc', 'AB', 'T6P3Z3', 'Mar 20 1976', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200522220, 'Joe', 'Petroni', 'M', '11206 Imperial Building', 'Calgary', 'AB', 'T3Q5A7', 'Aug  3 1965', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200578400, 'Andy', 'Kowaski', 'M', '172 Downing St.', 'Woolerton', 'SK', 'S7Y0Q3', 'Nov  7 1976', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200645320, 'Thomas', 'Brown', 'M', '11206 Empire Building', 'Edmonton', 'AB', 'T4S6S2', 'Oct  2 1977', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200688700, 'Robbie', 'Chan', 'F', 'Box 561', 'Athabasca', 'AB', 'T4Z4B1', 'Mar 30 1968', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200978400, 'Peter', 'Pan', 'M', '182 Downing St.', 'Tisdale', 'SK', 'S1K9H3', 'Nov  7 1986', 0.00)
Insert into Student(StudentID, FirstName, LastName, Gender, StreetAddress, City, Province, PostalCode, Birthdate, BalanceOwing)
Values(200978500, 'Dave', 'Brown', 'M', '433 Crazy St.', 'Edmonton', 'AB', 'T9E1D3', 'Jan  20 1972', 0.00)

--CLUB
Insert into Club(ClubId, ClubName)
Values('CSS', 'Computer System Society')
Insert into Club(ClubId, ClubName)
Values('NASA', 'NAIT Staff Association')
Insert into Club(ClubId, ClubName)
Values('CIPS', 'Computer Info Processing Society')
Insert into Club(ClubId, ClubName)
Values('CHESS', 'NAIT Chess Club')
Insert into Club(ClubId, ClubName)
Values('ACM', 'Association of Computing Machinery')
Insert into Club(ClubId, ClubName)
Values('NAITSA', 'NAIT Student Association')
Insert into Club(ClubId, ClubName)
Values('DBTG', 'DataBase Task Group')
Insert into Club(ClubId, ClubName)
Values('NASA1', 'NAIT Support Staff Association')

--ACTIVITY
Insert into Activity(StudentID, ClubId)
Values(199912010, 'CSS')
Insert into Activity(StudentID, ClubId)
Values(199912010, 'ACM')
Insert into Activity(StudentID, ClubId)
Values(199912010, 'NASA')
Insert into Activity(StudentID, ClubId)
Values(200312345, 'CSS')
Insert into Activity(StudentID, ClubId)
Values(199899200, 'CSS')
Insert into Activity(StudentID, ClubId)
Values(200495500, 'CHESS')
Insert into Activity(StudentID, ClubId)
Values(200495500, 'CSS')
Insert into Activity(StudentID, ClubId)
Values(200322620, 'CSS')
Insert into Activity(StudentID, ClubId)
Values(200495500, 'ACM')
Insert into Activity(StudentID, ClubId)
Values(200322620, 'ACM')

--COURSE
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT103', 'Applied Problem Solving', 96, 3, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT104', 'Programming Fundamentals', 96, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT101', 'Communications in IT and New Media', 64, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT108', 'Web Design 1', 64, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT172', 'Systems Analysis & Design 1', 96, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT152', 'Advanced Programming (.net 1)', 96, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT168', 'Math & Physics', 80, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT225', 'Systems Analysis & Design 2', 96, 3, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT259', 'DMIT259 Project Management', 64, 2, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT163', 'Game Programming 1', 96, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT221', 'Open Source Programming (J2EE)', 96, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT223', 'Quality Assurance', 64, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT170', 'Networking 1', 64, 4, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT227', 'Web Server Administration (IIS, Apache)', 64, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT224', 'Server Administration & Applications', 64, 5, 450.00)
Insert into Course(CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
Values('DMIT254', 'Capstone Project', 192, 5, 1575.00)

--SEMESTER
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A100','jan 1 2010','April 30 2010')
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A200','jan 1 2011','April 30 2011')
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A300','jan 1 2012','April 30 2012')
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A400','jan 1 2013','April 30 2013')
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A500','jan 1 2014','April 30 2014')
Insert into Semester (SemesterCode, StartDate,EndDate)
values ('A600','jan 1 2015','April 30 2015')


--OFFERING
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1000,6,'DMIT163','A100')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1001,6,'DMIT103','A200')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1002,6,'DMIT104','A300')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1003,5,'DMIT101','A400')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1004,5,'DMIT101','A500')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1005,5,'DMIT172','A600')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1006,5,'DMIT152','A100')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1007,5,'DMIT168','A200')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1008,5,'DMIT227','A300')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1009,4,'DMIT225','A400')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1010,4,'DMIT227','A500')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1011,4,'DMIT221','A600')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1012,4,'DMIT223','A100')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1013,4,'DMIT170','A200')
Insert into Offering (OfferingCode,StaffID,CourseID,SemesterCode)
Values (1014,4,'DMIT254','A300')

--REGISTRATION
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200978500, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200978500, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,199912010, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,199912010, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,199912010, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,199912010, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,199912010, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,199912010, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,199912010, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1007,199912010, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1008,199912010, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1009,199912010, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1010,199912010, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1011,199912010, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1012,199912010, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1013,199912010, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200495500, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200495500, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,200495500, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,200495500, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,200495500, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,200495500, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1011,200495500, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200494470, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200494470, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,200494470, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,200494470, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,200494470, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,200494470, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,200494470, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1007,200494470, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1008,200494470, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1009,200494470, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1010,200494470, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1011,200494470, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1012,200494470, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200122100, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200122100, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,200122100, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,200122100, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,200122100, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,200122100, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,200122100, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200312345, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200312345, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,200312345, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,200312345, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,200312345, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,200312345, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,200312345, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,200578400, 30, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,200578400, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,200578400, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,200578400, 98, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,200578400, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,200578400, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,200578400, 88, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1000,199899200, 85, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1001,199899200, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1002,199899200, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1003,199899200, 78, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1004,199899200, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1005,199899200, 83, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1006,199899200, 89, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1007,199899200, 80, 'N')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1008,199899200, 0, 'Y')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1012,200578400, 0, 'Y')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1013,200312345, 0, 'Y')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1012,200122100, 0, 'Y')
Insert into Registration(OfferingCode,StudentID, Mark, WithdrawYN)
Values(1014,199912010, 0, 'Y')

--PAYMENT
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(5, 'American Express')
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(1, 'Cash')
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(2, 'Cheque')
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(4, 'MasterCard')
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(6, 'Debit Card')
Insert into PaymentType(PaymentTypeID, PaymentTypeDescription)
Values(3, 'VISA')

--PAYMENT
-- need to turn off date check temporarily to allow for old dates
alter table Payment NOCHECK constraint CK_paymentDate

Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(24, 'May  1 2004 12:59PM', 900.00, 2, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(17, 'May  1 2003 12:14PM', 450.00, 6, 200122100)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(25, 'May  1 2004  9:21AM', 450.00, 6, 200578400)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(22, 'Jan  1 2004 10:17AM', 450.00, 2, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(9, 'Sep  1 2001  8:35AM', 900.00, 6, 199912010)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(32, 'May  1 2005  2:46PM', 1575.00, 2, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(8, 'Jan  1 2001 12:10PM', 900.00, 4, 200495500)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(2, 'Sep  1 2000 11:18AM', 2250.00, 5, 199912010)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(13, 'Sep  1 2002 10:58AM', 900.00, 5, 200122100)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(21, 'Jan  1 2004  1:30PM', 1350.00, 4, 199899200)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(26, 'Sep  1 2004 12:36PM', 900.00, 1, 199899200)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values	(5, 'Sep  1 2000  9:55AM', 1800.00, 5, 200578400)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(16, 'Jan  1 2003  3:58PM', 450.00, 1, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(29, 'May  1 2005  1:13PM', 1575.00, 4, 199899200)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(14, 'Sep  1 2002 12:05PM', 450.00, 3, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(3, 'Sep  1 2000  2:49PM', 2250.00, 1, 200494470)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(28, 'Jan  1 2005 12:21PM', 900.00, 1, 199899200)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(6, 'Jan  1 2001 12:33PM', 2250.00, 6, 199912010)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(4, 'Sep  1 2000  1:30PM', 2250.00, 2, 200495500)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(18, 'May  1 2003  3:35PM', 450.00, 5, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(1, 'Sep  1 2000 12:20PM', 450.00, 5, 199899200)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(7, 'Jan  1 2001  8:14AM', 2250.00, 5, 200494470)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(19, 'Sep  1 2003 10:19AM', 900.00, 4, 200122100)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(10, 'Sep  1 2001 11:18AM', 450.00, 2, 200494470)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(12, 'Jan  1 2002 10:05AM', 900.00, 4, 200494470)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(20, 'Sep  1 2003  3:06PM', 450.00, 5, 200312345)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(33, 'May  1 2005  2:01PM', 1575.00, 3, 200578400)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(27, 'Sep  1 2004  5:01PM', 450.00, 2, 200578400)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(23, 'Jan  1 2004  2:11PM', 450.00, 6, 200578400)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(30, 'May  1 2005 11:06AM', 1575.00, 1, 199912010)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(11, 'Jan  1 2002 11:16AM', 900.00, 4, 199912010)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(15, 'Jan  1 2003 10:25AM', 900.00, 6, 200122100)
Insert into Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
Values(31, 'May  1 2005  6:27PM', 1575.00, 4, 200122100)


