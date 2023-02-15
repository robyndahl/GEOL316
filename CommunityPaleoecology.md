# Community Paleoecology

## Part 1: Introduction

The goal of this activity is for you to learn some of the methods paleontologists use to study diversity in fossil assemblages. Like many different fields in science, modern paleontology has trended more and more towards utilizing “big data” and quantitative analytical techniques, and most modern paleontologists are an equal mix of paleontologist, statistician, and computer programmer. We will not be using advanced statistical methods or coding in this course, but I want to illustrate how paleontologists can use big data to study diversity trends and evolutionary patterns.

### Important Vocabulary

**Term**  | **Definition**
--------- | ---------------
Diversity | General concept referring to the variety of kinds of organisms (see *disparity*, *taxonomic richness*)
Disparity | An aspect of biodiversity reflecting morphological differences among species
Evenness | how close in numbers each species in an environment is. Mathematically, it is defined as a diversity index, a measure of biodiversity which quantifies how equal the community is numerically. For example, if there is an ecosystem with 2 trilobites and 300 brachiopods, it is not very even, but if there are 25 trilobites and 27 brachiopods, the community is quite even. 
Taxonomic richness | A measure of biodiversity equal to the number of taxa present


## Part 2: Introduction to R

In Part 1 of this lab, you calculated the dissimilarity scores for four hypothetical assemblages by hand. Paleontologists rarely do such calculations by hand, especially when working with large data sets. From this point forward, we will use the R programming language to conduct our analyses.

Since we don't have time to actually learn to program in R, I will be providing you with the scripts you should use to analyze our datasets. If you are interested in actually learning how to write code in R, I can direct you towards some very useful tutorials to explore on your own time.

### Step 1: Getting to know R Studio
We will be using the R Studio programming environment for this lab. R Studio is free download and is also available on all campus computers, including the machines in the Geology Department computer lab in ES 230. If you need extra time to complete this lab, you can either download the program onto your own computer or find a computer on campus to use.

