system(command = "/home/osboxes/anaconda3/bin/jupyter nbconvert --to script ~/proj/bikesharing/p01_import/import_and_cleaning.ipynb")
fun_modify_script_py(filename)
system(command = "/home/osboxes/anaconda3/envs/data/bin/python ~/proj/bikesharing/p01_import/import_and_cleaning.py")
df = read.csv(file = "df.csv",header = T,sep ="," ,stringsAsFactors = F)



# S'il s'agit de test alors on doit créer de fake variable pour pas que le code casse
if (filename=="test.csv"){
  df$casual = runif(n = nrow(df),min = 0,max=1)
  df$registered =runif(n = nrow(df),min = 0,max=1)
  df$count = runif(n = nrow(df),min = 0,max=1)
}



df$season_recoded <- NA
df$season_recoded[df$season == 1] <- "Printemps"
df$season_recoded[df$season == 2] <- "Été"
df$season_recoded[df$season == 3] <- "Automne"
df$season_recoded[df$season == 4] <- "Hiver" 
df$season <- NULL
names(df)[names(df) == "season_recoded"] <- "season"





df$weather_recoded <- NA
df$weather_recoded[df$weather == 1] <- "Beau temps"
df$weather_recoded[df$weather == 2] <- "Nuageux"
df$weather_recoded[df$weather == 3] <- "Pluvieux (-)"
df$weather_recoded[df$weather == 4] <- "Pluvieux (+)"                
df$weather <- NULL
names(df)[names(df) == "weather_recoded"] <- "weather"




df$datetime= strptime(df$datetime, "%Y-%m-%d %H:%M:%S",tz = "GMT")
df$season = as.factor(df$season)
df$holiday = as.factor(df$holiday)
df$workingday = as.factor(df$workingday)
df$weather = as.factor(df$weather)
df$month = factor(df$month,levels = c("January","February","March","April","May","June","July","August","September","October","November","December"))
df$hour = as.factor(df$hour)
df$day = factor(df$day,levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
df$year = as.factor(df$year)

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






