
# FEATURE HOLYDAY * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

# Création dataframe liste des jours fériés
vect_holiday = c(
"2011-01-01",
"2011-01-17",
"2011-02-21",
"2011-05-30",
"2011-07-04",
"2011-09-05",
"2011-10-10",
"2011-11-11",
"2011-11-24",
"2011-12-25",
"2011-12-26",
"2012-01-01",
"2012-01-02",
"2012-01-16",
"2012-02-20",
"2012-05-28",
"2012-07-04",
"2012-09-03",
"2012-10-08",
"2012-11-11",
"2012-11-22",
"2012-12-25",
"2012-12-26")

df_holiday = data.frame(vect_holiday)
names(df_holiday) = "only_day"
df_holiday$holiday_feature = 1

df_temp = df
rm(df)
# date(as_datetime("2011-01-01 00:00:00"))

df_temp$only_day = as.character(date(df_temp$datetime))
df_holiday$only_day = as.character(df_holiday$only_day )

df = merge(df_temp,df_holiday,by.x = "only_day", by.y = "only_day",all.x = T)
# names(df)
# verif = df[df$holiday == 1,]
# length(unique(df[df$holiday_feature ==1, ]$only_day))

df$holiday = NULL
df$holiday_new = ifelse(is.na(df$holiday_feature), 0, 1)
df$holiday_feature = NULL
# Renommer holiday_new en holiday
names(df)[names(df) == "holiday_new"] = "holiday"

rm(vect_holiday)
rm(df_holiday)
rm(df_temp)

# SCHOOL VACATION ****************************************************
vect_school_vacation = 
c(ymd(c("2011-01-14",
        "2011-01-17",
        "2011-02-18",
        "2011-02-21",
        "2011-02-28",
        "2011-03-18")),
seq.Date(ymd("2011-04-15"), ymd("2011-04-25"), by = "1 day"),
ymd(c(
    "2011-05-16",
    "2011-05-30")),
seq.Date(ymd("2011-06-17"), ymd("2011-08-20"), by = "1 day"),
ymd(c("2011-09-05", 
      "2011-10-10",
      "2011-10-14",
      "2011-10-17",
      "2011-11-11",
      "2011-11-24",
      "2011-11-25",
      "2011-12-02")),
seq.Date(ymd("2011-12-22"), ymd("2012-01-02"), by = "1 day"),
ymd(c(
    "2012-01-16",
    "2012-02-03",
    "2012-02-06",
    "2012-02-20",
    "2012-03-23")),
seq.Date(ymd("2012-04-02"), ymd("2012-04-09"), by = "1 day"),
ymd(c("2012-04-16",
      "2012-05-21",
      "2012-05-28")),
seq.Date(ymd("2012-06-14"), ymd("2012-08-26"), by = "1 day"),
ymd(c(
    "2012-09-03",
    "2012-10-08",
    "2012-10-19",
    "2012-10-22",
    "2012-11-11")),
seq.Date(ymd("2012-11-22"), ymd("2012-11-23"), by = "1 day"),
ymd("2012-12-14"),
seq.Date(ymd("2012-12-24"), ymd("2013-01-04"), by = "1 day")
)
  
df_school_vacation = data.frame(vect_school_vacation)

names(df_school_vacation) = "only_day"
df_school_vacation$school_vacation_feature = 1

df_temp = df
df_temp$only_day = as.character(date(df_temp$datetime))
df_school_vacation$only_day = as.character(df_school_vacation$only_day)

# class(df_temp$only_day)
# class(df_school_vacation$only_day)

df = merge(df_temp,df_school_vacation,by.x = "only_day", by.y = "only_day",all.x = T)

# length(unique(df[df$school_vacation_feature ==1, ]$only_day))

df$school_vacation_feature_new <- ifelse(is.na(df$school_vacation_feature), 0, 1)
df$school_vacation_feature = NULL

# Renommer school_vacation_feature_new en school_vacation_feature
names(df)[names(df) == "school_vacation_feature_new"] = "school"

rm(vect_school_vacation)
rm(df_school_vacation)
rm(df_temp)

# table(df$holiday)
# table(df$school_vacation_feature)

