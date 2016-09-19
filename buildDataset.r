setwd("/Users/francois/Dropbox/LinuxAWS/virtualEnvironment/RAEScrape/data")

library(plyr)
library(ggplot2)
library(maps)
library(reshape)
library(RColorBrewer)
library(scales)
library(cowplot)
library(geosphere)
library(stargazer)
library(KernSmooth)

cities <- c("London", "Chicago", "Manhattan", "Houston", "SanFran", "LosAngeles", "Miami")

cleanData <- function(dataFrame) {
  data <- dataFrame
  data$OTTime <- NULL	
  data$OTCuisine <- NULL
  data$OTAddress <- NULL	
  data$OTIndex <- NULL	
  data$OTPhoneNumber <- NULL	
  data$OTLink <- NULL	
  data$TATime <- NULL	
  data$TACity <- NULL	
  data$OTMeanRating <- NULL
  #data$TAName <- NULL	
  data$TAAddress <- NULL	
  data$TAPhoneNumber <- NULL	
  data$TAMeanRating <- NULL
  data$TALink <- NULL
  return(data)		
}


for (city in cities) { 
  
  print(paste(city, "Match.csv", sep=""))
  
  cityData  <- read.csv(paste(city, "Match.csv", sep=""))
  
  cityData <- cleanData(cityData)
  cityData$OTName <- substr(cityData$OTName, start=1, 30)
  
  cityData <- cityData[cityData$OTReviewCount >= 25, ]		
  cityData <- cityData[cityData$TAReviewCount != "NotFound", ]
  cityData$TAReviewCount <- as.numeric(as.character(cityData$TAReviewCount))
  cityData <- cityData[cityData$TAReviewCount >= 25, ]
  
  cityData$TA1 <- as.numeric(as.character(cityData$TA1))
  cityData$TA2 <- as.numeric(as.character(cityData$TA2))
  cityData$TA3 <- as.numeric(as.character(cityData$TA3))
  cityData$TA4 <- as.numeric(as.character(cityData$TA4))
  cityData$TA5 <- as.numeric(as.character(cityData$TA5))
  cityData$OT1 <- as.numeric(as.character(cityData$OT1))
  cityData$OT2 <- as.numeric(as.character(cityData$OT2))
  cityData$OT3 <- as.numeric(as.character(cityData$OT3))
  cityData$OT4 <- as.numeric(as.character(cityData$OT4))
  cityData$OT5 <- as.numeric(as.character(cityData$OT5))
  
  # FIX THE NUMBER OF REVIEWS 
  cityData$TAReviewCount <- cityData$TA1 + cityData$TA2 + cityData$TA3 + cityData$TA4 + cityData$TA5
  cityData$OTReviewCount <- cityData$OT1 + cityData$OT2 + cityData$OT3 + cityData$OT4 + cityData$OT5
  
  digitsP <- 8
  cityData$OTMean <- round((1*cityData$OT1 + 2*cityData$OT2 + 3*cityData$OT3 + 4*cityData$OT4 + 5*cityData$OT5)/cityData$OTReviewCount, digits= digitsP)
  cityData$TAMean <- round((1*cityData$TA1 + 2*cityData$TA2 + 3*cityData$TA3 + 4*cityData$TA4 + 5*cityData$TA5)/cityData$TAReviewCount, digits= digitsP)
  
  
  ### THE 1* MEASURE ###
  cityData$TAP1 <- round(cityData$TA1/(cityData$TA1 + cityData$TA2 + cityData$TA3 + cityData$TA4 + cityData$TA5), digits= digitsP)
  cityData$OTP1 <- round(cityData$OT1/(cityData$OT1 + cityData$OT2 + cityData$OT3 + cityData$OT4 + cityData$OT5), digits= digitsP)
  
  cityData$cheat1 <- (cityData$TAP1 - cityData$OTP1)*((cityData$TAReviewCount + cityData$OTReviewCount)/2)
  
  cityData$cheat1 <- ( ( cityData$cheat1 - mean(cityData$cheat1) ) / sd(cityData$cheat1) ) + 1
  
  
  ### THE 5* MEASURE ###
  cityData$TAP5 <- round(cityData$TA5/(cityData$TA1 + cityData$TA2 + cityData$TA3 + cityData$TA4 + cityData$TA5), digits= digitsP)
  cityData$OTP5 <- round(cityData$OT5/(cityData$OT1 + cityData$OT2 + cityData$OT3 + cityData$OT4 + cityData$OT5), digits= digitsP)
  
  cityData$cheat5 <- (cityData$TAP5 - cityData$OTP5)*((cityData$TAReviewCount + cityData$OTReviewCount)/2)
  
  cityData$cheat5 <- ( ( cityData$cheat5 - mean(cityData$cheat5) ) / sd(cityData$cheat5) ) + 1
  
  assign(paste(city, "Data", sep=""), cityData)
}


