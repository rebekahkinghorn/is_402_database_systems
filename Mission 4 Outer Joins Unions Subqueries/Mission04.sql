-- IS 402 - Hilton - Mission #4 Assignment

-- Save this file as Mission04.sql.
-- Write exactly ONE SQL query under each question below.
-- Do not modify the "-- Q#:" lines.
-- End each query with a semicolon ;
-- Save the .sql file in Postgres and upload it to Canvas when complete.
-- Each question is worth 1 point.
-- Each question tells you how many rows your result should return.
-- Use the row count to check your work before you submit.







-- Q1:
-- (Sales Orders) We need a single alphabetical list of every state
-- where we have at least one customer or employee. Do not list any
-- state more than once.
-- Expected row count: 4
set search_path to salesordersmodify;

select c.custstate
from customers c
union
select e.EmpState
from employees e
order by 1;








-- Q2:
-- (Entertainment Agency) We need to see every musical style in our
-- system along with the entertainers associated with that style.
-- Make sure musical styles with no entertainers still appear.
-- Show the results alphabetically by style name and then entertainer name.
-- Expected row count: 40
set search_path to entertainmentagencyexample;

select ms.styleid, ms.stylename
from MUSICAL_STYLES ms
left join ENTERTAINER_STYLES es
	on ms.StyleID = es.StyleID
left join ENTERTAINERS ent
	on es.EntertainerID = ent.EntertainerID
order by ms.stylename, ent.EntStageName;









-- Q3:
-- (Entertainment Agency) For every engagement, show the engagement
-- number, start date, and last name of the customer who booked it.
-- Show the engagements in start-date order, using the engagement number
-- to break ties.
-- Expected row count: 111
set search_path to entertainmentagencyexample;

select eng.EngagementNumber, eng.StartDate, cust.CustLastName
from ENGAGEMENTS eng
inner join CUSTOMERS cust
	on eng.CustomerID = cust.CustomerID
order by eng.StartDate, eng.EngagementNumber;
	












-- Q4:
-- (Sales Orders) We need the names and retail prices of all products
-- priced below the average retail price for all products.
-- Show the least expensive products first.
-- Expected row count: 36
set search_path to salesordersexample;

select p.ProductName, p.RetailPrice
-- (select round(avg(p.RetailPrice),2) as retail_average
-- 	from products p)
from products p
where p.RetailPrice <
	(select round(avg(p.RetailPrice),2) as retail_average
	from products p)
order by p.retailprice;











-- Q5:
-- (Bowling League) We need the names and team numbers of bowlers who
-- have posted a handicap score of at least 220 in at least one game.
-- List each bowler once, alphabetically by last name.
-- Expected row count: 10
set search_path to bowlingleaguemodify;

select distinct b.BowlerFirstName, b.BowlerLastName, t.Teamid
from bowlers b
left join teams t
	on t.TeamID = b.TeamID
left join BOWLER_SCORES bs
	on bs.BowlerID = b.BowlerID
where bs.HandiCapScore >= 220
order by b.BowlerLastName;














-- Q6:
-- (Entertainment Agency) We need the first and last names of customers
-- who have never booked an engagement with us. Show them alphabetically
-- by last name.
-- Expected row count: 2
set search_path to entertainmentagencyexample;

select c.CustFirstName, c.CustLastName
from customers c
left join ENGAGEMENTS e
	on c.CustomerID = e.CustomerID
where e.EngagementNumber is null
order by c.CustLastName;













-- Q7:
-- (Recipes) We need a list of ingredients that have never been used
-- in a recipe. Show the ingredient names alphabetically.
-- Expected row count: 20
set search_path to recipesexample;

select i.IngredientName
from INGREDIENTS i
left join RECIPE_INGREDIENTS ri
	on ri.IngredientID = i.IngredientID
where ri.RecipeID is null
order by i.IngredientName;










-- Q8:
-- (Sales Orders) We need to know which vendor offers the lowest
-- wholesale price on any product. Show the vendor name, product name,
-- and wholesale price.
-- Expected row count: 1
set search_path to salesordersexample;

select v.VendName, p.ProductName, 
	(
	select min(pv.WholesalePrice) as minimum
	from product_vendors pv
	)
from PRODUCT_VENDORS pv
left join VENDORS v
	on pv.VendorID =v.VendorID
left join PRODUCTS p
	on p.ProductNumber = pv.ProductNumber
where pv.WholesalePrice = 
	(
	select min(pv.WholesalePrice) as minimum
	from product_vendors pv
	);











-- Q9:
-- (School Scheduling) We need the first and last names, position, and
-- salary of staff members whose salaries are higher than the average
-- salary for their position. Show the highest salaries first within each
-- position.
-- Expected row count: 11
set search_path to schoolschedulingexample;

select s.StfFirstName, s.StfLastName, s.Position, s.Salary
from 
	(select round(avg(new.salary),2) as new_salary, new.position
	from staff new
	group by new.position
	) as inner_table
inner join staff s
	on s.position = inner_table.position
where s.salary >  inner_table.new_salary
order by s.position, s.salary desc;












-- Q10:
-- (School Scheduling) We need the student ID, first name, and last name
-- of every student who has never taken a music course. Show the results
-- alphabetically by last name and then first name.
-- Expected row count: 13
set search_path to schoolschedulingexample;


select s.StudentID, s.StudFirstName, s.StudLastName
from students s
left join 
	(
	select distinct s.studentid, cat.categoryid
	from students s
	left join STUDENT_SCHEDULES ss
		on ss.StudentID = s.StudentID
	left join classes c
		on c.ClassID = ss.ClassID
	left join subjects sub
		on sub.SubjectID = c.SubjectID
	left join CATEGORIES cat
		on cat.CategoryID = sub.CategoryID
	where cat.CategoryID = 'MUS'
	-- order by s.StudLastName, s.StudFirstName
	) as inner_table
on s.studentid = inner_table.studentid
where inner_table.categoryid is null
order by s.studlastname, s.studfirstname;








