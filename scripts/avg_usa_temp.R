library(dplyr)
library(ggplot2)
library(maps)
# Get our temperature data
temp <- read.csv("data/data-society-global-climate-change-data/GlobalLandTemperaturesByState.csv",
                 stringsAsFactors = FALSE)
# Focus on the USA
temp <- temp %>% filter(Country == "United States")
# remove NAs
temp <- temp[complete.cases(temp),]
# Average the temp per year and state instead of monthly
temp$dt <- substr(temp$dt,1,4)
temp <- temp %>% group_by(dt, State) %>%
  summarise(AverageTemperature = mean(AverageTemperature))
# Get map outlines
states <- map_data("state")
usa <- map_data("usa")
# In order to map our data we need to join it to our outline
# To do that we need to mfix some column names and Georgia
colnames(temp)[colnames(temp) == "State"] <- "region"
temp$region <- tolower(temp$region)
temp$region[temp$region == "georgia (state)"] <- "georgia" 
joined <- full_join(states, temp, by = "region")
