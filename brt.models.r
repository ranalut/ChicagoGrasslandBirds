
# Build BRT models using NASS and Landsat Data.

library(mgcv)
library(dismo)
library(pROC)
library(gbm)
library(ROCR)
library(rgdal)
library(tcltk)






# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)

# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)

# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")


