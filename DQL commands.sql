/*

sample table 

OrderID	CustomerName	ProductID	Amount	OrderDate
1		Sabari			101			500		2024-01-15
2		Subha			102			200		2024-01-17
3		Sabari			101			700		2024-02-10
4		Arun			103			150		2024-03-05
5		Subha			101			400		2024-03-10
6		Sabari			102			300		2024-04-12
7		Priya			104			250		2024-04-18
8		Arun			101			350		2024-05-01
9		Subha			102			150		2024-05-03
10		Priya			104			500		2024-05-10
 
 
Question 1:
Group orders by customer and show how many orders each customer has placed.
 
Question 2:
Show the average order amount for each product ID.
 
Question 3:
List each customer along with the total amount they have spent on orders.

Question 4: 
Show product IDs that have been ordered more than 3 times.

Question 5:
Display customer names whose total order amount exceeds ₹10,000.

Question 6:
Group orders by product and show the total sales for each product.

Question 7:
List the product IDs that have been ordered more than 2 times and show their total sales.

*/








create database DQL;

use DQL;


create table Shop
(
OrderID int identity(1,1) primary key,
CustomerName varchar(50),
ProductID int,
Amount decimal(8,2),
OrderDate date
);

insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Sabari',101,500,'2024-01-15');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Arun',102,700,'2024-01-18');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Subha',104,100,'2024-01-18');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Priya',102,250,'2024-01-26');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Arun',104,550,'2024-02-03');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Sabari',103,600,'2024-02-12');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Priya',101,890,'2024-02-20');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Subha',104,230,'2024-02-28');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Sabari',103,120,'2024-03-1');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Priya',101,430,'2024-03-17');
insert into Shop(CustomerName,ProductID,Amount,OrderDate) values('Priya',101,280,'2024-04-01');

/*Display all in the table*/
select * from Shop;


/*Group orders by customer and show how many orders each customer has placed.*/
select CustomerName,Count(CustomerName) as Orders from Shop group by CustomerName;


/*Show the average order amount for each product ID*/
select ProductID,Avg(Amount) as AverageAmount from Shop group by ProductID;


/*List each customer along with the total amount they have spent on orders.*/
select CustomerName,sum(Amount) as AmountSpent from Shop group by CustomerName;


/*Show product IDs that have been ordered more than 3 times.*/
select ProductID from Shop  group by ProductID having Count(ProductID)>3;


/*Display customer names whose total order amount exceeds ₹1500.*/
select CustomerName from Shop group by CustomerName having sum(Amount)>1500;


/*Group orders by product and show the total sales for each product. */
select ProductID,sum(Amount) as SpentAmount from Shop group by ProductID;


/*List the product IDs that have been ordered more than 2 times and show their total sales.*/
select ProductID,sum(Amount) as TotalSales from Shop group by ProductID having count(ProductID)>2;

