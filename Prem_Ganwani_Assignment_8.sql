--Q1) Pivot the Occupation column in OCCUPATIONS so that each Name is sorted 
--alphabetically and  displayed underneath its corresponding Occupation. The output 
--column headers should be  Doctor, Professor, Singer, and Actor, respectively. 
--Note: Print NULL when there are no more  names corresponding to an occupation.
SELECT [doctor], [singer],[professor], [actor]
FROM
(
    SELECT name,occupation ,row_number() over (partition by occupation order by name) as row_
    FROM input
) AS SourceData
PIVOT
(
max(name)
 FOR occupation IN ([doctor], [singer],[professor], [actor])
    
) AS PivotTable;
​
--Q2) We want to pivot the data to display total sales amounts for each product by region.
create table sales(salesid int,product varchar(15),region varchar(10),amount  int);
insert into sales(salesid,product,region,amount)values(1,'apple','east',100),
(2,'banana','west',150),(3,'orange','east',200),(4,'apple','west',120);
​
​
select region,[apple],[banana],[orange]
from
(
select product,region,amount from sales
)as sourcetable
pivot
(
  sum(amount)
  for product in ([apple],[banana],[orange])
  )as pivottable
​
  --Q3) We want to unpivot the data to display sales data in a normalized format
  create table qtrsales(product varchar(15),q1 int,q2 int,q3 int,q4 int)
  insert into qtrsales(product,q1,q2,q3,q4)values
  ('apple',100,120,90,110),('banana',150,140,130,160),
  ('orange',200,180,220,210);
​
  select product,qtr,amount
  from
  ( 
    select product,q1,q2,q3,q4 from qtrsales
	)as sourcetable
	unpivot
	(
	amount for qtr in ( q1,q2,q3,q4)
	) as pivottable
​
/*Q4)-Suppose we have two tables: Products and ProductUpdates. We want to 
update the Products  table based on the information in the ProductUpdates 
table. If a product exists in both tables,  update its price; if it only exists in 
ProductUpdates, insert it into the Products table.*/


create table products(id int,name varchar(15),price decimal(5,2))
insert into products(id,name,price)
values(101,'apple',1.00),(102,'banana',0.75),(103,'orange',0.50);

create table productupdate(id int,name varchar(15),price decimal(5,2))
insert into products(id,name,price)
values(104,'grape',1.20),
(102,'banana',0.80),(104,'pieapple',2.50);
​
WITH updatetable AS
(
   select  p.id,p.name,p.price,pd.price as new_price from products p inner join productupdate pd on p.name=pd.name
)
SELECT id,name,price
FROM updatetable;
​
/*Q5)Write SQL Query for data with product names on the left and store locations 
across the  top, with the number of sales at each intersectio*/

create table sample(name varchar(10),location varchar(10),sales int)
insert into sample(name,location,sales)
values('chair','north',30),
('desk','central',120),
('couch','central',40),
('chair','central',90),
('chair','south',56),
('chair','north',98),
('desk','west',78),
('couch','north',12),
('chair','south',14),
('desk','north',57);
​
select name,[north],[south],[west],[central]
from
(
  select name ,[location],sales from sample
  )as sourcetable
  pivot
  (
  sum(sales)
  for location in ([north],[south],[west],[central])
  )as pivottable
​
​
 -- Q6)We want to unpivot the data to display result in normalized form.
  create table input2(name varchar(10),north int,central int,south int,west int)
  insert into input2(name,north,central,south,west)values
  ('chair',436,231,345,129),('couch',123,567,null,678),
  ('desk',432,120,130,124)
​
  select name,store_location,num_sales
  from
  ( 
    select name,north,central,south,west from input2
	)as sourcetable
	unpivot
	(
	num_sales for store_location in (north,central,south,west)
	)as pivottable
​
--Q7)
​
	create table student(id int not null primary key,name varchar(30),dep_name varchar(40),
	score int )
	insert into student(id,name,dep_name,score)values
	(2,'yusuf','bio',70),(5,'mahi','bio',86),(9,'neha','bio',80),
	(12,'tolu','cs',67),(8,'joel','cs',90),(4,'raj','cs',80),(11,'janvi','cs',80),
	(10,'raj','chem',78),(3,'ram','maths',80),(1,'riya','maths',30)
​
--A)	Find the minimum and maximum score of each department.
	select dep_name,max(score) as max_score,min(score) as min_score  from student
	group by dep_name
​
--B) Write a query to find the rank of student department wise.
	select id,name,dep_name, score,rank() over (partition by dep_name order by score,name ) as [rank]
	from student
​
--C) Write a query to find the rank of student department and if tie occurs then 
	select id,name,dep_name, score,dense_rank() over (partition by dep_name order by score ) as [rank]
	from student