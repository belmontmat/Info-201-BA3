library(dplyr)
library(plotly)
library(ggplot2)
library(countrycode)

temperatures_by_country <- read.csv("data/data-society-global-climate-change-data/GlobalLandTemperaturesByCountry.csv")
temperatures_by_country$iso <- countrycode(temperatures_by_country$Country, "country.name", "iso3c")
temperatures_by_country$year <- substr(temperatures_by_country$dt, 1, 4)

# temp_test <- temperatures_by_country %>% 
#   filter(year == "1772")

# plot_geo() %>% 
#   add_trace(
#     z = temp_test$AverageTemperature, 
#  locations = temp_test$country_code, color = ~temp_test$AverageTemperature, colors= "Blues") %>% 
#     layout(geo = list(
#       showframe = FALSE,
#       projection = list(type = 'Mercator')
#     )
#   )
# 
