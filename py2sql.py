#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 26 14:50:25 2019

@author: czx
"""

import pymysql
import numpy as np
import pandas as pd
from sqlalchemy import create_engine

# In[]
def connect_mysql():
    print('[Connect Mysql]...')
    USER = input('  User: ')
    PASSWORD = input('  Password: ')
    config = {
        'host': 'localhost',
        'port': 3306,
        'user': USER,
        'passwd': PASSWORD,
        'charset':'utf8mb4',
        'cursorclass':pymysql.cursors.DictCursor
        }
    conn = pymysql.connect(**config)
    conn.autocommit(1)
    cursor = conn.cursor()
    engine = create_engine('mysql+pymysql://%s:%s@localhost/db_dac' % (USER, PASSWORD))
    return cursor, engine

# In[]
cursor, engine = connect_mysql()


# In[]
import datetime
x = datetime.datetime.now()
df = pd.read_csv('/Users/erincao/Downloads/dataComp/calendar.csv')
print(datetime.datetime.now()-x)

x = datetime.datetime.now()
df.to_sql('calendar', engine, index=False, if_exists='replace')
print(datetime.datetime.now()-x)