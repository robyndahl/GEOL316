# load packages

library(vegan)
library(cluster)
library(paleotree)

# load raw data

ediacaran <- read.csv("Ediacaran.csv", header = TRUE, row.names = 1)

# standardize by converting community matrix from raw number to relative abundance

ediacaranStand <- decostand(ediacaran, method = "total")

# Q-mode cluster analysis (based on taxonomic abundance at each site)

siteDistEdiacaran <- vegdist(ediacaranStand, "bray")
siteDistEdiacaran.agnes <- agnes(siteDistEdiacaran)
plot(siteDistEdiacaran.agnes)

# R-mode cluster analysis (based on taxa only)

taxaDistEdiacaran <- vegdist(ediacaranStand, "bray")
taxaDistEdiacaran.agnes <- agnes(siteDistEdiacaran)
plot(siteDistEdiacaran.agnes)

# two-way cluster analysis (compares Q and R mode, or sites vs taxa)

twoWayEcologyCluster(
  xDist = siteDistEdiacaran,
  yDist = taxaDistEdiacaran,
  propAbund = ediacaranStand)

# conduct nonmetric multidimensional scaling (NMDS) analysis

ediacaranNMDS <-metaMDS(ediacaran)

# plot NMDS

ediacaran_groups <- read.csv("ediacaran_groups.csv", header = TRUE, row.names = 1) # site information

colvec <- c("#1f78b4", "#b2df8a") # color by region

plot(ediacaranNMDS, "sites")
with (ediacaran_groups,
      points(ediacaranNMDS,
             display = "sites",
             col = "black",
             pch = 21,
             bg = colvec[Region]))
with(ediacaran_groups,
     legend("topleft",
            legend = levels(Region),
            bty = "n",
            col = colvec,
            pch = 21,
            pt.bg = colvec))
