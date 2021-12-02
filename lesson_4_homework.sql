--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select * 
from (
select product.model, maker, product.type
from product 
join pc on product.model = pc.model 
union all
select product.model, maker, product.type
from product 
join printer on product.model = printer.model 
union all 
select product.model, maker, product.type
from product 
join laptop on product.model = laptop.model 
) a 


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case
when price > (select avg(price) from pc) then 1
else 0
end
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name 
from ships
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with q1 as (
select name, extract(year from date) as year 
from battles 
)
select *
from q1 
where year not in (select launched from ships)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select distinct battle 
from outcomes o 
where ship in 
(select name
from ships 
where class = 'Kongo')

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
select model, price,
case when price > 300 then 1
else 0
end flag
from ( 
select product.model, price
from pc 
join product
on pc.model = product.model 
union 
select product.model, price
from printer 
join product
on printer.model = product.model 
union
select product.model, price
from laptop 
join product
on laptop.model = product.model 
) a

select *
from all_products_flag_300


--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
select model, price,
case when price > avg(price) then 1
else 0
end flag
from ( 
select product.model, price
from pc 
join product
on pc.model = product.model 
union 
select product.model, price
from printer 
join product
on printer.model = product.model 
union
select product.model, price
from laptop 
join product
on laptop.model = product.model 
) a
group by a.model, a.price

select *
from all_products_flag_avg_price


--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select product.model 
from product 
join printer 
on product.model = printer.model 
where printer.price > (
  select avg(printer.price) 
  from product 
  join printer 
  on product.model = printer.model 
  where maker = 'D' and maker = 'C'
  )
and maker = 'A'


--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select (
  (select sum(price)
  from product 
  join printer 
  on product.model = printer.model
  where maker = 'A')
+
  (select sum(price)
  from product 
  join laptop 
  on product.model = laptop.model
  where maker = 'A')
+
  (select sum(price)
  from product 
  join pc 
  on product.model = pc.model
  where maker = 'A')
)
/
(
  (select count(price)
  from product 
  join printer 
  on product.model = printer.model
  where maker = 'A')
+
  (select count(price)
  from product 
  join laptop 
  on product.model = laptop.model
  where maker = 'A')
+
  (select count(price)
  from product 
  join pc
  on product.model = pc.model
  where maker = 'A')
)

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(distinct product.model)
from product
join pc
on product.model = pc.model 
group by maker 
union 
select maker, count(distinct product.model)
from product
join printer p 
on product.model = p.model 
group by maker 
union
select maker, count(distinct product.model)
from product
join laptop l 
on product.model = l.model 
group by maker 

select *
from count_products_by_makers

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
select *
from count_products_by_makers
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].values.tolist(), labels={'x':'maker', 'y':'count'})
fig.show()


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
select *
from (
delete from printer 
where model in (select printer.model
               from printer  
               join product
               on printer.model = product.model
               where maker = 'D')
) a               

select *
from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select p.code, p.model, p.color, p.type, p.price, product.maker 
from  printer_updated p
join product
on p.model = product.model 


--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as
select class, count (name)
from (
select name, class 
from ships
union all
select ship, 'is null' as class
from outcomes 
) a 
where name in (
select ship
from outcomes 
where result = 'sunk'
)
group by class


--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

request = """
select *
from sunk_ships_by_classes
"""
df1 = pd.read_sql_query(request, conn)
fig = px.bar(x=df1['class'].to_list(), y=df1['count'].values.tolist(), labels={'x':'class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select *,
case
when numguns >= 9 then 1
else 0
end flag
from classes

select *
from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

df2['country'].value_counts().plot.bar(rot=90, grid=True, figsize=(12, 6))

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(name)
from (
select name 
from ships
where name like 'M%' or name like '%O'
union 
select ship
from outcomes
where ship like 'M%' or ship like '%O'
) a 

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(name)
from (
select name 
from ships
where name like '% %'
union 
select ship
from outcomes
where ship like '% %'
) a 

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched as year, count(name)
from ships
group by year 
