library(dplyr)
library(plotly)  
#read temperature data frame

temp_df <- read.csv("data/data-society-global-climate-change-data/GlobalLandTemperaturesByState.csv",
  stringsAsFactors = FALSE)


#create new data frame for average temp per year
average_usa_temp <- temp_df %>%
                      filter(Country == "United States")
average_usa_temp$dt <- substr(average_usa_temp$dt, 1, 4)
# oldest date - 1750, farthest date 2010
average_usa_temp <- average_usa_temp %>%
                      filter(dt > 1799)

average_1800_2015_temp <- data.frame(
  Year = seq(1815, 2010, 5),
  HighTemp = 0,
  AvgTemp = 0,
  LowTemp = 0,
  NationHigh = 0,
  NationAvg = 0,
  NationLow = 0,
  State = ""
)


national_state_temp <- average_usa_temp
national_state_temp$State <- "Nation"

specific_state_temp <- average_usa_temp %>%
                         filter(State == "Washington")
average_1800_2015_temp$State <- "Washington"

inc <- function(x)
{
  eval.parent(substitute(x <- x + 1))
}

x <- 1

for (i in 1815:2010) {
  if (!i %% 5) {
    
    state_df <- specific_state_temp %>%
            filter(dt == i & AverageTemperature != "NA")
    
    nation_df <- national_state_temp %>%
                   filter(dt == i & AverageTemperature != "NA")
    
    average <- sum(state_df$AverageTemperature) /
                     length(state_df$AverageTemperature)
    
    averageUncertainty <- sum(state_df$AverageTemperatureUncertainty) /
                                length(state_df$AverageTemperatureUncertainty)
    nation_average <- sum(nation_df$AverageTemperature) /
      length(nation_df$AverageTemperature)
    
    nationUncertainty <- sum(nation_df$AverageTemperatureUncertainty) /
      length(nation_df$AverageTemperatureUncertainty)
    
    nationHigh <- nation_average + nationUncertainty
    
    nationLow <- nation_average - nationUncertainty
    
    high <- average + averageUncertainty
    
    low <- average - averageUncertainty
    
    average_1800_2015_temp$NationAvg[x] <- nation_average
    average_1800_2015_temp$NationHigh[x] <- nationHigh
    average_1800_2015_temp$NationLow[x] <- nationLow
    average_1800_2015_temp$AvgTemp[x] <- average
    average_1800_2015_temp$HighTemp[x] <- high
    average_1800_2015_temp$LowTemp[x] <- low
    inc(x)
  }
} 
average_1800_2015_temp <- average_1800_2015_temp %>%
                          filter(HighTemp != "NaN")

  national_fit <- lm(NationAvg ~ Year, data = average_1800_2015_temp)
  state_fit <- lm(AvgTemp ~ Year, data = average_1800_2015_temp)
  
  average_1800_2015_temp$Year <- factor(average_1800_2015_temp$Year, levels = average_1800_2015_temp[["Year"]])
  
  p <- plot_ly(average_1800_2015_temp, x = ~Year, y = ~NationHigh, type = 'scatter', mode = 'lines & markers',
               line = list(color = 'transparent'),
               showlegend = FALSE, text = 'National High', name = " ") %>%
    add_trace(y = ~NationLow, type = 'scatter', mode = 'lines',
              fill = 'tonexty', fillcolor='rgba(0,100,80,0.2)', line = list(color = 'transparent'),
              showlegend = FALSE, text = 'National Low', name = " ") %>%
    add_trace(y = ~NationAvg, type = 'scatter', mode = 'lines',
              line = list(color='rgb(0,100,80)'),
              text = 'National Average', name = " ") %>%
    add_trace(y = fitted(national_fit),
              line = list(color='rgb(0,0,0)', dash = 'dash'), text = 'National Trend',
              name = " ") %>%
    
    add_trace(y = ~AvgTemp, type = 'scatter', mode = 'lines',
              line = list(color='rgb(100,0,40)'),
              text = ~paste(average_1800_2015_temp$State, 'Average'), name = " ") %>%
    add_trace(y = ~HighTemp, type = 'scatter', mode = 'lines', 
              fillcolor='rgba(100,0,40,0.2)', line = list(color = 'transparent'),
              showlegend = FALSE, text = ~paste(average_1800_2015_temp$State, 'High'), name = " ") %>%
    add_trace(y = ~LowTemp, type = 'scatter', mode = 'lines',
              fill = 'tonexty', fillcolor='rgba(100,0,40,0.2)', line = list(color = 'transparent'),
              showlegend = FALSE, text = ~paste(average_1800_2015_temp$State, 'Low'), name = " ") %>%
    add_trace(y = fitted(state_fit),
              line = list(color='rgb(0,0,0)', dash = 'dash'), text = ~paste(average_1800_2015_temp$State, 'Trend'),
              name = " ") %>%

  
    layout(title = ~paste("Temperatures for", average_1800_2015_temp$State,
                          "and United States"),
           paper_bgcolor='rgb(255,255,255)', plot_bgcolor='rgb(229,229,229)',
           hovermode = 'compare',
           xaxis = list(title = "Years",
                        gridcolor = 'rgb(255,255,255)',
                        showgrid = TRUE,
                        showline = FALSE,
                        showticklabels = TRUE,
                        tickcolor = 'rgb(127,127,127)',
                        ticks = 'outside',
                        zeroline = FALSE),
           yaxis = list(title = "Temperature (degrees C)",
                        gridcolor = 'rgb(255,255,255)',
                        showgrid = TRUE,
                        showline = FALSE,
                        showticklabels = TRUE,
                        tickcolor = 'rgb(127,127,127)',
                        ticks = 'outside',
                        zeroline = FALSE))
  p
  

