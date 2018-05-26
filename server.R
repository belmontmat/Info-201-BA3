# server.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(maps)
library(plotly)

# Start shinyServer
shinyServer(function(input, output) {
  
  # Plot for Tab 1
  output$plot1 <- renderPlotly ({
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
    specific <- joined %>% filter(dt == input$year)
    # Change unit of measurement
    if (input$unit == "Fahrenheit"){
      specific$AverageTemperature <- specific$AverageTemperature * 1.8 + 32
    }
    # Make the map
    p <- ggplot(
      data = usa,
      mapping = aes(x = long, y = lat, group = group)
    ) +
      geom_polygon(
        fill = "darkorange3",
        color = "black"
      ) +
      coord_fixed(1.3) +
      geom_polygon(data = states, fill = NA, color = "white") +
      # Map our input
      geom_polygon(
        data = specific, aes(fill = AverageTemperature),
        color = "white"
      ) + labs(fill = "Average Temperature",
               x = "Longitude",
               y = "Latitude") +
      # Add input theme
      scale_fill_gradient(low = "#f73131", high = "#f7e64a", space = "Lab",
                          na.value = "grey50", guide = "colourbar")
    ggplotly(p)
  })
  
  #Tab 1 text output
  output$disaster_text <- renderText ({
    disaster_df <- read.csv("data/emdat-disasters/USA_disasters.csv")
    disaster_df <- disaster_df %>% 
      filter(year == input$year) %>%
      select(occurrence)
    paste0("There were ", disaster_df[1,1], " natural disasters this year")
  })
  # Plot for Tab 2
  output$plot2 <- renderPlot ({
    
  })
  # Plot for Tab 3
  output$plot3 <- renderPlot ({
    
  })
  # Plot for Tab 4
  output$plot4 <- renderPlot ({
    #get needed data
    temp <- read.csv("data/data-society-global-climate-change-data/AverageGlobalTempPerYear.csv")
    disa <- read.csv("data/emdat-disasters/Data.csv")
    #reduce to needed columns
    disaster <- disa %>% 
      select(year,occurrence)
    #combine data frames
    names(disaster)[1] <- "Year"
    combined <- merge(temp,disaster,by="Year")
    #aggregate to remove repeated rows
    combined <- aggregate(. ~ Year + X + Temp, data = combined,sum)
    p <- ggplot() +
      geom_line(mapping = aes(x = combined$Temp, y = combined$occurrence))
    p
    
  })
  # Plot for Tab 5
  output$plot5 <- renderPlot ({
    
  })
})