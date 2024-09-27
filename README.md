## Software and Platform

This project was developed using R Studio (version 4.4.1), alongside several key packages: dplyr, readr, tm, ggwordcloud, SentimentAnalysis, topicmodels, tidytext, ggplot2, transforEmotion, and ggpubr to perform data cleaning, text mining, sentiment analysis, topic modeling, significance testing and data visualization. Python alongside the Gemini API were used in the topic modeling portion of project. The project runs on both Windows and Mac platforms.

## Documentation Map
1. Data
   
     **[Original Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_original.csv)** 


     **[Clean Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_clean.csv)**


     **[Final Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_final.csv)**
   
1. Scripts
   
     **[Data Cleaning Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-DataCleaning.R)**

   
     **[Exploratory Data Analysis Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-EDA.R)**
   

     **[Sentiment and Topic Analysis, Zero Short Classification, and Significance Testing Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-Analysis.R)**

   
     **[Master Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-MasterAnalysis.R)**
   
3. Output

## Reproducing Results
To reproduce this work:

**Download R Studio(version 4.4.1 or higher)**

**Install and load packages and all dependencies**

**Read in original dataset(##Original Dataset) to be cleaned. Run data cleaning script(##Data Cleaning Script) and save clean data to be used in Exploratory Data Analysis**

**Load in clean data(##Clean Dataset), and run Exploratory Data Analysis data script(##Exploratory Data Analysis Script).**

**Using clean data still, run Analysis script(## Sentiment and Topic Analysis, Zero Short Classification, and Significance Testing Script).**


Preprocess data using tm package, and create document-term matrix setting sparsity to 0.965

Perform sentiment analysis and store results under a variable.

Perform topic modeling specifically using the LDA function, setting k= 5 and seed= 1234. K is the number of topics tokens in the document-term matrix will be grouped. Save results of topic model under a variable. This variable stores the probability of each token in the document-term matrix belonging to each of the 5 topics. 

After performing topic model, group tokens into topics they have the highest probability of belonging using the tidy function and the variable from topic modeling. Using tokens from each topic, categorise into themes using generative AI and cross-referencing with common themes in Taylor Swift lyrics.

Use results and generated themes from topic modeling process as classes in zero-shot classification in the transforEmotion package. Save results in variable. 

Merge results from sentiment analysis and zero-shot classification to clean dataset. This will be dataset to organize mean comparisons.



## References

[1] Data Centric Inc., “Tutorial on topic modelling in r tutorial,” YouTube, Nov. 21, 2021. 
https://www.youtube.com/watch?v=3ozjwHWf-6E (accessed Sep. 26, 2024).

[2] Early Chirp, “Exploring the Evolution of Taylor Swift Lyrics | Early Chirp | Medium,” Medium, May 06, 2024.
https://blog.earlychirp.com/taylor-swift-lyrics-58ae00d30a29

[3] S. Elizabeth, “All of Taylor Swift’s Album Eras and Their Distinctive Styles — Taylor Swift Midnights,” L’Officiel USA, Mar. 21, 2023.
https://www.lofficielusa.com/pop-culture/every-taylor-swift-album-era-style

[4]Stefan Feuerriegel, “SentimentAnalysis Vignette,” cran.r-project.org. 
https://cran.r-project.org/web/packages/SentimentAnalysis/vignettes/SentimentAnalysis.html

[5]“Topic Modeling with R,” ladal.edu.au.
https://ladal.edu.au/topicmodels.html
‌
‌
‌
