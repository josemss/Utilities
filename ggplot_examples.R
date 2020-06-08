##############################################
#  Some graphics with the {ggplot2} package  #
#      Author: Jose M. Sanchez-Santos        #
##############################################


# Install and load the package
if (!requireNamespace("ggplot2", quietly = TRUE))
  install.packages("ggplot2")
library(ggplot2)

# Data used for the examples -> mtcars

# Observations:
# - Arguments "colour" and "col" are identical.
# - Arguments "colour", "fill", "shape"... go inside aes() function if they refer to 
#   variables of the dataframe.


#####################################
#  Qualitative variables / factors  #
#####################################

### Barplot ("x" is a factor, "y" is not necessary unless we want percentages) -----
ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl))) + labs(x = "Cylinders", y = "Counts")

# Percentages (group = 1)
ggplot(data = mtcars) +
  geom_bar(aes(x = factor(cyl), y = stat(prop), group = 1)) + 
  labs(x = "Cylinders", y = "%")

# Add count/proportion/percentage labels (stat = 'count')
ggplot(data = mtcars, aes(x = factor(cyl), y = stat(count))) + 
  geom_bar() + labs(x = "Cylinders", y = "Counts") +
  geom_text(stat = 'count', aes(label = stat(count)), vjust = -0.2)

ggplot(data = mtcars, aes(x = factor(cyl), y = stat(prop), group = 1)) + 
  geom_bar() + labs(x = "Cylinders", y = "Proportion") +
  geom_text(stat = 'count', vjust = -0.2,
            aes(label = stat(prop), group = 1))

ggplot(data = mtcars, aes(x = factor(cyl), y = 100*stat(prop), group = 1)) + 
  geom_bar() + labs(x = "Cylinders", y = "%") +
  geom_text(stat = 'count', vjust = -0.2,
            aes(label = 100*stat(prop), group = 1))


# For 2 variables -> Stacked (by default)
# colour
ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl), colour = factor(gear))) + 
  labs(x = "Cylinders", y = "Counts", colour = "Gear")
# fill
ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl), fill = factor(gear))) +
  labs(x = "Cylinders", y = "Counts", fill = "Gear")

# For 2 variables -> Grouped (position="dodge") (colour o fill)
# colour
ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl), colour = factor(gear)), position = "dodge") +
  labs(x = "Cylinders", y = "Counts", colour = "Gear")
# fill
ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl), fill = factor(gear)), position = "dodge") + 
  labs(x = "Cylinders", y = "Counts", fill = "Gear")

# Add count labels
ggplot(data = mtcars, aes(x = factor(cyl), fill = factor(gear))) + geom_bar(position = "dodge") + 
  labs(x = "Cylinders", y = "Counts", fill = "Gear") +
  geom_text(stat = 'count', aes(label = stat(count)),
            position = position_dodge(width = 0.9), vjust = -0.2)


### Pie chart (it is a "circular" barplot, leaving the variable x empty) -----------
ggplot(data = mtcars) + geom_bar(aes(x = "", fill = factor(cyl))) + coord_polar(theta = "y") + 
  labs(x = "", y = "", fill = "Cylinders")

# To add percentages create a dataframe with table() for Counts and Percentages
Cyl <- levels(factor(mtcars$cyl))  # categories
Freq <- as.numeric(table(mtcars$cyl))  # Counts
Perc <- as.numeric(100*table(mtcars$cyl)/sum(table(mtcars$cyl)))  # Percentages
dftemp <- data.frame(Cyl, Freq, Perc)
ggplot(data = dftemp, aes(x = "", y = Freq, fill = Cyl)) + 
  geom_bar(width = 1, position = "stack", stat = "identity") + labs(fill = "Cylinders") + 
  labs(x = "", y = "") + geom_text(aes(label = paste0(Freq, "\n (", round(Perc, 3), "%)")), col = "white",
            position = position_stack(vjust = 0.5), size = 5) + coord_polar(theta = "y") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(), panel.grid  = element_blank())
  # configure arguments of theme() to delete axis and ticks


################################################
#  Ordinal / Numeric / Quantitative Variables  #
################################################

