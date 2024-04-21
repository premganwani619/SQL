
--Assessment Questions
--Total Time: 5.5 Hrs
--Date: 11 Aug 2023--Name: Prem Ganwani

CREATE DATABASE assesment;
USE assesment;

--Que 1. 

create table Worker (
Worker_id int primary key,
First_name  varchar(10),
Last_name varchar(10),
Salary  int,
Joining_date datetime,
Department   varchar(10)
);

insert into Worker(Worker_id, First_name, Last_name , Salary, Joining_date, Department)
values
(001,'Monika', 'Arora',100000, '2014-02-20 09:00:00', 'HR'),
 (002, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(003, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(004,'Amitabh', 'Singh',500000,    '2014-02-20 09:00:00', 'Admin'),
(005,'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(006, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(007, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(008, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

create table Bonus (
Worker_ref_id int,
Bonus_date datetime,
Bonus_amount int
);

INSERT INTO Bonus (Worker_ref_id, Bonus_date, Bonus_amount)
VALUES
(1,'2016-02-20 00:00:00',5000),
(2, '2016-06-11 00:00:00', 3000),
(3, '2016-02-20 00:00:00',4000),
(1,'2016-02-20 00:00:00', 4500),
(2, '2016-06-11 00:00:00', 3500);

create table Title (
Worker_ref_id int,
Worker_title varchar(15),
Affected_from datetime
);

insert into Title (Worker_ref_id, Worker_title, Affected_from)
values
(1, 'Manager', '2016-02-20 00:00:00'),
(2, 'Executive', '2016-06-11 00:00:00'),
(8, 'Executive', '2016-06-11 00:00:00'),
(5, 'Manager', '2016-06-11 00:00:00'),
(4, 'Asst. Manager', '2016-06-11 00:00:00'),
(7, 'Executive', '2016-06-11 00:00:00'),
(6, 'Lead', '2016-06-11 00:00:00'),
(3, 'Lead', '2016-06-11 00:00:00');

--1. Write an SQL query to print details of the Workers who are also Managers.

select w.*
from worker as w
inner join
title as t
on w.worker_id = t.worker_ref_id
where t.worker_title='Manager';

--2. Write an SQL query to show only odd rows from Worker table.

select * from Worker
where worker_id %2 =1;

--3. Write an SQL query to print the name of employees having the highest salary in each
--department.

select t.Worker_title,
w.First_name,
max(w.Salary) over(partition by t.Worker_title) as Salary from Worker as w
inner join Title as t
on w.worker_id = t.worker_ref_id

--4. Write an SQL query to fetch three max salaries from a table.

select top 3 First_name, Salary from worker order by
salary desc;

/*
Que 2.
Write a query identifying the type of each record in the TRIANGLES table using its three side
lengths. Output one of the following statements for each record in the table:
• Equilateral: It's a triangle with sides of equal length.
• Isosceles: It's a triangle with sides of equal length.
• Scalene: It's a triangle with sides of differing lengths.
• Not A Triangle: The given values of A, B, and C don't form a triangle.
*/
create table triangles (
    A int,
    B int,
    C int
);

insert into triangles (A, B, C)
values 
(20, 20, 23),
(20, 20, 20),
(20, 21, 22),
(13, 14, 30);

create function GetTriangleType(@a int, @b int, @c int)
returns int
as
begin
declare @result nvarchar(25)
if @a=@b AND @b=@c
set @result = 1
else if (@a=@b AND @b!=@c) OR (@b =@c AND @c!=@a) OR (@a =@c AND @c!= @b)
set @result = 2
else if @a!= @b AND @a!= @c AND @b!= @c
set @result = 3
else
set @result = 0
return @result
end

select
case
when dbo.GetTriangleType(A, B, C) = 1 then 'Equilateral'
when dbo.GetTriangleType(A, B, C) = 2 then 'Isosceles'
when dbo.GetTriangleType(A, B, C) = 3 then 'Scalene'
else 'Not A Triangle'
end as Triangle_Type
from triangles;

/*
QUE 3. 
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and
displayed underneath its corresponding Occupation. The output column headers should be
Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation.
*/

create table Workers (
    name varchar(50),
    Occupation varchar(50)
);


insert into Workers (name, Occupation)
values
    ('Samantha', 'Doctor'),
    ('Julia', 'Actor'),
    ('Maria', 'Actor'),
    ('Meera', 'Singer'),
    ('Ashley', 'Professor'),
    ('Ketty', 'Professor'),
    ('Christeen', 'Professor'),
    ('Jane', 'Actor'),
    ('Jenny', 'Doctor'),
    ('Priya', 'Singer');

SELECT doctor, singer,professor, actor
FROM(
SELECT name,occupation ,row_number() over (partition by occupation order by name) as row_
FROM Workers
)AS SourceData
PIVOT(
max(name)
 FOR occupation IN ([doctor], [singer],[professor], [actor])    
)AS PivotTable;

/*
Que 4.
The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a
query to print the hacker_id, name, and total score of the hackers ordered by the descending
score. If more than one hacker achieved the same total score, then sort the result by ascending
hacker_id. Exclude all hackers with a total score of from your result.
*/

create table Hackers (
    Hacker_id int,
    Name varchar(50)
);

insert into Hackers (Hacker_id, Name)
values
(4071, 'Rose'),
(4806, 'Angela'),
(26071, 'Frank'),
(49438, 'Patrick'),
(74842, 'Lisa'),
(80305, 'Kimberly'),
(84072, 'Bonnie'),
(87868, 'Michael'),
(92118, 'Todd'),
(95895, 'Joe');

CREATE TABLE Submissions (
Submission_id int,
Hacker_id int,
Challenge_id int,
Score int
);

insert into Submissions (Submission_id, Hacker_id, Challenge_id, Score)
values
(67194, 74842, 63132, 76),
(64479, 74842, 19797, 98),
(40742, 26071, 49593, 20),
(17513, 4806, 49593, 32),
(69846, 80305, 19797, 19),
(41002, 26071, 89343, 36),
(52826, 49438, 49593, 9),
(31093, 26071, 19797, 2),
(81614, 84072, 49593, 100),
(44829, 26071, 89343, 17),
(75147, 80305, 49593, 48),
(14115, 4806, 48593, 76),
(6943, 4071, 19797, 95),
(12855, 4806, 25917, 13),
(73343, 80305, 49593 ,48),
(14115, 4806, 49593, 76),
(6943, 4071, 19797, 95),
(12855,4806, 25917, 13),
(73343, 80305, 49593, 42),
(84264,84072, 63132, 0),
(9951, 4071, 49593, 43 ),
(45104, 49438, 25917, 34),
(53795, 74842, 19797, 5),
(26363, 26071, 19797 ,29),
(10063,4071,49593, 96);

select h.Hacker_id,h.Name,sum(sscore) as Total_score
from Hackers h inner join 
(select s.hacker_id,s.challenge_id,max(score) as sscore from Submissions s group by s.hacker_id,s.challenge_id) as st
on h.hacker_id=st.hacker_id
group by h.hacker_id,h.name
having sum(sscore)>0
order by total_score desc,h.hacker_id asc;

/*
Que 5.
Write a query to print all prime numbers less than or equal to 1000. Print your result on a single
line and use the ampersand (&) character as your separator (instead of a space).
*/

declare @i int = 2;
declare @prime int = 0;
declare @prime_numbers nvarchar(max) = '';

while @i <= 1000
begin
declare @j int = @i - 1;
set @prime = 1;
while @j > 1
begin
if @i % @j = 0
begin
set @prime = 0;
end
set @j = @j - 1;
end
if @prime = 1
begin
if @prime_numbers= ''
set @prime_numbers =cast(@i as varchar(3));
else
set @prime_numbers= @prime_numbers+' & '+cast(@I as varchar(3));
end
set @i= @i+1;
end
select @prime_numbers as PrimeNumbers;
