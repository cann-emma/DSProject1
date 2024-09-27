library(dplyr)
library(readr)
library(tm)
library(SnowballC)
library(ggwordcloud)
library(wordcloud)
library(RColorBrewer)
library(SentimentAnalysis)
library(topicmodels)
library(tidytext)
library(ggplot2)
library(transforEmotion)
library(ggpubr)

# LOAD AND VIEW DATA

ts_discography_original <- read_csv("ts_discography_original.csv")
Swift_final<- ts_discography_original%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
head(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date) # Rename columns
Swift_final$year<- substr(Swift_final$date, 1, 4) # Select year from date
max(Swift_final$year) # 2024
min(Swift_final$year) # 2006
unique(Swift_final$category) # What are the different categories/albums in the dataset?


## Other Artist Songs will not be included in clean dataframe. Analysis is on Taylor Swift. 
# However, collaborations are kept. 


# DATA CLEANING

Tswift<- Swift_final%>%select(1:5)%>%filter(category== 'Taylor Swift')

Fearless_08<- Swift_final%>%select(1:5)%>%filter(category== 'Fearless') # Select songs from original album release
Fearless_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Fearless (TV)') # Select songs that are Taylor's Version
Fearless_21<- Fearless_TV[19:25,] # Select only new songs/songs that do not appear in previous release
Fearless_21<- Fearless_21[2:7, ] # Keep songs with that are Taylor's Version and From Vault

SpeakNow_10<- Swift_final%>%select(1:5)%>%filter(category== 'Speak Now') # Select songs from original album release
SpeakNow_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Speak Now (TV)') # Select songs that are Taylor's Version
SpeakNow_23<- SpeakNow_TV[17:22,] # Select only new songs/songs that do not appear in previous release


Red_12<- Swift_final%>%select(1:5)%>%filter(category== 'Red') # Select songs from original album release
Red_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Red (TV)') # Select songs that are Taylor's Version
Red_21<- Red_TV[21:30,] # Select only new songs/songs that do not appear in previous release
Red_21<- Red_21[2:7, ] # Keep songs with that are Taylor's Version and From Vault


A1989<- Swift_final%>%select(1:5)%>%filter(category== '1989') # Select songs from original album release
TV_1989<- Swift_final%>%select(1:5)%>%filter(category== '1989 (TV)') # Select songs that are Taylor's Version
B1989<- TV_1989[17:22,] # Select only new songs/songs that do not appear in previous release
B1989<- B1989[1:5, ] # Keep songs with that are Taylor's Version and From Vault


Reputation<- Swift_final%>%select(1:5)%>%filter(category== 'reputation')
Lover<- Swift_final%>%select(1:5)%>%filter(category== 'Lover')
Folklore<- Swift_final%>%select(1:5)%>%filter(category== 'folklore')
Evermore<- Swift_final%>%select(1:5)%>%filter(category== 'evermore')
Midnights<- Swift_final%>%select(1:5)%>%filter(category== 'Midnights')
TTPD<- Swift_final%>%select(1:5)%>%filter(category== 'The Tortured Poets Department' )
NAS<- Swift_final%>%select(1:5)%>%filter(category== 'Non-Album Songs')


## Bind the rows that contain unique songs into dataframe

TSwift_clean <- rbind(Tswift, Fearless_08, Fearless_21, SpeakNow_10, SpeakNow_23, Red_12, Red_21, A1989, B1989, Reputation, Lover, Folklore, Evermore, Midnights, TTPD, NAS)
write.csv(TSwift_clean, "ts_discography_clean.csv")

## 266 obs in clean dataframe


## EXPLORATORY DATA ANALYSIS

Swift_final<- read.csv("ts_discography_clean.csv")

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
# High sparsity means many words that are not high in frequency
dtm1<- removeSparseTerms(dtm, sparse = 0.965)
dtm1

dtm.df<- as.data.frame(as.matrix(dtm1))


# Create frequency and sort
freq.dtm<- sort(colSums(dtm.df),decreasing = T)

# Transform to dataframe
freq.dat<- data.frame(word= names(freq.dtm), freq= freq.dtm)
head(freq.dat, 10)

# Most common words are like, know, just, don't and never.

# What are the common words associated with? What words are likely to come before or after frequent words? 

