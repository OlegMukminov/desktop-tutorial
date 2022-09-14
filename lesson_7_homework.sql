--+task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
import sqlite3
import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
conn = sqlite3.connect('task1_7.db')  
c = conn.cursor()

df = pd.DataFrame()
df['A'] = np.random.choice(range(0,1000),1000)
df['B'] = np.random.choice(range(0,1000),1000)
df['C'] = np.random.choice(range(0,1000),1000)


df.to_sql('table1', conn)

df1_query = 'select * from table1'
df1 = pd.read_sql(sql=df1_query, con=conn)

# Рисуем гистограмму
hist_info = plt.hist(df1['A'], bins = 50)
hist_info = plt.hist(df1['B'], bins = 50)
hist_info = plt.hist(df1['C'], bins = 50)
# print(hist_info)
plt.show()

--+task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email from person group by email having count(*)>1

--+task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select name employee from (
select id, name, salary, managerid m1 from employee) 
where salary > (select salary from employee where id = m1) 

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select score, dense_rank() over(order by score desc) rank from scores

--+task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstname, lastname, city, state from person p
left join address a
on p.personid = a.personid