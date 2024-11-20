# Part 1: Modeling Ecological Gradients

Modeling ecological gradients using multivariate data analyses.

## Basic Concepts

Most traditional data analyses are **univariate** or **bivariate**. A univariate analysis assesses a single variable and a bivariate analysis compares two variables. For example, `hist( )` is a univariate analysis, a `t.test( )` is bivariate, and a scatter plot is bivariate.

Such analyses fall shore when you want to anlyze the relationships among many different variables, i.e, a **multivariate** dataset. In fact, there are a whole host of problems associated with applying multiple bivariate anlyses to a multivariate dataset. In other words, you can't just perform a bivariate analysis on every possible pair of combinations in a multivariate dataset.

One way to solve this issue to use **multivariate** analyses. In this lab, we are going to explore a broad class of multivariate analyses known as **ordinations**. The driving principle behind these methods is to "*reduce the dimensionality*" of a multivariate dataset. In other words, we will take a dataset with many variables and summaries their relationships with only a few of those variables.

## Our First Multivariate Dataset

To complete this lab, we will need to use a few R packages as well as a collection functions originally written by Andrew Zaffos for the now defunct 'Velociraptr' package. To get started, run the following:

#### Step 1

````R
install.packages("paleobioDB")
install.packages("vegan")

library(paleobioDB)
library(vegan)
````

Next, click this link to access an R script containing the additional functions you need to load: [Velociraptr functions](https://github.com/robyndahl/GEOL316/blob/master/r/Lab8_functions.R)

Great! Now we are ready to download some data.

#### Step 2

We are going to download a very large dataset of bivalve occurrences throughout the entire Phanerozoic. Because this is such a large dataset, we're going to download it in chunks and then combine the chunks together into a single data set.

````R
# download occurrences, split by era because dataset is so large
# run each portion separately. ie, wait until the Paleozoic dataset
# has downloaded before starting the Mesozoic download

Paleozoic <- pbdb_occurrences(
  base_name = "bivalvia",
  interval = "Paleozoic",
  show = c("coords", "classext"),
  vocab = "pbdb",
  limit = "all"
)

Mesozoic <- pbdb_occurrences(
  base_name = "bivalvia",
  interval = "Mesozoic",
  show = c("coords", "classext"),
  vocab = "pbdb",
  limit = "all"
)

Cenozoic <- pbdb_occurrences(
  base_name = "bivalvia",
  interval = "Cenozoic",
  show = c("coords", "classext"),
  vocab = "pbdb",
  limit = "all"
)

# the Mesozoic and Cenozoic sets need some cleaning
# remove a column called "flags" from each
Cenozoic$flags <- NULL
Mesozoic$flags <- NULL
````

Spend some time examining the three datasets, then answer the following questions on your answer sheet:

1. How many bivalve occurrences are there in Paleozoic era?
2. How many in the Mesozoic era?
3. How many in the Cenozoic era?
4. How many occurrences in total are there? Hint: just add up your previous three answers.

#### Step 2

Now let's combine our three datasets into one and clean it up. We will remove any occrrences that are not resolved to genus, and then remove any fossils that are poorly constrained by age.

````R
# combine datasets into one set called "Phanerozoic"
Phanerozoic <- rbind(Paleozoic, Mesozoic, Cenozoic)

# clean up bad genus names
Phanerozoic <- subset(Phanerozoic, complete.cases(genus))

# download a matrix of geologic epoch definitions and metadata
Epochs <- downloadTime(Timescale = "international epochs")

# remove poorly constrained fossils
Phanerozoic <- constrainAges(Phanerozoic,Epochs)
````

4. How many fossil occurrences are now contained in the Phanerozoic dataset?
5. How many fossil occurrences were removed due to poorly resolved taxonomy or age constraints?

#### Step 3

Let's turn our newly downloaded and cleaned PBDB data into a community matrix. A community matrix is one of the most fundamental data formats in ecology. In such a matrix, the rows represent different samples, the columns represent different taxa, and the cell valuess represent the abundance of the species in that sample. If you would like to read more about the theory behind community matrices, this is a good paper to start with: [Novak et al. 2016](https://www.annualreviews.org/doi/10.1146/annurev-ecolsys-032416-010215)

Here are a few things to remember about community matrices.

- Samples are sometimes called sites, collections, or quadrats, but those are sub-discipline specific terms that should be avoided. Stick with samples because it is universally applicable.
- The columns do not have to be species per se. Columns could be other levels of the Linnean Hierarchy (e.g., genera, families) or some other ecological grouping (e.g., different habits, different morphologies).
- Since there is no such thing as a negative abundance, there should be no negative data in a Community Matrix.
- Sometimes we may not have abundance data, in which case we can substitute presence-absence data - i.e, is the taxon present or absent in the sample. This is usually represented with a 0 for absent and a 1 for present.

Let's convert our PBDB dataset into a presence-absence dataset using the `presenceMatrix( )` function fo the PBDB package. This function requires that you define which column will count as samples. For now, let's use "`early_interval`" (i.e., geologic age) as the separator. Because we are using a large dataset, this set might take a few minutes.

````R
# create a presence matrix
PhanMatrix <- presenceMatrix(dataPBDB,
                               Rows = "early_interval",
                               Columns = "genus")
````

Next, we need to use `cullMatrix` to clean up this new matri and remove depauperate samples and rare taxa. We will set it so that a sample needs at least 24 reported taxa for us to consider it reliable, and each taxon must occur in at least 5 samples. These are common minimums for sample sizes in ordination analysis.

````R
# cull matrix
PhanMatrix <- cullMatrix(PhanMatrix,
                           Rarity = 5,
                           Richness = 24)
````

#### Step 4

Now let's actually get into the data! We'll start by generating a table that shows the number of bivalve genera in each geologic epoch:

````R
# create a simple function to build this table
taxaPerEpoch <- function(Data) {
  Blanklist <- apply(Data,1,sum)
  return(as.matrix(Blanklist))
}

# create the table
TaxaPerEpoch <- taxaPerEpoch(PhanMatrix)

# print the table
TaxaPerEpoch
````

6. Which epoch has the highest diversity?
7. Look at the epochs in the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time). What is the timeframe for that epoch? In other words, how long ago (in millions of years) did that epoch start and end?

