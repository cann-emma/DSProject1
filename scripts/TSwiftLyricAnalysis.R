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

ts_discography_released <- read_csv("ts_discography_clean.csv")
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
freq.dat%>%ggplot(aes(label= word, size= freq, color= word))+geom_text_wordcloud_area()


par(mar = c(10, 4, 4, 2) + 0.1, cex.axis = 0.6)
hist(as.numeric(Swift_final$year),
     breaks = seq(min(as.numeric(Swift_final$year)), max(as.numeric(Swift_final$year)), by = 1),
     xlab = "Year",
     ylab = "Count",
     main = "Year Distribution",
     xaxt = "n")
axis(1, at = unique(as.numeric(Swift_final$year)), labels = unique(Swift_final$year), las = 2)

## More songs in the recent years than previous years


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


## Now, we can generate scores of emotions pertaining to our topics


## ZERO SHOT CLASSIFICATION 
scores <- transformer_scores(text = Swift_final$text, classes = c("Nostalgia", "Reflection", "Desire", "Love", "Sorrow", "Loss", "Comfort", "Confidence", "Resilience"))
scores_zsc<- as.data.frame(scores)
scores_zsc<- t(scores_zsc)
class(scores_zsc)

Swift_final<- cbind(Swift_final, scores_zsc)


# Comparing Means
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
mean_Comfort<- compare_means(Comfort~ year, Swift_final,method ="wilcox.test")
#mean_Loss<- compare_means(Love~ year, Swift_final,method = "wilcox.test")


## What years show significant differences when compared with each other?
sig_QDAP<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Love<- mean_Love%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Sorrow<- mean_Sorrow%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Comfort<- mean_Comfort%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Resilience<- mean_Resilience%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Confidence<- mean_Confidence%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Desire<- mean_Desire%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Nostalgia<- mean_Nostalgia%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
sig_Reflection<- mean_Reflection%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))
#sig_Loss<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***'))


## Clean data for significance visualization

## Have to focus mostly on year not entire date. Entire data makes it difficult to analyze as there are too many variables
sig_vis<- data.frame(Year= Swift_final$year, SentimentQDAP= Swift_final$SentimentQDAP, Love= Swift_final$Love, Sorrow= Swift_final$Sorrow,
                     Nostalgia= Swift_final$Nostalgia, Reflection= Swift_final$Reflection, Desire= Swift_final$Desire, Resilience= Swift_final$Resilience,
                     Confidence= Swift_final$Confidence, Comfort= Swift_final$Comfort)


QDAP_vis<- sig_vis%>%select(1, 2)%>%filter(Year %in% sig_QDAP$group1 | Year %in% sig_QDAP$group2)
Love_vis<- sig_vis%>%select(1, 3)%>%filter(Year %in% sig_Love$group1 | Year %in% sig_Love$group2)
Sorrow_vis<- sig_vis%>%select(1, 4)%>%filter(Year %in% sig_Sorrow$group1 | Year %in% sig_Sorrow$group2)
Nostalgia_vis<- sig_vis%>%select(1, 5)%>%filter(Year %in% sig_Nostalgia$group1 | Year %in% sig_Nostalgia$group2)
Reflection_vis<- sig_vis%>%select(1, 6)%>%filter(Year %in% sig_Reflection$group1 | Year %in% sig_Reflection$group2)
Desire_vis<- sig_vis%>%select(1, 7)%>%filter(Year %in% sig_Desire$group1 | Year %in% sig_Desire$group2)
Resilience_vis<- sig_vis%>%select(1, 8)%>%filter(Year %in% sig_Resilience$group1 | Year %in% sig_Resilience$group2)
Confidence_vis<- sig_vis%>%select(1, 9)%>%filter(Year %in% sig_Confidence$group1 | Year %in% sig_Confidence$group2)
Comfort_vis<- sig_vis%>%select(1, 10)%>%filter(Year %in% sig_Comfort$group1 | Year %in% sig_Comfort$group2)
#QDAP_vis<- sig_vis%>%select(1, 11)%>%filter(Year %in% sig_ | Year %>% sig_QDAP)



## Make list of matched years in sig_QDAP data
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

comparisons.listCo <- lapply(1:nrow(sig_Comfort), function(i) {
  c(as.character(sig_Comfort$group1[i]), as.character(sig_Comfort$group2[i]))})

comparisons.listD <- lapply(1:nrow(sig_Desire), function(i) {
  c(as.character(sig_Desire$group1[i]), as.character(sig_Desire$group2[i]))})




## Visualize Significance and sentiment distribution by year
ggviolin(QDAP_vis, x = "Year", y = "SentimentQDAP", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.list)
ggviolin(Love_vis, x = "Year", y = "Love", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listL)
ggviolin(Sorrow_vis, x = "Year", y = "Sorrow", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listS)
ggviolin(Nostalgia_vis, x = "Year", y = "Nostalgia", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listN)
ggviolin(Reflection_vis, x = "Year", y = "Reflection", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listR)
ggviolin(Confidence_vis, x = "Year", y = "Confidence", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listC)
ggviolin(Resilience_vis, x = "Year", y = "Resilience", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listRe)
ggviolin(Comfort_vis, x = "Year", y = "Comfort", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listCo)
ggviolin(Desire_vis, x = "Year", y = "Desire", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.listD)
# ggviolin(QDAP_vis, x = " ", y = " ", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+stat_compare_means(comparisons = comparisons.list)


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
