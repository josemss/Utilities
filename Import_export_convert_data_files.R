#-----------------------------------------------------------#
# Script for importing, exporting and converting data files # ----
#-----------------------------------------------------------#

## {rio} package ----
install.packages("rio", dependencies = T)
library(rio)


## Data ----
data <- mtcars


## Export (excel, text, csv, SPSS) ----

# to text separated by 'tab'
export(data, file = "prueba_tab.txt")

# to text separated by ';'
export(data, file = "prueba_semicolon.txt", format = ';')

# to csv separated by ','
export(data, file = "prueba_csv.csv")

# to excel
export(data, file = "prueba_excel.xlsx")

# to SPSS
export(data, file = "prueba_spss.sav")


## Import (excel, text, csv, SPSS) ----

# from excel, by default the first sheet
data <- import(file = "prueba_excel.xlsx")
head(data)

# from excel, specifying the sheet
data <- import(file = "prueba_excel.xlsx", which = 2)  # error only 1 sheet
head(data)

# from text separated by ';' 
data <- import(file = "prueba_semicolon.txt", format = ';')
head(data)

# from text separated by 'tab' 
data <- import(file = "prueba_tab.txt", format = '\t')
head(data)

# from csv separated by ','
data <- import(file = "prueba_csv.csv")
head(data)

# from SPSS
data <- import(file = "prueba_spss.sav")
head(data)


## Convert (overwrites the files) ----

# SPSS to Excel
convert("prueba_spss.sav", "prueba_excel.xlsx")

# csv to Excel
convert("prueba_csv.csv", "prueba_excel.xlsx")

# and so on
