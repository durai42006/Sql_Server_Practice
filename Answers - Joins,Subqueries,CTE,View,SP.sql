create database Demo;
use Demo;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID),
    Salary MONEY,
    HireDate DATE
);
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE
);
CREATE TABLE EmployeeProjects (
    EmpID INT FOREIGN KEY REFERENCES Employees(EmpID),
    ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID),
    HoursWorked INT,
    PRIMARY KEY (EmpID, ProjectID)
);
INSERT INTO Departments VALUES
(1, 'HR'), (2, 'IT'), (3, 'Finance');
INSERT INTO Departments VALUES
(4, 'Admin'),(5,'Testing');

INSERT INTO Employees VALUES
(101, 'Alice', 1, 60000, '2020-01-01'),
(102, 'Bob', 2, 80000, '2019-03-15'),
(103, 'Charlie', 3, 75000, '2021-06-01');
INSERT INTO Employees VALUES
(104, 'David', 2, 50000, '2022-05-21'),
(105, 'Envar', 1, 30000, '2023-02-27')

INSERT INTO Projects VALUES
(201, 'Payroll System', '2022-01-01'),
(202, 'Recruitment Portal', '2023-05-01');

INSERT INTO EmployeeProjects VALUES
(101, 202, 120),
(102, 201, 100),
(103, 201, 80),
(103, 202, 60);



-- Get the list of employees along with their department names.

Select e.EmpName,d.DeptName from Employees e 
join Departments d on d.DeptID = e.DeptID

-- Get all employees and the projects they are working on.

Select e.EmpName,p.ProjectName from EmployeeProjects ep
join Employees e on e.EmpID = ep.EmpID
join Projects p on p.ProjectID = ep.ProjectID

--  Get all departments, even those that don't have employees.

Select d.DeptName,Count(EmpID) from Departments d 
left join Employees e on e.DeptID=d.DeptID
group by d.DeptName

--  Get employees who are not assigned to any project.

Select e.EmpName from Employees e where e.EmpID not in (Select e.EmpID from Employees e join EmployeeProjects ep on ep.EmpID=e.EmpID)

-- Find the highest paid employee in each department.

select d.EmpName from (
	Select e.EmpName,e.DeptID,Rank() over(partition by e.DeptID order by e.Salary desc) as r  from Employees e group by e.EmpName,e.DeptID,e.Salary ) as d
	where d.r=1

-- Find the employee(s) who worked the most hours in total on projects.

select top 1 e.EmpID,EmpName,sum(HoursWorked) as hw from EmployeeProjects ep 
join Employees e on e.EmpID=ep.EmpID
group by e.EmpID,EmpName order by hw desc

-- Find departments with no employees.

select y.DeptName from Departments y where y.DeptID not in (select d.DeptID from Departments d 
join Employees e on e.DeptID=d.DeptID
group by d.DeptID ) 

--  Find employees who earn more than the average salary.

select EmpName from Employees e where e.Salary > (Select avg(Salary) from Employees)

--  Use CTE to list employees with total project hours worked.

with cte_EmpProjectHours as
(
	select EmpID,sum(HoursWorked) as hw from EmployeeProjects ep group by EmpID
)
select e.EmpName,d.hw from cte_EmpProjectHours d
join Employees e on e.EmpID=d.EmpID

--  Use CTE to find top 2 highest paid employees per department.

with cte_Top2PaidEmp as 
(
	select EmpID,Rank() over(Partition by DeptID order by Salary desc) r from Employees e
)
select EmpID from cte_Top2PaidEmp where r<=2

-- Create a CTE to calculate year of experience for each employee.

with cte_YearExperience as
(
	select EmpID,DATEDIFF(year,HireDate,GETDATE()) as ExperienceYear from Employees
)
Select EmpID,ExperienceYear from cte_YearExperience;

-- Use a recursive CTE to create a number series from 1 to 10.

with cte_numberSeries as
(
	 Select 1 as number
	 union all 
	 Select number+1 from cte_numberSeries
	 where number<10
)
select * from cte_numberSeries;

-- Create a stored procedure to insert a new employee.

alter procedure insertEmployee
(
	@EmpID		int,
	@EmpName	varchar(100),
	@DeptID		int,
	@Salary		decimal(10,2),
	@Hiredate	date
)
as 
begin
	begin try
		begin transaction
		insert into Employees values(@EmpID,@EmpName,@DeptID,@Salary,@Hiredate)
		commit transaction;
	end try

	begin catch
		rollback transaction;
		print 'Something went wrong';
	end catch
end

exec insertEmployee 7,'Frank',4,35000,'2024-04-01';

-- Create a stored procedure to update salary based on department.

alter procedure UpdateSalary 
(
	@EmpID int,
	@Salary decimal(10,2)
)
as
begin
	begin try
		
		if(@EmpID not in (select EmpID from Employees))
		begin 
			print 'Invalid emp id !'
		end
		else
		begin
			begin transaction
			update Employees set Salary=@Salary where EmpID=@EmpID;
			commit transaction;
		end
	end try

	begin catch
		rollback transaction;
		print 'Update failed !';
	end catch
end


-- Create a stored procedure that takes department name and returns all employees in it.

alter procedure DeptEmployees
(
	@DeptName varchar(20)
)
as
begin
	begin try
		begin transaction
		Declare @dept int
			select @dept =  DeptID from Departments where DeptName=@DeptName
			if(@dept is null)
			begin
				print 'Invalid department name !'
			end
			else
			begin
				select EmpID from Employees where DeptID = @dept
			end
			
		commit transaction;
	end try

	begin catch
		rollback transaction;
		print 'Something went wrong';
	end catch
