-- IS 402 — Hilton — Project #2

-- Save this file as Project02.sql
-- Write exactly ONE SQL query under each question below.
-- Do not modify the "-- Q#:" lines.
-- End each query with a semicolon ;
-- Save the .sql file in Postgres and upload it to Canvas when complete.

-- will this save??
-- quick check to confirm 
-- select distinct g.GRADE_TYPE_CODE, gt. DESCRIPTION
-- from grade g
-- inner join grade_type gt
-- 	on gt.GRADE_TYPE_CODE = g.GRADE_TYPE_CODE;



-- Q1:
-- We need a list of every instructor's first name and last name. Please show the instructors alphabetically by last name, 
-- using first name to break any ties.
-- Expected rows: 10
-- set search_path to student;

select FIRST_NAME, last_name
from INSTRUCTOR
order by last_name, first_name;






-- Q2:
-- We need a list of the different locations where classes have been taught. Please list each location only once 
-- and show the locations in alphabetical order.
-- Expected rows: 12
select distinct location
from section
order by location;




-- Q3:
-- We need the first and last names of all instructors whose last names begin with S through W. 
-- Show them alphabetically by last name, using first name to break any ties.
-- Expected rows: 4
select first_name, last_name
from instructor
where last_name like 'S%'
	or last_name like 'T%'
	or last_name like 'U%'
	or last_name like 'V%'
	or last_name like 'W%'
order by last_name, first_name;




-- Q4:
-- We need the phone number, full name, and employer for every student whose last name is Miller. 
-- Keep each student's first and last names together as one full name, and list the results in phone-number order.
-- Expected rows: 3

select phone, (first_name || ' ' || last_name) as full_name, employer
from student
where lower(last_name) = lower('Miller')
order by phone;






-- Q5:
-- We need the course number and description for every course that requires course 20 as a prerequisite. 
-- Show the results in course-number order.
-- Expected rows: 5
select COURSE_NO, DESCRIPTION
from course
where PREREQUISITE in (20)
order by course_no;







-- Q6:
-- We need the course number, description, and cost for every 200 level course that costs less than $1,100. 
-- Show the results in course-number order.
-- Expected rows: 2
select COURSE_NO, DESCRIPTION, COST
from course
where COST < 1100
	and course_no >= 200
	and course_no < 300
order by course_no;







-- Q7:
-- We need the course number and section ID for every 100 level course taught in room L211 or L214.
-- Expected rows: 12
select c.course_no, s.SECTION_ID -- , c.description, s.location
from course c
inner join section s
	on c.COURSE_NO = s.COURSE_NO
where (c.course_no >= 100 and c.course_no <200)
	and (s.location = 'L211' or s.location = 'L214');






-- Q8:
-- We need the course number and section ID for every class with a capacity of 10, 12, 15, 20, or 25. 
-- Show the results by course number, and then by section ID.
-- Expected rows: 78
select c.COURSE_NO, s.SECTION_ID
from course c
inner join section s
	on c.COURSE_NO = s.COURSE_NO
where s.CAPACITY in (10,12,15,20,25)
order by c.course_no, s.section_id;





-- Q9:
-- We need the student ID and final exam score recorded for students in section 147. 
-- Show the results by student ID, and then by final exam score.
-- Expected rows: 8
set search_path to student; 

select distinct stud.STUDENT_ID, g.GRADE_TYPE_CODE, max(g.numeric_grade) as high_grade
from student stud
inner join enrollment en
	on stud.STUDENT_ID = en.STUDENT_ID
inner join grade g
	on g.STUDENT_ID = en.STUDENT_ID
where en.SECTION_ID = 147
	and g.GRADE_TYPE_CODE = 'FI'
group by stud.student_id, g.GRADE_TYPE_CODE
order by stud.student_id, high_grade;








-- Q10:
-- We need the course number and description for every 200 level course that has a prerequisite. 
-- Show the results alphabetically by course description.
-- Expected rows: 5
set search_path to student;

select c.course_no, c.DESCRIPTION
from course c
where c.PREREQUISITE is not null
	and c.COURSE_NO >= 200
	and c.COURSE_NO < 300
order by c.description;







-- Q11:
-- We need the full name and phone number for every student who works for Board Utilities. 
-- Keep each student's first and last names together as one full name, and show the students alphabetically by last name, then first name.
-- Expected rows: 3
select (first_name || ' ' || last_name) as full_name, phone
from student
where employer = ('Board Utilities')
order by last_name, first_name;








