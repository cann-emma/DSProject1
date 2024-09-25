## PACKAGES
library(dplyr)
library(readr)
library(ggpubr)
library(tm)
library(ggwordcloud)
library(SentimentAnalysis)
library(topicmodels)
library(ggplot2)
library(tidytext)
library(transforEmotion)

## PRELIMINARY ANALYSIS
ts_discography_released <- read_csv("/Users/carolinehagood/Desktop/ts_discography_clean.csv")
Swift_final<- ts_discography_released%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
head(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date)
Swift_final$year<- substr(Swift_final$date, 1, 4)
max(Swift_final$year) # 2024
min(Swift_final$year) # 2006


# Pre-Processing
usableText<- function(x) stringr::str_replace_all(x, "[^[:graph:]]", " ")
corpus<- Corpus(VectorSource(Swift_final$text))
corpus<- tm_map(corpus, usableText)
corpus<- tm_map(corpus, tolower)
corpus<- tm_map(corpus, removePunctuation)
corpus<- tm_map(corpus, removeNumbers)
corpus<- tm_map(corpus, removeWords, stopwords("english"))

dtm<- DocumentTermMatrix(corpus)
dtm  
dtm1<- removeSparseTerms(dtm, sparse = 0.965)
dtm1
dtm.df<- as.data.frame(as.matrix(dtm1))

# Create frequency and sort
freq.dtm<- sort(colSums(dtm.df),decreasing = T)

# Transform to dataframe
freq.dat<- data.frame(word= names(freq.dtm), freq= freq.dtm)
head(freq.dat, 10)

## Visualization
freq.dat%>%ggplot(aes(label= word, size= freq, color= word))+geom_text_wordcloud_area()
par(mar = c(10, 4, 4, 2) + 0.1, cex.axis = 0.6)
hist(as.numeric(Swift_final$year),
     breaks = seq(min(as.numeric(Swift_final$year)), max(as.numeric(Swift_final$year)), by = 1),
     xlab = "Year",
     ylab = "Count",
     main = "Year Distribution",
     xaxt = "n")
axis(1, at = unique(as.numeric(Swift_final$year)), labels = unique(Swift_final$year), las = 2)