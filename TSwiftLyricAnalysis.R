library(dplyr)
library(readr)


## PRELIMINARY ANALYSIS

ts_discography_released <- read_csv("ts_discography_clean.csv")
Swift_final<- ts_discography_released%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
head(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date)
Swift_final$year<- substr(Swift_final$date, 1, 4)
max(Swift_final$year) # 2024
min(Swift_final$year) # 2006


# Pre-Processing
library(tm)
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


## Visualization

install.packages('ggwordcloud')
library(ggwordcloud)

freq.dat%>%ggplot(aes(label= word, size= freq, color= word))+geom_text_wordcloud_area()



par(mar = c(10, 4, 4, 2) + 0.1, cex.axis = 0.6)
hist(as.numeric(Swift$year),
     breaks = seq(min(as.numeric(Swift$year)), max(as.numeric(Swift$year)), by = 1),
     xlab = "Year",
     ylab = "Count",
     main = "Number of Occurrences per Year",
     xaxt = "n")
axis(1, at = unique(as.numeric(Swift$year)), labels = unique(Swift$year), las = 2)

## More songs in the recent years than previous years




# SENTIMENT ANALYSIS

library(SentimentAnalysis)
sentiment<- analyzeSentiment(Swift_final$text)
Swift<- cbind(Swift_final, sentiment)

## First look with significance testing

## Have to focus mostly on year not entire date. Entire data makes it difficult to analyze as there are too many variables
testSent1<- data.frame(SentimentLM= sentiment$SentimentLM, SentimentQDAP= sentiment$SentimentQDAP, Year= Swift_final$year)
testSent1



## TOPIC MODELING

# Topic modeling using topic model
install.packages('topicmodels')
install.packages('tidytext')
library(topicmodels)
library(ggplot2)
library(tidytext)


topics<- LDA(dtm1, k= 5, control= list(seed= 1234))

# Measures probability of text belonging to topic
beta_topics<- tidy(topics, matrix= "beta")
beta_topics
## Higher beta reflects higher probability of text belonging to specific network


# In our example, the word 'back' is likely to belong to topic 4, and 'bed' likely belongs to topic 4


# Visualization
#beta_top1<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=5)%>%ungroup()%>%arrange(topic, -beta)
beta_top2<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=15)%>%ungroup()%>%arrange(topic, -beta)

beta_top2%>%select(topic, term)%>%filter(topic== 5)
beta_top2%>%select(topic, term)%>%filter(topic== 4)
beta_top2%>%select(topic, term)%>%filter(topic== 3)
beta_top2%>%select(topic, term)%>%filter(topic== 2)
beta_top2%>%select(topic, term)%>%filter(topic== 1)

#beta_top<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=10)%>%ungroup()%>%arrange(topic, -beta)
# higher n= more words for analysis
# lower n= less words but more relevant words for analysis

beta_top2%>%mutate(term= reorder_within(term, beta, topic))%>%ggplot(aes(beta, term, fill= factor(topic)))+geom_col(show.legend = F)+ facet_wrap(~topic, scales= 'free')+ scale_y_reordered()


## From using sentiment and scores related to topic we model, we can create a predictive modeling to tell us what year a song is from

# Topic 1: Desire, Longing
# Topic 2: Resilience, Moving on, Standing strong, Self-empowerment
# Topic 3: Longing, Love, Comfort
# Topic 4: Past, Time, Memories
# Topic 5: Love, Relationships, Heartbreak

mean_Love<- compare_means(Love~ year, Swift_knn,method = "wilcox.test")

## Now, we can generate scores of emotions pertaining to our topics


## ZERO SHOT CLASSIFICATION 

library(transforEmotion)
scores <- transformer_scores(text = Swift_final$text, classes = c("Nostalgia", "Reflection", "Desire", "Love", "Sorrow", "Loss", "Comfort", "Confidence", "Resilience"))

scores_zsc<- as.data.frame(scores)
scores_zsc<- t(scores_zsc)
class(scores_zsc)

