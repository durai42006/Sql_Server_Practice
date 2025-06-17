-- Find employees who earn more than their manager
select * from Employees;
select EmpName from Employees e where Salary >(Select Salary from Employees m where m.EmpID=e.ManagerID);
select e.EmpName as EmployeeName, m.EmpName as ManagerName, e.Salary as EmployeeSalary, m.Salary as ManagerSalary from Employees e
join Employees m on m.EmpID=e.ManagerID where e.Salary>m.Salary


-- Display departments where the average salary is higher than the overall company average
select *,(Select sum(Salary) as TotalSalary from Employees) as Compansalary from (select distinct d.DeptName,avg(Salary) over(partition by e.DeptID) as deptAvgSalary from Employees e 
join Departments d on d.DeptID=e.DeptID) as dd where dd.deptAvgSalary>(Select avg(Salary) from Employees)

-- List top 2 highest-paid employees in each department
select * from (select e.EmpID,e.EmpName,e.DeptId,e.Salary,DENSE_RANK() over(partition by DeptID order by Salary desc) as r from Employees e) as dd where dd.r<3


--  Find employees who are not assigned to any project
select e.EmpID,e.EmpName from Employees e
left join EmployeeProjects ep on ep.EmpID=e.EmpID
where ProjectID=null

-- Get the employee(s) who joined earliest in each department
select EmpID,EmpName,DeptID,JoinedDate from (select EmpID,EmpName,DeptID,JoinedDate,DENSE_RANK() over(partition by DeptID order by joinedDate desc) as r from Employees) as dd where dd.r=1

-- Display departments with more than 3 employees who earn above department average
select e.DeptID from Employees e join (
select distinct DeptID,avg(Salary) over(partition by DeptID) as avgsalary from Employees ) as ds on ds.DeptID=e.DeptID
where e.Salary>ds.avgsalary
group by e.DeptID
having count(e.EmpID) >1 -- we can change here according to question

--  List employees whose salary is within 10% of their department's average salary
select * from Employees e 
join (select DeptID,avg(Salary)+avg(Salary)/10 as DeptSalary from Employees group by DeptID) as dd on dd.DeptID=e.DeptID
where e.Salary<dd.DeptSalary

-- Find the number of subordinates under each manager (including indirect subordinates)
with cte_ManagerSubordinates
as
(
	select EmpID from Employees se where se.ManagerID=101 -- here we can mention any emp id to search

	union all 

	select e.EmpID from Employees e
	join cte_ManagerSubordinates ct on ct.EmpID=e.ManagerID
)
select count(*) from cte_ManagerSubordinates

--  List employees who work on all projects that 'John Mathew' works on

select * from Employees e 
join EmployeeProjects ep on ep.EmpID=e.EmpID
where ep.ProjectID in (Select ProjectID from EmployeeProjects where EmpID = 101) -- by id


select * from Employees e 
join EmployeeProjects ep on ep.EmpID=e.EmpID
where ep.ProjectID in (Select ProjectID from EmployeeProjects where EmpID = (select EmpId from Employees where EmpName = 'John Mathew')) -- by name

-- Show salary banding: Low (<50k), Medium (50k–75k), High (>75k) per employee

Select EmpName,
case 
	when Salary<50000 then 'Low'
	when Salary>=50000 and Salary <=70000 then 'Medium'
	when Salary>70000 then 'Hard'
end as SalaryBand
from Employees 

-- Get project-wise count of employees, but only for projects that have more than 5 employees

select ProjectID,Count(EmpID) as Employees from EmployeeProjects ep group by ProjectID having Count(EmpID)>5

-- Find managers who have the most number of direct reports
select top 1 with ties e.ManagerID,count(e.ManagerID) as Count from Employees e 
join Employees m on m.EmpID=e.ManagerID 
group by e.ManagerID 
order by Count(e.ManagerID) desc
