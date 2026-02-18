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

The first step in morphometrics analysis is to collect landmark data from your specimens. We will be using a collection 18 trilobite photos and a landmark scheme developed for the TriloMorph database. 

**STEP 1:** To begin, create a folder on the desktop of your computer called "Morphometrics". This will be your working directory for the lab, so all of your data and other files will need to be stored in that file. Next, download the collection of photos labeled `trilobites.zip`. Unzip the file and save it in your Morphometrics folder. Spend a few minutes reviewing the images so that you are familiar with the range of variation among the specimens.

**STEP 2:** Use FIJI to collect your landmark data. But first, some things to remember about collecting landmark data:

+ Each image must have the same number of landmarks
+ The landmarks on each image must be collected in the same order
+ Landmarks are ordinarly placed on homologous points, or points that can be replicated from object to object based on common morphology, common fuction, or common geometry. Luckily for you, I have already determined where the landmarks will be placed, so your main task is learning to identify those places on each of the specimens. The landmark scheme is illustrated and described below.

**Description of Landmarks**
| Landmark | Description                                                      |
|----------| -----------------------------------------------------------------|
| LM1      | Anteriormost point of the saggital cephalic length without spine |
| LM2      | Anteriormost point of the saggital glabellar length              |
| LM3      | Intersection between the saggital axis and the occipital furrow  |
| LM4      | Posteriormost point of the saggital cephalic length              |
| LM5      | Maximum transversal glabellar width |
| LM6      | Intersection between the occipital and axial furrows |
| LM7      | Intersection between the posterior margin and the axial furrow |
| LM8      | Anteriormost end of the eye |
| LM9      | Poseriormost end of the eye |
| LM10     | Anterior facial sutuer at the saggital line |
| LM11     | Intersection between the posterior branch of facial suture and the posterior or lateral border furrow |
| LM12     | Intersection between the posterior branch of facial suture and the posterior or lateral margin |
| LM13     | Anteriormost point of the saggital (or ex-saggital) cephalic length (if spiny, LM13 is at the tip of the spine) |
| LM14     | Lateralmost external point of the eye |
| LM15     | Cephalic width at the level of the posterior margin of the occipital ring (LM4). If that point cannot be located, it is defined as the extreme of the genal angel. |
| LM16     | Tip of the genal angle or spine |

