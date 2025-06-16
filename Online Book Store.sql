
create database OnlineBookStore;

use OnlineBookStore;

create table Authors
(
	AuthorID int primary key,
	AuthorName varchar(30),
	AuthorAddress varchar(50) 
);

create table Books
(
	BookID int primary key,
	BookName varchar(20),
	AuthorID int foreign key references Authors(AuthorID),
	ISBN varchar(13),
	BookPrice Money
);

create table Login
(
	UserID int primary key,
	Username varchar(30),
	Password varchar(20),
	Role varchar(20)
);

create table Admin
(
	AdminID int primary key foreign key references Login(UserID),
	AdminAddress varchar(30)
);

create table BookUpdates
(
	AdminId int foreign key references Admin(AdminID),
	BookID int foreign key references Books(BookID)
);

create table Customers
(
	CustomerID int primary key foreign key references Login(UserID),
	CustoerPhone varchar(12),
	CustomerAddress varchar(50)
);

create table Orders
(
	OrderNo int primary key,
	CustomerID int foreign key references Customers(CustomerID), 
	OrderDate Date
);

create table OrderBook
(
	OrderNo int foreign key references Orders(OrderNo),
	BookID int foreign key references Books(BookID),
	Quantity int,
	primary key(OrderNo,BookID)
);


create table Payment
(
	PaymentID int primary key,
	PaymentMethod varchar(30),
	PaymentDate Date,
	OrderNo int foreign key references Orders(OrderNo),
	TotalAmount Money
);

create table Roles
(
	RoleID int primary key,
	RoleName varchar(30)
);


/***** Changes made after table creation *****/

--drop table OrderBook;

--alter table OrderBook drop constraint FK__OrderBook__Custo__47DBAE45;
--alter table OrderBook drop column CustomerID;
--alter table OrderBook add constraint UK_OrderBook_OrderNO Unique(OrderNo);

--alter table Login drop column Role;
--alter table Login add RoleID int;
--alter table Login add constraint FK_LOGIN_ROLEID foreign key(RoleID) references Roles(RoleID);

--update Books set AuthorID = case 
--	when BookID=102 then 2
--	when BookID=104 then 3
--	when BookID=105 then 2
--	else AuthorID
--	end;

--exec sp_rename 'Customers.CustoerPhone','CustomerPhone';



/***** Insert values into created tables *****/
insert into Authors(AuthorID,AuthorName,AuthorAddress) values(1,'Alice','Ariyalur');
insert into Authors(AuthorID,AuthorName,AuthorAddress) values(2,'Bob','Bangalore');
insert into Authors(AuthorID,AuthorName,AuthorAddress) values(3,'Charlie','Chennai');
insert into Authors(AuthorID,AuthorName,AuthorAddress) values(4,'David','Dindukal');
insert into Authors(AuthorID,AuthorName,AuthorAddress) values(5,'Etron','Erode');

insert into Books(BookID,BookName,AuthorID,ISBN,BookPrice) values(101,	'Java',		1,	'1231231231234',	100);
insert into Books(BookID,BookName,AuthorID,ISBN,BookPrice) values(102,	'C#',		1,	'1231234564567',	200);
insert into Books(BookID,BookName,AuthorID,ISBN,BookPrice) values(103,	'C',		1,	'1231237897890',	50);
insert into Books(BookID,BookName,AuthorID,ISBN,BookPrice) values(104,	'Python',	1,	'1231232462468',	150);
insert into Books(BookID,BookName,AuthorID,ISBN,BookPrice) values(105,	'SQL',		1,	'1231231351357',	250);

insert into Roles(RoleID,RoleName) values(55,'Customer');
insert into Roles(RoleID,RoleName) values(77,'Admin');

insert into Login(UserID,Username,Password,RoleID) values(11,	'Durai',	'Durai@2003',		77);
insert into Login(UserID,Username,Password,RoleID) values(12,	'Kavi',		'Kavi@2004',		55);
insert into Login(UserID,Username,Password,RoleID) values(13,	'Guhan',	'Guhan@2003',		55);
insert into Login(UserID,Username,Password,RoleID) values(14,	'Arumugam',	'Arumugam@2003',	55);
insert into Login(UserID,Username,Password,RoleID) values(15,	'Govardan',	'Govardan@2004',	55);
insert into Login(UserID,Username,Password,RoleID) values(16,	'Karan',	'Karan@2004',		55);
insert into Login(UserID,Username,Password,RoleID) values(17,	'Sakthi',	'Sakthi@2003',		77);

insert into Admin(AdminID,AdminAddress) values(11,'Thanjavur');
insert into Admin(AdminID,AdminAddress) values(17,'Trichy');

insert into Customers(CustomerID,CustomerPhone,CustomerAddress) values(12,	'6379639261',	'Chennai');
insert into Customers(CustomerID,CustomerPhone,CustomerAddress) values(13,	'9261637963',	'Coimbatore');
insert into Customers(CustomerID,CustomerPhone,CustomerAddress) values(14,	'9263616379',	'Bangalore');
insert into Customers(CustomerID,CustomerPhone,CustomerAddress) values(15,	'7339600783',	'Kerala');
insert into Customers(CustomerID,CustomerPhone,CustomerAddress) values(16,	'9791448346',	'Delhi');

