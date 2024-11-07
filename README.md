## Taylor Swift Lyrics Topic, Sentiment, and Emotional analysis 

This project aims to answer the question: Are there statistically significant differences(a=0.05, p<0.05) in the emotional themes and sentiments of Taylor Swift's lyrics over the years, reflecting changes as she has matured into adulthood?

 
 Emmanuella Cann, Caroline Hagood, Maggie Welch 


## Software and Platform

This project was developed using R Studio (version 4.4.1) and includes key functionalities such as data cleaning, text mining, sentiment analysis, topic modeling, statistical significance testing, and data visualization.A range of R packages were used to achieve these tasks:

- dplyr, readr: Data manipulation and cleaning
- tm, tidytext: Text mining
- topicmodels: Topic modeling
- ggplot2, ggwordcloud: Data visualization
- ggpubr: Significance Testing
- SentimentAnalysis, transforEmotion: Sentiment and emotion analysis

Additionally, Python and the Gemini API were integrated for more advanced topic modeling tasks. This project was designed and runs on both Windows and Mac.


## Documentation Map

LICENSE
This project is licensed under the MIT License - see the [LICENSE](https://github.com/cann-emma/DSProject1/blob/main/LICENSE) file for details.

1. Data
   - Data Appendix File
   - ts_discography_original.csv
   - ts_discography_clean.csv
   - ts_discography_final.csv
   - ts_topics.csv
   
2. Scripts
   - Processing Scripts
        - 01_TSwift-DataCleaning.R
     
   - Analysis Scripts
        - 02__TSwift-EDA.R
        - 03_TSwift-Analysis.R
        - 03_gemini-api.py
        - DataAppendixScript.R
          
   - Master Script
      - TSwift-MasterAnalysis.R
   
3. Output
   - Album_bar_cleandata.png
   - Confidence_Density.png
   - Confidence_Year_meancomp.jpeg
   - Desire_Density.png
   - Desire_Year_meancomp.jpeg
   - Hope_Density.png
   - Hope_Year_meancomp.jpeg
   - Loss_Density.png
   - Loss_Year_meancomp.jpeg
   - Love_Density.png
   - Love_Year_meancomp.jpeg
   - Lyric_freq.png
   - Nostalgia_Density.png
   - Nostalgia_Year_meancomp.jpeg
   - Reflection_Density.png
   - Reflection_Year_meancomp.jpeg
   - Resilience_Density.png
   - Resilience_Year_meancomp.jpeg
   - SDAP_Density.png
   - SDAP_Year_meancomp.jpeg
   - SignificanceResults.csv
   - Song per Album.png
   - Sorrow_Density.png
   - Sorrow_Year_meancomp.jpeg
   - Topics_plot.jpeg
   - year_hist.png
     

## Reproducing Results
To reproduce this work:

- Download [R Studio](https://cran.r-project.org/)(version 4.4.1 or higher)
  
- Fork this repository, then clone forked repository in terminal of workspace

- Install and load packages and all dependencies

- Read in [Original Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_original.csv) to be cleaned. Run [Data Cleaning script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-DataCleaning.R) and save clean data to be used in Exploratory Data Analysis

- Load in [Clean Dataset](https://github.com/cann-emma/DSProject1/blob/main/data/ts_discography_clean.csv), and run [Exploratory Data Analysis script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-EDA.R)

- Using clean data still, run [Analysis script](https://github.com/cann-emma/DSProject1/blob/main/scripts/TSwift-Analysis.R). Before zero-shot classification, run [Python and Gemini Api Script](https://github.com/cann-emma/DSProject1/blob/main/scripts/03_gemini-api.py) using [sorted beta dataframe](https://github.com/cann-emma/DSProject1/blob/main/data/ts_topics.csv)

- Run remaining Analysis code after topic modeling. This should be zero-shot classification and onward

**Note:** Using a generative AI tool, the response generated after running python and gemini api script may vary

## References

[1] Data Centric Inc., “Tutorial on topic modelling in r tutorial,” YouTube, Nov. 21, 2021. 
https://www.youtube.com/watch?v=3ozjwHWf-6E (accessed Sep. 26, 2024).

[2] Early Chirp, “Exploring the Evolution of Taylor Swift Lyrics | Early Chirp | Medium,” Medium, May 06, 2024.
https://blog.earlychirp.com/taylor-swift-lyrics-58ae00d30a29

[3] “Gemini API | Google AI Studio | Google for Developers  |  Google AI for Developers,” Google AI for Developers, 2024. https://ai.google.dev/gemini-api?gad_source=5&gclid=EAIaIQobChMI5P-c_LTeiAMVMlFHAR3y3DCEEAAYASAAEgJVCvD_BwE (accessed Sep. 27, 2024).

[4] M. Clark, “Taylor Swift - Released Song Discography (Genius),” Kaggle.com, 2024. https://www.kaggle.com/datasets/madroscla/taylor-swift-released-song-discography-genius (accessed Sep. 29, 2024).
‌

[5] S. Elizabeth, “All of Taylor Swift’s Album Eras and Their Distinctive Styles — Taylor Swift Midnights,” L’Officiel USA, Mar. 21, 2023.
https://www.lofficielusa.com/pop-culture/every-taylor-swift-album-era-style

[6] Stefan Feuerriegel, “SentimentAnalysis Vignette,” cran.r-project.org. 
https://cran.r-project.org/web/packages/SentimentAnalysis/vignettes/SentimentAnalysis.html

[7] “Topic Modeling with R,” ladal.edu.au.
https://ladal.edu.au/topicmodels.html
‌
‌
‌