end

exec DeptEmployees 'Admin'

-- Create a stored procedure to assign an employee to a project.

create procedure assignProject
(
	@EmpID int,
	@ProjectID int,
	@HoursWork int
)
as
begin
	begin try
		begin transaction
			insert into EmployeeProjects values(@EmpID,@ProjectID,@HoursWork)
		commit transaction
	end try
	begin catch
		print 'Something went wrong'
	end catch
end

exec assignProject 6,202,20;


-- Create a view that shows employee name, department, and salary.

create view vw_EmpDeptSalary 
as 
select EmpName,DeptName,Salary  from Employees e 
join Departments d on d.DeptID=e.DeptID

select * from vw_EmpDeptSalary order by Salary desc;

-- Create a view that lists employees and total hours worked on all projects.

create view vw_EmpWorkHours
as
select e.EmpID,e.EmpName,ep.HoursWorked from Employees e 
join EmployeeProjects ep on ep.EmpID= e.EmpID group by e.EmpID,e.EmpName,ep.HoursWorked

select * from vw_EmpWorkHours

-- Create an updatable view to show employee names and salaries.

create view vw_EmpSalary 
as
select EmpName,Salary from Employees 

select * from vw_EmpSalary

-- Create a view to show only employees hired after 2020.

alter view vw_Emp2020 
as
select * from Employees where Year(HireDate)>2020

select * from vw_Emp2020

-- Create a function to calculate bonus as 10% of salary for given emp id.

create function fn_Calculate_BonusSalary
(
	@EmpID int
)
returns decimal(10,2)
as 
begin
		Declare @Salary decimal(10,2) =0;
		Declare @BonusSalary decimal(10,2);
		select @Salary=Salary from Employees where EmpID=@EmpID;
		set @BonusSalary = @Salary+(@Salary/10);
		return @BonusSalary;
end

select dbo.fn_Calculate_BonusSalary(103) as Result

-- Create a function to calculate bonus as 10% of salary for all employees

alter function fn_AllBonusSalary
()
returns table
as
return select EmpName,Salary,Salary+(Salary/10) as BonusSalary from Employees

select * from fn_AllBonusSalary()

-- Create a function that returns employee age from HireDate for given emp id.

create function fn_EmpAge(@EmpID int)
returns int
as
begin
	declare @age decimal(10,2);
	select @age= datediff(year,HireDate,GETDATE()) from Employees where EmpID = @EmpID
	return @age
end

select dbo.fn_EmpAge(102) as ExperienceAge;

-- Create a function that returns employee age from HireDate for all employees.

create function fn_AllEmpAge()
returns table
as
	return select EmpName,datediff(year,HireDate,GETDATE()) as ExperienceAge from Employees;

select * from fn_AllEmpAge() order by ExperienceAge

-- Table-Valued UDF  -  Create a function that returns all projects for a given employee ID.

create function fn_EmpProjectDetails
(
	@EmpID int
)
returns @EmpProjects table(ProjectName varchar(100))
as 
begin
	insert into @EmpProjects
	select ProjectName  from EmployeeProjects ep
	join Projects p on p.ProjectID = ep.ProjectID
	where EmpID=@EmpID;
	return 
end

select * from dbo.fn_EmpProjectDetails(103)

-- Table-Valued UDF  -  Create a function that returns all projects for all employees.

create function fn_AllEmpProjectDetails()
returns @EmpProjects table
(
	EmpName varchar(100),
	ProjectName varchar(100)
)
as 
begin
	insert into @EmpProjects
	select EmpName,ProjectName  from EmployeeProjects ep
	join Projects p on p.ProjectID = ep.ProjectID
	join Employees e on e.EmpID=ep.EmpID
	return 
end

select * from fn_AllEmpProjectDetails()


-- Create a function that returns all employees in a department.

create function fn_AllEmpDept()
returns table
as
return select EmpName,DeptName from Employees e
join Departments d on e.DeptID= d.DeptID

select * from fn_AllEmpDept()


/*	
	Create a stored procedure that takes department name and returns:

	All employees in that department.

	Their total project hours.

	Their calculated bonus using a user-defined function.

	Create a view that joins employees and departments, and filters only those who have worked on more than 1 project.

	Use a CTE to rank employees by salary within their department.
*/

alter procedure Dept_HugeReturn
(
	@DeptID int
)
as
Begin
	set nocount on;
	Declare @Check table 
	(
		EmpName varchar(100),
		Salary decimal(10,2),
		BonusSalary decimal(10,2),
		ProjectName varchar(100)
	)
	insert into @Check
	Select e.EmpName,e.Salary,Salary+(Salary/10) as BonusSalary,p.ProjectName from Employees e
	join EmployeeProjects ep on ep.EmpID=e.EmpID
	join Projects p on p.ProjectID=ep.ProjectID
	where DeptID=@DeptID;

	if exists(select 1 from @Check)
	begin
		select * from @Check
	end
	else 
	begin
		print 'No data is present at the given department on projects'
	end

end

exec Dept_HugeReturn 4

alter view vw_EmpDeptProject
as 
select ep.EmpID,DeptName,count(ep.EmpID) as ct from Employees e 
join Departments d on d.DeptID = e.DeptID
join EmployeeProjects ep on ep.EmpID=e.EmpID
group by ep.EmpID,DeptName 
having count(ep.ProjectID)>1

select * from vw_EmpDeptProject



