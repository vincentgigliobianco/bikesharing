#!/usr/bin/env python
# coding: utf-8

# # Objectif
# L'objectif de ce notebook est l'importation et le cleaning des données
# L'output du notebook est le dataframe au format pickle prêt à être avalée par l'application Shiny (phase exploratoire)

# In[1]:


import pandas as pd


# In[2]:


df = pd.read_csv("../data/test.csv")
df.shape
df.head()


# In[3]:


df.reset_index(inplace = True)


# # Ajout des variables temporelles

# On veut le mois, l'heure, le jour de la semaine

# In[4]:


df.datetime = pd.to_datetime(df.datetime)


# In[5]:


df["month"] = df.datetime.map(lambda a : a.month_name())
df["hour"] = df.datetime.map(lambda a : a.hour)
df["day"] = df.datetime.map(lambda a : a.day_name())
df["year"] = df.datetime.map(lambda a : a.year)


# In[6]:


df.head()


# In[7]:


df.to_pickle("../p02_features/df.pkl")


# In[8]:


df.to_csv("../p02_features/df.csv",index=False)


# Transformer ce notebook en .py

# In[ ]:





# In[ ]:




