############################################################
###  Script to download and view data from GEO database  ###
############################################################

### Install packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!requireNamespace("GEOquery", quietly = TRUE))
  BiocManager::install("GEOquery")

if (!requireNamespace("car", quietly = TRUE))
  install.packages("car")

### Load packages
library(GEOquery)
library(car)

### Web to search data: NCBI-GEO
browseURL("https://www.ncbi.nlm.nih.gov/sites/GDSbrowser")
# Choose a dataset and copy the code GDSXXXX
# Inspect samples by clicking on "Sample subsets"


### Download, manipulate and save the data --------------------------

code <- "GDS1402"
gds <- getGEO(code)
str(gds)   # observe the content of each slot

### Get the expression matrix from the corresponding slot
df <- gds@dataTable@table
rownames(df) <- df[,"ID_REF"]   # data frame with probes and genes
summary(df)
df.expr <- na.omit(df)[,c(-1,-2)]   # only probes and samples

## Logarithmic scale if necessary
ifelse(min(df.expr) <= 0 | max(df.expr) < 20, 
        df.expr <- df.expr, df.expr <- log2(df.expr))
summary(df.expr)

## Save the expression matrix
write.table(df.expr,file = paste("expression_data_", code, ".txt", sep = ''))

## Samples subsets
names(gds@dataTable@columns)
factor <- "cell.type"   # change to the desired column
groups <- gds@dataTable@columns[,factor]; groups 


### Data visualization ----------------------------------------------

## Check if they are normalized with boxplot
col <- palette(c("blue","red","green","yellow","grey","purple"))
title <- paste("Boxplots from the dataset",code,sep = ' ')
layout(matrix(c(1,2), nrow = 1), width = c(5,1)) 
par(mar = c(5,5,4,1))
boxplot(df.expr, palette = col, boxwex = 0.7, notch = T, main = title, las = 2, 
        col = as.factor(groups), outline = F, cex.axis = 0.7)
par(mar = c(4,0,4,0))
plot(c(0,1), type = "n", axes = F, xlab = "", ylab = "")
legend("center",legend = levels(groups), fill = col, cex = 0.6, 
       title = factor, bty = "n")
layout(matrix(1))

## PCA with 2 components for samples
pca <- prcomp(t(df.expr), scale = T, rank = 2)
summary(pca)
plot(pca)
title2 <- paste("PCA for samples of dataset", code, sep = ' ')
plot(pca$x, col = groups, main = title2)
legend("topright",legend = levels(groups), col = col, cex = 0.6, pch = 1)

## Expression profile of genes chosen by the user
sel <- 1:5 # or other selection of rows
col2 <- rainbow(length(sel))
layout(matrix(c(1,2), nrow = 1), width = c(5,1)) 
par(mar = c(5,5,4,1))
matplot(x = 1:length(groups), y = t(df.expr[sel, ]), type = "l", col = col2, 
        lty = 1, main = paste("Expression profile of the",length(sel),"genes (probes) chosen"),
        xlab = NA, ylab = "Intensity", xaxt = "n")
Map(axis, side = 1, at = 1:dim(df.expr)[2], col.axis = groups, 
    labels = colnames(df.expr), lwd = 0, las = 2, cex.axis = 0.7)
axis(1, at = 1:dim(df.expr)[2], labels = FALSE)
par(mar = c(4,0,4,0))
plot(c(0,1), type = "n", axes = F, xlab = "", ylab = "")
legend("center", title = "Gen/Probe", colnames(t(df.expr[sel, ])), 
       col = col2, cex = 0.5, fill = col2, bty = "n")
layout(matrix(1))

## Heatmap with 1000 genes (probes)
k <- ifelse(dim(df.expr)[1] >= 1000, 1000, dim(df.expr)[1]); k
heatmap(as.matrix(df.expr[1:k,]), Colv = NA, revC = T,
        ColSideColors = as.character(as.numeric(groups)))

