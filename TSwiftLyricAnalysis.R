library(dplyr)
library(readr)

ts_discography_released <- read_csv("C:/Users/Emmanuella/Desktop/DS Project/ts_discography_released.csv")
Swift_final<- ts_discography_released%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
head(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date)
Swift_final$year<- substr(Swift_final$date, 1, 4)

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
dtm1<- removeSparseTerms(dtm, sparse = 0.96)
dtm1

dtm.df<- as.data.frame(as.matrix(dtm1))


# Create frequency and sort
freq.dtm<- sort(colSums(dtm.df),decreasing = T)

# Transform to dataframe
freq.dat<- data.frame(word= names(freq.dtm), freq= freq.dtm)
head(freq.dat, 10)

# The most frequent words are like, know, don't, just, now, love, never, you're, back, time


# Topic modeling using topic model
install.packages('topicmodels')
install.packages('tidytext')
library(topicmodels)
library(ggplot2)
library(tidytext)


topics<- LDA(dtm1, k= 5, control= list(seed= 1234))
summary(topics)

# Measures probability of text belonging to topic
beta_topics<- tidy(topics, matrix= "beta")
## Higher beta reflects higher probability of text belonging to specific network
beta_topics

# In our example, the word 'back' is likely to belong to topic 3, and 'bed' likely belongs to topic 2


# Visualization
#beta_top1<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=5)%>%ungroup()%>%arrange(topic, -beta)
beta_top2<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=15)%>%ungroup()%>%arrange(topic, -beta)

beta_top2%>%select(topic, term)%>%filter(topic== 5)

#beta_top<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=10)%>%ungroup()%>%arrange(topic, -beta)
# higher n= more words for analysis
# lower n= less words but more relevant words for analysis

beta_top2%>%mutate(term= reorder_within(term, beta, topic))%>%ggplot(aes(beta, term, fill= factor(topic)))+
geom_col(show.legend = F)+ facet_wrap(~topic, scales= 'free')+ scale_y_reordered()


## Using ChatGPT, topic1 and topic2 reflect everyday language
#Topic3 reflects relation themes and common pop song words
#Topic4 reflects personal reflections, emotions and
#Topic5 reflect desires, growth

# Sentiment Analysis
library(SentimentAnalysis)
sentiment<- analyzeSentiment(Swift_final$text)
Swift<- cbind(Swift_final, sentiment)

## First look with significance testing

## Have to focus mostly on year not entire date. Entire data makes it difficult to analyze as there are too many variables
testSent1<- data.frame(SentimentLM= sentiment$SentimentLM, SentimentQDAP= sentiment$SentimentQDAP, Year= Swift_final$year)
testSent1


# Comparing Means
library(ggpubr)
mean_comp<- compare_means(SentimentLM ~ Year, testSent1,method = "wilcox.test")
mean_comp1<- compare_means(SentimentQDAP ~ Year, testSent1,method = "wilcox.test")

mean_comp1
# None of the results compared by year is significant for LM
## Some significance in QDAP

  
# Exploratory Graph Analysis
library(EGAnet)

## Troubleshooting
dtm.df_fixed <- apply(dtm.df, 2, function(x) {round((x - min(x)) / (max(x) - min(x)) * 11)})

maximum_value<- max(dtm.df)
maximum_value
topics<- EGA.fit(dtm.df_fixed, model = "tmfg", plot.EGA = F)
topics

topics.optimal$EntropyFit
topics<- EGA(dtm.df, model= "tmfg", steps= 3)
topics$dim.variables



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