cleanTA <- function(dataFrame) {
  data <- dataFrame
  data$Time <- NULL	
  data$Address <- NULL	
  data$PhoneNumber <- NULL	
  data$Link <- NULL	
  return(data)		
}


for (city in cities) { 
  print(paste(city, "TAData.csv", sep=""))
  cityTA <- read.csv(paste(city, "TAData.csv", sep=""))
  cityTA <- cleanTA(cityTA)
  cityTA$Name <- substr(cityTA$Name, start=1, 30)
  cityTA <- cityTA[cityTA$Longitude != "NotFound", ]
  cityTA <- cityTA[cityTA$Latitude != "NotFound", ]
  cityTA$Longitude <- as.numeric(as.character(cityTA$Longitude))
  cityTA$Latitude <- as.numeric(as.character(cityTA$Latitude))
  assign(paste(city, "TAData", sep=""), cityTA)
}


Asia <- c("Asian", "Chinese", "Vietnamese", "Thai", "Polynesian", "Japanese", "Pacific Rim", "Indian", "Sushi", "Bangladeshi", "Korean", "Malaysian", "Nepalese", "Philippine", "Filipino", "Nepali")

MEastA <- c("African", "Turkish", "Middle Eastern", "Moroccan", "Lebanese", "Halal", "Moroccan", "Afghani", "Pakistani", "Persian")

Europe <- c("Austrian", "Belgian", "European", "German", "Spanish", "Russian", "French", "Portuguese", "Greek", "Mediterranean", "Polish", "Dutch", "Eastern European", "Hungarian", "Israeli", "Kosher", "Swedish", "Armenian")

Italy <- c("Italian", "Pizza")

Anglo <- c("American", "British", "Steakhouse", "Barbecue", "Grill", "Australian", "Brew Pub", "New Zealand", "Southwestern", "Irish", "Swiss", "Fast Food", "Hawaiian", "Scottish")

Latin <- c("Caribbean", "South American", "Brazilian", "Mexican", "Cajun & Creole", "Jamaican", "Argentinian", "Peruvian", "Central American", "Salvadoran", "Venezuelan", "Cuban", "Argentinean", "Guatemalan", "Latin", "Chilean")

Other <- c("Bar", "Cafe", "Diner", "Contemporary", "Fast food", "Fusion", "Gastropub", "Gluten Free", "International", "Healthy", "Soups", "Wine Bar", "Seafood", "Pub", "Vegetarian", "Canadian", "Delicatessen", "Street Food", "Vegan")

NotFound <- c("NotFound")


for (city in cities) { 
  print(paste(city, "Data", sep=""))
  dataHolder <- eval(as.name(paste(city, "Data", sep="")))
  dataHolder$CuisineN <- "Cuisine"
  
  for(i in 1:length(dataHolder$CuisineN)) { 
    
    type <- eval(as.name(paste(city, "Data", sep="")))$TACuisine[i]
    
    if(type %in% Asia) {
      dataHolder$CuisineN[i] <- "Asia"	
    }	
    if(type %in% MEastA) {
      dataHolder$CuisineN[i] <- "MEastA"	
    }	
    if(type %in% Europe) {
      dataHolder$CuisineN[i] <- "Europe"	
    }	
    if(type %in% Italy) {
      dataHolder$CuisineN[i] <- "Italy"	
    }	
    if(type %in% Anglo) {
      dataHolder$CuisineN[i] <- "Anglo"	
    }		
    if(type %in% Latin) {
      dataHolder$CuisineN[i] <- "Latin"	
    }	
    if(type %in% Other) {
      dataHolder$CuisineN[i] <- "AAOther"	
    }	
    if(type %in% NotFound) {
      dataHolder$CuisineN[i] <- "NotFound"	
    }	
  }
  assign(paste(city, "Data", sep=""), dataHolder)
}

