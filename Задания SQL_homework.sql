--task1. На все отчетные даты за 2018  г. вывести количество клиентов и средний размер 
--заработной платы по банкам, полу и группе по возрасту (меньше 18 (включительно), 
--от 18 до 35 (включительно), от 35 до 60(включительно), больше 60 лет)


select bank, gender, group_age, count(a.client_id), avg(sallary), over(partition by date) from
(select *, 
case 
	when age<= 18 then 1
	when age>18 and age<=35 then 2
	when age>35 and age<=60 then 3
	when age> 60 then 4
end group_age 
from clnt_aggr a
join clnt_data d
on a.client_id = d.client_id where year(date) = 2018 ) tab1
group by bank, gender, group_age


--task2. На самую актуальную дату вывести банк, возраст и заработную плату клиентов, 
--получающих максимальную заработную плату в своем банке

select bank, age, sallary from(
select bank, age, sallary, max(sallary) over (partition by bank) max_sl from 
(select * 
from clnt_aggr a
join clnt_data d
on a.client_id = d.client_id) tab1
where date = (select max(date) from clnt_aggr)) tab2
where max_sl = sallary


--task3. На самую актуальную дату вывести идентификаторы клиентов, у которых pos-оборот 
--строго больше, чем в среднем по базе

select client_id from clnt_aggr 
where date = (select max(date) from clnt_aggr) and
pos_amt > (select max(pos_amt) from clnt_aggr)