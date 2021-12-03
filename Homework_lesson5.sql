--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as
select *,
case when num % 2 = 0 then num/2
else num/2 + 1
end as page_num,
case when total % 2 = 0 then total/2
else total/2 + 1
end as num_of_pages
from (
select *, row_number() over() as num,
count(*) over()  as total
from laptop
) a

select *
from pages_all_products

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
select M, typ,
cast(100.0*sum_/sum_1 as numeric)
from
(select M, typ, sum(c) sum_ from
(SELECT distinct maker M, 'PC' typ, 0 c from product
union all
SELECT distinct maker, 'Laptop', 0 from product
union all
SELECT distinct maker, 'Printer', 0 from product
union all
SELECT Maker, type, count(*) from product
group by maker, type) as a
group by M, typ) a1 
join
(select maker, count(*) sum_1 from product
group by maker) b 
on M = maker


select*
from distribution_by_type


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

df5.plot.pie(y='numeric', figsize=(7,7),legend=False, labels=labels, autopct='%.f')

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select  *
from ships
where name like '% %'

select *
from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select a.name,class 
from (
select name, class
from ships 
union all
select distinct ship, NULL as class
from Outcomes
where ship not in (select name from ships) 
) a
where a.name like 'S%' and class is null

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
# Возможно ошибка в условии: производитель принтера С нет в наличии.

select * from (
select model, row_number(*) over (partition by model order by price desc ) as rn 
from (
select printer.model, price
from product 
join printer 
on product.model = printer.model
where printer.price > (select avg(price)
		       from product 
		       join printer 
		       on product.model = printer.model) and maker = 'A'
) a
) b
where rn < 3