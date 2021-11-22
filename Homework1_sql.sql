--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
select classes.class, ships.name 
from classes
join ships
on classes.class = ships.class
where launched >= 1920


-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
select classes.class, ships.name, ships.launched 
from classes
join ships
on classes.class = ships.class
where launched >= 1920
and launched <= 1942

или

select classes.class, ships.name, ships.launched 
from classes
join ships
on classes.class = ships.class
where launched between 1920 and 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
select count(name), class 
from ships
group by class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select class, country
from classes
where bore >= 16


-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select ship
from outcomes
where battle = 'North Atlantic'
and result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
select ship
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk'
and battles.date = (select max(date)
                    from battles
                    join outcomes
                    on battles.name = outcomes.battle
                    where outcomes.result = 'sunk')


-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
select name, class 
from ships 
where name in (
select ship
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk'
and battles.date = (select max(date)
                    from battles
                    join outcomes
                    on battles.name = outcomes.battle
                    where outcomes.result = 'sunk')

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
 select name, s.class 
 from ships s 
 join classes c 
 on s.class = c.class
 where bore >= 16
 and name = (select ship
             from outcomes
             join ships
             on outcomes.ship = ships.name
             where result = 'sunk'
             )

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select class
from classes
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select name, ships.class
from classes
join ships
on classes.class = ships.class
where country = 'USA'