### Sequence (a single variable with respect to indices 1,2,3 ...) -----------------
# points
ggplot(data = mtcars) + geom_point(aes(seq_along(mpg), mpg))
# points & lines
ggplot(data = mtcars, aes(seq_along(mpg), mpg)) + geom_line() + geom_point()
# two sequences
ggplot(data = mtcars, aes(x = seq_along(mpg))) + geom_line(aes(y = mpg, col = "mpg")) + 
  geom_point(aes(y = mpg, col = "mpg")) + geom_line(aes(y = wt, col = "wt")) + 
  geom_point(aes(y = wt, col = "wt")) + ylab('') + xlab('Index') + labs(col = "Variable") +
  scale_colour_manual(values = c("red", "green"))


### Histogram (function I() is to put colors as is) --------------------------------
ggplot(data = mtcars) + geom_histogram(aes(x = mpg), bins = 10, fill = I("white"), colour = I("black")) +
  labs(title = "Histogram", x = "Miles per gallon", y = "Counts")
# with percentages
ggplot(data = mtcars) + geom_histogram(aes(x = mpg, stat(density)), bins = 10, fill = I("white"),  
                                       colour = I("black")) +
  labs(title = "Histogram", x = "Miles per gallon", y = "Density")
# by a factor -> "colour" or "fill" go inside aes()
ggplot(data = mtcars) + geom_histogram(aes(x = mpg, colour = factor(am)), bins = 10, fill = I("white")) +
  labs(title = "Histogram", x = "Miles per gallon", y = "Counts", colour = "am")
# overlaid with transparency
ggplot(data = mtcars, aes(x = mpg, fill = factor(am))) + geom_histogram(bins = 10, alpha = .5, 
                                                                        position = "identity") +
  labs(title = "Histograms", x = "Miles per gallon", y = "Counts", fill = "am")


### Scatterplot --------------------------------------------------------------------
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt), colour = I("red")) +
  labs(title = "Scatterplot", x = "Miles per gallon", y = "Weight")
# by the scale of a variable
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, col = cyl)) +
  labs(title = "Scatterplot", x = "Miles per gallon", y = "Weight", col = "Cylinders")
# by a factor
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, col = factor(cyl))) +
  labs(title = "Scatterplot", x = "Miles per gallon", y = "Weight", col = "Cylinders")
# with lines
ggplot(data = mtcars, aes(x = mpg, y = wt, col = factor(cyl))) + geom_point() + geom_line() +
  labs(title = "Scatterplot with lines", x = "Miles per gallon", y = "Weight", col = "Cylinders")
# with smoothed means and confidence regions
ggplot(data = mtcars, aes(x = mpg, y = wt, col = factor(cyl))) + geom_point() + 
  geom_smooth(method = "loess") +
  labs(title = "Scatterplot with smoothed means and confidence regions", x = "Miles per gallon", 
       y = "Weight", col = "Cylinders")
# by size of another numerical variable (size = ...)
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, size = hp), col = I("red")) +
  labs(title = "Scatterplot with size", x = "Miles per gallon", y = "Weight", size = "hp")
# with symbols for a factor (shape = ...)
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, shape = factor(cyl)), col = I("green")) +
  labs(title = "Scatterplot with symbols", x = "Miles per gallon", y = "Weight", shape = "Cylinders")
# symbols & colours
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, col = factor(cyl), shape = factor(cyl))) +
  labs(title = "Scatterplot with symbols and colours", x = "Miles per gallon", y = "Weight", 
       shape = "Cylinders", col = "Cylinders")
# symbols, colours & size
ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, col = factor(cyl), shape = factor(cyl)), size = 5) +
  labs(title = "Scatterplot with symbols, colours & size", x = "Miles per gallon", y = "Weight", 
       shape = "Cylinders", col = "Cylinders")


### Boxplot (variable goes inside aes(y = ...)) ------------------------------------
ggplot(data = mtcars) + geom_boxplot(aes(y = mpg), width = 0.5) + labs(title = "Boxplot")

# by groups (the grouping variable goes in aes(x = ...))
ggplot(data = mtcars) + geom_boxplot(aes(x = factor(cyl), y = mpg), width = 0.5) + 
  labs(title = "Boxplot", x = "Cylinders")
# by groups & colours
ggplot(data = mtcars) + geom_boxplot(aes(x = factor(cyl), y = mpg, fill = factor(cyl))) + 
  labs(title = "Boxplot", x = "", fill = "Cylinders", y = "Miles per gallon")
# by two grouping variables
ggplot(data = mtcars) + geom_boxplot(aes(x = factor(cyl), y = mpg, fill = factor(cyl), col = factor(am))) + 
  labs(title = "Boxplot", x = "", fill = "Cylinders", y = "Miles per gallon", col = "Transmission")