You can download R Studio [here](https://posit.co/downloads/).

To get started, open R Studio and familiarize yourself with the environment. [This website](https://intro2r.com/rstudio_orient.html) should help you get to know the layout. We will also go over this together in class.

After you have explored R Studio a little, open up a scrip pane in the upper left corner of R Studio (click on the icon of a little white page with a green plus sign). This is where you will write (or copy/paste) any code.

### Step 2: Loading data
After you get to know the layout of R Studio, you're ready get to started on data analysis! The first step is to download all the packages that we will be using. Packages are open source programs or functions. The packages we will be using for this activity are called `vegan`, `cluster`, and `paleotree`. To download and access the packages, use the following script. Copy and paste it into your script pane in the upper left of R Studio, then click "Run"

````r
#download the packages
install.packages("vegan")
install.packages("cluster")
install.pagkages("paleotree")

#open the packages in your current session
library(vegan)
library(cluster)
library(paleotree)
````
NOTE: If you are working on a public computer, you will need to download these packages each time you start a new R session. If you are working on your personal laptop, the packages will stay downloaded from session to session, but you will need top load them each session. In otherwords, you can skip the first three commands (`install.packages()`) but you will still need to run the second three (`library()`).

Now let's load in some data! There are different ways of doing this depending on where the data you want to load is located. To simplify things, we will be using datasets that are hosted here in this Github Repository. Use the following script to load our class Pokemon Go dataset.

````r
#tell R where the data is hosted
URL <- ("https://raw.githubusercontent.com/robyndahl/GEOL316/master/datasets/pokemon.csv")

#load the data
pokemon <- read.csv(URL, header = T, row.names = 1)
````
Now that your data is loaded, you can view it by clicking on the file "pokemon" in the `Environment` pane in the upper right of R Studio. This will open your data in a new pane in the upper left. You can now toggle between the pokemon data and the R script by clicking on their tabs in the upper left pane. You can close and reopen your data as often as you want, but don't close out your script file unless you save it first!

The data you have just loaded is in the format of a **community matrix**. The rows represent different sites or assemblages and the columns represent individual taxa. Each cell indicates how many of each taxon is present at a particular site. Community matrices are a very common way of representing ecological data, but we need to transform it a little in order to conduct our analysis.

### Step 3: Pokemon Data Analysis
The Pokemon community matrix currently represents **raw abundance**. We need to *standardize* the data by converting it to **relative abundance** or percentages. Rather than computing this by hand (tedious! time consuming!) we will use a function (`decodstand`) included in the `vegan` package designed specifically to convert raw abundance in a community matrix to relative abundance. Here is the script to use:

````r
# standardize by converting community matrix from raw number to relative abundance
pokemon.stand <- decostand(pokemon, method = "total")
````
Take a look at the relative abundance community matrix by clicking on "pokemonStand" in the Environment pane.

The next step is to calculate the Bary-Curtis distance index numbers for each of the sites. This is what we calculated by hand in Part 1. Now we will use a function in the `vegan` package called `vegdist` to calculate the index for all site combinates at once. So much easier than calculating by hand! Use this script to do the generate the distance index numbers:

````r
# generate a new matrix for the distance index
sites.dist.pokemon <- vegdist(pokemon.stand, "bray")

# view the distance matrix
sites.dist.pokemon
````
Spend some time examining the distance matrix. Remember, the Bray-Curtix index returns values from 0 to 1 and a higher value indicates more **distance** or dissimilarity. A lower value indicates less distance, or more silimarity. Use this information to answer the following questions:

1. Which two site pairs are the most similar? What is their Bray-Curtis index?
2. Which two site pairs are the most different? What is their Bray-Curis index?
3. Which site seems like it is the most different from the others? Explain your reasoning.

Let's visualize this data by conducting a cluster analysis. Use the following script:

````r
sites.dist.pokemon.agnes <- agnes(sites.dist.pokemon)
plot(sites.dist.pokemon.agnes)
````
The cluster diagram you have generated clusters sites based on how similar they are. Use the diagram to answer the following questions:

4. According to the cluster diagram, which two sites are the most similar? Are they the same sites as your answer for Question 1 (above)?
5. Which site is the most different from the others? How can you tell? Is it the same site you selected for Question 3 (above)?

The type of analysis you just conducted is called Q-mode cluster analysis. The result of Q-mode cluster analysis tells you which sites are most similar. Sometimes paleontologists and ecologists want to look at the data in a different way, to determine which taxa are most likely to occur together. This is called R-mode cluster analysis. To conduct R-mode cluster analysis, you have to transpose the community matrix by flipping the rows and columns. Use the following script to conduct R-mode cluster analysis on the Pokemon data.

````r
# transpose your relative abundance community matrix
pokemon.stand.t <- t(pokemon.stand)

# generate a distance matrix
taxa.dist.pokemon <- vegdist(pokemon.stand.t, "bray")

# conduct and plot the cluster analysis
taxa.dist.pokemon.agnes <- agnes(taxa.dist.pokemon)
plot(taxa.dist.pokemon.agnes)
````

For the Pokemon data, the resulting plot is quite messy and difficult to interpret. It might be more useful to compare the two types of cluster analysis. We can use the function `twoWayEcologyCluster()` from the `paleotree` package to do this:

````r
twoWayEcologyCluster(
  xDist = sites.dist.pokemon.agnes,
  yDist = taxa.dist.pokemon.agnes,
  propAbund = pokemon.stand)
````

The resulting plot helps you easily determine which sites taxa occur in, and the pattern in occurences should help you see which sites are most similar.

## Part 3: Ediacaran Data Analysis
We have already explored some Ediacaran data in this course (in the Rarefaction Curve activity in Week 1). The Ediacaran is an important time in the history of life on Earth because marine seafloor ecosystems diversified rapidly, transitioning from a stromatolite (algal mat dominated) seafloor to diverse ecosystems that included all kinds of complex, soft-bodied organisms. We are going to examine data from two famous Ediacaran localities: the Ediacara Hills in South Australia and Mistaken Point in Newfoundland, Canada. At both localities, several bedding planes have been excavated and studied. Each bedding plane is essentially a “snapshot” of the seafloor at a single moment in time, so we can ignore the effects of *time averaging* and treat each bedding plane like a unique assemblage. Here is some information about these two localities:

[Mistaken Point](https://youtu.be/RxJzF3Yk0uc)

[Nilpena, Australia](https://youtu.be/koeeS5H3cNI)

The data set that we are going to explore was collected from 38 individual Ediacaran bedding planes. Use the script below to load the community matrix.

````r
URL <- ("https://raw.githubusercontent.com/robyndahl/GEOL316/master/datasets/ediacaran.csv")
ediacaran <- read.csv(URL, header = T, row.names = 1)
````

In this community matrix, rows represent fossil collections, not sites. Columns represent taxa. You might notice that some of the taxa have strange names. This is because most Ediacaran organisms are not closely related to modern groups of organisms and cannot be easily classified into existing taxonomic groups. Until each new fossil organism gets officially described and named, it’s given a descriptive nickname. For example, the fossil shown to the right was nicknamed “anchor” until it was formally described and named *Parvancorina*. The fossil in your data labeled “BOF” is called bundle of fibers and is yet to be formally described and named.

Answer the following questions:

6. Is a raw abundance or relative abundance matrix? How can you tell?
7. How many specimens of *Charniodiscus* were present in collection 103?
8. Whicih taxon was most abundant in collection 113? How many specimens of that taxon were present in that collection?

Now let's conduct our Q-mode analysis:

````r
# convert to relative abundance (spoiler for question 6, above)
ediacaran.stand <- decostand(ediacaran, method = "total")

# generate a distance matrix
sites.dist.ediacaran <- vegdist(ediacaran.stand, "bray")

#view distance matrix
sites.dist.edicaran

# Q-mode analysis
sites.dist.ediacaran.agnes <- agnes(sites.dist.ediacaran)
plot(siteDistEdiacaran.agnes)
````
Examine your plot and then answer the following questions:

9. Which of the following site pairs do you think are most similar?
  + 118/128
  + 126/127
  + 101/102
10. How certain in your answer for questions 9 are you? Explain.

Check your answer for question 9 by examining the Ediacaran distance matrix. You can view the whole matrix by using the following script:

````r
sites.dist.matrix <- as.matrix(sites.dist.ediacaran)
````

11. Was your answer to question 9 correct? How do you know?

Now let's conduct our R-mode cluster analysis:

````r
# R-mode analysis
ediacaran.stand.t <- t(ediacaran.stand)
taxa.dist.ediacaran <- vegdist(ediacaran.stand.t, "bray")
taxa.dist.ediacaran.agnes <- agnes(taxa.dist.ediacaran)
plot(taxa.dist.ediacaran.agnes)
````

12. According to the R-mode cluster diagram, which two taxa are you more likely to find in the same collection:
  + *Aulozoon* and Sprigginamorphs
  + *Helminthoidichnites* and *Wigwamiella*
13. Explain your reasoning for your answer to question 12.

Let's check by examining the distance matrix. Generate it using the following script:

````r
taxa.dist.matrix <- as.matrix(taxa.dist.ediacaran)
````

14. Was your answer to question 12 correct?
