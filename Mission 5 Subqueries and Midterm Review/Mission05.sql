/*
    IS 402 - Mission #5 Assignment

    Topics: Scalar subqueries, correlated subqueries, and common table expressions (CTEs)

    Write one SQL query for each problem below. Include the requested columns and
    ordering. Do not change the wording of the problems in this file.

    The expected row count is provided for each problem so you can verify your
    results.

    For this assignment, do not use GROUP BY or HAVING.

    Use the database/schema named in each question before running that query.
*/








/*
1. (Sales Orders) We need to know which product or products have the highest
   retail price.
   Show the product name and retail price. If more than one product ties for
   the highest price, include them all. Sort alphabetically by product name.
   Database: SalesOrdersExample
   Expected row count: 1
*/
set search_path to salesordersexample;

select productname, retailprice
from products
where retailprice = 
(
select max(p.retailprice) 
from products p
)
order by productname;









/*
2. (Sales Orders) We need a list of every customer and the date of that
   customer's most recent order. Include customers who have never placed an
   order; display NULL for their last order date. Show the customer's first
   name, last name, and most recent order date. Sort alphabetically by last
   name and then first name.
   Database: SalesOrdersExample
   Expected row count: 28
*/


-- NOT ALLOWED BUT GOOD PRACTICE
-- GROUP BY - finds the max and sorts every row by customer name! 

-- select c.CustFirstName, c.CustLastName, max(o.OrderDate)
-- from customers c
-- left join orders o
-- 	on c.CustomerID = o.CustomerID
-- group by c.CustFirstName, c.CustLastName
-- order by c.CustLastName, c.CustFirstName



-- TRY 2
-- select c.CustFirstName, c.CustLastName, o.OrderDate
-- from customers c
-- left join orders o
-- 	on o.CustomerID = c.CustomerID
-- 	and o.orderdate =
-- (
-- select max(o2.orderdate)
-- from orders o2
-- where o2.customerid = c.customerid
-- ) 
-- order by c.CustLastName, c.CustFirstName;




-- MUCH BETTER
set search_path to salesordersexample;


select c.CustFirstName, c.CustLastName,
(
select max(o.OrderDate)
from orders o
where c.CustomerID = o.CustomerID
) as last_order_date
from customers c
order by c.CustLastName, c.CustFirstName;










/*
3. (School Scheduling) List the first and last names of students who are not
   enrolled in any class scheduled on Saturday. Sort alphabetically by last
   name and then first name.

   Use a subquery with NOT IN.
   Database: SchoolSchedulingExample
   Expected row count: 4
*/


-- TRY 1... DOESN'T WORK
-- set search_path to SchoolSchedulingExample;

-- select s.StudFirstName, s.StudLastName,
-- (
-- select c.SaturdaySchedule
-- from classes c
-- where c.SaturdaySchedule <> 1
-- 	and c.ClassID = ss.classid
-- ) as sat_yes_no
-- from students s
-- inner join STUDENT_SCHEDULES ss
-- 	on ss.StudentID = s.StudentID;




-- TRY 2 - ALSO DOESN'T WORK
-- set search_path to SchoolSchedulingExample;

-- select s.StudFirstName, s.StudLastName
-- from students s
-- inner join STUDENT_SCHEDULES ss
-- 	on ss.StudentID = s.StudentID
-- inner join classes c 
-- 	on ss.ClassID = c.ClassID
-- where c.SaturdaySchedule not in
-- (
-- select c.SaturdaySchedule
-- from classes c
-- where c.ClassID = ss.classid
-- 	and c.SaturdaySchedule = 1
-- );



-- TRY 3 - THIS TIME
set search_path to SchoolSchedulingExample;

select s.StudFirstName, s.StudLastName
from students s
where s.studentid not in
(
select ss.studentid
from classes c
inner join STUDENT_SCHEDULES ss
	on ss.StudentID = s.StudentID
where c.SaturdaySchedule <> 0
	and c.ClassID = ss.classid
)
order by s.studlastname, s.studfirstname;








/*
4. (Recipes) List each recipe and all of its recipe-ingredient entries for
   recipes that include at least one seafood ingredient. Show the recipe title
   and ingredient name for each entry.
   Sort by recipe title and then ingredient name.

   Use a CTE to identify the recipes that contain a seafood ingredient before
   retrieving all ingredients for those recipes.
   Database: RecipesExample
   Expected row count: 22
*/

set search_path to recipesexample;


-- checking tables
-- select R.RecipeTitle, I.IngredientName, ic.IngredientClassDescription
-- from RECIPES r
-- inner join RECIPE_INGREDIENTS ri
-- 	on ri.RecipeID = r.RecipeID
-- inner join INGREDIENTS i
-- 	on i.IngredientID = ri.IngredientID
-- inner join INGREDIENT_CLASSES ic
-- 	on ic.IngredientClassID = i.IngredientClassID
-- where ic.IngredientClassDescription = 'Seafood'


-- NOTE THAT it still shows ingredients that aren't seafood;
-- it just filters by recipes that have seafood SOMEWHERE in their ingredients

with seafoods as (
	select distinct ri.RecipeID
	from RECIPE_INGREDIENTS ri
	inner join INGREDIENTS i 
		on ri.IngredientID = i.IngredientID
	inner join INGREDIENT_CLASSES ic
		on ic.IngredientClassID = i.IngredientClassID
	where ic.IngredientClassdescription = 'Seafood'
)

select R.RecipeTitle, i.IngredientName
from recipes r
inner join RECIPE_INGREDIENTS ri
	on ri.RecipeID = r.RecipeID
inner join INGREDIENTS i 
	on ri.IngredientID = i.IngredientID
inner join seafoods
	on r.recipeid = seafoods.recipeid
order by r.recipetitle, i.ingredientname;



/*
5. (Entertainment Agency) We want to identify customers whose most expensive
   engagement had a contract price greater than the average contract price for
   all engagements. List the customer's first name, last name, and most
   expensive contract price. Include only customers who have booked at least
   one engagement. Sort by contract price, highest first, and then by last
   name.
   Database: EntertainmentAgencyExample
   Expected row count: 13
*/

set search_path to entertainmentagencyexample;

select c.CustFirstName, c.CustLastName,
	(
	select max(e.ContractPrice)
	from ENGAGEMENTS e
	where c.CustomerID = e.CustomerID
	) as highest_contract
from CUSTOMERS c
where 
	(
	select max(e.ContractPrice)
	from ENGAGEMENTS e
	where c.CustomerID = e.CustomerID
	)
>
	(
	select avg(e.ContractPrice)
	from ENGAGEMENTS e
	)
order by highest_contract desc, c.custlastname;



-- get a visual
-- select c.CustFirstName, c.CustLastName, e.ContractPrice
-- from customers c
-- left join ENGAGEMENTS e
-- 	on e.CustomerID = c.CustomerID
-- order by c.custfirstname, e.contractprice




