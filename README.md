## Software and Platform

This project was developed using R Studio (version 4.4.1), alongside several key packages: tm, SentimentAnalysis, transformEmotions, ggpubbr, topicmodels, tidytext, and dplyr to perform text mining, sentiment analysis, topic modeling, and data visualization. The project runs on both Windows and Mac platforms.

## Documentation Map:
1. Data
   
     **[Original Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_released.csv)**


     **[Clean Dataset]**


     **[Final Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_clean.csv)**
   
1. Scripts
   
     **[Processing Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwiftLyric-DataCleaning.R)**

   
     **[Analysis Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwiftLyric-Analysis.R)**

   
     **[Master Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwiftLyricAnalysis.R)**
   
2. Output

## Reproducing Results
To reproduce this work:
Download R Studio(version 4.4.1 or higher)

Install packages(listed above) and load packages 
Perform Exploratory Data Analysis 

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