findAssocs(dtm1, "like", 0.30) # like associated with feels and snow
findAssocs(dtm1, "know", 0.30) # know associated with changed and better
findAssocs(dtm1, "never", 0.30) # never associated with street and walk
findAssocs(dtm1, "love", 0.30) # love associated with free and came


## Visualization
freq.dat%>%ggplot(aes(label= word, size= freq, color= word))+geom_text_wordcloud_area()

## What are the top 20 words in the lyrics? 

freq.20<- freq.dat[1:20, ]

ggplot(freq.20, aes(reorder(word, freq,), freq, fill = word))+ geom_col() + xlab(NULL) + coord_flip() + ylab("Frequency") 
+ theme(text = element_text(size = 15), axis.text.y = element_text(size = 10, angle = 45))


# Histogram of year

par(mar = c(10, 4, 4, 2) + 0.1, cex.axis = 0.6)
hist(as.numeric(Swift_final$year),
     breaks = seq(min(as.numeric(Swift_final$year)), max(as.numeric(Swift_final$year)), by = 1),
     xlab = "Year",
     ylab = "Count",
     main = "Year Distribution",
     xaxt = "n")
axis(1, at = unique(as.numeric(Swift_final$year)), labels = unique(Swift_final$year), las = 2)
## More songs in the recent years than previous years


# Song Distribution by Album


# SENTIMENT ANALYSIS

sentiment<- analyzeSentiment(Swift_final$text)
Swift_final<- cbind(Swift_final, sentiment)


## TOPIC MODELING

# Topic modeling using topic model
topics<- LDA(dtm1, k= 5, control= list(seed= 1234))

# Measures probability of text belonging to topic
beta_topics<- tidy(topics, matrix= "beta")
beta_topics
## Higher beta reflects higher probability of text belonging to specific network


# Group tokens into highest probability topics
beta_top2<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=15)%>%ungroup()%>%arrange(topic, -beta)
# Visualize topics tokens belong
beta_top2%>%mutate(term= reorder_within(term, beta, topic))%>%ggplot(aes(beta, term, fill= factor(topic)))+geom_col(show.legend = F)+ facet_wrap(~topic, scales= 'free')+ scale_y_reordered()
## Write out grouped topics to use for next step
write.csv(beta_top2, "ts_topics.csv")



# GEMINI API AND PYTHON
# Python was used for this section

import google.generativeai as genai
import numpy as np
import pandas as pd

topics= pd.read_csv("ts_topics.csv")
topics

genai.configure(api_key= GOOGLE_API_KEY)
model = genai.GenerativeModel(model_name="gemini-1.5-flash")

topics_str= topics.to_string()
print(topics_str)

response = model.generate_content(["What theme or category best describes each topic in this dataframe? What specific emotions or subjects are these themes related to?", topics_str])
print(response.text)


# Here's a breakdown of the themes and emotions associated with each topic in your dataframe:

# **Topic 1: Everyday Conversations**
# 
# * **Theme:**  General, casual conversations.
# * **Emotions/Subjects:**  Friendship, connection, simple exchanges, everyday experiences, lightheartedness.  Words like "can", "like", "got", "don't", "look", "stay", "way" all point to casual interactions.
# 
# **Topic 2:  Romantic Yearning/Regret**
# 
# * **Theme:**  Longing, love, loss, reflection on past relationships.
# * **Emotions/Subjects:**  Hope, sadness, nostalgia, yearning for something lost. Words like "back", "baby", "come", "ever", "wish", "never", "like", "said", "right", "cause", "want" all hint at romantic themes.
# 
# **Topic 3:  Love and Loss**
# 
# * **Theme:**  Heartbreak, reflection on love, the passage of time.
# * **Emotions/Subjects:**  Sadness, melancholy, introspection, time passing, remembering.  Words like "never", "love", "time", "still", "think", "like", "now", "didn't", "just", "know", "heart", "said", "good" are associated with feelings of loss and reflection.
# 
# **Topic 4:  Optimism and Confidence**
# 
# * **Theme:**  Positive outlook, self-assurance, determination.
# * **Emotions/Subjects:**  Hope, excitement, resilience, belief in oneself, making progress. Words like "know", "just", "like", "see", "gonna", "youre", "one", "keep", "cause", "never", "eyes", "better", "man", "now", "yeah" all convey a sense of confidence and forward momentum.
# 
# **Topic 5:  Pop Culture/Fan Culture**
# 
# * **Theme:**  References to a specific artist or genre (possibly Taylor Swift).
# * **Emotions/Subjects:**  Enthusiasm, admiration, belonging to a fandom. Words like "don't", "like", "taylor", "ooh", "swift", "wanna", "just", "ill", "say", "call", "want", "time", "know", "one", "youre" suggest a connection to a particular artist or genre.
# 
# **Important Note:** The context of the data is crucial for a more accurate interpretation. For example, the "Taylor Swift" topic might be linked to a specific song or era of her music. 
# 
# **Tips for Deeper Analysis:**
# 
# * **Sentiment Analysis:**  Use tools to analyze the emotional tone of text associated with each topic.
# * **Network Analysis:**  Visualize how words within each topic connect to create semantic networks.
# * **Additional Context:**  Look for any other available information about the data source, like genre, audience, or timeframe. 


