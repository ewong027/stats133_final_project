# ======================================================================
# cleaning_data: cleaning the raw data. 
# Description: This script starts off with two raw data files and we 
#              first worked on cleaning each individually by extracting 
#              the data we wanted and then concatenated both data sets 
#              based on the date of the accidents. 
# ======================================================================

# First we download the raw data onto R studio: 
# We will use a numbering convention so that at each modification the index
# increases by one. 
## ---- Loading Data ----
av_data_1 <- read.delim('../rawdata/aviation_data.txt', header = TRUE, 
                        sep = '|' , stringsAsFactors = FALSE)
air_data_1 <- read.csv('../rawdata/airplane_crashes.csv', 
                       stringsAsFactors = FALSE)
## ---- comment ----
# This takes only the airplane data from the data frame as opposed to  all 
# aircrafts. 

## ---- Cleaning1 ----
av_data_2 <- subset(av_data_1, Aircraft.Category == ' Airplane '| 
                      Aircraft.Category == '  ')
air_data_2 <- air_data_1[!grepl('airship', air_data_1$Type), ]

## ---- comment ----
# We will merge these two date tables so that air_data provides information
# from 1920-1981 and av_data information from 1982-2015. So now we extract 
# only the years we want from each data frame. 

## ---- Cleaning2 ----
acc_date <- av_data_2$Event.Date
av_data_2$year <- as.numeric(substr(acc_date, start = nchar(acc_date)-4, 
                                    stop = nchar(acc_date)))
av_data_3 <- subset(av_data_2, year >= 1982)

ac_date <- air_data_2$Date
air_data_2$year <- as.numeric(substr(ac_date, start = nchar(ac_date)-3, 
                                     stop = nchar(ac_date)))
air_data_3 <- subset(air_data_2, year <= 1981 & year >= 1920)

## ---- comment ----
# In av_data the columns 'Location' and 'Country' should be combined as well
# as 'Make' and 'Model'

## ---- Cleaning3 ----
av_data_3$new_location <- paste0(av_data_3$Location, av_data_3$Country)
av_data_3$Type <- paste0(av_data_3$Make, av_data_3$Model)

## ---- comment ----
# In air_data the order of data is currently in ascending order, but to match 
# av_data we want it to be in descending order. 

## ---- Aesthetics ----
air_data_4 <- air_data_3[nrow(air_data_3):1,]

# Now to extract the information (columns) that we want  
av_data_4 <- av_data_3[c('Event.Date', 'new_location', 'Type')]
air_data_5 <- air_data_4[c('Date', 'Location', 'Type')]

# We don't want the crash information for crashes missing 'Type' information.
av_data_5 <- subset(av_data_4, Type != '    ')
air_data_6 <- subset(air_data_5, Type != '')

# Rename column names so that they are the same for both data frames. 
names(av_data_5) <- c('date', 'location', 'type')
names(air_data_6) <- c('date', 'location', 'type') 

# Now we combine the two data frames. 
data <- rbind(av_data_5, air_data_6)

# Changing the 'type' column to all lowercase
data$type <- tolower(data$type)

# Changing the 'location' column to all lowercase
data$location <- tolower(data$location)

## ---- Peek ----
head(data)

## ---- Exporting ----
write.csv(data, file = '../data/data.csv')
