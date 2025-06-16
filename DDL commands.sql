/*DDL COMMANDS */

/*Creating database*/
create database DDL;

/*Use the created database*/
use DDL;

/*Altering name while database is in use*/
Alter database DDL set single_user with rollback immediate;
Alter database DDL modify name = Sample;
Alter database Sample set multi_user;

/*Create table in altered database*/
use Sample;

create table Students(
student_id int primary key,
student_name varchar(20),
student_age int
);

create table Courses(
course_Id int primary key,
course_name varchar(25),
);

/*Insert values into the tables*/
insert into Students(student_id,student_name,student_age) values(1,'Boobathi',21);
insert into Students(student_id,student_name,student_age) values(2,'Durai',21);
insert into Students(student_id,student_name,student_age) values(3,'Guhan',21);
insert into Students(student_id,student_name,student_age) values(4,'Govardan',21);

insert into Courses(course_Id,course_name) values(1,'Java');
insert into Courses(course_Id,course_name) values(2,'C');
insert into Courses(course_Id,course_name) values(3,'Python');


/*Display all values in tables*/
select * from Students;
select * from Courses;

/*Create another one table*/
create table Personal_Info(student_id int primary key ,Address varchar(30));
insert into Personal_Info(student_id,Address)  values(1,'Trichy');
insert into Personal_Info(student_id,Address)  values(2,'Thanjavur');
select * from Personal_Info;

/*Delete all rows in the table*/
truncate table Personal_info;
select * from Personal_Info;

/*Drop table*/
drop table Personal_Info;
exec sp_tables;