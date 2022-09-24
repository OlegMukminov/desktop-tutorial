--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT CASE 
    WHEN g.grade < 8 THEN 'NULL' 
    ELSE s.name 
    END 
, g.grade, s.marks 
FROM students s, grades g 
WHERE s.marks >= g.min_mark AND s.marks <= g.max_mark 
ORDER BY g.grade desc, s.name;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

SELECT Doctor, Professor, Singer, Actor FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) as rn, name, occupation FROM       occupations) 
PIVOT 
(MAX(name) FOR occupation IN ('Doctor' as Doctor,'Professor' as Professor, 'Singer' as Singer, 'Actor' as Actor)) 
ORDER BY rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city from station 
where REGEXP_LIKE (city, '^[^(a|e|u|i|o)](*)','i') order by city;

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city from station 
where REGEXP_LIKE (city, '(*)[^(a|e|u|i|o)]$','i') order by city;

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from station 
where REGEXP_LIKE (city, '^[^(a|e|u|i|o)](*)','i') or REGEXP_LIKE (city, '(*)[^(a|e|u|i|o)]$','i') order by city;

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city from station 
where REGEXP_LIKE (city, '^[^(a|e|u|i|o)](*)','i') and REGEXP_LIKE (city, '(*)[^(a|e|u|i|o)]$','i') order by city;

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name 
from employee 
where months < 10 and salary > 2000 
order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

Дубль task1