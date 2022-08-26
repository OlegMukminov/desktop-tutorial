-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class from ships s where launched > 1920; 

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select name, class from ships s where launched > 1920 and launched <= 1942;

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select class, count(*) from ships s group by class;

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select class, country  from classes c where bore >= 16;

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship from Outcomes where battle = 'North Atlantic' and result = 'sunk';

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select ship 
from outcomes o 
left join battles b 
on battle = name 
where date = (select max(date) from outcomes o left join battles b on battle = name)
and result = 'sunk'
limit 1;

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select o.ship, class 
	from outcomes o 
left join battles b 
	on battle = name
left join ships s 
	on s.name = o.ship 
	where date = (select max(date) from outcomes o left join battles b on battle = name)
	and result = 'sunk'
limit 1;

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select ship, c.class from ships s2 
left join classes c 
on s2.class = c.class  
left join outcomes o 
on o.ship = s2.name
where bore >= 16 and result = 'sunk';


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select class from classes c where country ='USA';

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select name, c.class from 
classes c 
full join
ships s 
on s.class = c.class 
where country = 'USA'; 