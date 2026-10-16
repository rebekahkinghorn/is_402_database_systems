-- Rebekah Kinghorn
-- class: simple totals and grouping data



-- CHAPTER 12: SIMPLE TOTALS


-- difference between count and sum (careful!)
set search_path to schoolschedulingexample;

select
avg(capacity),
min(capacity),
max(capacity),
count(capacity),
sum(capacity)
from class_rooms;




-- count(DISTINCT)
set search_path to entertainmentagencyexample;

select 
	count(distinct entertainerid)
from engagements;






-- count() only counts non-null values!
set search_path to schoolschedulingexample;

select count(subjectprereq)
from subjects;





-- 
set search_path to bowlingleagueexample;

select count(rawscore)
from bowler_scores;







-- quick subquery to get each ent's most recent date
set search_path to entertainmentagencyexample;

select e.entertainerid, e.EntStageName,
(
	select 
	max(eng.startdate)
	from engagements eng
	where e.entertainerid = eng.entertainerid
)
from entertainers e;







-- which entertainer booked the most recent engagement?
select entertainerid, startdate
from engagements
where startdate = 
	(select max(startdate) from engagements);




-- correct use of LMIIT
select entertainerid, startdate
from engagements
where startdate = 
	(select startdate from engagements order by startdate desc limit 1);








-- list the first and last name in order by last name
-- of every bowler whose personal average rawscore is >= overall average score
-- DOESN'T WORK
set search_path to bowlingleagueexample;

select distinct b.BowlerFirstName, b.BowlerLastName, 
(
	select avg(bs.RawScore)
	from BOWLER_SCORES bs
	where bs.BowlerID = b.BowlerID
)
from bowlers b
inner join BOWLER_SCORES bs
	on bs.BowlerID = b.BowlerID
where bs.rawscore >=
(
	select avg(bs.RawScore)
	from BOWLER_SCORES bs
)
order by b.bowlerlastname;






-- try 2
-- this is almost like a for loop
-- each time we have a new bowler id, it finds the b1 bowlerid,
-- then it takes the subquery avg we're finding and makes sure that it's the avg for the outer b1 bowler
select b.bowlerid, b.bowlerfirstname, b.bowlerlastname
from bowlers b
where 
	(select avg(rawscore) from bowler_scores where bowlerid = b.bowlerid)
	>= (select avg(rawscore) from bowler_scores)
order by b.bowlerid;








-- sales orders
-- what is the name of the product that has the highest quantity
-- purchased on an individual order?

set search_path to salesordersexample;

select distinct p.ProductName, od.QuantityOrdered
from products p
inner join ORDER_DETAILS od 
	on od.ProductNumber = p.ProductNumber
where od.QuantityOrdered = 
	(
	 select max(od.QuantityOrdered)
	 from order_details od 
	 where od.ProductNumber = p.ProductNumber
	)
order by od.QuantityOrdered desc;








-- CHAPTER 13: GROUPING DAT



-- example: entertainers
set search_path to entertainmentagencyexample;

-- you should group by the PRIMARY KEY, or you'll mess it up
-- you can group by more than the PK, but you have to do at least PK
-- it's easiest to group by everything you select that's not aggregrate
select et.entertainerid, et.entstagename, sum(contractprice)
from engagements eg 
inner join entertainers et 
	on et.entertainerid = eg.entertainerid
group by et.entertainerid, et.entstagename
order by et.entertainerid;









-- bowling league
-- get each bowler's lowest score ordered by (firstname, lastname)

set search_path to bowlingleagueexample;

-- make sure to group by the bowlerid because it's the PK
-- if you don't order by the PK, it will throw an error if you don't order by EVERYTHING non-aggregated thing in the select
select concat(b.BowlerLastName, ' ', b.BowlerMiddleInit, b.BowlerFirstName) as full_name, min(bs.RawScore) as min_score
from bowlers b
inner join BOWLER_SCORES bs
	on bs. BowlerID = b.BowlerID
group by b.bowlerid, b.BowlerLastName, b.BowlerMiddleInit, b.BowlerFirstName
order by b.BowlerLastName, b.BowlerFirstName;


-- same thing but using subquery!!
select b.BowlerLastName, b.BowlerFirstName,
	(
	select min(bs.rawscore)
	from BOWLER_SCORES bs
	where b.BowlerID = bs.BowlerID
	)
from bowlers b
order by b.BowlerLastName, b.BowlerFirstName;





-- ent agency example
set search_path to entertainmentagencyexample;

-- if you count *, it puts one row into numcontracts for Katherine Ehrlich
-- if you count contractprice, it will say 0 bc she's had not contracts
select 
	et.entertainerid, 
	et.entstagename, 
	count(eg.entertainerid) as NumContracts, 
	sum(contractprice) as TotalContracts, 
	min(contractprice) as LowestContracts, 
	max(contractprice) as HighestContracts,
	avg(contractprice) as AverageContracts
from entertainers et
left join engagements eg
	on et.entertainerid = eg.entertainerid
group by et.entertainerid, et.entstagename; 


-- this counts the rows that have a customer id in them (NOT unique customers)
-- use * to know that you are counting ROWS
-- select count(*)
-- from agents inner join engagements on agents.agentid = engagements.agentid


