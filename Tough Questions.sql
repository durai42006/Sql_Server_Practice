--create Database ToughQuestions;


--use ToughQuestions;


-- Departments
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);

-- Employees
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(101,1),
    EmpName VARCHAR(100),
    DeptID INT REFERENCES Departments(DeptID),
    ManagerID INT NULL REFERENCES Employees(EmpID),
    Salary DECIMAL(10,2),
    JoinedDate DATE
);

-- Projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100)
);

-- EmployeeProjects (Many-to-Many: Employee ↔ Project)
CREATE TABLE EmployeeProjects (
    EmpID INT REFERENCES Employees(EmpID),
    ProjectID INT REFERENCES Projects(ProjectID),
    PRIMARY KEY (EmpID, ProjectID)
);




INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');


INSERT INTO Employees (EmpName, DeptID, ManagerID, Salary, JoinedDate)
VALUES
-- Top-level Managers (No ManagerID)
('John Mathew', 1, NULL, 80000, '2018-04-10'),  -- EmpID = 101
('Priya Sharma', 2, NULL, 85000, '2017-05-20'), -- EmpID = 102

-- Subordinates under 101 (John)
('Ayesha Khan', 1, 101, 60000, '2019-03-15'),   -- 103
('Meera Iyer', 1, 101, 62000, '2020-06-12'),    -- 104

-- Subordinates under 102 (Priya)
('Sunil Raj', 2, 102, 75000, '2021-01-25'),     -- 105
('Sneha Verma', 2, 102, 50000, '2022-04-01'),   -- 106

-- Sunil as manager for others
('Vikram Singh', 2, 105, 78000, '2022-07-20'),  -- 107
('Neha Reddy', 2, 105, 72000, '2023-01-10'),    -- 108

-- Employees in Finance
('David Wong', 3, 101, 56000, '2021-10-10'),    -- 109
('Ravi Kumar', 3, 102, 54000, '2020-08-05');    -- 110


INSERT INTO Projects VALUES
(1, 'Recruitment System'),
(2, 'Payroll System'),
(3, 'E-Commerce Platform'),
(4, 'Mobile App Development');


-- John (101) - Manager on multiple projects
INSERT INTO EmployeeProjects VALUES (101, 1), (101, 2);

-- Priya (102)
INSERT INTO EmployeeProjects VALUES (102, 2), (102, 3);

-- Subordinates with projects
INSERT INTO EmployeeProjects VALUES
(103, 1),
(104, 1), (104, 2),
(105, 2), (105, 3),
(106, 3),
(107, 2), (107, 4),
(108, 2),
(109, 4),
(110, 3);
