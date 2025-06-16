/* 
Challenge: Top-Earning Employee per Department with Conditions
🔧 Problem Statement:
You are given the following schema:

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID),
    Salary DECIMAL(10,2),
    DOJ DATE, -- Date of Joining
    Status VARCHAR(10) CHECK (Status IN ('Active', 'Resigned'))
);


🎯 Your Task:
Write a SQL query to retrieve:

The top-earning active employee in each department

Along with their:

Name

Department name

Salary

Years of experience (from DOJ to today, rounded to 1 decimal)

BUT: Exclude any department where more than 50% of employees have resigned

If there are ties (same salary), pick the employee who joined earlier

📤 Sample Output Columns:
DeptID	DeptName	EmpID	EmpName	Salary	Experience (Years)
1	HR	102	Ramesh Kumar	75000.0	4.3
2	IT	203	Divya Singh	96000.0	6.8

*/

use Practice;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID),
    Salary DECIMAL(10,2),
    DOJ DATE, -- Date of Joining
    Status VARCHAR(10) CHECK (Status IN ('Active', 'Resigned'))
);

INSERT INTO Departments (DeptID, DeptName)
VALUES 
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Logistics');


INSERT INTO Employees (EmpID, EmpName, DeptID, Salary, DOJ, Status)
VALUES
(101, 'Alice Johnson',     1, 45000.00, '2020-03-15', 'Active'),
(102, 'Bob Smith',         3, 60000.00, '2019-07-23', 'Resigned'),
(103, 'Charlie Green',     2, 75000.00, '2018-11-10', 'Active'),
(104, 'David Miller',      4, 50000.00, '2021-01-02', 'Active'),
(105, 'Emily Watson',      3, 60000.00, '2022-06-18', 'Active'),
(106, 'Frank Thomas',      5, 40000.00, '2020-08-30', 'Resigned'),
(107, 'Grace Lee',         1, 45000.00, '2021-12-05', 'Active'),
(108, 'Henry Clark',       2, 75000.00, '2017-09-11', 'Resigned'),
(109, 'Isabella Adams',    4, 50000.00, '2023-02-20', 'Active'),
(110, 'Jack Wilson',       5, 40000.00, '2021-04-12', 'Active'),
(111, 'Kylie Morgan',      3, 60000.00, '2020-10-08', 'Active'),
(112, 'Liam Davis',        1, 45000.00, '2022-03-27', 'Resigned');



------------------------------  Answer query  ----------------------------
with cte_details
as
(
	select e.DeptID,
	sum(case when e.Status='Active' then 1 else 0 end)as Active,
	sum(case when e.Status='Resigned' then 1 else 0 end) as Resigned from Departments d 
	join Employees e on e.DeptID=d.DeptID group by e.DeptID
),
status_details 
as
(
	select DeptID from cte_details where Active>Resigned
)

select d.DeptID,d.DeptName,EmpID,EmpName,Salary,DATEDIFF(year,DOJ,getdate()) as Experience from Employees e 
join Departments d on d.DeptID=e.DeptID where e.DeptID in (select DeptID from status_details)













CREATE TABLE AnotherDepartments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE AnotherEmployees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT FOREIGN KEY REFERENCES AnotherDepartments(DeptID)
);

CREATE TABLE PerformanceReviews (
    ReviewID INT PRIMARY KEY,
    EmpID INT FOREIGN KEY REFERENCES AnotherEmployees(EmpID),
    ReviewScore INT, -- 1 to 10
    ReviewDate DATE
);

INSERT INTO AnotherDepartments (DeptID, DeptName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

INSERT INTO AnotherEmployees (EmpID, EmpName, DeptID) VALUES
(101, 'Ramesh Kumar', 1),
(102, 'Priya Sharma', 1),
(201, 'Anil Verma', 2),
(202, 'Divya Singh', 2),
(203, 'Manoj Rathi', 2),
(301, 'Sneha Joshi', 3),
(302, 'Karan Patel', 3);


INSERT INTO PerformanceReviews (ReviewID, EmpID, ReviewScore, ReviewDate) VALUES
-- HR
(1, 101, 7, '2024-01-10'),
(2, 101, 8, '2024-02-15'),
(3, 101, 9, '2024-03-20'),
(4, 102, 6, '2024-01-12'),
(5, 102, 6, '2024-02-16'),
(6, 102, 6, '2024-03-21'),

-- IT
(7, 201, 9, '2024-01-05'),
(8, 201, 5, '2024-02-10'),
(9, 201, 6, '2024-03-11'),
(10, 202, 8, '2024-01-06'),
(11, 202, 8, '2024-02-11'),
(12, 202, 8, '2024-03-12'),
(13, 203, 9, '2024-01-07'),
(14, 203, 9, '2024-02-13'),
(15, 203, 9, '2024-03-14'),

-- Sales
(16, 301, 7, '2024-01-20'),
(17, 301, 7, '2024-02-20'),
(18, 301, 7, '2024-03-20'),
(19, 302, 10, '2024-01-21'),
(20, 302, 4, '2024-02-21'),
(21, 302, 6, '2024-03-21');


-------------- Question ---------------
/* 
For each department, find the employee who has the most consistent performance (i.e., lowest standard deviation of review scores).

If more than one employee has the same consistency score, pick the one with the highest average score.

Only include employees who have at least 3 reviews.

Return:

DeptID		DeptName	EmpID		EmpName		StdDevScore		AvgScore	TotalReviews
*/


--with cte_StdScore
--as
--(
--	select p.EmpID,DeptID,STDEV(ReviewScore) as StdDevScore from AnotherEmployees e
--	join PerformanceReviews p on e.EmpID=p.EmpID
--	group by p.EmpID,DeptID
--),
--cte_MinStdDevScore
--as
--(
--	select DeptID,min(StdDevScore) as minstdscore from cte_StdScore
--	group by DeptID
--)


--select d.DeptID,DeptName,e.EmpID,EmpName,
--cm.minstdscore,
--avg(ReviewScore) as AvgScore,
--count(ReviewScore) as TotalReviews 
--from AnotherEmployees e 
--join cte_StdScore css on css.EmpID=e.EmpID
--join AnotherDepartments d on d.DeptID = e.DeptID
--join PerformanceReviews p on p.EmpID = e.EmpID
--join cte_MinStdDevScore cm on cm.DeptID=d.DeptID
--group by d.DeptID,DeptName,e.EmpID,EmpName,cm.minstdscore


WITH ReviewStats AS (
    SELECT 
        e.EmpID,
        e.EmpName,
        e.DeptID,
        d.DeptName,
        COUNT(p.ReviewID) AS TotalReviews,
        AVG(CAST(p.ReviewScore AS FLOAT)) AS AvgScore,
        STDEV(CAST(p.ReviewScore AS FLOAT)) AS StdDevScore
    FROM AnotherEmployees e
    JOIN PerformanceReviews p ON e.EmpID = p.EmpID
    JOIN AnotherDepartments d ON e.DeptID = d.DeptID
    GROUP BY e.EmpID, e.EmpName, e.DeptID, d.DeptName
    HAVING COUNT(p.ReviewID) >= 3
),
RankedEmployees AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY DeptID
               ORDER BY StdDevScore ASC, AvgScore DESC
           ) AS rn
    FROM ReviewStats
)
SELECT 
    DeptID,
    DeptName,
    EmpID,
    EmpName,
    ROUND(StdDevScore, 2) AS StdDevScore,
    ROUND(AvgScore, 2) AS AvgScore,
    TotalReviews
FROM RankedEmployees
WHERE rn = 1
ORDER BY DeptID;
