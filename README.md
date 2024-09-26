## Software and Platform
Software: R Studio(4.4.1) 
Packages: [tm, SentimentAnalysis, transforEmotions, ggpubbr, topicmodels, tidytext, dplyr] 
Platforms: [Windows and Mac]

## Documentation Map:
1. Our project utilizes a dataset titled 'ts_discography_clean.csv', which contains a cleaned version of Taylor Swift's complete distography, which we also have under the file titled, 'ts_discography_released.csv' The dataset has been refined to eliminate multiple releases of the same song. This step was necessary due to the unique nature of her distography, where many songs have been re-released as part of her protest for artist rights, following the sale of her original masters without her consent. For the purpose of oour analysis, we have excluded these re-releases to ensure that the sentiment analysis relfects the emotional tone adn lyrical intent at the time of the songs' original release, providing a more accurate representation of her evolving mindset.  
2. [script]
3. [output]

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

