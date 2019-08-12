#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
from pysolar.solar import *
import datetime
import pickle


# # Import du dataframe

# In[2]:


df = pickle.load(open('df.pkl', 'rb'))


# In[3]:


df.head()


# # Elevation du soleil

# In[4]:


df["soleil"] = df.datetime.map(lambda a : get_altitude(38.89511, -77.03637,a.replace(tzinfo=datetime.timezone.utc) + datetime.timedelta(hours=4)))


# In[5]:


df[["index","soleil"]].to_csv("soleil.csv",index = False)


# In[ ]:





# In[ ]:




