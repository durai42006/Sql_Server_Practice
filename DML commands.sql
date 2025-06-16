
/*DML COMMANDS*/

/*Creating database*/
create database DML;

/*using created database*/
use DML;

/*Creating table */
create table Employees(
Emp_id int identity(1,2) primary key,
Emp_name varchar(50),
Emp_salary decimal(10,2)
);

create table Department(
Dept_id int identity(1,2) primary key,
Dept_name varchar(25)
);

/*Inserting values into the database*/
insert into Employees(Emp_name,Emp_salary) values ('Durai',30000);
insert into Employees(Emp_name,Emp_salary) values ('Ramnivas',70000);
insert into Employees(Emp_name,Emp_salary) values ('Rajkumar',50000);
insert into Employees(Emp_name,Emp_salary) values ('Renga',30000);
insert into Employees(Emp_name,Emp_salary) values ('Karthi',25000);

insert into Department(Dept_name) values ('Developer');
insert into Department(Dept_name) values ('Marketing');
insert into Department(Dept_name) values ('Finance');

/*View all records in the two tables*/
select * from Employees;
select * from Department;

/*Update the department name*/
update Department
set Dept_name='IT' where Dept_name='Developer'

/*View the changes made at department*/
select * from Department;

/*Delete the speific row*/
delete from Employees where Emp_name='Karthi';
select * from Employees


/*Merge command*/
merge Employees as target
using Department as source
on target.Emp_id=source.Dept_id
when matched then
	update set target.Emp_salary+=500
when not matched by source then
	delete;

select * from Employees;