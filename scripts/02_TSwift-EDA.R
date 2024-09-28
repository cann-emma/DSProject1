## EXPLORATORY DATA ANALYSIS

library(tm)
library(SnowballC)
library(ggwordcloud)
library(wordcloud)
library(RColorBrewer)


Swift_final<- read.csv("ts_discography_clean.csv") # Load clean data

# Pre-Processing
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


# Create frequency and sort
freq.dtm<- sort(colSums(dtm.df),decreasing = T) # Create frequency of tokens/words in document term matrix

# Transform to dataframe
freq.dat<- data.frame(word= names(freq.dtm), freq= freq.dtm) # Make a dataframe of the sorted tokens and their frequencies with columns "word" and "frequency"
head(freq.dat, 10) # View data

# Most common words are like, know, just, don't and never.

# What are the common words associated with? What words are likely to come before or after frequent words? 

findAssocs(dtm1, "like", 0.30) # like associated with feels and snow
findAssocs(dtm1, "know", 0.30) # know associated with changed and better
findAssocs(dtm1, "never", 0.30) # never associated with street and walk
findAssocs(dtm1, "love", 0.30) # love associated with free and came


## Visualization
freq.dat%>%ggplot(aes(label= word, size= freq, color= word))+geom_text_wordcloud_area()  # Wordcloud of frequent words

## What are the top 20 words in the lyrics? 

freq.20<- freq.dat[1:20, ] # Select 20 rows from the frequency dataframe

ggplot(freq.20, aes(reorder(word, freq,), freq, fill = word))+ geom_col() + xlab(NULL) + coord_flip() + ylab("Frequency") 
+ theme(text = element_text(size = 15), axis.text.y = element_text(size = 10, angle = 45))


# Year Distribution in dataframe

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
ggplot(Swift_final, aes(x = category)) + 
  geom_bar(fill = "lightblue", color = "black") + 
  labs(x = "Album", y = "Number of Songs", title = "Number of Songs per Album") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8), 
        plot.margin = margin(50, 10, 10, 10),  # Increase bottom margin for more space
        plot.title = element_text(size = 10, hjust = 0.5), 
        axis.title = element_text(size = 9)) + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)), 
                     limits = c(0, max(table(Swift_final$category)) * 1),  # Shorten y-axis by reducing the limit
                     breaks = pretty(0:max(table(Swift_final$category)), n = 5)) + 
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor = element_blank())