Use the landmark descriptions in the table above along with the diagrams below to place your landmarks. This will likely take some time and will require you to become intimately familiar with the morphology of trilobite cephala (heads). You can also use the morphology diagrams of the [whole body](https://www.trilobites.info/trilomorph.htm) and the [cephalon](https://www.trilobites.info/cephalon.htm) on [this trilobite website](https://www.trilobites.info/) to help determine where to place your landmarks.

**Figure 1:** Diagram of landmark scheme illustrated on three different trilobites
![Figure1](/Morphometrics/Serra_et_al_Fig2.png)

**Figure 2:** Another diagram of landmark scheme
![Figure2](/Morphometrics/Serra_et_al_Fig3.png)

To collect your landmark data, open the first image in your images folder in FIJI. Use the multipoint collector tool to place the landmarks on the image. Remember, you *must* place them in numerical order (1-16). If you need to move a landmark after you place it, you can just click and drag the point. Once you have placed all 16 landmarks, use **CTRL-M** to record them in the measurement window (a spreadsheet that will populate with all of your data as you collect from each image). FIJI will collected more information than we are interested in, and you don't need to pay any attention to the first four columns on the sheet (Area, Mean, Min, Max). We are only interested in the cartesian coordinates of our landmarks (X, Y). When you are done with your first image, use CTRL-SHIFT-O to open the next image. Repeat until you have collected landmark data from all 30 images.

**STEP 3:** When you have collected landmark data for all of the images, copy and paste the data from the FIJI measurements into Excel. We need to format this spreadsheet so that it can be saved as a `.tps` file that can be used by the `geomorph` R package. To do this, insert blank rows before and after the block of rows for each specimen. Above the x-coordinate, enter the text `LM=16`. Below the x-coordinate, enter the text `ID=` follwed by the specimen number (e.g., `ID=1` or `ID=11`). Your spreadsheet should end up looking something like this:

![Figure3](/Morphometrics/Spreadsheet.png)

To save this as a `.tps` file, highlight the two columns your coordinate data (columns F & G in the example picture) and copy. In Word, use `Paste Special` to paste the data as **unformatted text**. Some programs don't like tab characters, which are inserted by default when you paste from Excel. Remove them with `Edit > Find > Advanced Replace` and `Replace`. To do this, click the arrow in the lower left to show options. Click the "replace" tab at the top to open both Find and Replace input bars. Enter `^t` in the "Find What" bar and enter a single space in the "Replace With" bar. Click `Replace All`.

Save your file as **plain text** called `trilobites.txt` in the r directory on the computer you are working on.

**STEP 4:** Analyze the data in R using the `geomorph` package

Open R Studio and run the following script:

````r
# check if you need to install necessary packages
if (!any(installed.packages()[, 1] == "geomorph")) {
  install.packages("geomorph") }
if (!any(installed.packages()[, 1] == "tidyverse")) {
  install.packages("tidyverse") }

# load packages
library(geomorph)
librayr(tidyverse)

# load in your data
trilobites <- readland.tps("trilobites.txt", specID = "ID")
````

Great, now your data is loaded and ready to be analyzed! The first analysis we want to conduct is a **Generalized Procrustes Analysis** or GPA. Here is an GPA explainer from Sherratt (2014):

>Generalized Procrustes Analysis (GPA: Gower 1975; Rohlf and Slice 1990) is the primary means by which shape variables are obtained from landmark data. GPA translates all specimens to the origin, scales them to unit-centroid size, and optimally rotates them (using a least-squares criterion) until the coordinates of corresponding points align as closely as possible. The resulting aligned Procrustes coordinates represent the shape of each specimen, and are found in a curved space related to Kendall's shape space (Kendall 1984). Typically, these are projected into a linear tangent space yielding Kendall's tangent space coordinates (Dyrden and Mardia 1993; Rohlf 1999), which are used for subsequent multivariate analyses.

To conduct a GPA on your data, complete the following:

````r
# run the generalized procrustes analysis to align your specimens
triloGPA <- gpagen(trilobites)

# view the GPA results
triloGPA
````

**Questions**

 1. Copy and paste the GPA results into your lab report.
 2. What do you think the X-Y coordinates refer to?

Let's plot the GPA to see what our aligned data looks like

````r
plot(triloGPA)
````
**Questions**

 3. Add this plot to your lab report.
 4. Examine the plot. What does this information visualize? What do you think the large black points represent? What about the smaller gray points?

**STEP 5:** Now we will use `geomorph` to conduct a **Principal Components Analysis** or PCA. For a quick explanation of PCA, we can turn to Foote & Miller:

>**Ordination of Specimens:** One of the main uses of multivariate analysis is the facilitate visual inspection of data. In a bivariate plot, it is easy to see which specimens are most similar, how specimens differ, how the data trend, and so on. To do the same with multivariate data requires an **ordination** -- a representation of the position of the specimens relative to on another. One of the most widely employed methods to achieve this goal is PCA. In the figure above, Figure 3.12c shows the same hypothetical data as figure 3.12a. The points have simply been rotated so that the major and minor axes running through the data in Figure 3.12a are now in the same direction as the new x and y axes of Figure 3.12c. The direction of the major axis is the direction of maximal dispersion in the data and defines the first principal component. There is still residual variation around the axis, indicated by the minor axis that is perpendicular to the first axis. The minor axis defines the second principal component.
>
>The method of principal components extends to any number of dimensions. Each successive axis is always perpendicular to all the previous ones, and it runs in the direction of maximal remaining dispersion around the previous axes. The position of each specimen along a particular principal-component axis is referred to as its score on that axis. The length of each axis tells how much variance in the data is acounted for by the corresponding principal component; it is expressed by a number called the eigenvalue.

To conduct and plot PCA in R:

````r
# run PCA on the GPA data
triloPCA <- gm.prcomp(triloGPA$coords)

# view the results
triloPCA
````

**Questions**

5. Copy and paste the results of your PCA into your lab report.
6. Examine the PCA results. What is the proportion of variance for principal component 1 (PC1)?
7. What is the proportion of variance for PC2?
8. Think about the information that is being given for each principle component. What is the cumulative proportion of variance accounted for by PC1 and PC2?
9. Usually most of the variance in an analysis like this accounted for by the first 4 or 5 PCs. What is the cumulative proportion of variance accounted for by PC5?

You can also view the information above as a histogram. This type of plot is called a Scree plot and is very useful for understanding the distribution of the shape variance in the different PCs. To create this plot, run the following:

````r
# create barplot of proportion of variance
barplot(triloPCA$sdev^2/sum(triloPCA$sdev^2))
````

**Questions**

10. Add the barplot to your lab report.
11. Is there a single dominant PC axis (one PC axis that accounts for much more variation than any other)? Or are there two or three PC axes that are similar and account for most of the variation?

Now let's plot the PCA. You can view a very basic PCA plot using `plot(triloPCA` but you will have a tough time analyzing it unless you add some additional information. Let's load in the specimen information and use that to make the PCA plot more informative:

````r
# load specimen info
trilo.info <- read.csv("lab_specimens.csv", header = T)

# create a new data file (tibble) that is easier to plot
triloTIB <- as_tibble(triloPCA$x)

triloTIB <- mutate(triloTIB,
                   ID = trilo.info$Specimen,
                   Family = trilo.info$Family,
                   Genus = trilo.info$Genus,
                   Age = trilo.info$Age)

# plot the PCA with ID labels and taxonomy
ggplot(triloTIB, aes(Comp1, Comp2, label = ID)) +
  geom_point(aes(color = Family), size = 3) +
  geom_text(hjust=-0.75, vjust=0.5) +
  xlab("Principal Component 1") +
  ylab("Principal Component 2") +
  theme_bw()
````

**Questions**

12. Add the PCA plot to your lab report.
13. Is there any obvious grouping in the data? In other words, do specimens of the same family plot close to each other?
14. Which two individual specimens vary the most along the PC1 axis? To figure this out, you should identify the two most distant specimens along the x-axis, regardless of where they plot on the y-axis.
15. View `triloTIB` to see more information about the two specimens you chose for Question 14. List their family, genus, and age.
16. Which two individual specimens vary the most along the PC2 axis?
17. List the family, genus, and age for the two specimens you selected for Question 16.

Now let’s examine how shape actually varies along these two axes. To do this, you will generate two plots that illustrate how landmarks vary between the two endmembers of a given principal component. Use the following script to do this.

````r
# first, generate a plot for the reference specimen
# this plot is built from the centroid points for each landmark
ref <- mshape(triloGPA$coords)

# next, compare the two most different specimens along PC1 to the reference specimen
par(mfrow = c(1,3))
plotRefToTarge(ref, triloPCA$shapes$shapes.comp1$min, method = "points")
plotRefToTarge(ref, ref, method = "points")
plotRefToTarge(ref, triloPCA$shapes$shapes.comp1$max, method = "points")

# finally, compare the two most different specimens along PC2
par(mfrow = c(1,3))
plotRefToTarge(ref, triloPCA$shapes$shapes.comp2$min, method = "points")
plotRefToTarge(ref, ref, method = "points")
plotRefToTarge(ref, triloPCA$shapes$shapes.comp2$max, method = "points")
````

**Questions**

18. Add the three-panel plot for the PC1 comparison to your lab report.
19. Which landmarks are changing the most across PC1?
20. Add the three-panel plot for the PC2 comparison to your lab report.
21. Which landmarks are changing the most across PC2?

## Part 3: Utilizing the TriloMorph Database

For this final part of the lab, we will use the TriloMorph database to examine how morphometrics can be used to study evolution. We will focus on Devonian Trilobites. To begin, download the landmark file from Canvas. Place the unzipped folder (called "landmarks") in your Morphometrics folder. Next, run the following script. There are some lines in the script that will take a few moments to run, so I've broken this into chunks with some explanation of what the script is doing included throughout.

````r
# .: Check and load the required libraries (package citations at end of script).
# These various packages must be installed prior to the following analyses.
# First, we check if they are installed
# if not installed, we automatically set the installation (internet connection required):
if (!any(installed.packages()[, 1] == "geomorph")) {
  install.packages("geomorph") }

if (!any(installed.packages()[, 1] == "StereoMorph")) {
  install.packages("StereoMorph") }

if (!any(installed.packages()[, 1] == "data.table")) {
  install.packages("data.table") }

if (!any(installed.packages()[, 1] == "vegan")) {
  install.packages("vegan") }

# Load all required packages
library(geomorph)     # for landmark analyses (Adams & Otárola-Castillo 2013)
library(StereoMorph)  # for landmark acquisition (Olsen & Westneat 2015)
library(data.table)   # for data handling
library(vegan)        # for analysis of multivariate dispersion

# Source additional functions used in this study (internet connection required).
source("https://raw.githubusercontent.com/balsedie/trilomorph/main/TriloMorph-funs.R")

# .: Paths to Trilomorph metadata and PBDB occurrence dataset
fdat <- "https://raw.githubusercontent.com/balsedie/trilomorph/main/trilomorph.yaml"
focs <- (paste0("https://paleobiodb.org/data1.2/occs/list.csv?", 
                "base_name=Trilobita&",
                "interval=Lochkovian,Famennian&",  # bottom, top
                "show=class,coords,loc,refattr&",  #information retrieved
                "occs_created_before=2023-3-27")) # stable data set

# .: Assume that data have the following names and are in the following folders:
# Keep in mind that most computer systems are not case sensitive.
dirlm <- "landmarks"
if(!file.exists(dirlm)) stop("expected folder of landmark datafiles is missing")

# .: Set the expected template of landmarks for this analysis.
# Template = number of dimensions, number of landmarks, number of semilandmarks for the first curve, ...
# As described in the paper, cephala have 16 landmarks and four curves of semilandmarks.
# Expected order of the curves: glabella, facial suture, anterior margin, and posterior margin (for details see the published article).
nlms <- list(dim = 2, #dimensions (2d)
             lm = c(1:16), #vector of desired fixed landmark configuration
             cv = c("glabella","suture","anterior","posterior"), #names or numbers of desired curves
             cvs.lm = c(12, 20, 20, 20), #number of subsampled semilandmarks in each curve
             curves.id = c("cephalon") #names of maximum number of curves in the dataset
             )
````

At this point, you should have the following listed in your R Studio Environment pane:

+ nlms
+ dirlm
+ fdat
+ focs
+ Several functions (from `shapFix` to `yaml_read`)

Now you can begin actually download data from TriloMorph and the Paleobiology Database. Run the following script to load trilobite specimen metadata:

````r
# .: Load the 'TriloMorph' CSV-formatted file containing the contextual information of considered specimens.
# The database is, indeed, a collection of data files overseen by a main table designed to contain specimen-level traits for considered taxa.
# The basic unit of entry in this main table is that of a specimen with a unique alphanumeric identifier (ID).
# It is accompanied by contextual characteristics such as the publication reference,
#   taxonomic information, relevant morphological information, geographic context, and stratigraphic information (internet connection required).
trilos <- yaml_read(file = fdat, flat = TRUE)
trilos <- trilos[which(trilos$morphology.cephalon),]  # as indicated above, keep only cephala
trilos$taxonomy.genus <- trimws(trilos$taxonomy.genus)
````

View the trilobite metadata by clicking on `trilos` in the Environment pane. Spend a moment familiarizing yourself with the types of data included.

**Questions**

22. How many specimens are included in the database? This is indicated by the number of objects (`obs.`) in the dataframe.
23. Determine the column that includes the publication information for each entry. How many different publications are referenced in the database? You can quickly calculate this by using `length(unique(trilos$ref.pic))`
24. The database includes detailed taxonomic information. How many unique genera of trilobites are included in the database? See if you can alter the code from Question 23 to calculate this.
25. The database also includes geographical information. How many different countries are represented?

Next we will download some trilobite occurrence data from the Paleobiology Database.

````r
# .: Load an occurrence dataset of Devonian trilobites (internet connection required).
# Occurrence data are downloaded from https://paleobiodb.org/ (for details see file's header).
occs <- fread(focs, na.strings="")

# Because this illustrative case study focus at the genus rank, ...
# ... unknown occurrences at the genus level are removed,
# ... and subgenus information is removed.
occs <- occs[!is.na(occs$genus),]
occs$genus <- sapply(occs$genus, function(x) unlist(strsplit(x, " ", fixed=T))[1])

# .: Reconstruct the taxon-by-time (genus/stage) incidence matrix of Devonian trilobites
# by collating and processing these two datasets (both contain occurrences not present in the other one).
# ..: Set chronostratigraphic data from the ICS (https://stratigraphy.org/).
xt <- c(419.2, 410.8, 407.6, 393.3, 387.7, 382.7, 372.2, 358.9)
stages <- c("Lochkovian", "Pragian", "Emsian", "Eifelian", "Givetian", "Frasnian", "Famennian")
colages <- setNames(c("#E5B75A", "#E5C468", "#E5D075", "#F1D576", "#F1E185", "#F2EDAD", "#F2EDC5"), stages)
gn_all <- sort(unique(c(occs$genus, trilos$taxonomy.genus)))
# ..: Compile occurrences of each genus in each stage.
ocms <- matrix(0L, nrow = length(gn_all), ncol = length(stages),
  dimnames = list(gn_all, stages))
for(s in gn_all) for(t in stages) {
  dx <- occs[(occs$genus == s) & (occs$early_interval == t),]
  if(nrow(dx) > 0) ocms[s,t] <- 1
  dy <- trilos[(trilos$taxonomy.genus == s) & (trilos$stratigraphy.min_age == t),]
  if(nrow(dy) > 0) ocms[s,t] <- 1
}

# ..: Remove taxa without Devonian occurrences and then fill ranges with gaps.
ocms <- ocms[(rowSums(ocms) > 0),]
fads <- apply(ocms, 1, function(x) min(which(x > 0)))
lads <- apply(ocms, 1, function(x) max(which(x > 0)))
for(i in 1:nrow(ocms)) ocms[i,fads[i]:lads[i]] <- 1
````

View the trilobite occurrence data by clicking on `occs` in the Environment pane. Spend a moment familiarizing yourself with the types of data included.

**Questions**

26. How many trilobite occurrences are included in this dataset?
27. How many genera are included? (hint: use an altered version of the code from Question 23)

Finally, let's load in the morphometric data:

````r
# Then, load and filter the geomorphometric data for selected genera.
# The loading and processing of the landmark data consist in:
# - Load and parse landmark data of each specimen and store them in a named list.
# - Remove specimen with a landmark scheme not compatible with the provided template (e.g. remove specimens with missing landmarks).
# - Possibly resample semilandmark curves to the submitted template.
# - Collapse all data to the standard 3D array (see Claude 2008).

# .: Spot genera having a landmarked specimen in the TriloMorph database
# and recorded in this incidence matrix.
trilos <- trilos[(trilos$taxonomy.genus %in% rownames(ocms)),]

# .: Load geomorphometric data of these specimens.
fids <- trilos$ID
str(fids)
if(any(duplicated(tolower(fids)))) stop("IDs are not unique as expected : ",
  toString(fids[duplicated(tolower(fids))]))

# .: Load and parse the landmark datafiles.
lmks <- shapRead(fids, sufix = "_C", subdir = dirlm)

# Filter and fit loaded configurations to the submitted template.
ldks <- shapFix(lmks, nlms)
````

At this point, we've loaded a ton of data but it's not easily viewable. The new data files in Environment pane are:

+ lmks - a list (a type of file that includes multiple types of data) that compiles all the landmark data
+ nlms - a list that describes the "curved" landmark data (also known as "semilandmarks"). Note that we did not collect any semilandmarks in the earlier part of this lab.
+ occs - a dataframe of Devonian trilobite occurrences (from the Paleobiology Database)
+ ocms - a occurrence matrix that shows trilobite genera occurrences by geologic age
+ trilos - a dataframe of trilobite specimen metadata from the TriloMorph database

Now we're finally ready to conduct the morphometric analysis!

````r
# .: Superimpose by GPA.
gpan <- geomorph::gpagen(ldks, Proj = TRUE, PrinAxes = FALSE)

# .: Plot the aligned configurations and the mean shape (consensus).
dev.new()
geomorph::plotAllSpecimens(gpan$coords)
title("aligned configurations and consensus")
mtext(paste0("n = ", dim(gpan$coords)[3]), side = 3, adj = 1, font = 3)
````

Just like in the earlier part of this lab, the plot of GPA is not very useful. Let's do a principal components analysis:

````r
# .: Run the PCA
pcan <- geomorph::gm.prcomp(gpan$coords)

# view the PCA summary
pcan

# plot the PCA
geomorph:::plot.gm.prcomp(pcan, main = "PCA-based morphospace", pch = 21, bg = "lightgray", cex = 1.5)
mtext(paste0("n = ", nrow(pcan$x)), side = 3, adj = 1, font = 3)
````

**Questions**

28. Copy and past the first portion of the PCA summary into your lab report. This should include the summary and the "Importance of Components" for the first five principal components.
29. How much variation is accounted for by PC1? How about PC2?
30. What is the cumulative variance accounted for by PC1 through PC5?
31. Add the PCA plot to your lab report.

Let's break the PCA plot down by geologic age, to see if there are any trends or patterns in morphospace occupation throughout the Devonian. The following script will create an array of seven plots that show specimens for each geologic age, from the Lochkovian (419.2 Ma) to the Famennian (358.9 Ma).

````r
# .: Several morphological disparity metrics exist (see Guillerme et al. 2020).
# Here, for illustration, we simply compute the most common measure used in palaeobiology:
#   the sum of variances (SOV; Foote 1992).
# Here, compute a value for each Devonian stage.
ysov <- ylow <- yup <- yrng <- ylmk <- setNames(integer(length(stages)), stages)
par(mfrow = c(3,3))
for(s in stages) {
  # Get list of genera occurring in the current stage.
  gens <- rownames(ocms)[ocms[,s] > 0]
  yrng[s] <- length(gens)
  # Match this list with the landmarked specimens of the TriloMorph DataBase.
  k <- (trilos$taxonomy.genus %in% gens)
  tids <- trilos$ID[k]
  ylmk[s] <- length(unique(trilos$taxonomy.genus[k]))
  # Show them on the morphospace.
  k <- which(rownames(pcan$x) %in% tids)
  plot(pcan$x[,1:2], asp = 1, main = s, xlab = "", ylab = "", xaxt = "n", yaxt = "n",
    pch = replace(rep(4, nrow(pcan$x)), k, 21),
    bg = replace(rep(NA_character_, nrow(pcan$x)), k, colages[s]),
    cex = replace(rep(0.5, nrow(pcan$x)), k, 2))
  mtext(paste0("n = ", length(k)), side = 3, adj = 1, font = 3)
  # Compute their morphological disparity (SOV).
  ysov[s] <- y <- shapSumVar(pcan$x[k,])
  ylow[s] <- attr(y,"ci")[1]
  yup[s] <- attr(y,"ci")[2]
}
par(mfrow = c(1,1))
````

**Questions**

32. Describe any trends that you see in morphospace occupation throughout the Devonian.

Remember that morphological diversity is also called "disparity". We can use the datasets we have already generated to compare how taxonomic diversity and disparity changed throughout the Devonian. The following script will create a plot that compares total taxonomic diversity (from Paleobiology Database data) to disparity. This will allow you to check your answer to Question 32.

````r
# .: Plot diversities through time (taxonomic richness and morphological disparity).
x <- xt[1:(length(xt)-1)] + diff(xt)
par(mfrow = c(2,1))
plot(x, yrng, type = "b", xlim = rev(range(xt)), ylim = c(0, extendrange(yrng)[2]),
  main = "taxonomic diversity", ylab = "genus richness", xlab = "geological time (Ma)")
points(x, ylmk, col = "red", pch = "+")
lines(x, ylmk, col = "red", lty = 3)
legend("topright", c("known Devonian taxa","landmarked taxa"), col = c("black", "red"),
  pch = c("o", "+"), lty = c(1, 3), ncol = 1)
plot(x, ysov, type = "b", xlim = rev(range(xt)), ylim = extendrange(c(ysov, ylow, yup)),
  main = "morphological disparity", ylab = "sum of variances", xlab = "geological time (Ma)")
segments(x, ylow, x, yup)
par(mfrow = c(1,1))
````

**Questions**

33. Add the plot of diversity and disparity to your lab report.
34. How did trilobite disparity change throughout the Devonian?
35. How did trilobite taxonomic diversity change throughout the Devonian?
36. Do you think that diversity and disparity are related in this case?

## References

Serra et al. (2023) A dynamic and collaborative database for morphogeometric information of trilobites. Scientific Data, 10:841.

Webster, M. and H. D. Sheets (2010) A practical guide to landmark-based geometric morphometrics. The Paleontological Society Papers, 16:163-188.
