--Rebekah Kinghorn
--practice for midterm
--random stuff

set search_path to bowlingleagueexample;
SELECT
    bs.BowlerID,
    COUNT(*) AS game_count,
    MAX(bs.RawScore) AS highest_score,
FROM Bowler_Scores bs
WHERE bs.BowlerID = 7
  AND bs.RawScore >= 150
GROUP BY bs.BowlerID;


-- practice join with COMPOSITE KEY - notice the AND in the join!
set search_path to bowlingleagueexample;

select b.BowlerfirstName,b.teamid, bs.rawscore, mg.winningteamid
from bowlers b
inner join bowler_scores bs
	on bs.bowlerid = b.bowlerid
inner join match_games mg
	on mg.matchid = bs.matchid
	and mg.gamenumber = bs.gamenumber;




-- practice intersection, except, and union... kind of
select bowlerid, bowlerfirstname, 'name'
from bowlers
union
select teamid, teamname, 'TEAM'
from teams
order by bowlerid;


--select bowlerid for bowlers who are team captains
select bowlerid
from bowlers
intersect
select captainid
from teams;



--select bowlerid for bowlers who are NOT team captains
select bowlerid
from bowlers
except
select captainid
from teams;