## ZERO SHOT CLASSIFICATION 


## Using the themes and topics generated from topics tokens in topic modeling belong,
## use zero shot classification to generate scores for each theme.

scores <- transformer_scores(text = Swift_final$text, classes = c("Nostalgia", "Reflection", "Desire", "Love", "Sorrow", "Loss", "Hope", "Confidence", "Resilience"))
scores_zsc<- as.data.frame(scores)
scores_zsc<- t(scores_zsc)
class(scores_zsc)

Swift_final<- cbind(Swift_final, scores_zsc)

write.csv(Swift_final, "ts_discography_final.csv")


# MEAN COMPARISON, SIGNIFICANCE TESTING AND VISUALIZATION

mean_LM<- compare_means(SentimentLM ~ Year, testSent1,method = "wilcox.test")
mean_QDAP<- compare_means(SentimentQDAP ~ year, Swift_final,method = "wilcox.test")

# None of the results compared by year is significant for LM
## Some significance in QDAP
## General trend in significance: More significance in sentiments in earlier years when compared to later years

mean_QDAP<- compare_means(SentimentQDAP ~ year, Swift_final,method = "wilcox.test")
mean_Love<- compare_means(Love~ year, Swift_final,method = "wilcox.test")
mean_Sorrow<- compare_means(Sorrow~ year, Swift_final,method = "wilcox.test")
mean_Reflection<- compare_means(Reflection~ year, Swift_final,method = "wilcox.test")
mean_Nostalgia<- compare_means(Nostalgia~ year, Swift_final,method = "wilcox.test")
mean_Desire<- compare_means(Desire~ year, Swift_final,method = "wilcox.test")
mean_Confidence<- compare_means(Confidence~ year, Swift_final,method = "wilcox.test")
mean_Resilience<- compare_means(Resilience~ year, Swift_final,method = "wilcox.test")
mean_Hope<- compare_means(Hope~ year, Swift_final,method ="wilcox.test")
mean_Loss<- compare_means(Love~ year, Swift_final,method = "wilcox.test")


## What years show significant differences when compared with each other?
sig_QDAP<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Love<- mean_Love%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Sorrow<- mean_Sorrow%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Hope<- mean_Hope%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Resilience<- mean_Resilience%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Confidence<- mean_Confidence%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Desire<- mean_Desire%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Nostalgia<- mean_Nostalgia%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Reflection<- mean_Reflection%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Loss<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))


## Clean data for significance visualization

## Save all variables of interest into one dataframe for visualization

sig_vis<- data.frame(Year= Swift_final$year, SentimentQDAP= Swift_final$SentimentQDAP, Love= Swift_final$Love, Sorrow= Swift_final$Sorrow,
                     Nostalgia= Swift_final$Nostalgia, Reflection= Swift_final$Reflection, Desire= Swift_final$Desire, Resilience= Swift_final$Resilience,
                     Confidence= Swift_final$Confidence, Hope= Swift_final$Hope, Loss= Swift_final$Loss)


## Make dataframe for sentiment and topics selecting years where topic was significant

