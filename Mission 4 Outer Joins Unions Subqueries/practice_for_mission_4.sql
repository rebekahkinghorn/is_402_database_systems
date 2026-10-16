-- Rebekah Kinghorn
-- pre-class practice
--CHAPTERS 9-11
--OUT OF ORDER MY B


-- practice join
-- set search_pa





--CHAPTER 10 UNIONS
 

-- practice union and labeling a new column that indicates which table the row came from
set search_path to entertainmentagencyexample;

select EntertainerID, EntStageName, 'tablea' as source_table from ENTERTAINERS
union
select CustomerID, CustFirstName, 'tableb' as source_table from CUSTOMERS
order by EntertainerID;


-- union kind of acts like idk
set search_path to bowlingleagueexample;

select bowlerfirstname from bowlers
union
select teamname from teams;





--practice unions
--get every class description and all indgredientnames
set search_path to recipesexample;

select ic.IngredientClassDescription as name
from INGREDIENT_CLASSES ic
union
select i.IngredientName
from ingredients i
order by name;






--CHAPTER 9 OUTER JOINS


-- practice outer join
set search_path to entertainmentagencyexample;

select c.custfirstname, c.custlastname, e.engagementnumber--, a.AgentID, ent.EntertainerID
from customers c
left join ENGAGEMENTS e
	on c.CustomerID = e.CustomerID
where e.engagementnumber is null;
-- inner join agents a 
-- 	on e.AgentID = a.AgentID
-- inner join ENTERTAINERS ent
-- 	on ent.EntertainerID = e.EntertainerID




-- the WHERE trap!
set search_path to entertainmentagencyexample;

--filter in ON instead
select c.CustomerID, e.EngagementNumber
from customers c
left join engagements e on c.CustomerID = e.CustomerID and e.EngagementNumber >= 100
order by e.EngagementNumber desc;



--left join stuff - textbook
-- “I need all the recipe types, and then all the recipe names and preparation instructions, 
-- and then any matching ingredient step numbers, ingredient quantities, 
-- and ingredient measurements, and finally all ingredient names from my recipes database, 
-- sorted in recipe title and step number sequence.”
set search_path to recipesexample;

SELECT Recipe_Classes.RecipeClassDescription,
Recipe_Details.RecipeTitle, Recipe_Details.Preparation,
Ingredients.IngredientName,
Recipe_Details.RecipeSeqNo,
Recipe_Details.Amount,
Recipe_Details.MeasurementDescription

FROM (Recipe_Classes
	FULL OUTER JOIN
	(SELECT Recipes.RecipeID, Recipes.RecipeClassID,
	Recipes.RecipeTitle, Recipes.Preparation,
    Recipe_Measures.Amount,
    Recipe_Measures.RecipeSeqNo,
    Recipe_Measures.MeasurementDescription,
    Recipe_Measures.IngredientID
  FROM Recipes
  LEFT OUTER JOIN
    (SELECT Recipe_Ingredients.RecipeID,
       Recipe_Ingredients.IngredientID,
       Recipe_Ingredients.RecipeSeqNo,
       Recipe_Ingredients.Amount,
       Measurements.MeasurementDescription
     FROM Recipe_Ingredients
     INNER JOIN Measurements
     ON Measurements.MeasureAmountID =
         Recipe_Ingredients.MeasureAmountID)
    AS Recipe_Measures
    ON Recipes.RecipeID =
    Recipe_Measures.RecipeID) AS Recipe_Details
	ON Recipe_Classes.RecipeClassID =
    Recipe_Details.RecipeClassID)

	FULL OUTER JOIN Ingredients
	ON Ingredients.IngredientID =
	Recipe_Details.IngredientID
	ORDER BY RecipeTitle, RecipeSeqNo;



--List every recipe class and its recipes. Include recipe classes that have no recipes.
set search_path to recipesexample;

select rc.RecipeClassID, r.RecipeID, r. recipetitle
from RECIPE_CLASSES rc
left join recipes r
	on r.RecipeClassID = rc.RecipeClassID
order by rc.recipeclassid;




--List every recipe, its ingredients, and measurement description. Keep recipes even if they have no ingredient records.
set search_path to recipesexample;

select r.recipetitle, ri.ingredientid, ri.amount, m.MeasurementDescription
from recipes r
left join RECIPE_INGREDIENTS ri
	on r.RecipeID = ri.RecipeID
left join MEASUREMENTS m 
	on ri.MeasureAmountID = m.MeasureAmountID;






--new table practice
--everything from recipe_details is a new table we temporarily made
set search_path to recipesexample;

select rc.RecipeClassDescription,
       Recipe_Details.RecipeTitle,
       Recipe_Details.IngredientID,
       Recipe_Details.Amount,
       Recipe_Details.MeasurementDescription

--select from recipe_classes as the main left table (there is one that has no recipes in it)
from recipe_classes rc
--this next part is a collection of values left joined on recipes 
--includes all recipes that don't even have ingredients (none in this case)
left join(
	select r.recipetitle, r.RecipeClassID, ri.ingredientid, ri.amount, m.MeasurementDescription
	from recipes r
	left join RECIPE_INGREDIENTS ri
		on r.RecipeID = ri.RecipeID
	left join MEASUREMENTS m 
		on ri.MeasureAmountID = m.MeasureAmountID
	) as recipe_details

	on rc.RecipeClassID = recipe_details.RecipeClassID;





--CHAPTER 11 SUBQUERIES


set search_path to salesordersexample;

SELECT Customers.CustFirstName,
Customers.CustLastName,
	(SELECT COUNT(*)
	FROM Orders
	WHERE Orders.CustomerID =
	 Customers.CustomerID)
	AS CountOfOrders
	FROM Customers;






