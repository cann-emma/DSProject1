library(readr)
library(dplyr)
library(ggplot2)
library(psych)
library(tm)
library(wordcloud2)
library(topicmodels)
library(tidytext)
library(ggpubr)

ts_discography_original <- read_csv("ts_discography_original.csv")
Swift_final<- ts_discography_original%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date)
Swift_final$year<- substr(Swift_final$date, 1, 4)
Swift_final$year<- as.numeric(Swift_final$year)

max(Swift_final$year)
min(Swift_final$year)

usableText<- function(x) stringr::str_replace_all(x, "[^[:graph:]]", " ") # Function to keep only visible text
corpus<- Corpus(VectorSource(Swift_final$text)) # Convert data into vector and transform into corpus. Make words in text suitable for analysis
corpus<- tm_map(corpus, usableText) # Keep only visible text in corpus
corpus<- tm_map(corpus, tolower) # Convert all text to lowercase
corpus<- tm_map(corpus, removePunctuation) # Remove punctuation
corpus<- tm_map(corpus, removeNumbers) # Remove numbers from text
corpus<- tm_map(corpus, removeWords, stopwords("english")) # Remove english stop words like "is", "the", "a" etc

dtm<- DocumentTermMatrix(corpus) # Convert corpus into a document term matrix
dtm  
# High sparsity means many words that are not high in frequency
dtm1<- removeSparseTerms(dtm, sparse = 0.965) # Reduce sparsity to 0.965
dtm1  # View reduced sparsity document term matrix. Sparsity at 0.89

dtm.df<- as.data.frame(as.matrix(dtm1))  # Convert document term matrix into matrix then into dataframe



ts_discography_final<- read.csv("ts_discography_final.csv")
Swift_final<- ts_discography_final


# Create frequency and sort
freq.dtm<- sort(colSums(dtm.df),decreasing = T)
freq.dat<- data.frame(word= names(freq.dtm), freq= freq.dtm)

freq.20<- freq.dat[1:20, ] # Select 20 rows from the frequency dataframe

freq<- freq.20%>%arrange(desc(freq.20))%>%head(20)
colors <- c("#FF69B4", "#FFD700", "#00FA9A", "#00BFFF", "#FF6347", "#ADFF2F", "#FFA07A", "#7B68EE", "#FF4500", "#40E0D0")
wordcloud2(freq, color= colors, backgroundColor = "white")  


Swift_final%>%ggplot(aes(x= category, fill = category))+geom_bar(color= "black", fill= 'lightblue')+labs(title = "Number of Songs Per Album", x = "Album", y = "Count")+theme_bw()+theme(axis.text.x = element_text(angle= 90), plot.title = element_text(hjust = 0.5))
Swift_final%>%ggplot(aes(x= year))+geom_histogram(binwidth= 0.5, color= "black", fill= "lightblue")+scale_x_continuous(limits = c(2005, 2025), breaks = seq(2006, 2024, by= 1))+labs(title= "Taylor Swift Songs Year Distribution")+theme_bw()+ theme(plot.title = element_text(hjust= 0.5))


ts_discography_final%>%ggplot(aes(x= SentimentQDAP))+geom_density(color= "black", fill= '#FF4500')+labs(title = "Sentiment Distribution in Taylor Swift Lyrics", x = "SentimentQDAP")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(x= Love))+geom_density(color= "black", fill= '#FF69B4')+labs(title = "Love Probability Distribution in Taylor Swift Lyrics", x = "Love")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(x= Desire))+geom_density(color= "black", fill= 'red3')+labs(title = "Desire Probability Distribution in Taylor Swift Lyrics", x = "Desire")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Sorrow))+geom_density(color= "black", fill= 'blue3')+labs(title = "Sorrow Probability Distribution in Taylor Swift Lyrics", x = "Sorrow")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Hope))+geom_density(color= "black", fill= '#FFD700')+labs(title = "Hope Probability Distribution in Taylor Swift Lyrics", x = "Hope")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Loss))+geom_density(color= "black", fill= "#7B68EE" )+labs(title = "Loss Probability Distribution in Taylor Swift Lyrics", x = "Loss")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Nostalgia))+geom_density(color= "black", fill="#00BFFF" )+labs(title = "Nostalgia Probability Distribution in Taylor Swift Lyrics", x = "Nostalgia")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Reflection))+geom_density(color= "black", fill= "#FF6347")+labs(title = "Reflection Probability Distribution in Taylor Swift Lyrics", x = "Reflection")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Resilience))+geom_density(color= "black", fill= '#40E0D0')+labs(title = "Resilience Probability Distribution in Taylor Swift Lyrics", x = "Resilience")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))
ts_discography_final%>%ggplot(aes(Confidence))+geom_density(color= "black", fill= 'orange2')+labs(title = "Confidence Probability Distribution in Taylor Swift Lyrics", x = "Confidence")+theme_bw()+theme(plot.title = element_text(hjust = 0.5))


topics<- LDA(dtm1, k= 5, control= list(seed= 1234))


# Measures probability of text belonging to topic
beta_topics<- tidy(topics, matrix= "beta")
beta_topics
## Higher beta reflects higher probability of text belonging to specific network


# Group tokens into highest probability topics
beta_top2<- beta_topics%>%group_by(topic)%>%slice_max(beta, n=15)%>%ungroup()%>%arrange(topic, -beta)
# Visualize topics tokens belong
beta_top2%>%mutate(term= reorder_within(term, beta, topic))%>%ggplot(aes(beta, term, fill= factor(topic)))+geom_col(show.legend = F)+ facet_wrap(~topic, scales= 'free')+ scale_y_reordered()

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
sig_QDAP<- mean_QDAP%>%select(2, 3, 6, 7)%>%filter(p.signif %in% c('*','**','***')) # Select only years where there were significant results for each sentiment and emotional theme
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

ggviolin(QDAP_vis, x = "Year", y = "SentimentQDAP", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.list, label = "p.signif")+theme(legend.position = "none")  

ggviolin(Confidence_vis, x = "Year", y = "Confidence", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE),draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listC, label = "p.signif", method = "wilcox.test",label.y = c(0.26, 0.3,0.31, 0.4)) +theme(legend.position = "none")

ggviolin(Love_vis, x = "Year", y = "Love", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listL,label = "p.signif", method = "wilcox.test") +theme(legend.position = "none")

ggviolin(Desire_vis, x = "Year", y = "Desire", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listD, label= "p.signif")+theme(legend.position = "none")

ggviolin(Sorrow_vis, x = "Year", y = "Sorrow", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listS, label= "p.signif")+theme(legend.position = "none") 

ggviolin(Nostalgia_vis, x = "Year", y = "Nostalgia", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listN, label= "p.signif", label.y= seq(0.45, 1, by= 0.05))+theme(legend.position = "none")

ggviolin(Reflection_vis, x = "Year", y = "Reflection", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listR,label = "p.signif", method = "wilcox.test") +theme(legend.position = "none")

ggviolin(Resilience_vis, x = "Year", y = "Resilience", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listRe, label= "p.signif", label.y= seq (0.35, 0.75, by= 0.05))+theme(legend.position = "none")

ggviolin(Hope_vis, x = "Year", y = "Hope", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listH, label= "p.signif")+theme(legend.position = "none")

ggviolin(Loss_vis, x = "Year", y = "Loss", color= "black", fill= "Year", add = c("boxplot"), add.params = list(jitter= TRUE), draw_quantiles = TRUE, alpha = 0.2)+
  stat_compare_means(comparisons = comparisons.listLs, label= "p.signif", label.y= seq(0.47, 0.65, by= 0.05))+theme(legend.position = "none")