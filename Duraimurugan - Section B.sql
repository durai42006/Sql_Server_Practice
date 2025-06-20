-- Section B

-- Q3.Find customer who placed orders at each month for last 6 months

declare @TempDate Date =dateadd(MONTH,-6,getdate());
select CustomerID from Orders where OrderDate>@TempDate group by CustomerID having count(distinct datepart(month,OrderDate))=6


-- Q4.Find all subordinates(directly/indirectly) to the specific manager

create table Employees(
EmpID int primary key identity(101,1),
EmpName varchar(30),
Salary decimal(10,2),
ManagerID int references Employees(EmpID)
)

insert into Employees values('Alice',10000,null), ('Bob',20000,101),('Charlie',30000,101), ('David',40000,106), ('Durai',50000,106), ('Ebe',60000,null)

declare @ManagerID int = 101;

with cte_CheckTeams
as
(
	select EmpID,ManagerID from Employees where ManagerID=@ManagerID

	union all

	select e.EmpID,e.ManagerID from Employees e
	join cte_CheckTeams ct on ct.EmpID=e.ManagerID
)
select * from cte_CheckTeams;

-- Q5.Second highest salary without using TOP,LIMIT,OFFSET

with cte_SecondSalary
as
(
	select EmpID,Salary,DENSE_RANK() over(order by Salary) as R from Employees e
)
select EmpId,Salary from cte_SecondSalary where R=2;

-- Q6.7 day Rolling average of Sales

select * from Products;

create table Sales(
	ProductID int,
	SalesDate date,
	Amount decimal(10,2)
)

insert into Sales values (5,'2025-06-01',200),(10,'2025-06-02',200),(5,'2025-06-03',200),(5,'2025-06-04',100),(10,'2025-06-05',150),
(5,'2025-06-06',200),(10,'2025-06-07',200),(5,'2025-06-07',200),(5,'2025-06-08',200),(5,'2025-06-09',200)

select * from Sales;
select ProductID,SalesDate,DailyAmount,cast(avg(DailyAmount)  over(partition by ProductID order by SalesDate rows between 6 preceding and current row) as decimal(10,2)) as AvgSales from 
(select ProductID,SalesDate,sum(Amount) as DailyAmount from Sales group by ProductID,SalesDate) as d