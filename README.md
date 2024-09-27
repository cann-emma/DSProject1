## Software and Platform

This project was developed using R Studio (v4.4.1) and includes key functionalities such as data cleaning, text mining, sentiment analysis, topic modeling, statistical significance testing, and data visualization.A range of R packages were used to achieve these tasks:

- dplyr, readr: Data manipulation and cleaning
- tm, tidytext: Text mining
- topicmodels: Topic modeling
- ggplot2, ggwordcloud: Data visualization
- ggpubr: Significance Testing
- SentimentAnalysis, transforEmotion: Sentiment and emotion analysis

Additionally, Python and the Gemini API were integrated for more advanced topic modeling tasks. This project was designed and runs on both Windows and Mac.

## Documentation Map
1. Data
   
     - [Original Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_original.csv) 


     - [Clean Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_clean.csv)


     - [Final Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_final.csv)
   
2. Scripts
   
     - [Data Cleaning Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/01_TSwift-DataCleaning.R)

   
     - [Exploratory Data Analysis Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/02_TSwift-EDA.R)
   

     - [Sentiment and Topic Analysis, Zero Short Classification, and Significance Testing Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/03_TSwift-Analysis.R)
  
     - [Python and Gemini Api Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/03_gemini-api.py)

   
     - [Master Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-MasterAnalysis.R)
   
3. Output

   - [Output Files](https://github.com/cann-emma/DSProject1/tree/main/output)

## Reproducing Results
To reproduce this work:

- Download [R Studio](https://cran.r-project.org/)(version 4.4.1 or higher)

- Install and load packages and all dependencies

- Read in [Original Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_original.csv) to be cleaned. Run [Data Cleaning script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-DataCleaning.R) and save clean data to be used in Exploratory Data Analysis

- Load in [Clean Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_clean.csv), and run [Exploratory Data Analysis script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-EDA.R)

- Using clean data still, run [Analysis script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-Analysis.R)

**Or:** clone this repository and follow steps above


## References

[1] Data Centric Inc., “Tutorial on topic modelling in r tutorial,” YouTube, Nov. 21, 2021. 
https://www.youtube.com/watch?v=3ozjwHWf-6E (accessed Sep. 26, 2024).

[2] Early Chirp, “Exploring the Evolution of Taylor Swift Lyrics | Early Chirp | Medium,” Medium, May 06, 2024.
https://blog.earlychirp.com/taylor-swift-lyrics-58ae00d30a29

[3]“Gemini API | Google AI Studio | Google for Developers  |  Google AI for Developers,” Google AI for Developers, 2024. https://ai.google.dev/gemini-api?gad_source=5&gclid=EAIaIQobChMI5P-c_LTeiAMVMlFHAR3y3DCEEAAYASAAEgJVCvD_BwE (accessed Sep. 27, 2024).
‌
[4] S. Elizabeth, “All of Taylor Swift’s Album Eras and Their Distinctive Styles — Taylor Swift Midnights,” L’Officiel USA, Mar. 21, 2023.
https://www.lofficielusa.com/pop-culture/every-taylor-swift-album-era-style

[5] Stefan Feuerriegel, “SentimentAnalysis Vignette,” cran.r-project.org. 
https://cran.r-project.org/web/packages/SentimentAnalysis/vignettes/SentimentAnalysis.html

[5] “Topic Modeling with R,” ladal.edu.au.
https://ladal.edu.au/topicmodels.html
‌
‌
‌
