--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
case when Grade < 8 then 'NULL'
else Students.Name
end, grades.Grade, Marks
from Students
join grades
on Students.Marks between grades.min_mark and grades.max_mark
order by grades.grade desc, Students.Name ASC, Students.Marks ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

SELECT Doctor, Professor, Singer, Actor 
FROM (SELECT NAME,OCCUPATION, 
(ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME))rn 
from OCCUPATIONS 
ORDER BY NAME ) 
PIVOT ( MAX(name) FOR OCCUPATION IN ('Doctor' As Doctor,'Professor' as Professor,'Singer' as Singer,'Actor' as Actor) )
ORDER BY rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city
from station
where not (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%');

или

select distinct city 
from station 
WHERE not REGEXP_LIKE ( CITY, '^[AEIOU]');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where not (city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'); 

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct City
from Station
where REGEXP_LIKE(City, '^[^AEIOU]|*[^aeiou]$');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct City
from Station
where REGEXP_LIKE(City, '^[^AEIOU].*[^aeiou]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from Employee
where months < 10 and salary > 2000
order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
case when Grade < 8 then 'NULL'
else Students.Name
end, grades.Grade, Marks
from Students
join grades
on Students.Marks between grades.min_mark and grades.max_mark
order by grades.grade desc, Students.Name ASC, Students.Marks ASC;