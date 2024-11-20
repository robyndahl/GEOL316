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
  show = c("coords", "classext", "paleoloc"),
  vocab = "pbdb",
  limit = "all"
)

Mesozoic <- pbdb_occurrences(
  base_name = "bivalvia",
  interval = "Mesozoic",
  show = c("coords", "classext", "paleoloc"),
  vocab = "pbdb",
  limit = "all"
)

Cenozoic <- pbdb_occurrences(
  base_name = "bivalvia",
  interval = "Cenozoic",
  show = c("coords", "classext", "paleoloc"),
  vocab = "pbdb",
  limit = "all"
)

# the Mesozoic and Cenozoic sets need some cleaning
# remove a column called "flags" from each
Cenozoic$flags <- NULL
Mesozoic$flags <- NULL
````

Spend some time examining the three datasets, then answer the following questions on your answer sheet:

1. How many bivalve occurrences are there in Paleozoic era? (hint, you can either ask to see the number of dimensions in this dataset using `dim(Paleozoic)` or look for how many rows or objects there are in the set)
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
PhanMatrix <- presenceMatrix(Phanerozoic,
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
which(PhanMatrix[,"Mytilus"] == 1)
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
CenozoicData <- function(Data) {
     Paleocene <- Data["Paleocene",]
     Eocene <- Data["Eocene",]
     Oligocene <- Data["Oligocene",]
     Miocene <- Data["Miocene",]
     Pliocene <- Data["Pliocene",]
     Pleistocene <- Data["Pleistocene",] 
     NewFrame <- data.frame(Paleocene,Eocene,Oligocene,Miocene,Pliocene,Pleistocene)
     return(t(NewFrame))
 }

# run function, then use vegist() to calculate the Jaccard indices
CenozoicOnly <- CenozoicData(PhanMatrix)
vegdist(CenozoicOnly, method = "jaccard")
````

11. Which two Cenozoic epochs were the least similar?
12. What might explain that result?

# Part 2: Calculating Stratigraphic Ranges

Calculating confidence intervals for the stratigraphic ranges of taxa.

## Basic Concepts

The easiest way to calculate the stratigraphic range of a fossil is to find the age of its oldest occurrence (sometimes called *First Occurrence*, **FO**) and its youngest occurrence (sometimes called *Last Occurrence*, **LO**).

Today we are going to exclusively focus on calculating confidence intervals for last occurrences (time of extinction), but the principles are the same for calculating confidence intervals on origination rates.

#### Step 1

For this part of the activity, we will use the `Cenozoic` dataset we generated early, which includes all bivalve occurrences from throughout the Cenozoic.

Take a minute to examine that dataset. There are four columns in `Cenozoic` relevant to the age of an organism: `early_interval`, `late_interval`, `max_ma`, and `min_ma`. Because we rarely have a precise date, we generally give the age of an occurrence as a range. This range can be expressed by interval names or by numbers.

13. What do the max_ma and min_ma columns of `Cenozoic` represent? If you do not intuitively know, you can always check the [Paleobiology Database API documentation](https://paleobiodb.org/data1.2/occs/list_doc.html). This document defines all possible data outputs from the PBDB.

We can use some simple coding to explore different aspects of the dataset. For example, we could figure out which genus has the most occurrences:

````R
max_genus <- max(table(Cenozoic$genus))

which(table(Cenozoic$genus) == max_genus)
````

14. Which genus has the most occurrences?
15. What kind of bivalve is that? (You can google the genus name)

With the information we collected in Question 4, we can determine the stratigraphic range of that taxon using the following. Note, you will need to substitue in the genus name where I have written `[GENUS]` in brackets (do not include the brackets).

````R
# first, separate out the data for [GENUS]
[GENUS] <- Cenozoic[which(Cenozoic$genus == "[GENUS]"),]

# then, determine the maximum and minimum age occurrences
max([GENUS]$max_ma)

min([GENUS]$min_ma)
````

16. What value did you get for the maximum age occurrence?
17. What value did you get for the minimum age occurrence?

## Confidence intervals

In statistics we like to measure uncertainty. We often do this with something called a **confidence interval**. Google defines a confidence interval as, "a range of values so defined that there is a specified probability that the value of a parameter lies within it." Under this definition, a 95% confidence interval ranging from 0-10, means that there is a 95% probability that the true value of the parameter we are measuring lies somewhere between 0 and 10.

This definition/interpretation of confidence intervals has received ***extensive criticism*** in recent years, though you may still see it presented in some textbooks that way. The criticism stems, partly, from a broader debate between two different statistical philosophies about the nature of probability. We will not dive into this debate, but I want you to be aware that *many* statisticians have a deep disapproval of the definition given above. Nevertheless, it is the one we will use moving forward for this lab exercise.

````R
# Subset the data so that we get the genus *Lucina*
Lucina <- subset(Cenozoic, Cenozoic$genus == "Lucina")

# Isolate the paleolatitude data, while also omitting any entries with missing data (NA)
PaleoLat <- na.omit(Lucina$paleolat)

# Find the mean paleolat of all Lucina occurrences.
> OriginalMean <- mean(PaleoLat)
> OriginalMean
