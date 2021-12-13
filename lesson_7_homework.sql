--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

df = pd.read_sql('''
with recursive generate_series(r1,r2,r3) as (
    select abs(random() % 1000000) as r1, abs(random() % 1000000) as r2, abs(random() % 1000000) as r3
    union all select abs(random() % 1000000) as r1, abs(random() % 1000000) as r2, abs(random() % 1000000) as r3
    from generate_series
    limit 10000)
select * from generate_series;
''', conn_sqlite)

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from person
group by email
having count(email) > 1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

SELECT a.Name as Employee
FROM Employee AS a, Employee AS b
WHERE a.ManagerId = b.Id
AND a.Salary > b.Salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score,
dense_rank() over(order by score desc) "rank"
from scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstname, lastname, city, state
from person
left join address
on person.personid = address.personid