-- Q12:
-- We need a list of student employers whose company names begin with 'Miller.' 
-- Please list each employer only once, in alphabetical order.
-- Expected rows: 2
select distinct s.employer
from student s
where s.employer like 'Miller%'
order by s.employer;







-- Q13:
-- We need an alphabetical list of students whose phone numbers have area code 212. 
-- Show each student's name as LAST NAME in all capital letters, followed by a comma and the first initial - for example, LOCKE, J. 
-- Include the phone number after the name.
-- Expected rows: 5
select (upper(last_name) || ', ' || left(first_name, 1) || '.') as name, phone
from student
where phone like '212%'
order by last_name;








-- Q14:
-- We need the full name and address of every student whose phone number has not been entered. Include the street address and ZIP code.
-- Expected rows: 1
select first_name, last_name, STREET_ADDRESS, zip, phone
from student
where phone = '';









-- Q15:
-- We need the ZIP codes used for addresses in Jersey City, New Jersey. Show them in ZIP-code order.
-- Expected rows: 4
select z.zip, z.state, z.city
from zipcode z
where z.state = 'NJ'
	and z.city = 'Jersey City'
order by z.zip;








-- Q16:
-- We need the course number and room location for every class taught in building M. Show the results in course-number order.
-- Expected rows: 5
select c.course_no, s.location
from course c
inner join section s
	on c.COURSE_NO = s.COURSE_NO
where location like 'M%'
order by c.course_no;









-- Q17:
-- For the states MA, FL, and GA, we need the full state name, state abbreviation, and city. Show the results alphabetically by city.
-- Expected rows: 7
set search_path to student;
select distinct state, city,
case
	when state = 'MA' then 'Massachusetts'
	when state = 'FL' then 'Florida'
	when state = 'GA' then 'Georgia'
end as full_state
from zipcode
where 
	state = 'MA'
	or state ='FL'
	or state = 'GA'
order by city;







-- Q18:
-- We need one column containing a complete mailing address for every instructor in ZIP code 10025. 
-- Combine the salutation, first name, last name, street address, and ZIP code into that one column. 
-- Show the results alphabetically by last name, then first name.
-- Expected rows: 4
select concat(i.salutation || ' ' || i.FIRST_NAMe || ' ' || i.LAST_NAME
	|| ' lives at ' || i.STREET_ADDRESS || ', ' || z.city || ', ' || z.state || ', ' || z.zip)
from INSTRUCTOR i 
inner join ZIPCODE z
		on z.zip = i.zip                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
where z.zip = '10025';






-- Q19:
-- We need to see how students in section 87 performed on the final exam. 
-- Show each student ID and recorded final exam score, with the highest score first.
-- Expected rows: 7
select distinct stud.STUDENT_ID, g.GRADE_TYPE_CODE, max(g.numeric_grade) as high_grade
from student stud
inner join enrollment en
	on stud.STUDENT_ID = en.STUDENT_ID
inner join grade g
	on g.STUDENT_ID = en.STUDENT_ID
where en.SECTION_ID = 87
	and g.GRADE_TYPE_CODE = 'FI'
group by stud.student_id, g.GRADE_TYPE_CODE
order by high_grade desc;





-- Q20:
-- We need a report of final exam results for students in section 116. 
-- Include each student's ID, final exam score, and a PASS or FAIL result. 
-- Scores of 85 or higher count as passing. Show the report by student ID.
-- Expected rows: 8
select distinct stud.STUDENT_ID, g.GRADE_TYPE_CODE, max(g.numeric_grade) as high_grade,
	case
		when max(g.numeric_grade) >= 85 then 'PASS'
		else  'FAIL'
	end as PASS_FAIL
from student stud
inner join enrollment en
	on stud.STUDENT_ID = en.STUDENT_ID
inner join grade g
	on g.STUDENT_ID = en.STUDENT_ID
where en.SECTION_ID = 116
	and g.GRADE_TYPE_CODE = 'FI'
group by stud.student_id, g.GRADE_TYPE_CODE
order by stud.student_id;








-- Q21:
-- We need the first name, last name, and phone number for every student who registered on February 23, 2007. 
-- Show the results alphabetically by last name, then first name.
-- Expected rows: 18
select s.first_name, s.last_name, s.phone, s.REGISTRATION_DATE
from student s
where s.REGISTRATION_DATE >= '2007-02-23 00:00:00'
	and s.REGISTRATION_DATE < '2007-02-24 00:00:00';







