setwd("/Users/francois/Dropbox/LinuxAWS/virtualEnvironment/RAEScrape/Scripting/finalFolder")

library(ggplot2)
library(lmtest)

dataLoad  <- read.csv("data.csv", sep=",")

nrow(dataLoad)

OTAll <- c(rep(1, sum(dataLoad$OT1)), rep(2, sum(dataLoad$OT2)), rep(3, sum(dataLoad$OT3)), rep(4, sum(dataLoad$OT4)), rep(5, sum(dataLoad$OT5)) )
length(OTAll)

dataLoad <- dataLoad[!is.na(dataLoad$TA1), ]
nrow(dataLoad)
TAAll <- c(rep(1, sum(dataLoad$TA1)), rep(2, sum(dataLoad$TA2)), rep(3, sum(dataLoad$TA3)), rep(4, sum(dataLoad$TA4)), rep(5, sum(dataLoad$TA5)) )
length(TAAll)

t.test(dataLoad$TAP1, dataLoad$OTP1)


mean(dataLoad$OTReviewCount)

dataLoad <- dataLoad[!is.na(dataLoad$TAReviewCount), ]
nrow(dataLoad)
mean(dataLoad$TAReviewCount)

sd(dataLoad$OTReviewCount)
sd(dataLoad$TAReviewCount)

dataLoad <- dataLoad[is.finite(dataLoad$OTMean), ]
nrow(dataLoad)
mean(dataLoad$OTMean)
mean(dataLoad$TAMean)

sd(dataLoad$OTMean)
sd(dataLoad$TAMean)

mean(dataLoad$OTP1)
mean(dataLoad$TAP1)

sd(dataLoad$OTP1)
sd(dataLoad$TAP1)

FrequencyOT <- c(mean(dataLoad$OTP1), mean(dataLoad$OTP2), mean(dataLoad$OTP3), mean(dataLoad$OTP4), mean(dataLoad$OTP5))

FrequencyTA <- c(mean(dataLoad$TAP1), mean(dataLoad$TAP2), mean(dataLoad$TAP3), mean(dataLoad$TAP4), mean(dataLoad$TAP5))

Frequency <- c(FrequencyOT, FrequencyTA)
Website <- c(rep("OpenTable", 5), rep("TripAdvisor", 5))
Ratings <- rep(paste(seq(1,5), "*", sep=""), 2)

meanOT <- mean(allData$OTMean)
meanTA <- mean(allData$TAMean)

plotData <- data.frame(Ratings, Website, Frequency)

library(extrafont)

font_import(pattern="[E/e]clid")

widthB = 0.86
p1 <- ggplot(plotData) + theme(panel.grid.major = element_line(colour = "white"), panel.grid.minor = element_blank(), panel.background = element_rect(fill = 'white', colour = 'grey'), text = element_text(size=15)) + geom_bar(aes(Ratings, Frequency, fill= Website), 	position=position_dodge(width= widthB), stat="identity", color="black", width= widthB) + scale_fill_brewer(palette="Pastel1") + geom_text(aes(Ratings, Frequency, label= percent(round(Frequency, 3)), group=Website), vjust=1.6,  family="Euclid", position = position_dodge(width= widthB)) + ggtitle("Figure 1: Histogram of the mean proportion of rating accross websites.") + theme(panel.background = element_rect(fill="white"), panel.grid = element_line(colour="white"), axis.text.x = element_text(colour="black"), text = element_text(size=16, family="Euclid")) + theme(plot.title=element_text(family="Euclid", face="plain", size=16))
ggdraw(p1)

# The correlation matrix
cmatrix <- cor(allData[,c("GIndex1", "PIndex1", "TIndex1", "TOIndex1", "RIndex2500")])
stargazer(cmatrix, title="Table 2: Correlation Matrix of Competition Indices", type="text")



