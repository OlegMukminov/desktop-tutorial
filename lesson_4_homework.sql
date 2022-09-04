--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--+task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
select pc.model model, maker, type  from pc 
left join product pr
on pr.model = pc.model
union all 
select p.model model, maker, pr1.type  from printer p  
left join product pr1
on pr1.model = p.model
union all 
select l.model model, maker, pr2.type  from laptop l  
left join product pr2
on pr2.model = l.model
--+task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case when price > (select avg(price) from PC)
then 1
else 0
end flag
from printer

--+task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

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
select ship from(
select ship, class from outcomes o
left join classes c 
on ship = class
union all 
select ship, class from outcomes o1
left join ships s1 
on ship = name) as tab1
where class is null and ship not in (select ship from tab2)

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
Select name from battles where year(date) not in (select
launched
from ships)

--select *,cast(date as date) from battles b   

--+task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle from outcomes
join
ships s  
on ship = name
where class = 'Kongo'

--+task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as 
with tab1 as (
select model, price from pc
union all 
select model, price from printer p 
union all 
select model, price from laptop l 
)
select *, 
case when price > 300 
then 1 
else 0 
end flag from tab1 
;;

select * from all_products_flag_300

--+task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
with tab1 as (
select model, price from pc
union all 
select model, price from printer p 
union all 
select model, price from laptop l 
)
select *, 
case when price > (select avg(price) from tab1) 
then 1 
else 0 
end flag from tab1 
;;

select * from all_products_flag_avg_price

--+task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with tab1 as (
select p.model, maker, price from printer p
join product p1
on p1.model = p.model
)
select model from tab1
where price >= (select avg(price) from tab1 
where maker = 'C' or maker = 'D')
and maker = 'A'
--+task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with tab1 as (
select p.model, maker, price from printer p
join product p1
on p1.model = p.model
),
tab2 as(
select p_o.model, price, maker from (select p.model, price from printer p
union all
select l.model, price from laptop l
union all
select PC.model, price from PC) p_o
join product p1
on p_o.model = p1.model
)
select model from tab2
where price >= (select avg(price) from tab1 
where maker = 'C' or maker = 'D')
and maker = 'A'

--+task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with tab2 as(
select p_o.model, price, maker from (select p.model, price from printer p
union
select l.model, price from laptop l
union
select PC.model, price from PC) p_o
join product p1
on p_o.model = p1.model
)
select avg(price) from tab2 where maker = 'A'


--+task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
with tab2 as(
select p_o.model, price, maker from (select p.model, price from printer p
union
select l.model, price from laptop l
union
select PC.model, price from PC) p_o
join product p1
on p_o.model = p1.model
)
select maker, count(model) from tab2 group by maker;


--+task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
select * from count_products_by_makers order by maker;
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['maker'].to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'count'})
fig.show()

--+task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as 
select * 
from printer;


delete from printer_updated
where model in (
select p1.model from printer p1
join product p2
on p1.model = p2.model
where maker = 'D'
);

--+task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, p1.model, color, p1.type, price, maker from printer_updated p1
join product p2
on p1.model = p2.model;

--select * from printer_updated_with_makers

--+task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
create view sunk_ships_by_classes as
with tab1 as (
select ship, class from outcomes o
left join ships s 
on name = ship
where result = 'sunk' and class is not null
union
select ship, class from outcomes o
left join classes c  
on class = ship
where result = 'sunk' and class is not null
)
select COALESCE(class, '0') as class, count(*) from (
select ship, class from tab1
union
select ship, class  from (select ship, class from outcomes o
left join ships s 
on name = ship
where result = 'sunk'
union
select ship, class from outcomes o
left join classes c  
on class = ship
where result = 'sunk'
) as tab2
where ship not in (select ship from tab1)
) as tab3 group by class;

--select * from sunk_ships_by_classes;

--+task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

request = """
select * 
from sunk_ships_by_classes;
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['class'].to_list(), y=df['count'].to_list(), labels={'x':'class', 'y':'count'})
fig.show()

--+task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as 
select *,
case when numguns >= 9
then 1
else 0
end flag
from classes;

select * from classes_with_flag

--+task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select country, count(*) 
from classes c 
group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['country'].to_list(), y=df['count'].to_list(), labels={'x':'country', 'y':'count'})
fig.show()  

--+task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*) from
(
select name from ships s
union
select ship as name from outcomes o ) as t 
where name like 'M%' or 
name like 'O%'

--+task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*) from
(
select name from ships s
union
select ship as name from outcomes o ) as t 
where name like '% %' and name not like '% % %'

--+task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select 
launched, count(*) 
from ships 
group by launched 
order by launched 
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['launched'].to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'})
fig.show()
