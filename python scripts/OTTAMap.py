
# coding: utf-8

# In[31]:

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

import math
from math import radians, cos, sin, asin, sqrt

from difflib import SequenceMatcher

def similar(a, b):
    return SequenceMatcher(None, a, b).ratio()

def compare(a, b): return SequenceMatcher(None, a, b).ratio()

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys


# In[32]:

city = input("Enter city: ")

dataFolder = "data/"


# In[33]:

def gaussian(num, sd):
    out = (1/(math.sqrt(2*math.pi*(sd**2)))) * math.exp( (-(num**2)) / (2*(sd**2)) )
    return(out)

def haversine(lon1, lat1, lon2, lat2):
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    km = 6367 * c
    return(km)


# In[41]:

'''
rowTA = Time,City,Name,ReviewCount,Price,Cuisine,Longitude,Latitude,Address,PhoneNumber,Ranking,MeanRating,1,2,3,4,5,Link
rowOT = Time,City,Name,Index,ReviewCount,Price,Cuisine,Longitude,Latitude,Address,PhoneNumber, url, MeanRating,1,2,3,4,5,Link
          0    1   2     3      4           5     6        7         8       9        10       11       12  ...        17
'''

with open(dataFolder + city + "Match.csv", "a") as matchFile:
    
    with open(dataFolder + city + "OTData.csv") as OTDataFile:
        readerOT = csv.reader(OTDataFile)
        OT1 = next(readerOT)
        
    for index, item in enumerate(OT1): 
        OT1[index] = "OT" + OT1[index]

    with open(dataFolder + city + "TAData.csv") as TADataFile:
        readerTA = csv.reader(TADataFile)
        TA1 = next(readerTA)
    
    for index, item in enumerate(TA1): 
        TA1[index] = "TA" + TA1[index]
    
    wr = csv.writer(matchFile)
    wr.writerow(OT1 + TA1)  
    
matchCount = 0

overallCount = 0

with open(dataFolder + city + "OTData.csv") as csvOT:
    
    next(csvOT, None) 
    
    for indexOT, rowOT in enumerate(csv.reader(csvOT, delimiter=',')):
        
        overallCount += 1
        
        highscore = 0
        TAmatch = []
        
        with open(dataFolder + city + "TAData.csv") as csvTA:

            next(csvTA, None) 
            
            for indexTA, rowTA in enumerate(csv.reader(csvTA, delimiter=',')):

                score = 0
                         
                try:
                    #distance = math.sqrt( ( float(rowTA[7]) - float(rowOT[8]) )**2 + ( float(rowTA[6]) - float(rowOT[7]) )**2 ) 
                    distance = haversine(float(rowTA[6]), float(rowTA[7]), float(rowOT[7]), float(rowOT[8]))
                except:
                    distance = 10
                    pass
                    
                if distance < 0.2:

                    if rowTA[8].split(" ")[0] == rowOT[9].split(" ")[0]:
                        addressScrore = 1
                        score += 1
                    else:
                        addressScrore = 0

                    try:
                        distance = distance*100
                        distScore = gaussian(distance, 3)*15
                        distScore = round(distScore, 3)

                        score += distScore
                    except:
                        distScore = 0
                        pass

                    lenString = min(len(rowTA[2]), len(rowOT[2]))    
                    nameSimilar = 1 - similar(rowTA[2][:lenString], rowOT[2][:lenString])
                    nameScore = gaussian(nameSimilar, 0.2)
                    nameScore = round(nameScore, 3)

                    score += nameScore

                    try:
                        if int(rowTA[9][-5:]) == int(rowOT[10][-5:]):
                            phoneScore = 3
                            score += 3
                        else:
                            phoneScore = 0
                        
                    except:
                        phoneScore = 0
                        pass

                    if score >= highscore: 
                        highscore = score
                        scoreList = [addressScrore, distScore, nameScore, phoneScore]
                        TAmatch = rowTA

        # DO SOME TESTING HERE ON THE OPTIMAL HIGHSCORE THRESHOLD
        if highscore > 3: 
            with open(dataFolder + city + "Match.csv", "a") as matchFile:
                line = rowOT + TAmatch #+ scoreList
                #line.append(round(highscore, 2))
                wr = csv.writer(matchFile)
                wr.writerow(line) 
                
                matchCount += 1
        #else:
            #print("Match not found for " + rowOT[2] + ". Highs")

print("Matched " + str(matchCount) + " out of " + str(overallCount) + " restaurants.")
print("Sucess rate: " + str(round((matchCount/overallCount)*100, 1)) + "%.")



# In[ ]:




# In[ ]:




# In[ ]:



