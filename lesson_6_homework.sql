--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

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

--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 
pscp C:\product_202209171417.csv student20@178.170.196.15:/home/students/student20


 create table pc1
( code int,
model varchar(50),
speed int,
ram int,
hd float,
cd varchar(10),
price numeric(12,2));


\COPY pc1 FROM '/home/students/student19/pc_2.csv' DELIMITER ',' CSV HEADER;
