create database JoinsDB;
use JoinsDb;
 
create table Department
(
ID int primary key identity (1,1),
Name varchar(50),
Location varchar(50)
);
 
create table Employee 
(
ID int primary key identity (101,1),
Name varchar(50) not null,
DepartmentID int references Department(ID),
Role varchar(50),
Salary decimal
);
 
create table Project
(
ID int primary key identity (1001,1),
Name varchar(30),
LeadID int references Employee(ID),
Budget decimal
);
 
create table ProjectAssignments
(
projectID int references Project(ID),
EmployeeID int references Employee(ID),
primary key (projectID,EmployeeID)
);
 
create table PerformanceReviews
(
ID int primary key identity(1,1),
EmployeeID int references Employee(ID),
Year int ,
Rating float
);
 
insert into Department (Name, Location) values
('Data Engineering', 'Chennai'),
('Application Dev', 'Bangalore'),
('Creative Studio', 'Hyderabad'),
('Product Management', 'Mumbai');
 
insert into Employee (Name, DepartmentID, Role, Salary) values
('Nithya', 1, 'Data Analyst', 70000),
('Rahul', 2, 'Software Eng.', 85000),
('Sruthi', 3, 'UI/UX Designer', 65000),
('Ajay', 1, 'Data Scientist', 95000),
('Karthik', NULL, 'Intern', 20000);
insert into Employee values('Boobathi',2,'Software Engineer',10000);
 
insert into Project (Name, LeadID, Budget) values
('InsightMiner', 104, 500000),
('ZenApp', 102, 350000),
('VisualFlow', 103, 275000),
('QuantumReports', 101, 620000);
 
insert into ProjectAssignments (projectID, EmployeeID) values
(1001, 101),
(1001, 104),
(1002, 102),
(1002, 105),
(1003, 103),
(1004, 101),
(1004, 104);
 
insert into PerformanceReviews (EmployeeID, Year, Rating) values
(101, 2023, 4.5),
(102, 2023, 4.0),
(103, 2023, 3.8),
(104, 2023, 4.9),
(105, 2023, 3.0),
(104, 2022, 4.7),
(101, 2022, 4.2);
 
--alter the tables to practice DML queries 
alter table Department add HeadID int references Employee(ID);
 
alter table Employee add JoiningDate date default Getdate(),
status varchar(20) default 'Active';
 
alter table PerformanceReviews add ReviewerName varchar(50);
 
select * from project;
select * from Employee;
 
update Project set leadid= null where id = 1005;
 
create table Leaves (
    EmployeeID INT REFERENCES Employee(ID),
    LeaveDate DATE,
    Reason VARCHAR(100)
);
 
insert into leaves values
(101, '2024-05-01', 'Sick'),
(102, '2024-06-03', 'Personal'),
(104, '2024-05-17', 'Travel');




--------------- ANSWER ----------------

/* 1) List all employees with their department name and location. */

select e.Name,d.Name,d.Location from Employee e
join Department d on e.DepartmentID=d.ID

/* 2) Show all projects with their lead’s name and the department they belong to. */

select p.Name as Project,e.Name as [Lead Name],d.Name [Department Name] from Project p
join Employee e on e.ID=p.LeadID
join Department d on d.ID=e.DepartmentID

/* 3) Find employees who are not assigned to any project. */

select e.Name from Employee e where e.ID not in (select EmployeeID from ProjectAssignments)

/* 4) List all project names along with names of employees assigned to each project. */

select p.Name,e.Name from ProjectAssignments ps
join Project p on p.ID = ps.projectID
join Employee e on e.ID = ps.EmployeeID

/* 5) For each department, show the total salary paid to employees. */

select d.Name,Sum(Salary) as [Total salary] from Department d 
join Employee e on e.DepartmentID=d.ID
group by d.Name

	-- (or)

select distinct e.DepartmentID,Sum(Salary) over(partition by e.DepartmentID) as DepartmentTotal from Employee e

	-- (or)

select DepartmentID,sum(Salary) as DepartmentTotal from Employee e group by DepartmentID

/* 6) List employees who worked on more than one project. */

select Name from Employee e 
join ProjectAssignments ps on ps.EmployeeID = e.ID
group by Name
having count(ps.EmployeeID)>1

/* 7) List all projects along with number of assigned employees. */

select ps.projectID,count(EmployeeID) as EmployeeCount from ProjectAssignments ps
group by ps.projectID

/* 8) Show employees who worked on the same projects as employee 'Nithya'. */

select distinct  e.Name from Employee e
join ProjectAssignments ps on ps.EmployeeID=e.ID
join
(
	select projectID from ProjectAssignments ps 
	join Employee e on e.ID=ps.EmployeeID
	where e.Name = 'Nithya'
) as jt on jt.projectID=ps.projectID
where e.Name not in ('Nithya')

/* 9) Get the average rating for each employee. */

select pr.EmployeeID,avg(Rating) as AverageRating from PerformanceReviews pr 
group by pr.EmployeeID

/* 10) Find the highest-rated employee in the year 2023. */

select top (1) pr.EmployeeID,pr.Rating from PerformanceReviews pr
where pr.Year='2023' order by Rating desc

/* 11) Show the latest performance rating for each employee (i.e., for the most recent year). */

select * from (select pr.EmployeeID,pr.Year,DENSE_RANK() over( order by Year desc) as r from PerformanceReviews pr) as Sample 
where Sample.r=1

	-- (or)

select pr.EmployeeID,max(pr.Year) as [Latest Review] from PerformanceReviews pr group by pr.EmployeeID

/* 12) List all project leads who also worked on their own projects (i.e., appear in ProjectAssignments). */

select distinct e.Name from Project p
join ProjectAssignments ps on p.LeadID=ps.EmployeeID
join Employee e on e.ID = p.LeadID


/* 13) For each department, list the top earning employee. */

with cte_sample as (select d.Name as DeptName,e.Name as EmpName,Dense_Rank()over(partition by e.DepartmentID order by Salary desc) as r from Employee e 
join Department d on d.ID=e.DepartmentID ) 
select DeptName,EmpName from cte_sample where cte_sample.r=1

				-- (or)

select DeptName,EmpName from (select d.Name as DeptName,e.Name as EmpName,Dense_Rank()over(partition by e.DepartmentID order by Salary desc) as r from Employee e 
join Department d on d.ID=e.DepartmentID ) as Sample where Sample.r=1


/* 14) Show projects where lead has not rated in 2023. */

select p.LeadID from Project p where p.LeadID not in (select pr.EmployeeID from PerformanceReviews pr where pr.Year='2023') 


/* 15) List departments with no employees assigned to any project. */

select d.Name as DeptName,e.Name from Employee e
join Department d on d.ID=e.DepartmentID
 where e.ID not in (select distinct ps.EmployeeID from ProjectAssignments as ps)