QDAP_vis<- sig_vis%>%select(1, 2)%>%filter(Year %in% sig_QDAP$group1 | Year %in% sig_QDAP$group2)
Love_vis<- sig_vis%>%select(1, 3)%>%filter(Year %in% sig_Love$group1 | Year %in% sig_Love$group2)
Sorrow_vis<- sig_vis%>%select(1, 4)%>%filter(Year %in% sig_Sorrow$group1 | Year %in% sig_Sorrow$group2)
Nostalgia_vis<- sig_vis%>%select(1, 5)%>%filter(Year %in% sig_Nostalgia$group1 | Year %in% sig_Nostalgia$group2)
Reflection_vis<- sig_vis%>%select(1, 6)%>%filter(Year %in% sig_Reflection$group1 | Year %in% sig_Reflection$group2)
Desire_vis<- sig_vis%>%select(1, 7)%>%filter(Year %in% sig_Desire$group1 | Year %in% sig_Desire$group2)
Resilience_vis<- sig_vis%>%select(1, 8)%>%filter(Year %in% sig_Resilience$group1 | Year %in% sig_Resilience$group2)
Confidence_vis<- sig_vis%>%select(1, 9)%>%filter(Year %in% sig_Confidence$group1 | Year %in% sig_Confidence$group2)
Hope_vis<- sig_vis%>%select(1, 10)%>%filter(Year %in% sig_Hope$group1 | Year %in% sig_Hope$group2)
Loss_vis<- sig_vis%>%select(1, 11)%>%filter(Year %in% sig_Loss$group1 | Year %in% sig_Loss$group2)



## Make list of matched years in for sentiment and topic to use for visualization

comparisons.list <- lapply(1:nrow(sig_QDAP), function(i) {
  c(as.character(sig_QDAP$group1[i]), as.character(sig_QDAP$group2[i]))})

comparisons.listL <- lapply(1:nrow(sig_Love), function(i) {
  c(as.character(sig_Love$group1[i]), as.character(sig_Love$group2[i]))})

comparisons.listS <- lapply(1:nrow(sig_Sorrow), function(i) {
  c(as.character(sig_Sorrow$group1[i]), as.character(sig_Sorrow$group2[i]))})

comparisons.listN <- lapply(1:nrow(sig_Nostalgia), function(i) {
  c(as.character(sig_Nostalgia$group1[i]), as.character(sig_Nostalgia$group2[i]))})

comparisons.listR <- lapply(1:nrow(sig_Reflection), function(i) {
  c(as.character(sig_Reflection$group1[i]), as.character(sig_Reflection$group2[i]))})

comparisons.listC <- lapply(1:nrow(sig_Confidence), function(i) {
  c(as.character(sig_Confidence$group1[i]), as.character(sig_Confidence$group2[i]))})

comparisons.listRe <- lapply(1:nrow(sig_Resilience), function(i) {
  c(as.character(sig_Resilience$group1[i]), as.character(sig_Resilience$group2[i]))})

comparisons.listH <- lapply(1:nrow(sig_Hope), function(i) {
  c(as.character(sig_Hope$group1[i]), as.character(sig_Hope$group2[i]))})

comparisons.listD <- lapply(1:nrow(sig_Desire), function(i) {
  c(as.character(sig_Desire$group1[i]), as.character(sig_Desire$group2[i]))})

comparisons.listLs <- lapply(1:nrow(sig_Loss), function(i) {
  c(as.character(sig_Loss$group1[i]), as.character(sig_Loss$group2[i]))})



## Visualize sentiment and topic significance by matched years

ggviolin(QDAP_vis, x = "Year", y = "SentimentQDAP", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.list)
ggviolin(Love_vis, x = "Year", y = "Love", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listL)
ggviolin(Sorrow_vis, x = "Year", y = "Sorrow", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listS)
ggviolin(Nostalgia_vis, x = "Year", y = "Nostalgia", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listN)
ggviolin(Reflection_vis, x = "Year", y = "Reflection", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listR)
ggviolin(Confidence_vis, x = "Year", y = "Confidence", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listC)
ggviolin(Resilience_vis, x = "Year", y = "Resilience", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listRe)
ggviolin(Hope_vis, x = "Year", y = "Hope", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listH)
ggviolin(Desire_vis, x = "Year", y = "Desire", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listD)
ggviolin(Loss_vis, x = "Year", y = "Loss", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listLs)
