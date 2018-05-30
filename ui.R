# ui.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(maps)
shinyUI(navbarPage(
  theme = shinytheme("cerulean"),
  "Temperature and Disasters",
  # Create a tab panel for your map
  tabPanel(
    "Overview",
    titlePanel("test")
    # Create sidebar layout

      # Main panel: display map
        # Maybe add an image
  ),
  tabPanel(
    "USA Heatmap",
    titlePanel("Climate Change in the USA"),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        sliderInput("year","Pick A Year", min = 1750, max = 2013, value = 2012),
        
        selectInput("unit", "Pick A Unit Of Temperature", choices = list(
          "Farenheit", "Celsius"), selected = "Celsius")
      ),
      mainPanel(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$h2(id = "main-heading", "Temperature By Year"),
        plotlyOutput("plot1"),
        textOutput("disaster_text")
      )
    )
  ),
  # Create a tabPanel to show your bar plot
  tabPanel(
    "Tab 2",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        # selectInput(
        #             )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot2")
      )
    )
  ),
  tabPanel(
    "Tab 3",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        # selectInput(
        # )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot3")
      )
    )
  ),
  tabPanel(
    "Global Line Graph",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        # selectInput(
        # )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot4")
      )
    )
  ),
  tabPanel(
    "Tab 5",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        # selectInput(
        # )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot5")
      )
    )
  )
)
)