insert into Orders(OrderNo,OrderDate,CustomerID) values(1101,Getdate(),12);
insert into Orders(OrderNo,OrderDate,CustomerID) values(1102,Getdate(),13);
insert into Orders(OrderNo,OrderDate,CustomerID) values(1103,Getdate(),16);
insert into Orders(OrderNo,OrderDate,CustomerID) values(1104,Getdate(),13);
insert into Orders(OrderNo,OrderDate,CustomerID) values(1105,Getdate(),14);

insert into OrderBook(OrderNo,BookID,Quantity) values(1101,105,3);
insert into OrderBook(OrderNo,BookID,Quantity) values(1101,103,5);
insert into OrderBook(OrderNo,BookID,Quantity) values(1102,102,1);
insert into OrderBook(OrderNo,BookID,Quantity) values(1103,101,10);
insert into OrderBook(OrderNo,BookID,Quantity) values(1103,105,4);
insert into OrderBook(OrderNo,BookID,Quantity) values(1104,105,10);
insert into OrderBook(OrderNo,BookID,Quantity) values(1105,101,2);
insert into OrderBook(OrderNo,BookID,Quantity) values(1105,103,7);

insert into Payment(PaymentID,PaymentDate,PaymentMethod,OrderNo) values(901,GETDATE(),'Upi',1101);
insert into Payment(PaymentID,PaymentDate,PaymentMethod,OrderNo) values(902,GETDATE(),'Visa',1102);
insert into Payment(PaymentID,PaymentDate,PaymentMethod,OrderNo) values(903,GETDATE(),'Upi',1103);
insert into Payment(PaymentID,PaymentDate,PaymentMethod,OrderNo) values(904,GETDATE(),'Visa',1104);
insert into Payment(PaymentID,PaymentDate,PaymentMethod,OrderNo) values(905,GETDATE(),'Upi',1105);


/* Retrieve all information from all tables */

select * from Authors;

select * from Books;

select * from Customers;

select * from Orders;

select * from OrderBook;

select * from Payment;

select * from Login;


/* insert the Total amount into Payment table */



create trigger trInsertPayment
on Payment
for Insert
as 
begin
	update Payment set TotalAmount = (select sum(ob.Quantity*b.BookPrice) from OrderBook ob join Books b on b.BookID=ob.BookID where ob.OrderNo=inserted.OrderNo);
end;




update Payment 
set TotalAmount = (
    select sum(ob.Quantity * b.BookPrice)
    from OrderBook ob
    join Books b on ob.BookID = b.BookID
    where ob.OrderNo = Payment.OrderNo
);



/*#####################--PRACTICE QUESTIONS--#######################*/



/*	
	**************************************************************
	Display all customers who placed an order.
	Output: CustomerID, Username, CustomerPhone, OrderNo, OrderDate
	**************************************************************
*/
select O.CustomerID,L.Username,C.CustomerPhone,O.OrderNo,OrderDate 
from Orders O
Join Login L on L.UserID=O.CustomerID
join Customers C on C.CustomerID=O.CustomerID;




/*	
	***************************************
	List all books that were never ordered.
	Output: BookID, BookName
	***************************************
*/
select * from Books; --Total books
select * from OrderBook; -- Ordered books
select BookID,BookName from Books 
where BookID not in (select BookID from OrderBook);




/*
	**********************************************
	Find the total quantity ordered for each book.
	Output: BookID, BookName, TotalQuantity
	**********************************************
*/
select * from OrderBook; --Ordered books

select OrderBook.BookID,BookName,sum(Quantity)TotalQuantity from OrderBook
join Books on Books.BookID=OrderBook.BookID
group by OrderBook.BookID,BookName




/*
	*******************************************************************
	Show order details along with total amount paid (price × quantity).
	Output: OrderNo, BookName, Quantity, BookPrice, LineTotal
	*******************************************************************
*/
select OrderNO,BookName,Quantity,BookPrice,(BookPrice*Quantity) as LineTotal
from OrderBook ob
join Books b on b.BookID=ob.BookID;




/*
	**************************************************************************
	List customers who paid using ‘UPI’.
	Output: CustomerID, Username, CustomerPhone, PaymentMethod, PaymentDate
	**************************************************************************
*/
select UserID as CustomerID,Username,CustomerPhone,PaymentMethod,PaymentDate
from Payment p
join Orders o on o.OrderNo=p.OrderNo
join Login l on l.UserID=o.CustomerID
join Customers c on c.CustomerID=o.CustomerID
where PaymentMethod='Upi';



/*
	*************************************
	Find the top 2 highest total paying customers.
	Output: CustomerID, Username, TotalAmountPaid
	*************************************
*/

/**in progress***/