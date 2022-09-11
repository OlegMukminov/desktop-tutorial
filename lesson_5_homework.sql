--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

select *, 
case when rn % 2 = 0 then rn / 2 else rn / 2 + 1 end  as page_num, 
case when rn % 2 = 0 then 2 else 1 end as position
from (
  select *, row_number(*) over (order by price desc) as rn
  from laptop 
) a


sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное 
--соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
create view distribution_by_type as 
with tab2 as(
select maker, tab1.model, type from (
select model from PC
union
select model from printer
union
select model from laptop
) tab1
join product p 
on p.model = tab1.model
)
select maker, type, kol*1.0/kol_1 * 100 kol_2 from(
select distinct maker, type, count(*) over (partition by type) kol,(select count(*) from tab2) kol_1 from tab2 order by type
) tab3;;


select * from distribution_by_type;;
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

request = """
select * from distribution_by_type;
"""

v = list(array(df.groupby('type').mean().values.tolist()).flat)
labels = df.groupby('type').mean().index.to_list()
plt.pie(v, labels=labels)
plt.show()

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as
select * from ships where name like '% %' and name not like '% % %';

select * from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
with tab2 as (
select * from(
select ship, class from outcomes o
left join classes c 
on ship = class
union all 
select ship, class from outcomes o1
left join ships s1 
on ship = name) as tab1
where class is not null
)
select distinct ship from(
select ship, class from outcomes o
left join classes c 
on ship = class
union all 
select ship, class from outcomes o1
left join ships s1 
on ship = name) as tab1
where class is null and ship not in (select ship from tab2) and ship like 'S%'
--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

with tab1 as
(select p.model, price, maker from printer p 
join product p2 
on p.model = p2.model) 
select model, price, maker from (
select model, price, maker, row_number() over(order by price desc) rn from tab1
) tab2 where rn<=3
union 
select model, price, maker from tab1 where price > (select COALESCE(avg(price),0) from tab1 where maker ='C') and maker = 'A'
