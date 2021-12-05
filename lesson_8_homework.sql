--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, sum(amount*unit_price) as costs 
from FamilyMembers 
join Payments 
on FamilyMembers.member_id = Payments.family_member
where Payments.date between '2005-01-01' and '2006-01-01'
GROUP BY member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

SELECT name
from Passenger
GROUP BY name
HAVING COUNT(name) > 1 

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

SELECT COUNT(first_name) as count
from Student
where first_name = 'Anna'
GROUP BY first_name
HAVING COUNT(first_name)  

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

SELECT COUNT(date) as COUNT 
from Schedule
where date = '2019-09-02'
group by date  

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
# повторяется task 4

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select FLOOR( 
avg(
(YEAR(CURRENT_DATE) - YEAR(birthday)) - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) 
)
) as age
FROM FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

SELECT good_type_name, SUM(amount*unit_price) as costs 
from Goods
JOIN Payments
on Goods.good_id = Payments.good
join GoodTypes
on GoodTypes.good_type_id = Goods.type
where Payments.date BETWEEN '2005-01-01' and '2006-01-01'   
GROUP BY good_type_name 

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

SELECT MIN(  
(YEAR(CURRENT_DATE) - YEAR(birthday)) - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) 
)as year 
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT MAX(TIMESTAMPDIFF(YEAR,birthday,CURRENT_DATE)) as max_year
FROM Student 
JOIN Student_in_class
    ON Student.id=Student_in_class.student
JOIN Class
    ON Student_in_class.class=Class.id
WHERE Class.name LIKE '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

SELECT status, member_name, SUM(amount*unit_price) as costs
from FamilyMembers
JOIN Payments
on FamilyMembers.member_id=Payments.family_member
JOIN Goods
on Goods.good_id=Payments.good
join GoodTypes
on GoodTypes.good_type_id=Goods.type
where good_type_name = 'entertainment'
GROUP BY status, member_name 

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

DELETE FROM Company
WHERE Company.id IN (
SELECT company 
FROM Trip
GROUP BY company
HAVING COUNT(id) = (SELECT MIN(count) 
                    FROM (SELECT COUNT(id) AS count FROM Trip GROUP BY company) AS min_count)
)

--task13  (lesson8)
--https://sql-academy.org/ru/trainer/tasks/45
 
select classroom 
from Schedule
GROUP BY classroom
HAVING COUNT(classroom) = (SELECT COUNT(classroom) from Schedule
                           GROUP BY classroom
                           ORDER BY COUNT(classroom) DESC LIMIT 1)  
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT last_name
from Teacher
join Schedule
on Teacher.id=Schedule.teacher
JOIN Subject
on Subject.id = Schedule.subject
where Subject.name = 'Physical Culture'
ORDER BY Teacher.last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.') AS name
FROM Student
ORDER BY last_name, first_name