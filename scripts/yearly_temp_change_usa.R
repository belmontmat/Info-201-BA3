library(dplyr)
library(ggplot2)  
#read temperature data frame

temp_df <- read.csv("GlobalLandTemperaturesByState.csv",
  stringsAsFactors = FALSE)


#create new data frame for average temp per year
average_usa_temp <- temp_df %>%
                      filter(Country == "United States")
average_usa_temp$dt <- substr(average_usa_temp$dt, 1, 4)

average_usa_temp <- average_usa_temp %>%
                      filter(dt > 1799)

average_1800_2015_temp <- data.frame(
  Year = seq(1800, 2010, 5),
  HighTemp = 0,
  AvgTemp = 0,
  LowTemp = 0,
  NationHigh = 0,
  NationAvg = 0,
  NationLow = 0,
  State = ""
)


#loop through each year, summing up temperature and finding average
national_state_temp <- average_usa_temp
national_state_temp$State <- "Nation"

specific_state_temp <- average_usa_temp %>%
                         filter(State == "Alabama")
average_1800_2015_temp$State <- "Alabama"

inc <- function(x)
{
  eval.parent(substitute(x <- x + 1))
}

x <- 1

for (i in 1800:2010) {
  if (!i %% 5) {
    
    state_df <- specific_state_temp %>%
            filter(dt == i & AverageTemperature != "NA")
    
    average <- sum(state_df$AverageTemperature) /
                     length(state_df$AverageTemperature)
    
    averageUncertainty <- sum(df$AverageTemperatureUncertainty) /
                                length(df$AverageTemperatureUncertainty)
    
    high <- average + averageUncertainty
    
    low <- average - averageUncertainty
    
    average_1800_2015_temp$AvgTemp[x] <- average
    average_1800_2015_temp$HighTemp[x] <- high
    average_1800_2015_temp$LowTemp[x] <- low
    inc(x)
  }

}

