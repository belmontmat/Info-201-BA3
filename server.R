# server.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(maps)
library(plotly)

# Start shinyServer
shinyServer(function(input, output) {


  # Tab 1 -------------------------------------------------------------------

  # Plot
  output$plot1 <- renderPlotly({
    # Data wrangling
    source("scripts/avg_usa_temp.R")
    specific <- joined %>% filter(dt == input$year)
    # Change unit of measurement
    if (input$unit == "Fahrenheit") {
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
      ) + labs(
        fill = "Average Temperature",
        x = "Longitude",
        y = "Latitude"
      ) +
      # Add input theme
      scale_fill_gradient(
        low = "#f7e64a", high = "#f73131", space = "Lab",
        na.value = "grey50", guide = "colourbar"
      )
    ggplotly(p)
  })

  # Text output
  output$disaster_text <- renderText({
    disaster_df <- read.csv("data/emdat-disasters/USA_disasters.csv")
    disaster_df <- disaster_df %>%
      filter(year == input$year) %>%
      select(occurrence)
    num_dis <- disaster_df[1, 1]
    if (is.na(num_dis)) {
      paste0("There is no data on natural disasters for this year.")
    } else if (num_dis != 1) {
      paste0("There were ", num_dis, " natural disasters in ", input$year, ".")
    } else {
      paste0("There was one natural disaster in ", input$year, ".")
    }
  })
  output$temp_text <- renderText({
    source("scripts/avg_usa_temp.R")
    specific <- joined %>% filter(dt == input$year)
    paste0(
      "The average temperature in the U.S. was ",
      round(mean(specific$AverageTemperature), 1),
      " degrees ", input$unit, "."
    )
  })

  # Tab 2 -------------------------------------------------------------------


  # Plot
  output$plot2 <- renderPlotly({
    #read temperature data frame
    #source("scripts/yearly_temp_change_usa.R")
    temp_df <- read.csv("data/data-society-global-climate-change-data/GlobalLandTemperaturesByState.csv",
                        stringsAsFactors = FALSE)
    
    #create new data frame for average temp per year
    average_usa_temp <- temp_df %>%
      filter(Country == "United States")
    average_usa_temp$dt <- substr(average_usa_temp$dt, 1, 4)
    # oldest date - 1750, farthest date 2010
    average_usa_temp <- average_usa_temp %>%
      filter(dt > 1814)
    
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
      filter(State == input$state_select)
    average_1800_2015_temp$State <- input$state_select
    
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
  })

  # Tab 3 -------------------------------------------------------------------


  # Plot
  output$plot3 <- renderPlotly({
    disasters <- read.csv("data/emdat-disasters/USA_disasters_gapless.csv",
      stringsAsFactors = FALSE
    )
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

  # Tab 4 -------------------------------------------------------------------


  # Plot
  output$plot4 <- renderPlotly({
    # get needed data
    temp <- read.csv("data/data-society-global-climate-change-data/AverageGlobalTempPerYear.csv",
      stringsAsFactors = FALSE
    )
    disa <- read.csv("data/emdat-disasters/Data.csv",
      stringsAsFactors = FALSE
    )

    continent_disaster <- disa %>%
      filter(continent == input$continent_tab4) %>%
      select(year, occurrence)
    names(continent_disaster)[1] <- "Year"
    continent_combined <- merge(temp, continent_disaster, by = "Year")
    # reduce to needed columns
    disaster <- disa %>%
      select(year, occurrence)
    # combine data frames
    names(disaster)[1] <- "Year"
    combined <- merge(temp, disaster, by = "Year")
    # aggregate to remove repeated rows
    combined <- aggregate(. ~ Year + X + Temp, data = combined, sum)
    p <- ggplot() +
      geom_line(
        mapping =
          aes(
            x = combined$Temp,
            y = combined$occurrence,
            color = "red"
          )
      ) +
      geom_line(
        mapping =
          aes(
            x = continent_combined$Temp,
            y = continent_combined$occurrence,
            color = "blue"
          )
      ) +
      labs(
        title = "How Disasters Relate to Temperature",
        y = "Number of Disasters",
        x = "Temperature"
      ) +
      scale_color_discrete(
        name = "Line Color",
        labels = c("Total", input$continent_tab4)
      )

    ggplotly(p) %>%
      layout(hovermode = "compare")
  })

  # Text output
  output$text_tab4 <- renderText({
    "As you can see by the graph, the amount of disasters trends upward with 
    higher temperatures. This shows a correlation between how hot it is and how
    many disasters occur. We can also observe the fact that Asia has the highest
    occurrence of overall. This could be attributed to the high amount of greenhouse
    gasses emmited by China and other developing countries. It could also have to do
    with geographical location, since the Americas emits a high amount of greenhouse
    gasses, yet remains relativley low in disaster occurrences."
  })

  # Tab 5 -------------------------------------------------------------------


  # Plot
  output$plot5 <- renderPlotly({
    source("scripts/average_global_temp.R")
    disasters_by_country <-
      read.csv("data/disaster_by_country_removed_bottom.csv",
        stringsAsFactors = FALSE
      )
    global_temps <- temperatures_by_country %>%
      filter(year == input$tab5_year) %>%
      group_by(iso) %>%
      summarise(AverageTemperature = mean(AverageTemperature))
    global_disasters <- disasters_by_country %>%
      filter(year == input$tab5_year)
    global_data <- full_join(global_temps, global_disasters, by = "iso")

    plot <- plot_geo() %>%
      add_trace(
        z = global_data$AverageTemperature,
        text = paste("# of Disasters:", global_data$occurrence),
        locations = global_data$iso,
        color = ~ global_data$AverageTemperature,
        colors = c("blue", "orange")
      ) %>%
      layout(geo = list(
        showframe = FALSE,
        projection = list(type = "Mercator")
      )) %>%
      colorbar(title = "Average Temperature")

    plot
  })
})
