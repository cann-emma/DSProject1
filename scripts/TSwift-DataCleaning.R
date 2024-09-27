library(dplyr)

# LOAD AND VIEW DATA

ts_discography_released <- read_csv("ts_discography_released.csv")
Swift_final<- ts_discography_released%>%select(category, song_title, song_lyrics, song_release_date)
glimpse(Swift_final)
head(Swift_final)
Swift_final<- Swift_final%>%rename(title= song_title, text= song_lyrics, date= song_release_date) # Rename columns
Swift_final$year<- substr(Swift_final$date, 1, 4) # Select year from date

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
write.csv(TSwift_clean, "TSwift_clean.csv")

## 266 obs in clean dataframe
