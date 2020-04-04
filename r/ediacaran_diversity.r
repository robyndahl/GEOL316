# load packages

library(vegan)
library(cluster)

# load raw data

ediacaran <- read.csv("Ediacaran.csv", header = TRUE, row.names = 1)
