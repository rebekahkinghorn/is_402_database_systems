set search_path to entertainmentagencyexample;

select * from entertainers;

-- select *
-- from engagements eng
-- 	left join entertainers ent on eng.entertainerid = ent.entertainerid
-- where eng.engagementnumber is not null;

select *
from entertainers et
	left join engagements eg on eg.entertainerid = et.entertainerid;




-- PRACTICE on salesorders
-- salesorderexample
-- which products have never been ordered
set search_path to salesordersexample;

-- select everything
select * 
-- from the products table alias P
from products p 
	-- left join bc I want to return all products, even the ones that don't show up in the od table
	left join ORDER_DETAILS od on p.productnumber = od.productnumber
-- find the products that exist but don't have an associated ordernumber
where ordernumber is null;





-- PRACTICE on recipes
-- list all of the recipes and the associated class descriptions
set search_path to recipesexample;

-- select what I want from either table I'm joining
select r.recipetitle, rc.recipeclassdescription
-- left table is recipes
from recipes r
	-- use left join bc we want ALL recipes, regardless of if it has a class descriptions
	left join recipe_classes rc on rc.RecipeClassID = r.RecipeClassID



