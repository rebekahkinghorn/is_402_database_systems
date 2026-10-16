set search_path to bowlingleagueexample;

select *
from bowlers;

-- select *
-- from bowler_scores;


--practice inner joins - specify column and table names 
select bowlers.bowlerfirstname, bowlers.bowlerlastname, bowler_scores.wongame, bowlers.bowlerid
from bowlers
	inner join bowler_scores
		on bowlers.bowlerid = bowler_scores.bowlerid;


-- practice joining multiple tables
select bowlers.bowlerfirstname, bowlers.bowlerlastname, 
	bowler_scores.gamenumber, teams.teamname
from (bowlers
	inner join bowler_scores
	on bowlers.bowlerid =
		bowler_scores.bowlerid
	inner join teams
	on bowlers.teamid =
		teams.teamid
);


--more simple practice
-- note: if I tried to as DISTINCT, it would filter only the replicate combinations
-- eg: Barabara | 146 as a set wouldn't be listed more than once
-- to get each game, you should include the PK from the bowler scores table (bs.matchid)
select b.bowlerid, b.bowlerfirstname, max(bs.rawscore) as highestscore 
from bowlers as b
inner join bowler_scores as bs
   on b.bowlerid = bs.bowlerid
group by b.bowlerid, b.bowlerfirstname
order by b.bowlerid;