for (city in cities) { 
  print(paste(city, "TAData", sep=""))
  dataHolderTA <- eval(as.name(paste(city, "TAData", sep="")))
  dataHolderTA$CuisineN <- "Cuisine"
  
  for(i in 1:length(dataHolderTA$CuisineN)) { 
    type <- eval(as.name(paste(city, "TAData", sep="")))$Cuisine[i]
    
    if(type %in% Asia) {
      dataHolderTA$CuisineN[i] <- "Asia"	
    }	
    if(type %in% MEastA) {
      dataHolderTA$CuisineN[i] <- "MEastA"	
    }	
    if(type %in% Europe) {
      dataHolderTA$CuisineN[i] <- "Europe"	
    }	
    if(type %in% Italy) {
      dataHolderTA$CuisineN[i] <- "Italy"	
    }	
    if(type %in% Anglo) {
      dataHolderTA$CuisineN[i] <- "Anglo"	
    }		
    if(type %in% Latin) {
      dataHolderTA$CuisineN[i] <- "Latin"	
    }	
    if(type %in% Other) {
      dataHolderTA$CuisineN[i] <- "AAOther"	
    }	
    if(type %in% NotFound) {
      dataHolderTA$CuisineN[i] <- "NotFound"	
    }	
  }
  assign(paste(city, "TAData", sep=""), dataHolderTA)
}


kernelGauss <- function(num, h) { 
  return(exp( -(1/2)*((num / h)**2) ))
}

kernelExp <- function(num, h) {
  return( exp( - (num / h) ) )
}

haversine <- function(long1, lat1, long2, lat2) {
  rad <- pi/180
  a1 <- lat1 * rad
  b1 <- lat2 * rad
  dlon <- (long2 * rad) - (long1 * rad)
  dlat <- b1 - a1
  a <- (sin(dlat/2))^2 + cos(a1) * cos(b1) * (sin(dlon/2))^2
  return((40041.47/(2 * pi)) * (2 * atan2(sqrt(a), sqrt(1 - a))))
}


# THE DISCONTINUITY

for (city in cities) { 
  print(paste(city, "Data", sep=""))
  dataHolderI <- eval(as.name(paste(city, "Data", sep="")))
  dataHolderI$distAbs <- 0
  dataHolderI$starDist <- 0
  dataHolderI$samp <- 0
  
  for (i in 1:nrow(dataHolderI)) { 
    stars <- 0
    distStar <- 0
    gap <- 0
    
    stars <- round(dataHolderI$TAMean[i]*2)/2
    
    if (dataHolderI$TAMean[i] > stars) { 
      distStar <- stars + 0.25
    } else { 
      distStar <- stars - 0.25
    }
    gap <- dataHolderI$TAMean[i] - distStar
    dataHolderI$distAbs[i] <- gap
    if (gap > 0) { 
      dataHolderI$starDist[i] <- 1        
    }
    if (abs(gap) < 0.02) { 
      dataHolderI$samp[i] <- 1
    }
    
  }
  assign(paste(city, "Data", sep=""), dataHolderI)
}

# Combine the datasets
testData <- LondonData
for (city in cities) { 
  if(city != "London") { 
    testData <- rbind(testData, eval(as.name(paste(city, "Data", sep=""))))
  }
}

aData <- NULL
aData <- testData[ which( testData$samp==1 ), ]
aData$Int <- aData$distAbs*aData$starDist

hist(aData$distAbs, breaks=120)

DCdensity(aData$distAbs, cutpoint=0)


hist(aData$distAbs, breaks=160)



# THE COMPETITION TYPE MEASURE 

