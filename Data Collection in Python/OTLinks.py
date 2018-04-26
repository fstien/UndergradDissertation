
# coding: utf-8

# In[3]:

from selenium import webdriver
from bs4 import BeautifulSoup
import time
from time import sleep
import timeit
import datetime
import time
import re
import math
import random
import openpyxl
import numpy
import os
import sys
import glob
from sys import exit
import csv
import lxml

from xlsxwriter.workbook import Workbook



from difflib import SequenceMatcher

def compare(a, b): return SequenceMatcher(None, a, b).ratio()

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys


# In[4]:

userAgents = [
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7",
	"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko", 
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56",
	"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.2.7 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.7",
	"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
	"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
	"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
	"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.3; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
	"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0",
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:41.0) Gecko/20100101 Firefox/41.0",
	"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:42.0) Gecko/20100101 Firefox/42.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0",
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.3; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0",
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
	"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36"
]


# In[5]:

city = input("City: ")

url = input("Enter city link where data is: ")

lag = 0.2

dataFolder = "data/"


# In[27]:

def printData(page):

    bsObj = BeautifulSoup(driver.page_source, "lxml")

    venues = bsObj.findAll(class_="content-section-list-row")

    for index, venue in enumerate(venues):
        
        global restoIndex
        
        restoIndex += 1

        name = venue.find(class_="rest-row-name").get_text()

        link = venue.find(class_="rest-row-info").find("a")["href"]

        try:
            price = venue.find(class_="rest-row-pricing").find("i").get_text()
            price = price.replace("\$", "").replace("\n", " ").replace(" ", "")
            price = len(price)
        except:
            price = "NotFound"
            
        cuisine = venue.find(class_="rest-row-meta").get_text()
        cuisine = cuisine.split("|",1)[0]
        cuisine = cuisine.replace("\$", "").replace("\n", " ").replace(" ", "")

        try: 
            reviews = venue.find(class_="star-rating-text").get_text()
            reviews = reviews.replace("(", "").replace(")", "")
            reviews = int(reviews)
        except: 
            reviews = 0
        
        
        with open(dataFolder + city + "OTLinks.csv", "a") as myfile:
            wr = csv.writer(myfile)
            
            dataTime = time.strftime("%a, %d %b %Y %X", time.gmtime()).replace(",", "")

            wr.writerow([dataTime, city, name, restoIndex, 0, cuisine, reviews, price, link])



# In[ ]:




# In[28]:

try: 
	randomUA = random.choice(userAgents)
	dcap = dict(DesiredCapabilities.PHANTOMJS)
	dcap["phantomjs.page.settings.userAgent"] = randomUA
	driver = webdriver.PhantomJS(desired_capabilities=dcap)

	driver.set_window_size(1100 + random.randint(-100, 100), 1000 + random.randint(-100, 100))
    
except: 
	print("ERROR: Could not set user agent.")
    
try:
	driver.get(url)
    
	element = WebDriverWait(driver, 30).until(
		EC.presence_of_element_located((By.ID, "results-pagination")))
    
	time.sleep(0.3)
    
except: 
	print("ERROR: Could not load page.")

try:
    
	bsObj = BeautifulSoup(driver.page_source, "lxml")

	numReviews = bsObj.find(id="results-title").get_text()
	numReviews = re.sub("[^0-9]", "", numReviews)
	numReviews = numReviews.replace("\$", "").replace("\n", " ").replace(" ", "")
	numReviews = int(numReviews)
	
	pageCount = math.ceil(numReviews/100)
            
except:
	print("ERROR: Could find the number of pages.")
    


# In[29]:

with open(dataFolder + city + "OTLinks.csv", "a") as myfile:
    wr = csv.writer(myfile)
    wr.writerow(["Time", "City", "Name", "Index", "Status", "Cuisine", "NumberOfRatings", "Price", "Link"])

restoIndex = 0    

printData(1)
time.sleep(0.3)

for i in range(1, pageCount):
    driver.find_element_by_css_selector("span[data-from=" + "'" + str(i) + "00" + "'" + "]").click()
    element = WebDriverWait(driver, 30).until(
        EC.presence_of_element_located((By.ID, "results-pagination")))
    time.sleep(2)
    printData(i + 1)


# In[6]:

workbook = Workbook(dataFolder + city + "OTLinks" + '.xlsx')
worksheet = workbook.add_worksheet()
with open(dataFolder + city + "OTLinks.csv") as f:
    reader = csv.reader(f)
    for r, row in enumerate(reader):
        for c, col in enumerate(row):
            worksheet.write(r, c, col)
workbook.close()


# In[ ]:




# In[ ]:



