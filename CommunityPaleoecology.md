# Community Paleoecology

The first part of this lab should be completed on the worksheet handed out in class.

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
pokemonStand <- decostand(pokemon, method = "total")
````
