declare @variable int =1;
while (@variable<=100)
begin
print @variable;
set @variable = @variable + 1;
end;

with cte as (
select 1 as n
union all
select n+1 from cte 
where n<100)

select * from cte