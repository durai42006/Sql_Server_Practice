-- Section C

-- Q7.Stored Procedure - Accept OrderID as input calculate Total amount and log into the AuditLog 

create table AuditLog
(
	OrderID int,
	TotalAmount decimal(10,2),
	LogDate timestamp
)
go

create or alter procedure LogOrderAmount
(	@OrderID int	)
as
begin
	declare @Total decimal(10,2);
	with cte_getProducts
	as
	(
		select p.ProductID,Quantity,(Quantity*ProductPrice) as Total from OrderDetails od
		join Products p on p.ProductID=od.ProductID
		where od.OrderID=@OrderID
	)
	select @Total=sum(Total) from cte_getProducts

	insert into AuditLog(OrderID,TotalAmount) values (@orderID,@Total)
end

LogOrderAmount 129

select * from AuditLog



-- Q8. Table-valued function - Returns Who have not placed any order for last N months

create or alter function fn_NotOrderCustomers
(@Month int)
returns table
as
return
	with cte_FilterMonth
	as
	(
		select * from Orders o where OrderDate>dateadd(month,-@Month,GetDate())
	)
	select CustomerID,CustomerName from Customers where CustomerID not in (Select CustomerID from cte_FilterMonth);

select * from fn_NotOrderCustomers(6);
select * from Orders;
go

-- Q9.Create view for who placed more than 5 orders and log recent order also.

create view vw_CustomerRecentOrder
as
with cte_Customers
as
(
	select CustomerID from Orders o group by CustomerID having count(CustomerID)>5
)
select CustomerID,Max(OrderDate) as RecentOrderDate from Orders where CustomerID in (Select CustomerId from cte_Customers) group by CustomerID;

select * from vw_CustomerRecentOrder;

-- Q10. Scalar Function that support in index view

create function fn_ScalarIndexView
(@number int) 
returns int with schemabinding
as
begin
	declare @Result int;
	set @Result=@number*@number;
	return @Result;
end


select dbo.fn_ScalarIndexView(4) as SquareValue