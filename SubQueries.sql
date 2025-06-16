use SubQueries;

create table Departments
(
	DeptID int primary key,
	DeptName varchar(20),
	DeptBudget money
);


create table Employees
(
	EmpID int primary key,
	EmpName varchar(25),
	EmpSalary Money,
	DeptID int references Departments(DeptID)
);

INSERT INTO Departments (DeptID, DeptName, DeptBudget) VALUES
(101, 'HR', 500000),
(102, 'IT', 1000000),
(103, 'Finance', 750000),
(104, 'Marketing', 600000);

INSERT INTO Employees (EmpID, EmpName, EmpSalary, DeptID) VALUES
(1, 'Alice', 55000, 101),
(2, 'Bob', 70000, 102),
(3, 'Charlie', 65000, 103),
(4, 'Diana', 62000, 104),
(5, 'Ethan', 58000, 101),
(6, 'Fiona', 80000, 102);


SELECT EmpName
FROM Employees
WHERE EmpSalary > (SELECT AVG(EmpSalary) FROM Employees);  -- scalar subquery


CREATE PROCEDURE DisplayWelcome
AS
BEGIN
  PRINT 'WELCOME TO PROCEDURE in SQL Server'
END

DisplayWelcome

 sp_helptext DisplayWelcome