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
    # Data wrangling
    source("scripts/avg_usa_temp.R")
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
        fill = "grey",
        color = "white"
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
      scale_fill_gradient(low = "#f7e64a", high = "#f73131", space = "Lab",
                          na.value = "grey50", guide = "colourbar")
    ggplotly(p)
  })
  
  #Tab 1 text output
  output$disaster_text <- renderText ({
    disaster_df <- read.csv("data/emdat-disasters/USA_disasters.csv")
    disaster_df <- disaster_df %>% 
      filter(year == input$year) %>%
      select(occurrence)
    num_dis <- disaster_df[1,1]
    if(is.na(num_dis)){
      paste0("There is no data on natural disasters for this year.")
    }else if(num_dis != 1){
      paste0("There were ", num_dis, " natural disasters in ",input$year,".")
    } else {
      paste0("There was one natural disaster in ",input$year,".")
    }
  })
  output$temp_text <- renderText ({
    source("scripts/avg_usa_temp.R")
    specific <- joined %>% filter(dt == input$year)
    paste0("The average temperature in the U.S. was ",
           round(mean(specific$AverageTemperature),1),
           "degrees ", input$unit, ".")
  })
  # Plot for Tab 2
  output$plot2 <- renderPlot ({
    
  })
  # Plot for Tab 3
  output$plot3 <- renderPlotly ({
    disasters <- read.csv("data/emdat-disasters/USA_disasters_gapless.csv", stringsAsFactors = FALSE)
    plot_data <- disasters %>% 
      filter(year >= input$tab3_slider[1]) %>% 
      filter(year <= input$tab3_slider[2])
    
    plot_ly(
      x = plot_data$year,
      y = plot_data$occurrence,
      type = "bar",
      color = plot_data$Total.damage....000.US..
    ) %>% 
      colorbar(title = "Damage Cost (Dollars)")
    
  })
  # Plot for Tab 4
  output$plot4 <- renderPlotly ({
    #get needed data
    temp <- read.csv("data/data-society-global-climate-change-data/AverageGlobalTempPerYear.csv",
                     stringsAsFactors = FALSE)
    disa <- read.csv("data/emdat-disasters/Data.csv",
                     stringsAsFactors = FALSE)
    
    continent_disaster <- disa %>%
      filter(continent == input$continent_tab4) %>% 
      select(year,occurrence)
    names(continent_disaster)[1] <- "Year"
    continent_combined <- merge(temp,continent_disaster,by = "Year")
    #reduce to needed columns
    disaster <- disa %>% 
      select(year,occurrence)
    #combine data frames
    names(disaster)[1] <- "Year"
    combined <- merge(temp,disaster,by="Year")
    #aggregate to remove repeated rows
    combined <- aggregate(. ~ Year + X + Temp, data = combined,sum)
    p <- ggplot() +
      geom_line(mapping = 
                  aes(x = combined$Temp, 
                      y = combined$occurrence, color = "red")) +
      geom_line(mapping = 
                  aes(x = continent_combined$Temp, 
                      y = continent_combined$occurrence,color = "blue")
                ) +
      labs(title = "How Disasters Relate to Temperature",
           y = "Number of Disasters",
           x = "Temperature") +
      scale_color_discrete(name = "Line Color",labels = c("Total",input$continent_tab4))
      
    ggplotly(p) %>% 
      layout(hovermode = "compare")
    
  })
  output$text_tab4 <- renderText({
    "As you can see by the graph, the amount of disasters trends upward with 
    higher temperatures. This shows a correlation between how hot it is and how
    many disasters occur. We can also observe the fact that Asia has the highest
    occurrence of disasters over time"
  })
  # Plot for Tab 5
  output$plot5 <- renderPlotly ({
    source("scripts/average_global_temp.R")
    source("scripts/global_disasters.R")
    global_temps <- temperatures_by_country %>% 
      filter(year == input$tab5_year) %>% 
      group_by(iso) %>% 
      summarise(AverageTemperature = mean(AverageTemperature))
    global_disasters <- disasters_by_country %>% 
      filter(year == input$tab5_year)
    global_data <- full_join(global_temps, global_disasters, by = "iso")
    
    plot <- plot_geo() %>% 
      add_trace(
        z = global_data$AverageTemperature, text = paste("# of Disasters:", global_data$occurrence),
        locations = global_data$iso, color = ~global_data$AverageTemperature, colors= c("blue","orange")) %>% 
      layout(geo = list(
        showframe = FALSE,
        projection = list(type = 'Mercator')
        
      )
      ) %>% 
      colorbar(title= "Average Temperature")
    
    plot
  })
})