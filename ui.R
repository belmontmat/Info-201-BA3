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
    "Introduction",
    titlePanel("The Association Between The Rise In Temperature And Frequency Of Natural Disasters"),
    mainPanel(
    tags$p("This project is aimed towards allowing users to discover the relationships and impacts between the increase in temperature and number of natural disasters.",
           "Recently the U.S. has pulled out of the Paris Climate Agreement so we have focused on the U.S. to drive home this is a local and global phenomenon"),
      img(src="emdat.jpg", align = "center"),
      tags$p("Our data for temperature comes from ",
             tags$a("The International Disaster Database",
                    href = "https://www.emdat.be/"),
             " and limiting the disasters to ",
             tags$i("natural, meteorological, hydrological, and climatological"),
             "disasters."),
      img(src="Data_Society.png", align = "center", width = "600px"),
      tags$p("We'll be using",
             tags$a("the Data Society", href = "https://datasociety.com/about-us/"),
             " for our climate change dataset. Data society is a data science training and consulting firm based in Washington, D.C. We retrieved the data from ",
             tags$a("Data.World", href = "https://data.world/data-society/global-climate-change-data"),
             ", a database of datasets.")
    )
    
  ),
  tabPanel(
    "USA Heatmap",
    titlePanel("U.S. All-In-One Overview"),
    # Create sidebar layout
    sidebarLayout(
      
      # Side panel for controls
      sidebarPanel(
        sliderInput("year","Pick A Year", min = 1750, max = 2013, value = 2012,
                    step = 10),
        
        selectInput("unit", "Pick A Unit Of Temperature", choices = list(
          "Fahrenheit", "Celsius"), selected = "Celsius")
      ),
      mainPanel(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$h2(id = "main-heading", "Temperature By Year"),
        tags$p("How has temperature in the U.S. as a whole changed over time? ",
               "Has this had an impact on number of natural disasters?",
               "On this page we can see a visual overview of many different factors."),
        plotlyOutput("plot1"),
        textOutput("disaster_text"),
        textOutput("temp_text"),
        tags$p("We see there is indeed a rise in average temperature as well as",
               "a rise in recorded disasters. A more in-depth analysis of each state can be seen in the next tab.")
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
    "Tab 4",
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
      # Used the link below to figure out how to remove comma from years
      # https://stackoverflow.com/questions/26636335/formatting-number-output-of-sliderinput-in-shiny
      sidebarPanel(
         sliderInput("tab5_year", label = "Year", min = 1743, max = 2013, value = 2000, sep = "")
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotlyOutput("plot5")
      )
    )
  )
)
)