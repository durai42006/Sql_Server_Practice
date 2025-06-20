-- SECTION E
--Q15. Training management System


-- Design schema with all necessary keys and constraints
create table Trainees
(
TraineeID int primary key identity(101,1),
TraineeName varchar(30),
TraineeMail varchar(255) constraint uk_Trainees_Mail Unique(TraineeMail),
TraineePhone varchar(15)constraint uk_Trainees_Phone Unique(TraineePhone),
DOB date,
Address varchar(100)
)

create table TrainersDepartments
(
DeptID int primary key,
DeptName varchar(30)
)

create table Trainers
(
TrainerID int primary key identity(1101,1),
TrainerName varchar(30),
TrainerMail varchar(255) constraint uk_Trainers_Mail Unique(TrainerMail),
TrainerPhone varchar(15) constraint uk_Trainer_Phone Unique(TrainerPhone),
DeptID int constraint fk_Trainers_DeptID references TrainersDepartments(DeptID)
)
create table Sessions
(
SessionID SmallInt primary key,
SessionName varchar(30)
)
create table TraineeSession
(
TNS_ID int primary key,
TraineeID int constraint fk_TraineeSession_TraineeID references Trainees(TraineeID),
SessionID SmallInt constraint fk_TraineeSession_SessionID references Sessions(SessionID)
)
create table TrainerSession
(
TNR_ID int primary key,
TrainerID int constraint fk_TrainerSession_TrainerID references Trainers(TrainerID),
SessionID SmallInt constraint fk_TrainerSession_SessionID references Sessions(SessionID)
)
create table Status
(
StatusID TinyInt primary key,
StatusName varchar(30)
)
create table Attendance
(
AttendanceID int primary key identity(1,1),
TraineeID int constraint fk_Attendance_TraineeID references Trainees(TraineeID),
SessionID SmallInt constraint fk_Attendance_SessionID references Sessions(SessionID),
StatusID TinyInt constraint fk_Attendance_StatusID references Status(StatusID),
constraint uk_Composite_Attendance Unique(TraineeID,SessionID)
)

Select * from dbo.Trainees


insert into Trainees values('Durai','durai@gmail.com','6379639261','2003-10-26','Thanjavur'),
('Sabari','sabari@gmail.com','6379695786','2003-10-26','Pandruti'),
('Sriram','sriram@gmail.com','6368459261','2003-10-26','kadalur'),
('Santhosh','santhosh@gmail.com','9835639261','2003-10-26','Thiruvarur'),
('Boobathi','boobathi@gmail.com','6379456987','2003-10-26','Trichy'),
('Hari','hari@gmail.com','6398956375','2003-10-26','kadalur'),
('Pravin','pravin@gmail.com','9865798456','2003-10-26','Thindivanam'),
('Imran','imran@gmail.com','9498657523','2003-10-26','Chennai'),
('Shanmugam','shanmugam@gmail.com','9675896245','2003-10-26','Chennai')


insert into TrainersDepartments values(1,'IT'),(2,'Testing'),(3,'Admin'),(4,'HR')

insert into Trainers values('Abdul','abdul@gmail.com','9698795456',1),
('Arthi','arthi@gmail.com','9663759845',2),
('Ebe','ebe@gmail.com','9791448346',1),
('Subin','subin@gmail.com','7339600783',3),
('Jeya','jeya@gmail.com','6382891751',4)

insert into Status values(0,'Absent'),(1,'Present')

insert into Sessions values (201, 'Java Basics'),(202, 'SQL Fundamentals'),
(203, 'Web Development'),(204, 'OOP Concepts'),(205, 'Software Testing');


insert into TrainerSession values(1, 1101, 201),(2, 1102, 202), (3, 1103, 203),(4, 1104, 204), (5, 1105, 205);

insert into TraineeSession values(1, 101, 201),(2, 102, 201),(3, 103, 202),(4, 104, 203),
(5, 105, 204),(6, 106, 202),(7, 107, 205),(8, 108, 204),(9, 109, 205);

insert into TraineeSession values(10,109, 204)

go


-- create stored procedure to mark attendance for trainee
create or alter procedure MarkAttendance
(
@TraineeID int,
@SessionID int,
@StatusID int
)
as
begin
Set nocount ON;
Begin try
insert into Attendance values(@TraineeID,@SessionID,@StatusID);
Print 'Success !'
End try
Begin catch
Print 'Wrong inputs'
End catch
end


Exec MarkAttendance 101, 201, 1;
Exec MarkAttendance 102, 201, 0;
Exec MarkAttendance 103, 202, 1;
Exec MarkAttendance  104, 203, 1;
Exec MarkAttendance 105, 204, 1;
Exec MarkAttendance 106, 202, 0;
Exec MarkAttendance 107, 205, 1;
Exec MarkAttendance 108, 204, 0;
Exec MarkAttendance 108, 205, 0;
Exec MarkAttendance 108, 201, 0;
Exec MarkAttendance 108, 202, 1;
Exec MarkAttendance 109, 205, 1;
Exec MarkAttendance 109, 204, 0;
Exec MarkAttendance 109, 203, 0;
go


-- create view to log the 
create view vw_TraineeAttendance
as
	with cte_AttendancePercentage
	as
	(
	select TraineeID,Count(TraineeID) as SessionCount from Attendance
	where StatusID =1
	group by TraineeID
	)
	select ct.TraineeID,((SessionCount*100)/Total) as AttendancePercentage from cte_AttendancePercentage ct
	join (select TraineeID,Count(TraineeID) as Total from Attendance group by TraineeID) as d on d.TraineeID=ct.TraineeID


create table Warnings
(
WarningID int primary key identity(101,1),
TraineeID int,
AttendancePercentage decimal(10,2)
)
go
create or alter trigger tr_LowPercentage
on Attendance
for insert
as
begin
	declare @TraineeID int;
	declare @Percent_Attendance decimal(10,2);
	declare @TotalCount int;
	declare @ActualCount int;

	select @TraineeID=TraineeID from inserted;

	select @TotalCount=Count(TraineeID) from Attendance where TraineeID=@TraineeID group by TraineeID;

	select @ActualCount=Count(TraineeID) from Attendance where TraineeId=@TraineeID and StatusID=1;

	set @Percent_Attendance=(@ActualCount*100)/@TotalCount;

	if @Percent_Attendance<70
		begin
		print 'Low attendance'
		insert into Warnings values(@TraineeID,@Percent_Attendance);
		end
end

select * from Warnings;