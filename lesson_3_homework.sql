--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--+task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
with ships_of_battle as (
select ship, result, class,
case when result = 'sunk'
then 1
else 0
end flag
from outcomes o
left join ships s
on name = ship
union 
select ship, result, class,
case when result = 'sunk'
then 1
else 0
end flag
from outcomes o1
left join classes
on class = ship
)
select class, sum(flag) sunk from
ships_of_battle where class is not null
group by class


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select cl.class, min(launched) 
from classes cl  
left join ships sh 
on cl.class = sh.class group by cl.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with ships_outcomes as(
select class, name from ships
union
select ship as class, ship as name
from outcomes
where ship in (select class from classes))
select class, count(*)
from ships_outcomes as a
join outcomes b on name=ship
where result='sunk' and class in
(select class from
ships_outcomes  c
group by class
having count(*)>=3)
group by class


--+task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
 
with ships_GD as
(select name,numGuns,displacement
                        from ships join classes
                             on classes.class=ships.class
                        union
                        select ship,numGuns,displacement
                        from Outcomes join Classes
                                      on ship=class)                  
                                      
select name
from(select name,numGuns,displacement
     from ships_GD) as x
     where numGuns=(select max(numGuns)
                   from ships_GD as y
                        where
                        x.displacement=y.displacement)                       
                        
--+task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with maker_Pr as (
select * from printer pr
left join
product p 
on pr.model = p.model 
),
RAM_Speed as 
(select RAM, speed from PC)
select maker from product p1 
left join pc p2 
on p1.model = p2.model
where maker in (select maker from maker_Pr) 
and type = 'PC' 
and ram = (select min(ram) from RAM_Speed)
and speed = (select max(speed) from RAM_Speed where ram = (select min(ram) from RAM_Speed)) 