# multiple columns/variables of a dataframe (stack or melt the dataframe)
ggplot(data = stack(mtcars[,-(3:4)]), aes(x = ind, y = values)) + geom_boxplot() + labs(title = "Boxplot of vars")
ggplot(data = reshape2::melt(mtcars[,-(3:4)]), aes(x = variable, y = value)) + geom_boxplot() + labs(title = "Boxplot of vars")

### Violin Plot (x empty, put the variable in y) -----------------------------------
ggplot(data = mtcars) + geom_violin(aes(x = "", y = mpg)) + labs(title = "Violin plot", x = "")
# not trimmed
ggplot(data = mtcars) + geom_violin(aes(x = "", y = mpg), trim = F) + 
  labs(title = "Violin plot", x = "")
# by groups
ggplot(data = mtcars) + geom_violin(aes(x = factor(cyl), y = mpg), trim = F) + 
  labs(title = "Violin plot", x = "Cylinders")
# by groups with colors
ggplot(data = mtcars) + geom_violin(aes(x = factor(cyl), y = mpg, fill = factor(cyl)), trim = F) + 
  labs(title = "Violin plot", x = "", fill = "Cylinders")
# with points
ggplot(data = mtcars) + geom_violin(aes(x = factor(cyl), y = mpg, fill = factor(cyl)), trim = F) + 
  labs(title = "Violin plot", x = "", fill = "Cylinders") +
  geom_point(aes(x = factor(cyl), y = mpg, fill = factor(cyl)))
# with jitter
ggplot(data = mtcars) + geom_violin(aes(x = factor(cyl), y = mpg, fill = factor(cyl)), trim = F) + 
  labs(title = "Violin plot", x = "", fill = "Cylinders") +
  geom_jitter(aes(x = factor(cyl), y = mpg, fill = factor(cyl)),
              height = 0, width = 0.1)


### Dotplot ------------------------------------------------------------------------
ggplot(data = mtcars) + geom_dotplot(aes(x = mpg)) + labs(title = "Dotplot", x = "Miles per gallon")
# centered
ggplot(data = mtcars) + geom_dotplot(aes(x = mpg), stackdir = "center", binwidth = 1.2) + 
  labs(title = "Dotplot", x = "Miles per gallon")
# vertical & centered (put x = 1 and binaxis = "y")
ggplot(data = mtcars) + geom_dotplot(aes(x = 1, y = mpg), binaxis = "y", stackdir = "center") + 
  labs(title = "Dotplot", y = "Miles per gallon")
# vertical & centered, separating the points
ggplot(data = mtcars) + geom_dotplot(aes(x = 1, y = mpg), binaxis = "y", stackdir = "center", stackratio = 1.5) + 
  labs(title = "Dotplot", y = "Miles per gallon")
# by groups
ggplot(data = mtcars) + geom_dotplot(aes(x = factor(cyl), y = mpg, fill = factor(cyl)), binaxis = "y", 
                                     stackdir = "center", stackratio = 1.5) + 
  labs(title = "Dotplot", x = "", y = "Miles per gallon", fill = "Cylinders")
# dotplot + violinplot & colours
ggplot(data = mtcars, aes(x = factor(cyl), y = mpg)) + geom_violin(aes(fill = factor(cyl)), trim = F) +
  geom_dotplot(binaxis = "y", stackdir = "center", stackratio = 1.5) + 
  labs(title = "Violin + Dotplot", x = "", y = "Miles per gallon", fill = "Cylinders")


### Density plot -------------------------------------------------------------------
ggplot(data = mtcars) + geom_density(aes(x = mpg), fill = I("aquamarine2")) +
  labs(title = "Density", x = "Miles per gallon")
# add transparency
ggplot(data = mtcars) + geom_density(aes(x = mpg), fill = I("aquamarine2"), alpha = 0.4) + xlim(0, 40) +
  labs(title = "Density", x = "Miles per gallon")
# by groups without fill
ggplot(data = mtcars) + geom_density(aes(x = mpg, col = factor(am))) + xlim(0, 45) +
  labs(title = "Density", x = "Miles per gallon", col = "Transmission")
# by groups with fill and transparency
ggplot(data = mtcars) + geom_density(aes(x = mpg, fill = factor(am), linetype = factor(am)), alpha = 0.4) + 
  xlim(0, 45) + labs(title = "Density", x = "Miles per gallon", fill = "Transmission", linetype = "Transmission")
