
/*

SQL Practice Question: Sales Table (DDL, DML & DQL)
You are managing a database for a small retail business. You need to create and manage a Sales table that stores information about product sales. Complete the tasks below using appropriate SQL statements.

1. DDL (Data Definition Language)
Task:
Create a table named Sales with the following columns:

Column Name	Description
SaleID	Primary key, auto-incremented
SaleDate	Date of the sale
CustomerName	Name of the customer
Product	Product sold
Quantity	Quantity sold
PricePerUnit	Price per single unit
PaymentMethod	e.g., 'Cash', 'Card', 'Online'

2. DML – INSERT (Insert Data)
Task:
Insert the following records into the Sales table:

SaleDate	CustomerName	Product	Quantity	PricePerUnit	PaymentMethod
2025-05-01	Alice	Headphones	2	150.00	Card
2025-05-02	Bob	Smartphone	1	700.00	Online
2025-05-03	Charlie	Charger	3	25.00	Cash
2025-05-03	Alice	Laptop	1	1200.00	Card

*/




/* Answer */


/* 1. DDL (Data Definition Language) */

	create database Shop;

	use Shop;

	create table Sales(
	Descryption varchar(200),
	SalesID int identity(1,1) primary key,
	SalesDate Date,
	CustomerName varchar(50),
	Product varchar(50),
	Quantity int,
	PricePerUnit decimal(8,2),
	PaymentMethod varchar(20) 
	constraint payment_method check (PaymentMethod in ('Online','Cash','Card'))
	);

/* 2. DML – INSERT (Insert Data) */

	insert into Sales(Descryption,SalesDate,CustomerName,Product,Quantity,PricePerUnit,PaymentMethod) values('Wireless noise-cancelling over-ear headphones','2025-05-01','Alice','Headphones',2,150.00,'Card');
	insert into Sales(Descryption,SalesDate,CustomerName,Product,Quantity,PricePerUnit,PaymentMethod) values('14-inch ultra-slim business laptop','2025-05-02','Bob','Laptop',1,700.00,'Online');
	insert into Sales(Descryption,SalesDate,CustomerName,Product,Quantity,PricePerUnit,PaymentMethod) values('Fast charging USB-C wall charger','2025-05-03','Charlie','Charger',3,25.00,'Cash');
	insert into Sales(Descryption,SalesDate,CustomerName,Product,Quantity,PricePerUnit,PaymentMethod) values('14-inch ultra-slim business laptop','2025-05-03','Alice','Laptop',1,1200.00,'Card');
	select * from Sales;

/* 3. DML – UPDATE (Update Data) */

	--a) Update the payment method to 'Online' for all sales made by 'Alice'.
		update Sales set PaymentMethod='Online' where CustomerName='Alice';
		select * from Sales;

	--b) Update the price per unit of 'Charger' to 30.00.
		update Sales set PricePerUnit=30 where Product='Charger';
		select * from Sales;

/* 4. DML – DELETE (Delete Data) */

	--a) Delete all sales records where the quantity is less than 2.
		select * from Sales;
		Delete from Sales where Quantity<2;
		select * from Sales;

	--b) Delete the record of any sale made by 'Bob'.
		select * from Sales;
		delete from Sales where CustomerName='Bob';
		select * from Sales;

/* 5. DQL (Data Query Language) */
	

	--a) List all sales made using the 'Card' payment method.
		select * from Sales where PaymentMethod='Card';

	--b) Calculate the total revenue generated (Quantity × PricePerUnit).
		select * from Sales;
		select sum(Quantity*PricePerUnit) as TotalRevenue from Sales;

	--c) Display the total quantity of each product sold.
		select * from Sales;
		select Product,sum(Quantity) as Quantity from Sales group by Product;

	--d) Show all sales where the quantity sold is more than 1.
		select * from Sales where Quantity>1;

	--e) Find the customer who spent the most in a single transaction.
		select Max(Quantity*PricePerUnit) as MaxSpent from Sales;