# ui.R
library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(plotly)
library(maps)

shinyUI(navbarPage(
  theme = shinytheme("superhero"),
  "Temperature and Disasters",

  # Create an introduction tab ----------------------------------------------


  tabPanel(
    "Introduction",
    titlePanel("The Association Between The Rise In Temperature And
               Frequency Of Natural Disasters"),
    mainPanel(
      tags$p(
        "This project is aimed towards allowing users to discover the
        relationships and impacts between the increase in temperature
        and number of natural disasters.",
        "Recently the U.S. has pulled out of the Paris Climate Agreement
        so we have focused on the U.S. to drive home
        this is a both local and global phenomenon."
      ),
      img(src = "emdat.jpg", align = "center"),
      tags$p(
        "Our data for temperature comes from ",
        tags$a("The International Disaster Database",
          href = "https://www.emdat.be/"
        ),
        " and limiting the disasters to ",
        tags$i("natural, meteorological, hydrological, and climatological"),
        "disasters."
      ),
      img(src = "Data_Society.png", align = "center", width = "600px"),
      tags$p(
        "We'll be using",
        tags$a("the Data Society", href = "https://datasociety.com/about-us/"),
        " for our climate change dataset. Data society is a data
        science training and consulting firm based in Washington,
        D.C. We retrieved the data from ",
        tags$a("Data.World",
          href = "https://data.world/data-society/global-climate-change-data"
        ),
        ", which is a database of datasets."
      )
    )
  ),

  # Create a heatmap of the USA ---------------------------------------------


  tabPanel(
    "USA Heatmap",
    titlePanel("U.S. All-In-One Overview"),
    # Create sidebar layout
    sidebarLayout(

      # Side panel for controls
      sidebarPanel(
        sliderInput("year", "Pick A Year",
          min = 1750, max = 2013, value = 2012,
          step = 10, sep = ""
        ),

        selectInput("unit", "Pick A Unit Of Temperature", choices = list(
          "Fahrenheit", "Celsius"
        ), selected = "Celsius")
      ),
      mainPanel(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
        tags$h2(id = "main-heading", "How has temperature in the U.S. as a 
                whole changed over time?"),
        tags$p(
          "Temperature By Year: ",
          "Has this had an impact on number of natural disasters?",
          "On this page we can see a visualization
          which overviews many different factors that look into these
          questions."
        ),
        plotlyOutput("plot1"),
        textOutput("disaster_text"),
        textOutput("temp_text"),
        tags$p(
          "It is evident that there is indeed a rise in average temperature;
           there is also an apparent",
          "a rise in recorded natural disasters. A more in-depth analysis of 
           each state's temperatures can be seen in the next tab. This will 
           provide clarity towards understanding the temperature trends in the
           U.S."
        )
      )
    )
  ),
  
  # Create a tabPanel to show your bar plot
  tabPanel(
    "Temperature Trends",
    titlePanel("State Versus National Temperature Trends"),
    # Create sidebar layout
    sidebarLayout(

      # Side panel for controls
      sidebarPanel(
        selectInput(
          "state_select",
          choices = c("Alabama", "Alaska" ,"Arizona", "Arkansas", "California",
                      "Colorado", "Connecticut", "Delaware",
                      "District Of Columbia", "Florida", "Georgia (State)",
                      "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                      "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                      "Massachusetts", "Michigan", "Minnesota", "Mississippi", 
                      "Missouri", "Montana", "Nebraska", "Nevada",
                      "New Hampshire", "New Jersey", "New Mexico", "New York",
                      "North Carolina", "North Dakota", "Ohio", "Oklahoma",
                      "Oregon", "Pennsylvania", "Rhode Island",
                      "South Carolina", "South Dakota", "Tennessee",
                      "Texas", "Utah", "Vermont", "Virginia", "Washington",
                      "West Virginia", "Wisconsin", "Wyoming"),
          label = "Select State"
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", "How has the temperature for a state
                changed in the past years?"),
        plotlyOutput("plot2")
      )
    )
  ),

  # Create the natural disaster cost tab ------------------------------------


  tabPanel(
    "Cost Bar Graph",
    titlePanel("Cost Bar Graph"),
    # Create sidebar layout
    sidebarLayout(
      # Side panel for controls
      sidebarPanel(
        sliderInput("tab3_slider",
          label = "Year Range",
          min = 1944,
          max = 2018,
          value = c(1950, 2017)
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotlyOutput("plot3")
      )
    )
  ),

  # Create a line graph using global data -----------------------------------


  tabPanel(
    "Global Line Graph",
    titlePanel("Global Line Graph"),
    # Create sidebar layout
    sidebarLayout(
      # Side panel for controls
      sidebarPanel(
        selectInput(
          "continent_tab4",
          choices = c("Africa", "Americas", "Asia", "Europe", "Oceania"),
          label = "Select Continent"
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", "Is there a correlation
                between climate change and natural disasters?"),
        tags$p(
          "This line graph helps to answer this question by relating",
          " temperature and occurrences of natural disasters."
        ),
        plotlyOutput("plot4"),
        textOutput("text_tab4")
      )
    )
  ),

  # Create a global map using global data -----------------------------------


  tabPanel(
    "Global Map",
    titlePanel("Global Map of Disasters and Temperature"),
    # Create sidebar layout
    sidebarLayout(
      # Used the link below to figure out how to remove comma from years
      # https://stackoverflow.com/questions/26636335/formatting-number-output-of-sliderinput-in-shiny
      # Side panel for controls
      sidebarPanel(
        sliderInput("tab5_year",
          label = "Year",
          min = 1743,
          max = 2013,
          value = 2000,
          sep = ""
        )
      ),
      mainPanel(
        tags$h2(id = "main-heading", ""),
        plotlyOutput("plot5")
      )
    )
  )
))
