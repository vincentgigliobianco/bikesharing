# On regarde pour si il y a des données manquantes

library(ggplot2)
library(lubridate)
library(dplyr)
library(dygraphs)
library(xts)
rm(list=ls())

# Import du .csv en vue d'explorer les données avec Shiny
df = read.csv(file = "df.csv",header = T,sep ="," ,stringsAsFactors = F)
df$datetime= strptime(df$datetime, "%Y-%m-%d %H:%M:%S",tz = "GMT")
# lapply(df,class)
# Verif : df[,c("datetime","datetime_new")]

# discret : season, holiday, workingday,weather,month,hour,day, year
df$season = as.factor(df$season)
df$holiday = as.factor(df$holiday)
df$workingday = as.factor(df$workingday)
df$weather = as.factor(df$weather)
df$month = factor(df$month,levels = c("January","February","March","April","May","June","July","August","September","October","November","December"))
df$hour = as.factor(df$hour)
df$day = factor(df$day,levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
df$year = as.factor(df$year)
# levels(df$month) = c("January","February","March","April","May","June","July","August","September","October","November","December")
# levels(df$day) = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")


df$humidityQ <- with(df, cut(humidity, 
                             breaks=quantile(humidity, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                             include.lowest=TRUE))


df$tempQ <- with(df, cut(temp, 
                         breaks=quantile(temp, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                         include.lowest=TRUE))

df$atempQ <- with(df, cut(atemp, 
                          breaks=quantile(atemp, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                          include.lowest=TRUE))

df$windspeedQ <- with(df, cut(windspeed, 
                              breaks=quantile(windspeed, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                              include.lowest=TRUE))

df$casualQ <- with(df, cut(casual, 
                           breaks=quantile(casual, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                           include.lowest=TRUE))

df$registeredQ <- with(df, cut(registered, 
                               breaks=quantile(registered, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                               include.lowest=TRUE))


# On regarde pour si il y a des données manquantes

# Si Holiday = 1
# test= df[df$holiday==0,]
holiday_manq = df[df$holiday==1,]
# table(holiday_manq$day)
# GROS PROBLEME : pendant les vacances aucun vélo loué le mardi, jeudi et le samedi!

# lapply(df, class)
holiday_manq$only_date = as.Date(holiday_manq$datetime, format = "%Y/%m/%d")
unique(holiday_manq[, "only_date"])
