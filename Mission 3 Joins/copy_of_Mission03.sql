-- IS 402 — Hilton — Mission #3 Assignment


-- Save this file as Mission##.sql (for example Mission01.sql)
-- Write exactly ONE SQL query under each question below.
-- Do not modify the "-- Q#:" lines.
-- End each query with a semicolon ;
-- Save the .sql file in Postgres and upload it to Canvas when complete.
-- Each question tells you how many rows your result should return -- use it to check your work before you submit.




-- Q1:
-- (Sales Orders) List the order number, order date, and first and last
-- name of every customer from Seattle who placed an order.
-- Order by order date and then order number.
-- Expected row count: 62
set search_path to salesordersexample;

select o.ordernumber, o.orderdate, c.CustFirstName, c.CustLastName
from orders o 
inner join customers c 
	on o.customerid = c.customerid
where c.custcity = 'Seattle';


-- Q2:
-- (Entertainment Agency) List every agent's first and last name along
-- with the engagement numbers of engagements they arranged. Make sure that
-- every agent appears, including agents who have not arranged any engagements.
-- Show one row per engagement. Order by the agent's last name.
-- Expected row count: 112
set search_path to entertainmentagencyexample;

select a.AgtFirstName, a.AgtLastName, e.EngagementNumber
from agents as a
left join engagements e 
	on a.agentid = e.agentid
order by a.agtlastname;



-- Q3:
-- (School Scheduling) List the classroom ID and capacity of every
-- classroom, along with the name of the building where it is located.
-- Expected row count: 47
set search_path to schoolschedulingexample;

select cr.classroomid, cr.capacity, b.buildingname
from class_rooms cr 
inner join buildings b 
	on cr.buildingcode = b.buildingcode;



-- Q4:
-- (Bowling League) For every game played by a bowler, list
-- the bowler's first and last name, team name, tournament date,
-- tournament location, match ID, game number, and raw score.
-- Order by tournament date, bowler last name, match ID, and game number.
-- Expected row count: 1344
set search_path to bowlingleagueexample;

select  b.BowlerLastName, 
		b.BowlerfirstName, 
		t.teamname, 
		tourn.tourneydate,
		tourn.tourneylocation, 
		bs.matchid,
		bs.gamenumber,
		bs.rawscore
from bowlers b
inner join teams t
	on b.teamid = t.teamid
inner join bowler_scores bs
	on bs.bowlerid = b.bowlerid
inner join tourney_matches tm
	on bs.matchid = tm.matchid
inner join tournaments tourn
	on tm.tourneyid = tourn.tourneyid
order by tourn.tourneydate, 
		b.BowlerLastName, 
		bs.matchid,
		bs.gamenumber;





-- Q5:
-- (Recipes) List every ingredient class along with the names of the
-- ingredients in that class. Make sure classes with no ingredients
-- still appear.
-- Expected row count: 83
set search_path to recipesexample;

select ic.IngredientClassID,
	i.ingredientname
from INGREDIENT_CLASSES ic
left join INGREDIENTS i
	on ic.IngredientClassID = i.IngredientClassID
order by ic.IngredientClassID;




-- Q6:
-- (School Scheduling) List all buildings along with the room numbers
-- of their classrooms. Order by building name and then classroom ID.
-- Expected row count: 48
set search_path to schoolschedulingexample;

select b.buildingname, c.classroomid
from buildings b
left join class_rooms c
	on b.buildingcode = c.buildingcode
order by b.buildingname, c.classroomid;



-- Q7:
-- (Entertainment Agency) List the first and last names of customers
-- who have booked at least one engagement. Order by customer last name
-- in descending order.
-- Expected row count: 13
set search_path to entertainmentagencyexample;

select distinct c.CustFirstName, c.CustLastName
from customers c 
inner join ENGAGEMENTS e
	on c.CustomerID = e.CustomerID
order by c.CustLastName desc;
	



-- Q8:
-- (School Scheduling) List the subject code and subject name of every
-- subject that has never had a class scheduled. Order by subject code.
-- Expected row count: 10
set search_path to schoolschedulingexample;

-- select * from classes
-- order by subjectid;

select s.subjectid, s.subjectcode, s.subjectname --, c.classid
from subjects s
left join classes c 
	on s.subjectid = c.subjectid
where c.classid is null
order by s.subjectid;




-- Q9:
-- (Recipes) List the title of every main-course recipe, where
-- RecipeClassID = 1, along with the names of the ingredients used in it.
-- Order by recipe title.
-- Expected row count: 53
set search_path to recipesexample;

select r.recipetitle, rc.RecipeClassID, ri.RecipeSeqNo, i.IngredientName
from recipes r
inner join RECIPE_CLASSES rc
	on r.RecipeClassID = rc.RecipeClassID
inner join RECIPE_INGREDIENTS ri 
	on r.RecipeID = ri.RecipeID
inner join ingredients i 
	on ri.IngredientID = i.IngredientID
where r.RecipeClassID = 1
order by r.recipetitle;



-- Q10:
-- (Sales Orders) List every product along with the names of its vendors
-- and the vendors' wholesale prices. Make sure products with no vendor
-- information still appear. Order by product name.
-- Expected row count: 90
set search_path to salesordersexample;

select p.productname, pv.WholesalePrice, v.vendname
from products p
inner join product_vendors pv
	on p.ProductNumber = pv.ProductNumber
inner join vendors v
	on pv.VendorID = v.VendorID
order by p.productname;