# by groups with fill and transparency, changing legend values
ggplot(data = mtcars) + geom_density(aes(x = mpg, fill = factor(am), linetype = factor(am)), 
                                     alpha = 0.4) + xlim(0, 45) +
  labs(title = "Density", x = "Miles per gallon", fill = "Transmission", linetype = "Transmission") +
  scale_fill_discrete(name = "Transmission", labels = c("Automatic", "Manual")) +
  scale_linetype_discrete(name = "Transmission", labels = c("Automatic", "Manual"))


### Plot separated by factors (facet_grid() ----------------------------------------
# with a formula factor1~factor2 
ggplot(data = mtcars, aes(x = hp, y = mpg, shape = factor(am), colour = factor(am))) +
  facet_grid(gear ~ cyl) + geom_point() +
  scale_shape_discrete(name = "Transmission", labels = c("Automatic", "Manual")) +
  scale_colour_discrete(name = "Transmission", labels = c("Automatic", "Manual"))
# with rows = vars()
ggplot(data = mtcars, aes(x = hp, y = mpg, shape = factor(am), colour = factor(am))) +
  facet_grid(rows = vars(gear)) + geom_line()
# with cols = vars()
ggplot(data = mtcars, aes(x = hp, y = mpg, shape = factor(am), colour = factor(am))) +
  facet_grid(cols = vars(cyl)) + geom_point()
# with boxplots by a factor
ggplot(data = mtcars, aes(x = factor(vs), y = mpg, shape = factor(am), colour = factor(am))) +
  facet_grid(cols = vars(cyl)) + geom_boxplot()
# grid by 2+ factors
ggplot(data = mtcars, aes(x = hp, y = mpg, shape = factor(am), colour = factor(am))) +
  facet_grid(vs + am ~ gear, margins = "vs") + geom_point()


### Different plots in the same layout (grid.arrange() from {gridExtra} ) ----------
if (!requireNamespace("gridExtra", quietly = TRUE))
  install.packages("gridExtra")
library(gridExtra)
# generate the different plots
g1 <- ggplot(data = mtcars) + geom_bar(aes(x = factor(cyl), fill = factor(gear)), position = "dodge") + 
  labs(x = "Cylinders", y = "Counts", fill = "Gear", title = "Barplot")

g2 <- ggplot(data = mtcars) + geom_bar(aes(x = "", fill = factor(cyl))) + coord_polar(theta = "y") + 
  labs(x = "", y = "", fill = "Cylinders", title = "Piechart")

g3 <- ggplot(data = mtcars, aes(x = mpg, fill = factor(am))) + geom_histogram(bins = 10, alpha = .5, 
                                                                              position = "identity") +
  labs(title = "Histogram", x = "Miles per gallon", y = "Counts", fill = "am")

g4 <- ggplot(data = mtcars) + geom_point(aes(x = mpg, y = wt, col = factor(cyl), 
                                             shape = factor(cyl)), size = 5) +
  labs(title = "Scatterplot", x = "Miles per gallon", y = "Weight", shape = "Cylinders", col = "Cylinders")

g5 <- ggplot(data = mtcars) + geom_boxplot(aes(x = factor(cyl), y = mpg, fill = factor(cyl))) + 
  labs(title = "Boxplot", x = "", fill = "Cylinders", y = "Miles per gallon")

g6 <- ggplot(data = mtcars, aes(x = factor(cyl), y = mpg)) + 
  geom_violin(aes(fill = factor(cyl)), trim = F) +
  geom_dotplot(binaxis = "y", stackdir = "center", stackratio = 1.5) + 
  labs(title = "Violin + Dotplot", x = "", y = "Miles per gallon", fill = "Cylinders")

g7 <- ggplot(data = mtcars) + geom_density(aes(x = mpg, fill = factor(am), linetype = factor(am)), 
                                           alpha = 0.4) + xlim(0, 45) +
  labs(title = "Density", x = "Miles per gallon", fill = "Transmission", linetype = "Transmission")

g8 <- ggplot(data = mtcars, aes(x = hp, y = mpg, shape = factor(am), colour = factor(am))) + 
  facet_grid(cols = vars(cyl)) + geom_point() + labs(title = "Grid")

g9 <- ggplot() + annotate("text", label = "(c) JMSS 2019", size = 12, x = 4, y = 25) + theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())

grid.arrange(g1, g2, g3, g4, g5, g6, g7, g8, g9, ncol = 3)