for (city in cities) { 
  print(paste(city, "Data", sep=""))
  
  dataHolderI <- eval(as.name(paste(city, "Data", sep="")))
  dataHolderI$CompType <- 0
  
  for (i in 1:nrow(dataHolderI)) { 
    print(paste( city, i, nrow(dataHolderI) ) )
    distVec <- c()
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      dist <- haversine( dataHolderI$TALongitude[i], dataHolderI$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 20) {
        distVec <- c(distVec, dist)
      }
    }
    
    dataHolderI$CompType[i] <- coef(summary( lm( bkde(distVec)$y[1:which(as.vector(bkde(distVec)$y) == max( bkde(distVec)$y ))] ~  bkde(distVec)$x[1:which(as.vector(bkde(distVec)$y) == max( bkde(distVec)$y ))] )) )[2,1]
    
  }
  assign(paste(city, "Data", sep=""), dataHolderI)
}



#       THE GENERAL INDEX       #

for (city in cities) { 
  dataHolderI <- eval(as.name(paste(city, "Data", sep="")))
  GIndex <- c(0.5, 1.5, "GIndex")
  for(s in seq(as.numeric(GIndex[1]), as.numeric(GIndex[2]), by = as.numeric(GIndex[1]))) { 
    dataHolderI[(paste(GIndex[3], s, sep=""))] <- 0
  }
  assign(paste(city, "Data", sep=""), dataHolderI)
}

for (city in cities) { 
  
  dataHolderG <- eval(as.name(paste(city, "Data", sep="")))
  
  for (i in 1:nrow(dataHolderG)) { 
    print(paste( city, i, nrow(dataHolderG) ) )
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      
      dist <- haversine( dataHolderG$TALongitude[i], dataHolderG$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 30) {
        for(s in seq(as.numeric(GIndex[1]), as.numeric(GIndex[2]), by = as.numeric(GIndex[1]))) { 
          dataHolderG[[(paste(GIndex[3], s, sep=""))]][i] <- dataHolderG[[(paste(GIndex[3], s, sep=""))]][i] + kernelExp(dist, s)
          
        }
      }
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderG)
}





#       THE CUISINE TYPE INDEX       #

for (city in cities) { 
  dataHolderC <- eval(as.name(paste(city, "Data", sep="")))
  TIndex <- c(0.5, 1.5, "TIndex")
  for(s in seq(as.numeric(TIndex[1]), as.numeric(TIndex[2]), by = as.numeric(TIndex[1]))) { 
    dataHolderC[(paste(TIndex[3], s, sep=""))] <- 0
  }
  assign(paste(city, "Data", sep=""), dataHolderC)
}


for (city in cities) { 
  dataHolderG <- eval(as.name(paste(city, "Data", sep="")))
  
  for (i in 1:nrow(dataHolderG)) { 
    
    print(paste( city, i, nrow(dataHolderG) ) )
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      dist <- haversine( dataHolderG$TALongitude[i], dataHolderG$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 30) {
        
        if (as.character(dataHolderG$CuisineN[i]) != "NotFound" & as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t]) != "NotFound") { 
          
          if (as.character(dataHolderG$CuisineN[i]) == as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t])) { 
            
            print(paste(as.character(dataHolderG$CuisineN[i]),  as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t]), sep="" ))
            
            for(s in seq(as.numeric(TIndex[1]), as.numeric(TIndex[2]), by = as.numeric(TIndex[1]))) { 
              dataHolderG[[(paste(TIndex[3], s, sep=""))]][i] <- dataHolderG[[(paste(TIndex[3], s, sep=""))]][i] + kernelExp(dist, s)
            }		
          }
        } 		  
      }
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderG)
}



#       THE OTHER CUISINE TYPE INDEX       #

for (city in cities) { 
  dataHolderC <- eval(as.name(paste(city, "Data", sep="")))
  TOIndex <- c(0.5, 1.5, "TOIndex")
  for(s in seq(as.numeric(TOIndex[1]), as.numeric(TOIndex[2]), by = as.numeric(TOIndex[1]))) { 
    dataHolderC[(paste(TOIndex[3], s, sep=""))] <- 0
  }
  assign(paste(city, "Data", sep=""), dataHolderC)
}


