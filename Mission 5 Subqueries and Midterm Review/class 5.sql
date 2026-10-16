-- rebekah kinghorn class notes


--practice count and max
set search_path to bowlingleagueexample;

select count(*), max(rawscore)
from bowler_scores
where rawscore >=150 


-- view practice
set search_path to bowlingleagueexample;

create view bowlerswithteamnameszzz as
select b.BowlerLastName, b.BowlerFirstName, t.teamname
from bowlers b
inner join teams t
	on t.TeamID = b.TeamID;

select * from bowlerswithteamnameszzz;



-- practice ORDERING stuff most efficiently
-- 
set search_path to bowlingleagueexample;

select * 
from bowler_scores bs
inner join bowlers b
	on bs.bowlerid = b.bowlerid
where teamid = 1 
	and wongame = 1
	and rawscore > 150
	and BowlerAddress like '%Willow%';



-- practice case statements
select 
	bowlerid,
	rawscore,
	case
		when rawscore > 150 then 'excellent'
		when rawscore > 100 then 'mid'
		when rawscore > 50 then 'eh'
		else 'skill issue'
	end as rating
from bowler_scores
order by rawscore desc;





-- practice 
-- notice that teamid shows up twice
select *
from bowlers
inner join teams
	on bowlers.teamid = teams.teamid;






-- 3 WAYS TO DO THE BOWLING EXAMPLE


-- list of all bowlers that bowled an above-average



select b. bowlerfirstname, b.bowlerlastname, bs.RawScore,
	(
	select
	round(avg(bs.rawscore),2) as average
	from BOWLER_SCORES bs
	)
from bowlers b
inner join BOWLER_SCORES bs
	on b.BowlerID = bs.BowlerID
where bs.rawscore > (
	select
	round(avg(bs.rawscore),2) as average
	from BOWLER_SCORES bs
	)
order by b.bowlerfirstname;

--- another way to do it 
-- if you take out the bs.rawscore, you go down to 25 rows bc you ONLY return the name of the bowler

select b. bowlerfirstname, b.bowlerlastname, bs.RawScore
from bowlers b
inner join bowler_scores bs
	on b.bowlerid = bs.bowlerid
where b.bowlerid in
	(
	select bs.bowlerid
	from bowler_scores bs
	where rawscore >
		(
		select
		round(avg(bs.rawscore),2) as average
		from BOWLER_SCORES bs
		)
	)
order by b.bowlerfirstname;


-- do it again but with CTE
with averagebowlerscore as 
	(select round(avg(bs.rawscore),2) as averagescore from bowler_scores bs),
bowlersaboveaveragescores as 
(select bs.bowlerid
	from bowler_scores bs, averagebowlerscore
	where rawscore > averagebowlerscore.averagescore
	)


select b. bowlerfirstname, b.bowlerlastname
from bowlers b, bowlersaboveaveragescores
where b.bowlerid in (bowlersaboveaveragescores.bowlerid);









-- last example
-- customers who have never ordered helmets
set search_path to salesordersmodify;

-- inner join method
select distinct c.custfirstname, c.custlastname-- , o.ordernumber, od.productnumber, p.productname
from customers c
left join orders o
	on o.customerid = c.customerid
left join order_details od
	on od.ordernumber = o.ordernumber
left join products p
	on p.productnumber = od.productnumber
where p.productname not like '%Helmet%'
order by c.custfirstname desc;

-- subquery method
-- FINISH
-- select c.customerid, c.custfirstname, c.custlastname
-- from customers c
-- where 
-- 	(
-- 		select 
-- 	)




