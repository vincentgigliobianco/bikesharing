# On utilise les .csv générés grâce à "maestro.R"  dans RStudio 


# rm(df_train)
df_train_kaggle = read.csv(file = "/home/osboxes/proj/bikesharing/p04_model/data/train.csv",header = T,sep ="," ,stringsAsFactors = F)
df_test_kaggle = read.csv(file = "/home/osboxes/proj/bikesharing/p04_model/data/test.csv",header = T,sep ="," ,stringsAsFactors = F)



names(df_train_kaggle)

# Données manquantes
str(df_train_kaggle)
table(is.na(df_train_kaggle))

table(is.na(df_test_kaggle))

# On lance un Decision tree en utilisant la librairie rpart
# avec Y = log(S_registered + 1) et X = CO_hour
library(rpart)
library(rpart.plot)
library(RColorBrewer)

# On met la variable CO_hour en catégorielle
df_train_kaggle$hour=as.factor(df_train_kaggle$CO_hour)
# Non on met en integer
df_train_kaggle$hour=as.integer(df_train_kaggle$hour)
str(df_train_kaggle)

# install.packages("XML")
install.packages("rattle")
# sudo apt-get install r-cran-xml

library(rattle) 
#these libraries will be used 
# to get a good visual plot for the decision tree model.

d=rpart(S_registered~hour,data=df_train_kaggle)
df_train_kaggle$log_registered = log1p(df_train_kaggle$S_registered)

d=rpart(S_registered~hour,data=df_train_kaggle)
d=rpart(log_registered~hour,data=df_train_kaggle)
# plot(d)
fancyRpartPlot(d)

# On refait avec Y = count
d=rpart(count~hour,data=df_train_kaggle)
fancyRpartPlot(d)

df_train_kaggle$log_count = log1p(df_train_kaggle$count)
d=rpart(log_count~hour,data=df_train_kaggle)
fancyRpartPlot(d)

library(ggplot2)
library(dplyr)

name_var = "hour"
mystats = df_train_kaggle %>%
group_by_(name_var) %>%
  summarise(count = mean(count))

p<-ggplot(data=mystats, aes_string(x=name_var, y="count")) +
  geom_bar(stat="identity")

p

mystats = df_train_kaggle %>%
  group_by_(name_var) %>%
  summarise(count = mean(log_count))


p<-ggplot(data=mystats, aes_string(x=name_var, y="count")) +
  geom_bar(stat="identity")
p

sum(df_train_kaggle$S_registered)/sum(df_train_kaggle$count)
sum(df_train_kaggle$S_casual)/sum(df_train_kaggle$count)

# Avec Y = count  et X = month
# Avec Y = count  et X = day


# On lance un Decision tree en utilisant la librairie rpart
# avec Y = count et X = NN_soleil:
d=rpart(count~NN_soleil,data=df_train_kaggle)
fancyRpartPlot(d)

# avec Y = count et X = NO_temp
d=rpart(count~NO_temp,data=df_train_kaggle)
fancyRpartPlot(d)
