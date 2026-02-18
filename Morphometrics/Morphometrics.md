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

Save your file as **plain text** called "trilobites.txt" in the r directory on the computer you are working on.

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
