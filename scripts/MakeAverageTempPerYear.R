library(dplyr)
library(ggplot2)  
#read temperature data frame
temp_df <- read.csv(
  "data/data-society-global-climate-change-data/BerkleyAverageTemp.csv",
  stringsAsFactors = FALSE
  )

#create new data frame for average temp per year
average_global_temp <- data.frame(
  Year = c(1750:2015),
  Temp = 0
)

#loop through each year, summing up temperature and finding average
for (i in 1750:2015){
  df <- temp_df %>%  
    filter(substr(dt,1,4) == i)
  average <- sum(df$LandAverageTemperature)/length(df$LandAverageTemperature)
  average_global_temp$Temp[i-1749] = average
}

#plot temp vs time
ggplot(data = average_global_temp)+
  geom_jitter(mapping = aes(y = Temp,
                            x = Year))
#write new df to a csv
write.csv(average_global_temp, 
          file = "data/data-society-global-climate-change-data/AverageGlobalTempPerYear.CSV")