# ## Classification model instead of predictive model. What year is a song likely to come from based on certain scores on sentiments and emotions/topics
# # K-Nearest Neighbour Clustering
# 
# library(car)
# library(caret)
# 
# Swift_knn<- Swift%>%select(5:19)
# Swift_knn<- cbind(Swift_knn, scores_zsc)
# knn<- train(year~., Swift_knn, method= "knn")
# knn$finalModel

# 
# library(ggplot2)
# ggplot(knn)
# ## 9% Accuracy: Simple Model
# # Very Low
# 
# knn2<- train(year~SentimentHE+NegativityHE+PositivityHE+WordCount+RatioUncertaintyLM+SentimentQDAP+PositivityQDAP+NegativityQDAP+Nostalgia+Reflection+Love+Sorrow+Loss+Desire+Comfort+Confidence+Resilience, Swift_knn, method= "knn")
# knn$finalModel
# ggplot(knn2)


## 9 Neigbours would produce the most accurate results for a model that uses all our variables 
## Can also use regression + mars to refine classification models



## Question: Methods to further refine model and improve accuracy of model.




# Comparing Means
library(ggpubr)
mean_LM<- compare_means(SentimentLM ~ Year, testSent1,method = "wilcox.test")
mean_QDAP<- compare_means(SentimentQDAP ~ Year, testSent1,method = "wilcox.test")

# None of the results compared by year is significant for LM
## Some significance in QDAP
## General trend in significance: More significance in sentiments in earlier years when compared to later years


## What years have significant sentiment differences when compared with each other?
sig_QDAP<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))


## Clean data for significance visualization
testSent2<- testSent1%>%select(2, 3)%>%filter(Year %in% sig_QDAP$group1 | Year %in% sig_QDAP$group2)
unique(testSent2$Year)


## Make list of matched years in sig_QDAP data
comparisons.list <- lapply(1:nrow(sig_QDAP), function(i) {
  c(as.character(sig_QDAP$group1[i]), as.character(sig_QDAP$group2[i]))})


## Visualize Significance and sentiment distribution by year
ggviolin(testSent2, x = "Year", y = "SentimentQDAP", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.list)





## HOW DATA WAS PREPARED

### More in depth topic modeling 
# Duplicates? Fearless(TV), Red(TV), 1989(TV)

### More in depth topic modeling 
# Duplicates? Fearless(TV), Red(TV), 1989(TV)
unique(Swift_final$category)

Tswift<- Swift_final%>%select(1:5)%>%filter(category== 'Taylor Swift')

Fearless_08<- Swift_final%>%select(1:5)%>%filter(category== 'Fearless')
Fearless_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Fearless (TV)')
Fearless_21<- Fearless_TV[19:25,]

SpeakNow_10<- Swift_final%>%select(1:5)%>%filter(category== 'Speak Now')
SpeakNow_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Speak Now (TV)')
SpeakNow_23<- SpeakNow_TV[17:22,]

Red_12<- Swift_final%>%select(1:5)%>%filter(category== 'Red')
Red_TV<- Swift_final%>%select(1:5)%>%filter(category== 'Red (TV)')
Red_21<- Red_TV[21:30,]


A1989<- Swift_final%>%select(1:5)%>%filter(category== '1989')
TV_1989<- Swift_final%>%select(1:5)%>%filter(category== '1989 (TV)')

B1989<- TV_1989[17:22,]


Reputation<- Swift_final%>%select(1:5)%>%filter(category== 'reputation')
Lover<- Swift_final%>%select(1:5)%>%filter(category== 'Lover')
Folklore<- Swift_final%>%select(1:5)%>%filter(category== 'folklore')
Evermore<- Swift_final%>%select(1:5)%>%filter(category== 'evermore')
Midnights<- Swift_final%>%select(1:5)%>%filter(category== 'Midnights')
TTPD<- Swift_final%>%select(1:5)%>%filter(category== 'The Tortured Poets Department' )
NAS<- Swift_final%>%select(1:5)%>%filter(category== 'Non-Album Songs')






