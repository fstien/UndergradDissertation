# Cheating in Online Ratings and Restaurant Competition

## Abstract
We investigate fake online ratings which are posted by restaurant on their competitors. As consumers use online ratings to choose where to eat out, restaurants face an incentive to post fake negative ratings on their competitors. This might undermine the credibility of honest ratings and lead to a decrease in consumer welfare. We examine whether restaurants respond to the incentive to cheat on the basis of what drives consumer choices, which would maximise the benefit of cheating. Cheating is measured by exploiting an organisation difference between two popular ratings websites: TripAdvisor and OpenTable. We measure different types of competition by discounting competing restaurants in the same price range or cuisine type according to distance. We find that an increased presence of competitors in the same price range or of similar ranking leads to a statistically significant increase in cheating suffered by restaurants. Restaurants cheat on competitors in the same price range and who are close in the ranking. This suggests that economic incentives factor into the decision to cheat.


## Project structure: 

### 1. Data Collection in Python : Python 3 scripts to scrape ratings from OpenTable restaurants and to map restaurants with pages on TripAdvisor and scrape data from there. Stack: PhantomJS, Selenium, BeautifulSoup and OpenPyxl.

- OTLinks.py assembles a dataset containing all OpenTable restaurant page links and basic info for a given city. 
- OTData.py scrables the restaurant webpages and parses them and stores them in a csv file. 

- TALinks.py assembles a dataset containing all TripAdvisor restaurant page links and basic info for a given city. 
- TAData.py scrables the restaurant webpages and parses them and stores them in a csv file. 

- OTTAMap.py matches the restaurants from both sources by comparing a number of features including phone number, location coordinates and address .

To avoid getting your IP blocked, consider using AWS EC2 instances.

### 2. CSV Data Files : data tables with restaurant level rating data for a set of cities in the US from both TripAdvisor and OpenTable. 

In any given city:
- TAData.csv : TripAdvisor Data
- OTData.csv : OpenTable Data
- Match.csv : Matched data between TripAdvisor and OpenTable.

### 3. Modelling in R: 

- buildDataset.r reads in the csv files, cleans the data and constructs variables. Saves the dataset to data.csv. 

- runRegressions.r contains the core econometric analysis and produces graphics included in the paper. 

- tables.html includes the regression tables. 



## Outcome

Winner of the University Prize for ‘Best Performance in Research in Applied Economics’ (£150), awarded a grade of 87%. 

