--Create database DuraimuruganAssessment;

--use DuraimuruganAssessment;

-- SECTION A

-- Q1. Hospital management system

create table Patients
(
	PatientID int primary key identity(101,1),
	PatientName varchar(50),
	DOB Date,
	Address varchar(100),
	PatientPhone varchar(15)
)

create table Departments
(
	DeptID SmallInt primary key identity(1,1),
	DeptName Varchar(50),
)

create table Doctors
(
	DoctorID int primary key identity(1101,1),
	DeptID SmallInt constraint fk_Doctors_DeptID references Departments(DeptID),
	DoctorName varchar(30),
	DoctorPhone varchar(15),
	DoctorFees decimal(10,2),
	StartTime Time,
	EndTime Time
)
create table AppStatus
(
	StatusID TinyInt primary key identity(2,2),
	StatusName varchar(30)
)
create table Appointments
(
	AppointmentID int primary key identity(901,1),
	DoctorID int constraint fk_Appointments_DoctorID references Doctors(DoctorID),
	PatientID int constraint fk_Appointments_PatientID references Patients(PatientID),
	AppointmentDate date,
	StatusID TinyInt constraint fk_Appointments_Status references AppStatus(StatusID),
	unique(DoctorID,PatientID,AppointmentDate)
)

create nonclustered index ix_Doctors_DoctorName
on dbo.Doctors(DoctorName)

create nonclustered index ix_Patients_PatientName
on dbo.Patients(PatientName)


-- Q2. Normalize the table

-- | OrderID | CustomerName | Product1 | Product2 | Product3 | Address | TotalAmount |

create table City
(
	CityID int primary key identity(101,1),
	CityName varchar(30),
	PostalCode Varchar(10)
)
create table Address
(
	AddressID  int primary key identity(901,1),
	CityID int constraint fk_Address_CityID references City(CityID),
	StreetName varchar(50)
)
create table Customers
(
	CustomerID int primary key identity(1001,2),
	CustomerName varchar(30),
	CustomerMail varchar(254),
	CustomerPhone varchar(15),
	AddressID int constraint fk_Customers_AddressID references Address(AddressID)
)
alter table Customers add constraint uk_Customers_Mail Unique(CustomerMail)
alter table Customers add constraint uk_Customers_Phone Unique(CustomerPhone)
create table Products 
(
	ProductID int primary key identity(5,5),
	ProductName varchar(30),
	ProductPrice decimal(10,2)
)

create table Orders
(
	OrderID int primary key identity(101,1),
	CustomerID int constraint fk_Orders_CustomerID references Customers(CustomerID),
	OrderDate date,
	TotalAmount decimal(10,2) default null
)

create table OrderDetails
(
	OrderDetailID int primary key identity(9001,1),
	OrderID int constraint fk_OrderDetails_OrderID references Orders(OrderID),
	ProductID int constraint fk_OrderDetails_ProductID references Products(ProductID),
	Quantity int,
	TotalPrice decimal(10,2),
)


-- value insertion for created tables


insert into City values ('Arakonam',631001),('Kombai',625522),('Thanjavur',613204)

insert into Address values (101,'Pudthu street'),(102,'North Street'),(103,'Seniya street')

insert into Customers values ('Alice','alice@gmail.com','9592698561',901),('Bob','bob@gmail.com','9592845561',901),('Charlie','charlie@gmail.com','9592698128',902),('David','david@gmail.com','9592698854',903),('Envar','envar@gmail.com','9592698637',902),('Frank','frank@gmail.com','9592698699',901),('Guru','guru@gmail.com','9592695759',903)

insert into Products values ('Milk',10),('Apple',150),('Bread',20),('Cream',100),('Dog Food',300)

insert into Orders(CustomerID,OrderDate) values (1001,'2025-01-02'),(1001,'2025-02-12'),(1001,'2025-06-11'),(1005,'2025-01-02'),(1005,'2025-04-12'),(1003,'2025-01-01'),(1007,'2025-06-17'),(1009,'2025-05-21'),(1011,'2025-06-10')



select * from Orders

insert into Orders(CustomerID,OrderDate) values (1013,'2020/10/26')

insert into Orders(CustomerID,OrderDate) values (1001,'2025-03-02'),(1001,'2025-04-02'),(1001,'2025-05-02'),(1001,'2024-12-02')

insert into OrderDetails values (101)