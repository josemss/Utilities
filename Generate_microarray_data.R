#-----------------------------------------------------------#
#    Generating differentially expressed microarray data    # ----
#-----------------------------------------------------------#

## Packages ----
if(!require('BiocManager')) {install.packages("BiocManager")}
if(!require('optBiomarker')) {BiocManager::install("optBiomarker")}
library(optBiomarker)


# Simulate microarray data for two-group ----
help('simData')


# Parameters ----
nTrain <- 40      # total number of samples
nGr1 <- 10        # number of samples of group 1
nBiom <- 500      # total number of genes/probes/proteins
nRep <- 3         # number of replicates of each sample
diffExpr <- TRUE  # introduce differential expression between the two groups
foldMin <- 3      # minimum value of fold changes between groups
sdW <- 2          # experimental (technical) variation (σ_e), log2 scale
sdB <- 1          # biological variation (σ_b), log2 scale


# Generate with simData function ----
data <- simData(nTrain = nTrain, nGr1 = nGr1, nBiom = nBiom, nRep = nRep,
                diffExpr = diffExpr, foldMin = foldMin, sdW = sdW, sdB = sdB,
                orderBiom = FALSE, baseExpr = NULL)
View(data)


# Objects in data ----

# Groups
groups <- data$data[,1]
groups
table(groups)
prop.table(table(groups))

# Expression
ex <- data$data[,-1]
dim(ex)
summary(ex)
summary(t(ex))

# Samples boxplot
boxplot(t(ex), col = groups)

# Expression heatmap
heatmap(as.matrix(ex), Colv = NA, cexRow = 0.5, cexCol = 0.5, 
        RowSideColors = c('red','blue')[as.numeric(groups)])

