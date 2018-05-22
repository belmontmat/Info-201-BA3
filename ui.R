# ui.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(maps)
shinyUI(navbarPage(
  theme = shinytheme("cerulean"),
  "Project",
  # Create a tab panel for your map
  tabPanel(
    "Overview",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        # Input to select variable to map
        selectInput(
          )
        )
      ),
      
      # Main panel: display map
      mainPanel(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$h2(id = "main-heading", ""),
        plotOutput("plot_over")
      )
    )
  ),
  tabPanel(
    "Tab 1",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        selectInput(
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot1")
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
        selectInput(
                    )
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
        selectInput(
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot3")
      )
    )
  ),
  tabPanel(
    "Tab 4",
    titlePanel(""),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        selectInput(
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotOutput("plot4")
      )
    )
  )
)
