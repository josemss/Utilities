#-----------------------------------------------------------#
#      Colouring the area under a curve with {ggplot2}      # ----
#-----------------------------------------------------------#

## {ggplot} package ----
if(!require('ggplot2')) {install.packages("ggplot2")}
library(ggplot2)


# Example with normal density (change it if desired) ----

# Create an empty plot between -3 and 3
p <- ggplot(data.frame(x = c(-3, 3)), aes(x = x))

# Add Normal density
p <- p + stat_function(fun = dnorm)

# Colour the whole area ----
p + stat_function(fun = dnorm, geom = "area", fill = "blue", alpha = 0.2)

# Colour an interval (a,b) ----
# Extremes of the interval
a <- 1.96
b <- 3

# Create a function that is NA outside the interval so that this region
# does not appear on the graph
fun_limit <- function(x) {
  y <- dnorm(x)
  y[x < a  |  x > b] <- NA
  return(y)
}

# Add this function to plot
p + stat_function(fun = fun_limit, geom = "area", fill = "blue", alpha = 0.2)


# Other examples ----
a <- -1.96
b <- 1.96
p + stat_function(fun = fun_limit, geom = "area", fill = "blue", alpha = 0.2)

p +
  stat_function(fun = dnorm, geom = "area", fill = "blue", alpha = 0.2) +
  stat_function(fun = fun_limit, geom = "area", fill = "white", alpha = 0.5)
