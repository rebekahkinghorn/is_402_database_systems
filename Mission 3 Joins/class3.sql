select 'Spencer''s Sweet Shop' as hello;

select 13e4;



set search_path to bowlingleagueexample;

-- select concat(bowlerfirstname, ' ', bowlerlastname) as name
select (bowlerfirstname || ' ' || bowlerlastname) as name
from bowlers;




select *
from bowlers
where bowleraddress ilike '%drive%';




set search_path to schoolschedulingexample;

select *
from staff
where stfstreetaddress ilike '%po box%';


-- don't do this:
select * 
from majors, students
where studmajor = majorid
order by studentid;




set search_path to salesordersexample;

select * 
from products, order_details
where products.productnumber = order_details.productnumber and ordernumber is not null;



-- now we're talking!
select distinct * -- p.productnumber, p.productname

from products p 
	inner join order_details od on od.productnumber = p.productnumber
	inner join product_vendors pv on p.productnumber = pv.productnumber;
	-- inner join order_details od on od.productnumber = p.productnumber;





