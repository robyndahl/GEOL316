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

## Step 2: Loading data
After you get to know the layout of R Studio, you're ready get to started on data analysis! The first step is to download all the packages that we will be using. Packages are open source programs or functions. The packages we will be using for this activity are called 'vegan', 'cluster', and 'paleotree'.

Now let's load in some data! There are different ways of doing this depending on where the data you want to load is located. To simplify things, we will be using datasets that are hosted here in this Github Repository.

