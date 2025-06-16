create database EmployeePractice;
use EmployeePractice;

--create employee table
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE,
    ManagerID INT NULL,
    LastSalaryUpdate DATE
);

--create Department Table
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

--create SalaryChangeLog Table
CREATE TABLE SalaryChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10, 2),
    NewSalary DECIMAL(10, 2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

--create TransferLog Table
CREATE TABLE TransferLog (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldDepartmentID INT,
    NewDepartmentID INT,
    TransferDate DATETIME DEFAULT GETDATE()
);

-- Insert departments
INSERT INTO Department (DepartmentName) VALUES 
('Sales'), 
('Engineering'), 
('HR');

-- Insert employees
INSERT INTO Employee (FirstName, LastName, DepartmentID, Salary, HireDate, ManagerID, LastSalaryUpdate) VALUES
('John', 'Doe', 1, 50000, '2018-01-15', NULL, '2023-01-10'),
('Jane', 'Smith', 2, 70000, '2019-03-10', 1, '2022-05-05'),
('Alice', 'Johnson', 2, 65000, '2020-06-20', 1, '2023-06-01'),
('Bob', 'Brown', 3, 48000, '2017-11-12', NULL, '2020-03-15');



/* Create a procedure to get employees with salary greater than a given amount. */
create procedure GreaterSalary
(
@Salary Decimal(10,2) 
)
as 
	begin
		select (FirstName+LastName) as FullName,Salary from Employee where Salary>@Salary 
	end

GreaterSalary 50000;



/* Create a procedure to update the department of an employee by employee ID. */
create procedure UpdateDepartment
(
	@EmpID int,
	@DeptID int
)
as 
begin
	update Employee set DepartmentID=@DeptID where EmployeeID=@EmpID;
end

UpdateDepartment 3,3;
select * from Employee;



/* Create a procedure to return the total count of employees in a given department. */
create procedure EmpCountDeptWise
(
	@DeptID int
)
as
begin
	select Count(EmployeeID) from Employee where DepartmentID=@DeptID;
end

EmpCountDeptWise 3;



/* Create a procedure that accepts a salary range (min, max) and returns employees within that range. */

create procedure SalaryRange
(
	@RangeOne decimal(10,2),
	@RangeTwo decimal(10,2)
)
as
begin
	select * from Employee where Salary>@RangeOne and Salary<@RangeTwo;
end

 SalaryRange 49000,65000;


/* Create a procedure to increase the salary of all employees in a specific department by a given percentage. */
alter procedure SalaryIncrement 
(
	@DeptID int,
	@Percent Decimal(5,2)
)
as
begin

	update Employee set Salary=Salary+(Salary*(@Percent/100)) where DepartmentID=@DeptID;
end

SalaryIncrement 3,10;
select * from Employee;


/* Create a procedure to retrieve employees hired within a certain date range. */
alter procedure RetrieveEmployee
(
	@Date date
)
as
begin
	select * from Employee where HireDate<@Date;
end

RetrieveEmployee '2020-06-06';



/* Create a procedure to insert a new department into a Department table, returning the newly created DepartmentID. */
alter procedure CreateDepartment
(
	@DeptID int,
	@DeptName varchar(30)
)
as
begin
	if exists( Select 1 from Department where DepartmentID=@DeptID)
	begin
		Print 'Already department is existed !'
	end
	else
	begin
		insert into Department values(@DeptName)
		Print 'Successfully added'
	end
end
CreateDepartment 4,'Testing'
select * from Department;



/*Create a procedure to retrieve the department-wise average salary for all departments.*/
create procedure AverageDeptSalary
as
begin
	select DepartmentID,avg(Salary) as AvgSalary from Employee group by DepartmentID;
end

AverageDeptSalary;




/* Create a procedure that returns employees along with their manager's name (assume Employee table has ManagerID). */
create procedure EmpManager
as
begin
	select (e.FirstName+e.LastName) as Fullname, m.FirstName+m.LastName  as Managername from Employee as e join Employee as m on e.ManagerID=m.EmployeeID;
end

EmpManager;


/* Create a procedure to get the top N highest-paid employees. */
alter procedure TopSalaryEmployees
(
	@TopSalary int
)
as
begin
	select top (@TopSalary) with ties * from Employee order by Salary;
end
TopSalaryEmployees 2;



/* Create a procedure that returns the employee details along with a calculated bonus (e.g., 10% of salary) as an extra column. */
create procedure EmpBonus
(
 @Bonus decimal(10,2)
)
as
begin
	select (FirstName+LastName) as Fullname,Salary,(Salary*(@Bonus/100)) as Bonus,(Salary+(Salary*(@Bonus/100))) as TotalSalary from Employee
end
EmpBonus 10





------------------------------- INCOMPLETED QUESTIONS -------------------------------

/*
 
Create a procedure to log changes in employee salary: it should insert old and new salary into a separate table whenever an update happens.

Create a procedure that deletes employees who have not received a salary update for more than 2 years.
 
Create a procedure to transfer an employee from one department to another and log the transfer details in a separate TransferLog table using a transaction.

Create a procedure that accepts a comma-separated list of EmployeeIDs and deletes all those employees in a single operation.

*/




/*--- TRIGGERS LEARNING ---*/

create table Employee1
(
	EmpID int,
	EmpName varchar(30),
	EmpSalary decimal(10,2)
)
insert Employee1 values(1,'Alice',25000);
insert Employee1 values(2,'Bob',50000);
insert Employee1 values(3,'Charlie',75000);

create table LogTable
(
	EmpID int,
	ChangedDate date,
	oldSalary decimal(10,2),
	newSalary decimal(10,2)
)

create trigger trOldSalaryNewSalary
on Employee1
after update
as
begin
	declare @OldSalary decimal(10,2)
	 
	declare @EmpID int
	declare @NewSalary decimal(10,2)
	select @EmpID = EmpID, @NewSalary = EmpSalary from inserted

	select @OldSalary = EmpSalary from Employee1 where EmpID = @EmpID
	update Employee1 
	set EmpSalary = @NewSalary
	where EmpID = @EmpID

	insert into LogTable values (@EmpID, getdate(), @OldSalary , @NewSalary)
end;


drop trigger trOldSalaryNewSalary

update Employee1
set EmpSalary = 80000
where EmpID = 2;


select * from Employee1;
select *from LogTable;



select * from Employee;
select * from Department;


create view vw_EmpOperation
as
select * from Employee;

select * from vw_EmpOperation;


update vw_EmpOperation set Salary=60000 where EmployeeID=1;

insert into vw_EmpOperation values('Sabari','Raj',2,1000000,'2025-04-21',2,'2025-05-20');

