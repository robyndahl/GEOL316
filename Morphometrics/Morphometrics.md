# Geometric Morphometrics

## Part 1: Introduction

In this week’s lab, we will be learning about ***geometric morphometrics***, a method of studying organismal shape. Webster & Sheets (2010) provide an excellent introduction to the study and its utility within the field of paleontology. In their intro, they explain:

>Morphometrics is the quantitative study of biological shape, shape variation, and covariation of shape with other biotic or abiotic variables or factors. Such quantification introduces much-needed rigor into the description of and comparison between morphologies. Application of morphometric techniques therefore benefits any research field that depends upon comparative morphology: this includes systematics and evolutionary biology, biostratigraphy, and developmental biology (including studies of growth patterns within species, modularity, and evolutionary patterns such as heterochrony, etc.)
>
>Three general styles of morphometrics are often recognized, distinguished by the nature of data being analyzed. Traditional morphometrics involves summarizing morphology in terms of length measurements, ratios, or angles, that can be investigated individually (univariate analyses) or several at a time (bivariate and multivariate analyses). Landmark-based geometric morphometrics involves summarizing shape in terms of a landmark configuration (a constellation of discrete anatomical loci, each described by 2- or 3-dimensional Cartestian coordinates), and is inherently multidimensional. Outline-based geometric morphometrics involves summarizing the shape of open or closed curves (perimeters), typically without fixed landmarks.
>
>Geometric morphometrics (both landmark-based and outline) is powerful and popular because information regarding the spatial relationship among landmarks on the organism is contained within the data. This gives the ability to draw evocative diagrams of morphological transformations or differences, offering an immediate visualization of shape and the spatial localization of shape variation. Such graphical representation is easier to intuitively understand than a table of numbers.

### Learning Objectives

In this lab, you will learn how to collect 2D landmark data from photographs, how to conduct geometric morphometric analyes on those landmark data, and how to interpret your results. Our study organism for this lab will be trilobites and all of our data will be collected from photographs compiled by Serra et al. (2023) for [Trilomorph](https://github.com/balsedie/trilomorph), an open-access database for trilobite morphometrics.

### Software Requirements and Data

To complete this lab, you will need the following software:

+ R Studio: available on all campus computers, free to download at: [https://posit.co/downloads/](https://posit.co/downloads/)
+ FIJI: also known as ImageJ, free to download at: [https://fiji.sc/](https://fiji.sc/)
+ Datasets: all necessary datasets, include images for analysis, are available on Canvas.

## Part 2: Collecting 2D Landmark Data from Trilobite Specimens

The first step in morphometrics analysis is to collect landmark data from your specimens. We will be using a collection 18 trilobite photos and a landmark scheme developed by for the TriloMorph database. 

**STEP 1:** To begin, create a folder on the desktop of your computer called "Morphometrics". This will be your working directory for the lab, so all of your data and other files will need to be stored in that file. Next, download the collection of photos labeled `trilobites.zip`. Unzip the file and save it in your Morphometrics folder. Spend a few minutes reviewing the images so that you are familiar with the range of variation among the specimens.

**STEP 2:** Use FIJI to collect your landmark data. But first, some things to remember about collecting landmark data:

+ Each image must have the same number of landmarks
+ The landmarks on each image must be collected in the same order
+ Landmarks are ordinarly placed on homologous points, or points that can be replicated from object to object based on common morphology, common fuction, or common geometry. Luckily for you, I have already determined where the landmarks will be placed, so your main task is learning to identify those places on each of the specimens. The landmark scheme is illustrated and described below:



## Part 3: Utilizing the TriloMorph Dataset
To begin, let's install and load the necessary packages and scripts we will use to conduct our analysis. The research group at TriloMorph has developed the following set of scripts that automatically loads the required packages and functions neccesary. Copy, paste, and run this line in your R console:

````r
source("https://raw.githubusercontent.com/balsedie/trilomorph/main/TriloMorph-funs.R")
````

Now you can access the metadata for specimens included in the TriloMorph database. Do this by running the following:

````r
trilomorph_metadata <- yaml_read(file="https://raw.githubusercontent.com/balsedie/trilomorph/main/trilomorph.yaml")
````

Click `trilomorph_metadata` in the "Environment" tab of R Studio. This will open the file in the upper left window of your screen. Examine the file to familiarize yourself with the types of metadata included in this database. Then, run the following lines to help answer the questions below.

````r
# count the number of unique entries in each column of the data frame
apply(trilomorph_metadata, 2, function(x) length(unique(x)))
````

1. How many specimens are included in the database?
2. Determine the column that includes the publication information for each entry. How many different publications are referenced in the database?
3. The database includes detailed taxonomic information. How many unique genera of trilobites are included in the database?
4. The database also includes geographical information. How many different countries are represented?

## References

Serra et al. (2023) A dynamic and collaborative database for morphogeometric information of trilobites. Scientific Data, 10:841.

Webster, M. and H. D. Sheets (2010) A practical guide to landmark-based geometric morphometrics. The Paleontological Society Papers, 16:163-188.
