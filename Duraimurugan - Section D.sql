-- SECTION D 

-- Q11. Trigger - To restrict the product price updation which is not reduced more than its 20% of previous value.

--create or alter trigger tr_RestrictPrice
--on Products
--instead of update
--as
--begin
--	declare @OldPrice decimal(10,2);
--	declare @NewPrice decimal(10,2);
--	declare @LimitPrice decimal(10,2);
--	declare @productID int;

--	select @productID=ProductID,@NewPrice=ProductPrice from inserted;
--	select @OldPrice=ProductPrice from Products where ProductID=@productID;
--	select @LimitPrice=@OldPrice-@OldPrice/5;
		
--	if @NewPrice<@LimitPrice
--	begin
--		Rollback transaction;
--		Print 'New price is too low';
--	end

--end
--go

--drop trigger tr_RestrictPrice

create or alter trigger tr_RestrictPrice2
on Products
instead of update
as
begin
	declare @OldPrice decimal(10,2);
	declare @NewPrice decimal(10,2);
	declare @LimitPrice decimal(10,2);
	declare @ProductID int;


	declare cr cursor for 
	select ProductID,ProductPrice from inserted

	open cr;

	fetch next from cr into @ProductID,@NewPrice;

	while @@FETCH_STATUS=0
	begin
		select @OldPrice=ProductPrice from Products where ProductID=@productID;
		select @LimitPrice=@OldPrice-@OldPrice/5;
		begin transaction;
		if @NewPrice<@LimitPrice
			begin
				Rollback transaction;
				Print 'New price is too low';
			end
		fetch next from cr into @ProductID,@NewPrice;
	end
	
end


select * from Products;

begin try
update Products set ProductPrice=2 where ProductID=5 or ProductID=15;
end try
begin catch
	print 'Your price is too low ! '
end catch




-- Q12.Trigger - Capture deleted rows and log into the EmployeeArchive

select * from Employees;

select * into EmployeeArchive from Employees ;

truncate table EmployeeArchive

alter table EmployeeArchive add LogDate timestamp;

create trigger tr_LogDeletedRows
on Employees 
After Delete
as
begin
	insert into EmployeeArchive(EmpID,EmpName,Salary,ManagerID) select * from deleted
end

select * from Employees

insert into Employees values('checking',80000,101)

delete from Employees where EmpID in (107,108,109)

set identity_insert EmployeeArchive on -- to insert row from deleted records. Because we need to insert identity values explicitly in table.

select * from EmployeeArchive



--Q13.UDDT for Phone numbers which must start with + and minimum characters are 10.

-- First approach
create rule PhoneNumberRule
as @PhoneNumbers like '+__________%';

create type PhoneNumbers
from Varchar(15)  not null;

exec sp_bindrule 'PhoneNumberRule','PhoneNumbers';

create table SampleTable
(
	TableId int primary key identity(10,10),
	Name varchar(30),
	PhoneNumber PhoneNumbers unique
)

-- Second approach
create type MobileNo from varchar(15) not null;

create table Demo
(
	TableId int primary key identity(10,10),
	Name varchar(30),
	PhoneNumber MobileNo unique check(PhoneNumber like '+%' and len(PhoneNumber)>=10)
)


begin try
insert into SampleTable values('Durai','+56546564655686')
print 'Success !'
end try
begin catch
print  'Invalid phonenumber !'
end catch

insert into SampleTable values('Tanvir','654654656') -- This show error.

select * from SampleTable



--Q14. T-SQL block - for insertion incase of failure rollback and use TRY... CATCH... Log error number and line into ErrorLog Table

select * from ErrorLog;

begin try
	begin transaction
	set nocount on;
	insert into Employees values('Sample','erte',106);
	commit transaction;
	print 'Ok'
end try

begin catch
	print 'Insertion failed'
	rollback transaction
	insert into ErrorLog values(ERROR_MESSAGE(),ERROR_LINE())
	print 'Errors are logged into Log table'
end catch

