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
# fun_build_2d_plot(df,"hour")

# Fonction qui filtre le dataframe en fonction d'une date de début et une date de fin
fun_filter_df = function(df,date_debut,date_fin){
  filter = df$datetime<=date_fin & df$datetime>=date_debut
  resultat = df[filter,]
  return (resultat)
}

# THE MEGA TIME SERIES
build_the_time_series = function(){
  mydf = df[,c("datetime","count","S_rateregis")]
  mydf = mydf[order(mydf$datetime,decreasing = FALSE),]
  mydf$datetime = mydf$datetime + hours(5)
  mydata = xts(x = mydf, order.by = mydf$datetime)
  
  g = dygraph(mydata, main = "Enorme Plot")%>%
    dyAxis("y", label = "Count", valueRange = c(0, 1000), independentTicks = TRUE)%>%
    dyAxis("y2", label = "Registered Rate ", valueRange = c(0, 1), independentTicks = TRUE) %>%
    dySeries("S_rateregis", axis=('y2')) %>%
    dyRangeSelector()
  return(g)
}


fun_build_3dplot = function(df,varX,varY){
  
  g = ggplot(df, aes_string(varX, varY)) +
    geom_raster(aes_string(fill = "count")) + 
    scale_fill_gradientn(colours=c("yellow","red"))
  return(g)
  
}