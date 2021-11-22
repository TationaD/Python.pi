--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select class,
sum(case when result = 'sunk' then 1
else 0
end)
from (
select classes.class, name
from classes
join ships
on classes.class = ships.class
union
select class, ship
from classes
join outcomes
on class = ship
) as a
left join outcomes
on a.name = outcomes.ship 
group by class


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select classes.class, min(launched)
from classes
join ships
on classes.class = ships.class
group by classes.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
select class,
sum(case when result = 'sunk' then 1
else 0
end)
from (
select classes.class, name
from classes
join ships
on classes.class = ships.class
union
select class, ship
from classes
join outcomes
on classes.class = outcomes.ship
) as a
left join outcomes
on a.name = outcomes.ship 
group by class
having 
sum(case when result = 'sunk' then 1
else 0
end) > 0
and (select count(b.name)
     from (select ships.name, ships.class from ships
     union
     select outcomes.ship, outcomes.ship from outcomes 
     ) b
where b.class = a.class
group by b.class
     ) >= 3

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with a as (
select name, class 
from ships 
union
select ship, ship
from outcomes 
)
select a.name
from a, classes c
where a.class = c.class and
c.numguns >= all(
select c1.numguns   
from  classes c1
where c1."class" in (select a.class from a) and
c.displacement = c1.displacement 
)
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with A as (
select maker
from product
where model  in (select model                      
                 from pc
                 where ram = (select min(ram)
                 from pc)
                 and speed = (select max(speed)
                 from pc
                 where ram = (select min(ram) from pc)             
                 )
)
)
select distinct maker 
from product 
where type = 'Printer' and maker in (select maker from A)
