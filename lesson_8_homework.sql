--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select Department, Employee, Salary from (
select d.name Department, e.name Employee, Salary, dense_rank() over(partition by d.name order by salary desc) rn
from Employee e
join
Department d
on departmentid = d.id) tab1 where rn<=3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

SELECT fm.member_name, fm.status, 
sum(p.amount*p.unit_price) as costs 
FROM Payments p
left join FamilyMembers fm 
on fm.member_id = p.family_member
WHERE year(p.date) = '2005'
GROUP BY p.family_member

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name from passenger p1 GROUP by name HAVING count(*)>1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count from Student 
where first_name Like 'Anna';

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select DISTINCT count(subject) as count from Schedule 
where date = "2019-09-02"

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(year(CURRENT_DATE()) - year(birthday))) as age from FamilyMembers 

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(unit_price * amount) as costs 
from Payments p1
left join Goods g1
on p1.good = g1.good_id
left join GoodTypes g2
on g2.good_type_id = g1.type
where year(date) = '2005'
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(TIMESTAMPDIFF(Year, birthday, CURDATE() )) as year from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select max(TIMESTAMPDIFF(Year, birthday, CURDATE() )) as max_year from Student s1
left JOIN Student_in_class s2
on s1.id = s2.student 
left join class c
on c.id = s2.class
where name like '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, amount * unit_price as costs from Payments p
left join Goods g
on p.good = g.good_id
left join GoodTypes g2
on g2.good_type_id = g.type
left join FamilyMembers fm 
on p.family_member = fm.member_id 
where good_type_name = 'entertainment'

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55


delete from Company where id in (

select company 
from trip group by company  HAVING count(*) = (
select min(count) from (
select count(*) as count 
from trip group by company ) tab1))

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom  from Schedule group by classroom 
HAVING count(*) = (
select max(count) from(
select count(*) count 
from Schedule group by classroom ) tab1)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name from Schedule s1
left join Teacher t1
on t1.id = s1.teacher 
left join Subject s2
on s2.id = s1.subject 
where s2.name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select name from(
select concat(last_name, '.',left(first_name,1), '.',left(middle_name,1), '.') name 
from Student) tab1 order by name