for (city in cities) { 
  dataHolderG <- eval(as.name(paste(city, "Data", sep="")))
  
  for (i in 1:nrow(dataHolderG)) { 
    
    print(paste( city, i, nrow(dataHolderG) ) )
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      dist <- haversine( dataHolderG$TALongitude[i], dataHolderG$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 30) {
        
        if (as.character(dataHolderG$CuisineN[i]) != "NotFound" & as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t]) != "NotFound") { 
          
          if (as.character(dataHolderG$CuisineN[i]) != as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t])) { 
            
            #print(paste(as.character(dataHolderG$CuisineN[i]),  as.character(eval(as.name(paste(city, "TAData", sep="")))$CuisineN[t]), sep="" ))
            
            for(s in seq(as.numeric(TOIndex[1]), as.numeric(TOIndex[2]), by = as.numeric(TOIndex[1]))) { 
              dataHolderG[[(paste(TOIndex[3], s, sep=""))]][i] <- dataHolderG[[(paste(TOIndex[3], s, sep=""))]][i] + kernelExp(dist, s)
            }		
          }
        } 		  
      }
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderG)
}




#       THE PRICE INDEX       #

for (city in cities) { 
  dataHolderI <- eval(as.name(paste(city, "Data", sep="")))
  PIndex <- c(0.5, 1.5, "PIndex")
  for(s in seq(as.numeric(PIndex[1]), as.numeric(PIndex[2]), by = as.numeric(PIndex[1]))) { 
    dataHolderI[(paste(PIndex[3], s, sep=""))] <- 0
  }
  assign(paste(city, "Data", sep=""), dataHolderI)
}

for (city in cities) { 
  dataHolderG <- eval(as.name(paste(city, "Data", sep="")))
  
  for (i in 1:nrow(dataHolderG)) { 
    print(paste( city, i, nrow(dataHolderG) ) )
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      dist <- haversine( dataHolderG$TALongitude[i], dataHolderG$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 30) {
        if (as.character(dataHolderG$TAPrice[i]) != "NotFound" & as.character(eval(as.name(paste(city, "TAData", sep="")))$Price[t]) != "NotFound") {
          diffPrice <- abs( as.numeric(dataHolderG$TAPrice[i]) - as.numeric(eval(as.name(paste(city, "TAData", sep="")))$Price[t]) )
          for(s in seq(as.numeric(PIndex[1]), as.numeric(PIndex[2]), by = as.numeric(PIndex[1]))) { 
            dataHolderG[[(paste(PIndex[3], s, sep=""))]][i] <- dataHolderG[[(paste(PIndex[3], s, sep=""))]][i] + kernelExp(dist, s)*kernelGauss(diffPrice, 0.8)
          }		
        }		  
      }
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderG)
}





#       THE RANKING INDEX       #

