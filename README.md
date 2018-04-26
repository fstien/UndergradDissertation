# Web scraping for "Cheating in Online Ratings and Restaurant Competition" paper

Winner of the University Prize for ‘Best Performance in Research in Applied Economics’ (£150), awarded a grade of 89%. 

Project structure: 

* Data Collection in Python : Python 3 scripts to scrape ratings from OpenTable restaurants and to map restaurants with pages on TripAdvisor and scrape data from there. Stack: PhantomJS, Selenium, BeautifulSoup and OpenPyxl.

- OTLinks.py assembles a dataset containing all OpenTable restaurant page links and basic info for a given city. 
- OTData.py scrables the restaurant webpages and parses them and stores them in a csv file. 

- TALinks.py assembles a dataset containing all TripAdvisor restaurant page links and basic info for a given city. 
- TAData.py scrables the restaurant webpages and parses them and stores them in a csv file. 

- OTTAMap.py matches the restaurants from both sources by comparing a number of features including phone number, location coordinates and address .

To avoid getting your IP blocked, consider using AWS EC2 instances.

* CSV Data Files : data tables with restaurant level rating data for a set of cities in the US from both TripAdvisor and OpenTable. 

* Modelling in R: 

- buildDataset.r reads in the csv files, cleans the data and constructs variables. Saves the dataset to data.csv. 

- runRegressions.r contains the core econometric analysis and produces graphics included in the paper. 

- tables.html includes the regression tables. 

