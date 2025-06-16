create database UniversityManagement;
use UniversityManagement;

create table Students
(
	StudentID int primary key,
	Name varchar(30), 
	Email varchar(30) unique, 
	DOB date
)
create table Courses
(
	CourseID int primary key, 
	CourseName varchar(30), 
	Credits int
)
create table Departments
(
	DeptID int primary key,
	DeptName varchar(30)
)
create table instructors
(
	InstructorID int primary key, 
	InstructorName varchar(30), 
	DepartmentID int foreign key references Departments(DeptID)
)
create table Entrollments
(
	EnrollmentID int primary key, 
	StudentID int foreign key references Students(StudentID), 
	CourseID int foreign key references Courses(CourseID), 
	Semester int check(Semester>0 and Semester <9), 
	Grade Varchar(10) check (Grade in ('O','A+','A','B+','B','C+','C','F'))
)
create table CourseAssignments
(
	AssignmentID int primary key, 
	InstructorID int foreign key references Instructors(InstructorID), 
	CourseID int foreign key references Courses(CourseID), 
	Semester int check(Semester>0 and Semester <9) 
)

insert into Students values(101,'Alice','alice@gmail.com','2003-12-07');
insert into Students values(102,'Bob','bob@gmail.com','2004-02-10');
insert into Students values(103,'Charlie','charlie@gmail.com','2004-08-01');
insert into Students values(104,'David','david@gmail.com','2003-10-26');
insert into Students values(105,'Ebe','ebe@gmail.com','2003-09-21');

insert into Courses values(11,'DBMS',4);
insert into Courses values(12,'C',2);
insert into Courses values(13,'PYTHON',3);

insert into Departments values(1,'CSE');
insert into Departments values(2,'IT');
insert into Departments values(3,'AIDS');
insert into Departments values(4,'ECE');
insert into Departments values(5,'EEE');

insert into instructors values(901,'Abdul',1);
insert into instructors values(902,'Arthi',2);
insert into instructors values(903,'Eby',1);
insert into instructors values(904,'Subin',3);

insert into Entrollments values(1101,101,11,2,'A');
insert into Entrollments values(1102,101,13,4,'A+');
insert into Entrollments values(1103,102,12,6,'O');
insert into Entrollments values(1104,104,11,1,'F');
insert into Entrollments values(1105,104,12,2,'C');
insert into Entrollments values(1106,104,13,4,'C+');

insert into CourseAssignments values(501,901,11,2);
insert into CourseAssignments values(502,902,11,1);
insert into CourseAssignments values(503,901,12,2);
insert into CourseAssignments values(504,903,12,6);

select * from CourseAssignments;


-- Display all students who have enrolled in more than one course in the same semester.
select s.Name,count(e.StudentID) as CourseEntrolled from Students s
join Entrollments e 
on e.StudentID=s.StudentID
group by s.Name having count(e.StudentID)>1

-- List all instructors who did not teach any course in the current semester.
select InstructorName from instructors where InstructorID not in (select Distinct InstructorID from CourseAssignments);

--  Get the course name(s) that have the highest number of students enrolled.
select max(Courses.CourseID) as Course,count(Courses.CourseID) as CourseCount from Entrollments join Courses on Courses.CourseID=Entrollments.CourseID group by Entrollments.CourseID

-- Create a view that shows a summary report of student name, course name, instructor name, and grade — for all enrollments.
create view vw_SummaryReport 
as select s.Name,c.CourseName,i.InstructorName,Grade from Students s 
join Entrollments e on e.StudentID=s.StudentID
join CourseAssignments ca on ca.CourseID=e.CourseID
join Courses c on ca.CourseID=c.CourseID
join instructors i on i.InstructorID = ca.InstructorID
where ca.Semester=e.Semester;

select * from vw_SummaryReport;


-- Write a stored procedure that takes a student ID and returns all the courses enrolled by the student, with instructor names and grades.
create procedure StudentCourseDetails
 (
 @StudentID int
 )
 as
 begin
	select 
        s.name as studentname,
        c.coursename,
        i.instructorname,
        e.Semester
    from Entrollments e
    join Courses c on e.courseid = c.courseid
    left join CourseAssignments ca 
        on ca.courseid = c.courseid and ca.semester = e.Semester
    left join instructors i on ca.instructorid = i.instructorid
    join Students s on s.studentid = e.StudentID
    where e.studentid = @studentid;
 end

 StudentCourseDetails 101


