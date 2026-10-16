set search_path to entertainmentagencymodify;

--practice concatenation 
select (custfirstname || ' ' || custlastname), 'lives at' as lives_at, custzipcode
from customers;





set search_path to entertainmentagencymodify;

--searching for an intersection of customers and those who have engagements
select customerid
from customers
intersect
select customerid
from engagements;

--searching for a difference of customers and those who do NOT have engagements
select customerid
from customers
except 
select customerid
from engagements;