reg1 <- lm(cheat1 ~ GIndex1 + PIndex1 + RIndex2500 + TAQ + lTARC + OTPrice + CuisineN.f, data=dataLoad)
reg2 <- lm(cheat1 ~  PIndex1 + TIndex1 + TOIndex1 + RIndex2500 + TAQ + lTARC + OTPrice + CuisineN.f, data=dataLoad)
reg3 <- lm(cheat1 ~ GIndex1 + PIndex1 + TIndex1 + TOIndex1 + RIndex2500 + TAQ + lTARC + OTPrice + CuisineN.f, data=dataLoad)

cov1 <- vcovHC(reg1, type = "HC1")
rob1 <- sqrt(diag(cov1))
cov2 <- vcovHC(reg2, type = "HC1")
rob2 <- sqrt(diag(cov2))
cov3 <- vcovHC(reg3, type = "HC1")
rob3 <- sqrt(diag(cov3))

stargazer(reg1, reg2, reg3, se=list(rob1, rob2, rob3), align=TRUE, type="text")


reg4 <- lm(cheat1 ~ GIndex1 + PIndex1 + TIndex1 + TOIndex1 + RIndex2500 + TAQ + lTARC, data=dataLoad)
reg5 <- lm(cheat1 ~ GIndex1 + PIndex1 + TIndex1 + TOIndex1 + RIndex2500 + TAQ + lTARC + OTPrice + CuisineN.f, data=dataLoad)

cov4 <- vcovHC(reg4, type = "HC1")
rob4 <- sqrt(diag(cov4))
cov5 <- vcovHC(reg5, type = "HC1")
rob5 <- sqrt(diag(cov5))

stargazer(reg4, reg5, se=list(rob4, rob5), align=TRUE, type="text")


reg7 <- lm(cheat1 ~ GIndex0.5 + PIndex0.5 + TIndex0.5 + TOIndex0.5 + RIndex1500 + TAQ + lTARC  + OTPrice + CuisineN.f, data=dataLoad)
reg8 <- lm(cheat1 ~ GIndex1.5 + PIndex1.5 + TIndex1.5 + TOIndex1.5 + RIndex3500 + TAQ + lTARC  + OTPrice + CuisineN.f, data=dataLoad)
reg10 <- lm(cheat1 ~ GIndexG1 + PIndexG1 + TIndexG1 + TOIndexG1 + RIndexG2500 + TAQ + lTARC  + OTPrice + CuisineN.f, data=dataLoad)

cov7 <- vcovHC(reg7, type = "HC1")
rob7 <- sqrt(diag(cov7))
cov8 <- vcovHC(reg8, type = "HC1")
rob8 <- sqrt(diag(cov8))
cov10 <- vcovHC(reg10, type = "HC1")
rob10 <- sqrt(diag(cov10))

stargazer(reg7, reg8, reg10, se=list(rob7, rob8, rob10), align=TRUE, type="text")




dataLoad$distAbs <- 0
dataLoad$starDist <- 0
dataLoad$samp <- 0

for (i in 1:nrow(dataLoad)) { 
  stars <- 0
  distStar <- 0
  gap <- 0
  
  stars <- round(dataLoad$TAMean[i]*2)/2
  
  if (dataLoad$TAMean[i] > stars) { 
    distStar <- stars + 0.25
  } else { 
    distStar <- stars - 0.25
  }
  gap <- dataLoad$TAMean[i] - distStar
  dataLoad$distAbs[i] <- gap
  if (gap > 0) { 
    dataLoad$starDist[i] <- 1        
  }
  if (abs(gap) < 0.02) { 
    dataLoad$samp[i] <- 1
  }
  
}

sampData <- dataLoad[ which( dataLoad$samp==1 ), ]

hist(sampData$distAbs, breaks=140, main="Figure 3: Histogram of average rating around the rounding threshold.", family = "Euclid", font.main = 1, xlab = "Distance from the threshold.", ylab = "Frequency", cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5, col="grey")




