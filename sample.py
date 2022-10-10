import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

if st.button ('Нажми меня'):
    df = pd.read_excel('eur_rub.xlsx')
    df = df.sort_values(by='Date').reset_index(drop=True)
    chart_data = df[df.Date > '2022-01-04']
    st.line_chart(chart_data, x = 'Date', height=500)
    #chart_data = pd.DataFrame(
    #    np.random.randn(20, 3),
    #    columns=['a', 'b', 'c'])

    #st.line_chart(chart_data)