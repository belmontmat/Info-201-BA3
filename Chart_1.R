library(dplyr)
library(ggplot2)

df <- read.csv("data/emdat-disasters/Data.csv")

year_jitter <- function(data,y_choice,country){
  df_choice <- df %>% 
    filter(continent == country)
  ggplot(data = df_choice) +
      geom_jitter(mapping = aes(
    x = year, y = y_choice
    ))
}