# test = df[df$holiday == 1,]
# unique(test$only_day)

# test = df[df$school_vacation_feature == 1,]
# length(unique(test$only_day))
# test_2011 = df[df$school_vacation_feature == 1 & df$year == 2011,]
# length(unique(test_2011$only_day))
# 57 jours de vacances scolaires en 2011

# test_2012 = df[df$school_vacation_feature == 1 & df$year == 2012,]
# length(unique(test_2012$only_day))
# 63 jours de vacances scolaires en 2011










# FEATURE SOLEIL ELEVATION * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
system(command = "/home/osboxes/anaconda3/bin/jupyter nbconvert --to script feature_solar_elevation.ipynb")
system(command = "/home/osboxes/anaconda3/envs/data/bin/python feature_solar_elevation.py")
dfsoleil = read.csv("soleil.csv",header = T,stringsAsFactors = F)
df = merge(df,dfsoleil,by="index",all.x = TRUE)

df$soleilQ <- with(df, cut(soleil, 
                           breaks=quantile(soleil, probs=seq(0,1, by=0.25), na.rm=TRUE), 
                           include.lowest=TRUE))





# FEATURE TENDANCE * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
total_locations_by_year_month = df %>%
  group_by(year,month) %>%
  summarise(total_locations = sum(count))

total_locations_by_year_month=dcast(data = total_locations_by_year_month,
                                    formula = month~year ,
                                    value.var = "total_locations")

df = merge(df,total_locations_by_year_month,by = "month", all.x = T)
rm(total_locations_by_year_month)
names(df)[names(df) == "2011"] = "annee_2011"
names(df)[names(df) == "2012"] = "annee_2012"
df$tendance_1 = ifelse(df$year == "2011", df$annee_2011/df$annee_2012,df$annee_2012/df$annee_2011)
df$tendance_2 = as.numeric(date(df$datetime) - ymd("2011-01-01"))

# Buuild deciles variables
df$tendance_1Q <- with(df, cut(tendance_1, 
                               breaks=quantile(tendance_1, probs=seq(0,1, by=0.1), na.rm=TRUE), 
                               include.lowest=TRUE))
df$tendance_2Q <- with(df, cut(tendance_2, 
                               breaks=quantile(tendance_2, probs=seq(0,1, by=0.1), na.rm=TRUE), 
                               include.lowest=TRUE))
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 

# FEATURE rateregistered * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
# représente la proportion de registers dans le nombre de vélos loués
df$rateregis = df$registered / df$count
df$rateregisQ <- with(df, cut(rateregis,
                              breaks=quantile(rateregis, probs=seq(0,1, by=0.1), na.rm=TRUE),
                              include.lowest=TRUE))
# eventuellement FEATURE tendance rate registered













# Mini Cleaning and Naming
df = df[order(df$datetime,decreasing = FALSE),]
df$annee_2011 = NULL
df$annee_2012 = NULL 
df$only_day = NULL
df$index = NULL


# Numeric & New  NN
pref = "NN_"
mycolnames = c("soleil", "tendance_1", "tendance_2")
names(df)[names(df) %in% mycolnames] = paste0(pref,mycolnames)


# Numeric & Origin NO
pref = "NO_"
mycolnames = c("temp", "atemp", "humidity", "windspeed")
names(df)[names(df) %in% mycolnames] = paste0(pref,mycolnames)

# Cat & Origin CO
pref = "CO_"
mycolnames = c("month",
               "workingday",
               "hour",
               "day",
               "year",
               "season",
               "weather",
               "humidityQ",
               "tempQ",
               "atempQ",
               "windspeedQ",
               "holiday")
names(df)[names(df) %in% mycolnames] = paste0(pref,mycolnames)

# Cat & New CN
pref = "CN_"
mycolnames = c("school",
               "soleilQ",
               "tendance_1Q",
               "tendance_2Q")
names(df)[names(df) %in% mycolnames] = paste0(pref,mycolnames)



# Special
pref = "S_"
mycolnames = c("casual",
               "registered",
               "casualQ",
               "registeredQ",
               "rateregis",
               "rateregisQ")
names(df)[names(df) %in% mycolnames] = paste0(pref,mycolnames)