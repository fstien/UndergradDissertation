
# coding: utf-8

# In[1]:

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


# In[2]:

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


# In[3]:

city = input("City: ")

url = input("Enter city link where data is: ")

lag = 3

dataFolder = "data/"


# In[4]:

def printData():

    bsObj = BeautifulSoup(driver.page_source, "lxml")

    resultArray = bsObj.find(id="EATERY_SEARCH_RESULTS").findAll(class_="listing")

    for item in resultArray:

        data = item.find(class_="shortSellDetails")

        dataDictionnary = {}
        try:
            Name = data.find(class_="title").find("a").get_text().replace("\n","")
        except:
            Name = "NotFound"

        try:
            Link = data.find(class_="title").find(class_="property_title")['href']
        except:
            Link = "NotFound"

        try:
            Ranking = data.find(class_="popIndexBlock").get_text().replace("\n","").split(" ")[0].replace("#", "").replace(",", "")
        except:
            Ranking = "NotFound"

        try:
            RatingCount = data.find(class_="reviewCount").get_text().replace("\n","").split(" ")[0].replace(",","")
        except:
            RatingCount = "NotFound"

        try:
            Lat = float(data.find(class_="links").find("a")['onclick'].split(",")[7].replace(" ","").replace("'",""))
        except:
            Lat = "NotFound"

        try:
            Long = float(data.find(class_="links").find("a")['onclick'].split(",")[8].replace(" ","").replace("'",""))    
        except:
            Long = "NotFound"

        try:
            
            Cuisince = data.findAll(class_="cuisine")[0].get_text()
            
        except:
            Cuisince = "NotFound"

        
        with open(dataFolder + city + "TALinks.csv", "a") as myfile:
            wr = csv.writer(myfile)
            
            dataTime = time.strftime("%a, %d %b %Y %X", time.gmtime()).replace(",", "")

            wr.writerow([dataTime, city, Name, Ranking, 0, Cuisince, Long, Lat, RatingCount, Link])



# In[ ]:




# In[5]:

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
	time.sleep(random.randint(lag, lag + 1))
except: 
	print("ERROR: Could not load page.")

try:
	bsObj = BeautifulSoup(driver.page_source, "lxml")
	links = bsObj.find(class_="pageNumbers").findAll(class_="taLnk")

	pageCount = int(links[-1].get_text())

except:
	print("ERROR: Could find the number of pages.")
    


# In[6]:

with open(dataFolder + city + "TALinks.csv", "a") as myfile:
    wr = csv.writer(myfile)
    wr.writerow(["Time", "City", "Name", "Ranking", "Status", "Cuisine", "Longitude", "Latitude", "NumberOfRatings", "Link"])

printData()
time.sleep(random.randint(lag, lag + 1))

for i in range(0, pageCount -1):
    driver.find_element_by_class_name("next").click()
    time.sleep(random.randint(lag, lag + 1))
    printData()


# In[4]:

workbook = Workbook(dataFolder + city + "TALinks" + '.xlsx')
worksheet = workbook.add_worksheet()
with open(dataFolder + city + "TALinks.csv") as f:
    reader = csv.reader(f)
    for r, row in enumerate(reader):
        for c, col in enumerate(row):
            worksheet.write(r, c, col)
workbook.close()


# In[ ]:




# In[ ]:



