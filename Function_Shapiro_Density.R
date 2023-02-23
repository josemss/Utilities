#-----------------------------------------------------------#
#    Function that performs the Shapiro-Wilk test and the   # ----
#   density plot to the numerical variables of a dataframe  #
#-----------------------------------------------------------#

# Function definition ----

shapiro_density <- function(data, ncols = 2) {
  # Selects the numerics, their values and their names
  num_vars <- sapply(data, is.numeric)
  num_data <- data[, num_vars, drop = FALSE]
  num_var_names <- names(num_data)
  num_vars_count <- length(num_var_names)
  
  # Configure the graphical interface with the chosen ncols
  par(mfrow = c(ceiling(num_vars_count/ncols), ncols))
  
  # Loop for each variable
  for (i in 1:num_vars_count) {
    var_name <- num_var_names[i]
    var_data <- num_data[[var_name]]
    
    # Perform the test, extract the pvalue and calculate the density
    shapiro_result <- shapiro.test(var_data)
    p_value <- format(shapiro_result$p.value, digits = 3)
    density <- density(var_data)
    
    # Plot the density and adds the pvalue as text.  
    plot(density, main = var_name, xlab = var_name, zero.line = FALSE)
    text(x = mean(var_data) * 1, y = min(density$y) * 1, 
         labels = paste("Shapiro-Wilk test p-value =", p_value), 
         col = "blue", cex = 0.85)
  }
  # Restores the graphical interface to one column
  par(mfrow = c(1,1))
}


# Examples ----

# Two columns by default
shapiro_density(data = iris)

# User chooses the number of columns
shapiro_density(data = LifeCycleSavings, ncols = 2)
shapiro_density(data = LifeCycleSavings, ncols = 3)