Let's look a specific genus of bivalve, *Mytilus*. *Mytilus* is a common mussel. We can search the data to identify the epochs in which *Mytilus* occurred:

````R
which(PresencePBDB[,"Mytilus"] == 1)
````

8. Take another look at the [geologic timescale](https://en.wikipedia.org/wiki/Geologic_time_scale#Table_of_geologic_time). In which epochs can we infer that *Mytilus* was present, even though we have no record of them in the PBDB? How did you deduce this?

#### Step 5
#### Basic Similarity Indices

We covered the concept of similarity indices in Lab 6 (Community Paleoecology). In that lab, we calculated Bray-Curtis dissimilarity indices for our Ediacaran data set. Here we will use a different index, the **Jaccard Similarity Index**. It is one of the simplest similarity indices. It is the intersection of two samples divided by the union of two samples. In other words, the number of genera shared between two samples, divided by the total number of (unique) genera in both samples. Or, put an even simpler way, it is the percentage of genera shared between two samples.

We could calculate the Jaccard index for our data by hand using the following code:

````R
# Find the number of taxa present only in the Miocene
MioceneOnly <- length(which(PhanMatrix["Miocene",] == 1 & PhanMatrix["Pleistocene",] == 0))

# Then find the number of taxa present only in the Pleistocene
PleistoceneOnly <- length(which(PhanMatrix["Pleistocene",] == 1 & PhanMatrix["Miocene",] == 0))

# Then find the number of taxa that are present in both epochs
SharedTaxa <- length(which(PhanMatrix["Pleistocene",] == 1 & PhanMatrix["Miocene",] == 1))

# Finally, conduct the Jaccard similarity test
Jaccard1 <- SharedTaxa / (SharedTaxa + MioceneOnly + PleistoceneOnly)

Jaccard1
````

9. The value produced by the code above generates the Jaccard **similarity** index for the Miocene and Pleistocene. How would you turn that similarity index into a **dissimilarity** index? What value do you get?

Rather than calculating everything by hand, we could use a function called `vegdist` from a package called `vegan`. This automatically calculates the Jaccard **dissimilarity** index.

````R
# Turn the info returned by vegdist( ) into a more useful object, a matrix
Jaccard2 <- as.matrix(vegdist(PhanMatrix, method = "jaccard"))

# view the whole matrix
Jaccard2

# Find the location in the matrix at the intersection of the Miocene and Pleistocene
Jaccard2["Miocene","Pleistocene"]
````

10. What value was produced by `Jaccard2["Miocene","Pleistocene"]`?
11. Is that value the same as your answer for Question 9?

You can see why it's usually easier to find a package with functions that do the type of analysis you need than writing your own code!

If we want to use the Jaccard index to look at the whole Cenozoic, we can use a function to generate all the comparisons at once:

````R
# A function to isolate the Cenozoic data
CenozoicData <- function(PresencePBDB) {
     Paleocene <- PresencePBDB["Paleocene",]
     Eocene <- PresencePBDB["Eocene",]
     Oligocene <- PresencePBDB["Oligocene",]
     Miocene <- PresencePBDB["Miocene",]
     Pliocene <- PresencePBDB["Pliocene",]
     Pleistocene <- PresencePBDB["Pleistocene",] 
     NewFrame <- data.frame(Paleocene,Eocene,Oligocene,Miocene,Pliocene,Pleistocene)
     return(t(NewFrame))
 }

# run function, then use vegist() to calculate the Jaccard indices
Cenozoic <- CenozoicData(PresencePBDB)
vegdist(Cenozoic)
````

11. Which two Cenozoic epochs were the least similar?
12. What might explain that result?

# Part 2: Calculating Stratigraphic Ranges





