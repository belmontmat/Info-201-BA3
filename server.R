# server.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(maps)

# Start shinyServer
shinyServer(function(input, output) {
  
  # Plot for overview
  output$plot_over <- renderPlot {(
    
  )}
  # Plot for Tab 1
  output$plot1 <- renderPlot {(
    
  )}
  # Plot for Tab 2
  output$plot2 <- renderPlot {(
    
  )}
  # Plot for Tab 3
  output$plot3 <- renderPlot {(
    
  )}
  # Plot for Tab 4
  output$plot4 <- renderPlot {(
    
  )}
})