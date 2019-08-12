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

# Recodage de "season" et "weather"
# table(df$season)
# lapply(df,class)
df$season_recoded <- NA
df$season_recoded[df$season == 1] <- "Printemps"
df$season_recoded[df$season == 2] <- "Été"
df$season_recoded[df$season == 3] <- "Automne"
df$season_recoded[df$season == 4] <- "Hiver" 
df$season <- NULL
names(df)[names(df) == "season_recoded"] <- "season"

df$weather_recoded <- NA
df$weather_recoded[df$weather == 1] <- "Temps clair, peu nuageux"
df$weather_recoded[df$weather == 2] <- "Brouilard et nuageux"
df$weather_recoded[df$weather == 3] <- "Légèrement neigeux, pluie fine avec orage et quelques nuages, pluie fine avec quelques nuages"
df$weather_recoded[df$weather == 4] <- "Beaucoup de pluie avec grêle, orage et brouillad, neige avec nuages"                
df$weather <- NULL
names(df)[names(df) == "weather_recoded"] <- "weather"

# table(df$weather)

# Sauvegarde du dataframe nettoyé
saveRDS(object = df,file = "df.rds")


#  LES FONCTIONS * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

# Fonction qui dit si une variable est factorielle ou non
fun_is_factor = function(name_var){
  return(is.factor(df[[name_var]]))
}

# Fonction qui prend une variable 'text' et qui créer un graphique croisé avec la target
fun_build_2d_plot =function(df,name_var){
  # Quel est le format de la variable a plotter
  decision = fun_is_factor(name_var)
  
  # le cas ou la variable est catégorielle
  if (decision){
    
    mystats = df %>%
      group_by_(name_var) %>%
      summarise(count = mean(count))
    p<-ggplot(data=mystats, aes_string(x=name_var, y="count")) +
      geom_bar(stat="identity")
  } else { # le cas ou elle est continue
    p <- ggplot(df, aes_string(name_var, "count")) +
      geom_point() +
      stat_summary(fun.data=mean_cl_normal) +
      geom_smooth(method='lm') + ylim(c(0,max(df$count)))
  }
  
  return(p)
}
# test de la fonction
fun_build_2d_plot(df,"hour")

# names(df)

# Fonction qui filtre le dataframe en fonction d'une date de début et une date de fin
fun_filter_df = function(df,date_debut,date_fin){
  filter = df$datetime<=date_fin & df$datetime>=date_debut
  resultat = df[filter,]
  return (resultat)
}
# date_debut = as.Date("2011-06-22")
# date_fin = as.Date("2011-11-13")
# resultat = fun_filter_df(df,date_debut,date_fin)

# THE MEGA TIME SERIES
build_the_time_series = function(){
  mydf = df[,c("datetime","
               count")]
  mydf = mydf[order(mydf$datetime,decreasing = FALSE),]
  mydf$datetime = mydf$datetime + hours(5)
  mydata = xts(x = mydf$count, order.by = mydf$datetime)
  g = dygraph(mydata) %>% dyRangeSelector()
  return(g)
}

# date_debut = as.Date("2011-06-22")
# date_fin = as.Date("2011-11-13")
# date_debut = as.Date("2012-06-22")
# date_fin = as.Date("2012-11-13")
# df_filter = fun_filter_df(df,date_debut, date_fin)
# fun_build_2d_plot(df_filter,"hour")
# fun_build_2d_plot(df_filter,"month")


fun_build_3dplot = function(df,varX,varY){

  g = ggplot(df, aes_string(varX, varY)) +
    geom_raster(aes_string(fill = "count")) + 
    scale_fill_gradientn(colours=c("yellow","red"))
  return(g)
  
}

varX = "humidityQ"
varY = "day"
fun_build_3dplot (df,varX,varY)