for (city in cities) { 
  dataHolderI <- eval(as.name(paste(city, "Data", sep="")))
  RIndex <- c(1, 3, 500, 1000, "RIndex")
  for(s in seq(as.numeric(RIndex[1]), as.numeric(RIndex[2]), by = as.numeric(RIndex[1]))) { 
    for(p in seq(as.numeric(RIndex[3]), as.numeric(RIndex[4]), by = as.numeric(RIndex[3]))) { 
      dataHolderI[(paste(RIndex[5], s, p, sep=""))] <- 0
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderI)
}

for (city in cities) { 
  dataHolderG <- eval(as.name(paste(city, "Data", sep="")))
  
  for (i in 1:nrow(dataHolderG)) { 
    print(paste( city, i, nrow(dataHolderG) ) )
    
    for (t in 1:nrow(eval(as.name(paste(city, "TAData", sep=""))))) { 
      dist <- haversine( dataHolderG$TALongitude[i], dataHolderG$TALatitude[i], eval(as.name(paste(city, "TAData", sep="")))$Longitude[t], eval(as.name(paste(city, "TAData", sep="")))$Latitude[t])
      
      if (dist < 30) {

        rankDiff <- abs( dataHolderG$TARanking[i] - eval(as.name(paste(city, "TAData", sep="")))$Ranking[t] )
        
        for(s in seq(as.numeric(RIndex[1]), as.numeric(RIndex[2]), by = as.numeric(RIndex[1]))) {
          for(p in seq(as.numeric(RIndex[3]), as.numeric(RIndex[4]), by = as.numeric(RIndex[3]))) {
            dataHolderG[[(paste(RIndex[5], s, p, sep=""))]][i] <- dataHolderG[[(paste(RIndex[5], s, p, sep=""))]][i] + kernelGauss(dist, s)*kernelExp(rankDiff, p)
          }
        }
      }
    }
  }
  assign(paste(city, "Data", sep=""), dataHolderG)
}



######### TAALL

TAallData <- LondonTAData
for (city in cities) { 
  if(city != "London") { 
    TAallData <- rbind(TAallData, eval(as.name(paste(city, "TAData", sep=""))))
  }
}

TAallData <- TAallData[TAallData$MeanRating != "NotFound", ]
TAallData <- TAallData[TAallData$ReviewCount != "NotFound", ]
TAallData <- TAallData[TAallData$ReviewCount >= 30, ]		
TAallData$MeanRating <- as.numeric(as.character(TAallData$MeanRating))
TAallData$ReviewCount <- as.numeric(as.character(TAallData$ReviewCount))

nrow(TAallData)

mean(TAallData$MeanRating)

plot(density(TAallData$ReviewCount, adjust=0.001), xlim=c(0,100))



# Combine the datasets
allData <- LondonData
for (city in cities) { 
  if(city != "London") { 
    allData <- rbind(allData, eval(as.name(paste(city, "Data", sep=""))))
  }
}

# Normalisation 
allData$CompType <- ( (allData$CompType - mean(allData$CompType)) / sd(allData$CompType) ) + 1	

for(s in seq(as.numeric(GIndex[1]), as.numeric(GIndex[2]), by = as.numeric(GIndex[1]))) { 
  allData[[(paste(GIndex[3], s, sep=""))]] <- ( (allData[[(paste(GIndex[3], s, sep=""))]] - mean(allData[[(paste(GIndex[3], s, sep=""))]])) / sd(allData[[(paste(GIndex[3], s, sep=""))]]) ) + 1	
}

for(s in seq(as.numeric(TIndex[1]), as.numeric(TIndex[2]), by = as.numeric(TIndex[1]))) { 
  allData[[(paste(TIndex[3], s, sep=""))]] <- ( (allData[[(paste(TIndex[3], s, sep=""))]] - mean(allData[[(paste(TIndex[3], s, sep=""))]])) / sd(allData[[(paste(TIndex[3], s, sep=""))]]) ) + 1	
}

for(s in seq(as.numeric(TOIndex[1]), as.numeric(TOIndex[2]), by = as.numeric(TOIndex[1]))) { 
  allData[[(paste(TOIndex[3], s, sep=""))]] <- ( (allData[[(paste(TOIndex[3], s, sep=""))]] - mean(allData[[(paste(TOIndex[3], s, sep=""))]])) / sd(allData[[(paste(TOIndex[3], s, sep=""))]]) ) + 1	
}

for(s in seq(as.numeric(PIndex[1]), as.numeric(PIndex[2]), by = as.numeric(PIndex[1]))) { 
  allData[[(paste(PIndex[3], s, sep=""))]] <- ( (allData[[(paste(PIndex[3], s, sep=""))]] - mean(allData[[(paste(PIndex[3], s, sep=""))]])) / sd(allData[[(paste(PIndex[3], s, sep=""))]]) ) + 1	
}

for(s in seq(as.numeric(RIndex[1]), as.numeric(RIndex[2]), by = as.numeric(RIndex[1]))) { 
  for(p in seq(as.numeric(RIndex[3]), as.numeric(RIndex[4]), by = as.numeric(RIndex[3]))) {
    allData[[(paste(RIndex[5], s, p, sep=""))]] <- ( (allData[[(paste(RIndex[5], s, p, sep=""))]] - mean(allData[[(paste(RIndex[5], s, p, sep=""))]])) / sd(allData[[(paste(RIndex[5], s, p, sep=""))]]) ) + 1	
  }
}

allData$lTARC <- log(allData$TAReviewCount)

allData$TAQ <- ( allData$TAMean - mean(allData$TAMean) ) / sd(allData$TAMean)
allData$OTQ <- ( allData$OTMean - mean(allData$OTMean) ) / sd(allData$OTMean)

allData$CuisineN.f <- factor(allData$CuisineN)






