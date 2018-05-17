# Informatics 201 Final Project
## Group BA-3, Spring 2018

### Topic
Our topic is the relationship between climate change and the **global** increase in natural disasters. 

### Data
We'll be using the [Data Society]("https://datasociety.com/about-us/") for our climate change dataset. Data society is a data science training and consulting firm based in Washington, D.C. We retrieved the data from [Data.World]("https://data.world/data-society/global-climate-change-data"), a database of datasets. For the natual disasters we are using [The International Disaster Database]("http://emdat.be/") and limiting the disasters to _natural_, _meteorological_, _hydrological_, and _climatological_ disasters. Our target audience are policy makers who wish to see the impacts of climate change, maybe more specifically those who doubted the major consequences. These policy makers would want to know: Is there a direct and undeniable link between climate change and natural disasters? How much has the climate really changed and is it worrysome? Does this impact my local constituants?

## Technical
Our data from both databases are from .csv files. However, because we are using multiple data sets we will need to join the two data sets by location which we expect to be contained in dplyr and ggplot2. Our major challenges we anticipate are mostly wrangling our two data sets into a format to where we can make many graphs from them, this may have to be solved by creating a few dataframes rather than just one.  