-- Q22:
-- We need the course number, section ID, and start date and time for every class held in room L211. 
-- Show the results in start-date-and-time order.
-- Expected rows: 3
select c.COURSE_NO, sec.SECTION_ID, sec.START_DATE_TIME
from course c
inner join "section" sec
	on c.COURSE_NO = sec.COURSE_NO
where sec.LOCATION = 'L211';
	









-- Q23:
-- We need the course number, section ID, start date and time, instructor ID, and capacity for every class that begins in April 2007. 
-- Show the results by start date and time, then course number.
-- Expected rows: 21
select c.COURSE_NO, sec.SECTION_ID, sec.START_DATE_TIME, sec.INSTRUCTOR_ID, sec.CAPACITY
from course c
inner join "section" sec
	on c.COURSE_NO = sec.COURSE_NO
where sec.START_DATE_TIME >= '2007-04-01 00:00:00'
	and sec.START_DATE_TIME < '2007-05-01 00:00:00';





-- Q24:
-- We need the student ID, section ID, and final grade for every student who received a final grade and enrolled during January 2007.
-- Expected rows: 1
select distinct en.STUDENT_ID, en.section_id, en.FINAL_GRADE, en.ENROLL_DATE
from enrollment en
where en.ENROLL_DATE >= '2007-01-01 00:00:00'
	and en.ENROLL_DATE < '2007-02-01 00:00:00'
	and en.final_grade is not null;







-- Q25:
-- We need the course number, section ID, and the date 90 calendar days after each class begins. 
-- Show the results by course number, then section ID.
-- Expected rows: 78
select COURSE_NO, SECTION_ID, (START_DATE_TIME + interval '90 days' ) as new_date
from section
order by COURSE_NO, section_id;











-- -- Q26:
-- -- We need the course numbers for classes held in odd-numbered rooms in building M. Show the results in course-number order.
-- -- Expected rows: 3
select c.course_no, s.location--, substring(s.location, 2, length(s.location)) as cleaned
from course c
inner join section s
	on s.COURSE_NO = c.COURSE_NO
where s.location like 'M%'
	and 
	(s.location like '%1'
	or s.location like '%3'
	or s.location like '%5'
	or s.location like '%7'
	or s.location like '%9'
	)
order by c.course_no;






-- -- Q27:
-- -- We need the first and last names of students in ZIP code 11214 whose registration occurred more than two days after
-- -- their student record was created. Show the names alphabetically by last name, then first name.
-- -- Expected rows: 2
select s.first_name, s.last_name, s.zip
from student s
where s.zip = '11214'
	and s.REGISTRATION_DATE > (s.CREATED_DATE + interval '2 days')
order by s.last_name, s.first_name;











-- -- Q28:
-- -- We need the first and last names of students whose phone numbers have area code 203, 
-- -- along with the number of years since they registered. 
-- -- Calculate the number of years as of today, rounded to two decimal places, and show the longest-registered students first.
-- -- Expected rows: 22
select FIRST_NAME, LAST_NAME, phone, (extract(year from current_date) - extract(year from REGISTRATION_DATE)) as new_date
from student
where phone like '203%';













-- -- Q29:
-- -- We need a list of the different times at which course sections begin. Show each starting time only once, in chronological order.
-- -- Expected rows: 3
select distinct s.START_DATE_TIME::time
from section s
order by START_DATE_TIME;











-- -- Q30:
-- -- We need the student ID and section ID for every enrollment recorded at 10:20 a.m. Show the results in student-ID order.
-- -- Expected rows: 22
select s.STUDENT_ID, en.SECTION_ID
from student s
inner join enrollment en
	on en.STUDENT_ID = s.STUDENT_ID
where ENROLL_DATE::time = '10:20:00'
order by s.STUDENT_ID;











-- -- Q31:
-- -- We need the course number, description, and cost for every course taught by Charles Lowry. Show the results in course-number order.
-- -- Expected rows: 9
select c.course_no, c.DESCRIPTION, c.cost
from course c
inner join section s
	on s.COURSE_NO = c.COURSE_NO
inner join INSTRUCTOR i
	on i.INSTRUCTOR_ID = s.INSTRUCTOR_ID
where i.FIRST_NAME = 'Charles'
	and i.last_name = 'Lowry'
order by c.course_no;












