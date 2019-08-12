install.packages("smooth")

library("smooth")

# ma <- function(x, n = 12){filter(x, rep(1 / n, n), sides = 2)}

test = df[,c("datetime","count")]
ma(test,5)