-- -- Q32:
-- -- We need the highest final-exam grade earned by a student enrolled in course 130.
-- -- Expected rows: 1
select max(g.NUMERIC_GRADE) as max_grade--, g.section_id, s.COURSE_NO
from grade g
inner join section s
	on s.SECTION_ID = g.SECTION_ID
where s.COURSE_NO = 130
	and g.GRADE_TYPE_CODE = 'FI';
-- group by g.section_id, s.COURSE_NO













-- -- Q33:
-- -- We need the full name in one column and phone number for every student who lives in New York, NY. 
-- -- Show the results alphabetically by last name, then first name.
-- -- (Note: For this question, use a WHERE join rather than an INNER JOIN.)
-- -- Expected rows: 4
select concat(s.first_name || ' ' || s.last_name), s.phone, z.city, z.state
from student s
inner join zipcode z
	on s.ZIP = z.ZIP
where z.city = 'New York'
	and z.state = 'NY'
order by s.last_name, s.first_name;











-- -- Q34:
-- -- We need the grade type code, description, and number of grades of each type expected in course 220. 
-- -- Show the results alphabetically by grade description.
-- -- Expected rows: 5
select gt.GRADE_TYPE_CODE, gt.DESCRIPTION, count(gtw.NUMBER_PER_SECTION)
from GRADE_TYPE gt
inner join GRADE_TYPE_WEIGHT gtw
	on gtw.GRADE_TYPE_CODE = gt.GRADE_TYPE_CODE
inner join section s
	on s.SECTION_ID = gtw.SECTION_ID
inner join grade g
	on gtw.GRADE_TYPE_CODE = g.GRADE_TYPE_CODE
where s.COURSE_NO = 220
group by gt.GRADE_TYPE_CODE, gt.DESCRIPTION, s.COURSE_NO;














-- -- Q35:
-- -- We need the student ID and full name of every student who has received at least one score below 60. 
-- -- Put the last name first in the full name, and show the results alphabetically by last name, then first name.
-- -- Expected rows: 0
select new_students.student_id, concat(new_students.last_name || ', ' || new_students.first_name) as full_name--, new_students.numeric_grade
from 
	(select distinct s.student_id, s.last_name, s.first_name
	from student s
	inner join grade g
	on g.student_id = s.student_id
	where g.numeric_grade < 60
	) as new_students
order by new_students.last_name, new_students.first_name;











-- Q36:
-- We need a list of the different course costs currently recorded in the catalog. Show each cost only once, in cost order.
-- Expected rows: 3
select distinct cost
from course
where cost is not null
order by cost;







-- Q37:
-- We need the course numbers for courses that require course 310 or a higher-numbered course as a prerequisite. 
-- Show the results in course-number order.
-- Expected rows: 5
select c.COURSE_NO, c.PREREQUISITE
from course c
where c.PREREQUISITE >=310;







-- Q38:
-- We need the full name and enrollment date and time for each enrollment recorded after February 19, 2007 at 10:20 a.m. 
-- for students who live in Stamford, Connecticut. Show the results alphabetically by last name, then first name.
-- Expected rows: 2
select full_name, my_students.city
from
	(select distinct concat(s.FIRST_NAMe || ' ' || s.LAST_NAME) as full_name, z.city, s.first_name, s.last_name
	from student s
	inner join enrollment e
		on e.student_id = s.student_id
	inner join ZIPCODE z
		on z.zip = s.zip
	where e.ENROLL_DATE > '2007-02-19 10:20:00'
		and z.city = 'Stamford'
		and z.state = 'CT'
	) as my_students
order by my_students.last_name, my_students.first_name;








-- Q39:
-- We need the course number and description for every course that includes a project as part of its grading. 
-- Show the results in course-number order.
-- Expected rows: 9
select c.COURSE_NO, c.DESCRIPTION, gtw.GRADE_TYPE_CODE
from course c
inner join section s
	on s.COURSE_NO = c.COURSE_NO
inner join GRADE_TYPE_WEIGHT gtw
	on gtw.SECTION_ID = s.SECTION_Id
where gtw.GRADE_TYPE_CODE = 'PJ';








-- Q40:
-- We need the course number for every 300-level course with a prerequisite, along with the prerequisite course number and description. 
-- Show the results in course-number order.
-- Expected rows: 2
select c.course_no, c.PREREQUISITE, p.description
from course c
inner join course p
	on c.PREREQUISITE = p.course_no
where c.COURSE_NO >=300
		and c.COURSE_NO <400
		and c.PREREQUISITE is not null;











