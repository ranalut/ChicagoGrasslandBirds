### make LANDSAT 8 grids for extraction and prediction

library(raster)

setwd("D:/Chicago_Grasslands/BIRD_DATA/BCN")

all<-read.csv("31qryBreeding_JGS_version.csv", header=T)

## trim observations to those meeting requirements
obs<-all[all$VALID==1&all$PROTOCOL_ID=="P21"&all$DURATION_HRS==0.08&all$ALL_OBS_REPORTED==1,]

## make unique list of count submissions
counts<-aggregate(VALID~SUB_ID+JHOUR+JDATE+YEAR+LATITUDE+LONGITUDE, obs, length)

hist(counts$YEAR, xlab="year", ylab="frequency", main="5-minute point counts by year")
hist(counts$JDATE, xlab="julian day", ylab="frequency", main="5-minute point counts by day of year")
hist(counts$JDATE, xlab="julian day", ylab="frequency", main="5-minute point counts by day of year")


## select observations for species of interest
sppname<-paste("graspa")
spp<-obs[obs$SPECIES_CODE==sppname,]

## join to set of unique submissions

spp_PA<-merge(spp, counts, by=c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE"), all=T)
i<-is.na(spp_PA$HOW_MANY_ATLEAST)
spp_PA$HOW_MANY_ATLEAST[i]<-0
spp_PA<-spp_PA[,-(6:9)]
spp_PA<-spp_PA[,-(7:30)]

write.csv(spp_PA,paste(sppname, "_PA.csv", sep=""), row.names=F)

setwd("D:/Chicago_Grasslands/PREDICTIONS/GRIDS")

B1<-raster("LT50230312009140PAC01_B1.tif")
B2<-raster("LT50230312009140PAC01_B2.tif")
B3<-raster("LT50230312009140PAC01_B3.tif")
B4<-raster("LT50230312009140PAC01_B4.tif")
B5<-raster("LT50230312009140PAC01_B5.tif")
B6<-raster("LT50230312009140PAC01_B6.tif")
B7<-raster("LT50230312009140PAC01_B7.tif")

writeRaster(B1,"B1.tif")
writeRaster(B2,"B2.tif")
writeRaster(B3,"B3.tif")
writeRaster(B4,"B4.tif")
writeRaster(B5,"B5.tif")
writeRaster(B6,"B6.tif")
writeRaster(B7,"B7.tif")

B1ngb<-raster("LT50230312009140PAC01_B1ngb.tif")
B2ngb<-raster("LT50230312009140PAC01_B2ngb.tif")
B3ngb<-raster("LT50230312009140PAC01_B3ngb.tif")
B4ngb<-raster("LT50230312009140PAC01_B4ngb.tif")
B5ngb<-raster("LT50230312009140PAC01_B5ngb.tif")
B6ngb<-raster("LT50230312009140PAC01_B6ngb.tif")
B7ngb<-raster("LT50230312009140PAC01_B7ngb.tif")

writeRaster(B1ngb,"B1ngb.tif")
writeRaster(B2ngb,"B2ngb.tif")
writeRaster(B3ngb,"B3ngb.tif")
writeRaster(B4ngb,"B4ngb.tif")
writeRaster(B5ngb,"B5ngb.tif")
writeRaster(B6ngb,"B6ngb.tif")
writeRaster(B7ngb,"B7ngb.tif")

### make into blocky grid

B1a<-aggregate(B1, fact=100, fun=mean)
B2a<-aggregate(B2, fact=100, fun=mean)
B3a<-aggregate(B3, fact=100, fun=mean)
B4a<-aggregate(B4, fact=100, fun=mean)
B5a<-aggregate(B5, fact=100, fun=mean)
B6a<-aggregate(B6, fact=100, fun=mean)
B7a<-aggregate(B7, fact=100, fun=mean)

writeRaster(B1a,"LT50230312009140PAC01_B1a.tif")
writeRaster(B2a,"LT50230312009140PAC01_B2a.tif")
writeRaster(B3a,"LT50230312009140PAC01_B3a.tif")
writeRaster(B4a,"LT50230312009140PAC01_B4a.tif")
writeRaster(B5a,"LT50230312009140PAC01_B5a.tif")
writeRaster(B6a,"LT50230312009140PAC01_B6a.tif")
writeRaster(B7a,"LT50230312009140PAC01_B7a.tif")

## run BRT

library(mgcv)
library(dismo)
library(pROC)
library(gbm)
library(ROCR)
library(rgdal)
library(tcltk)

mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)

spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)

save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")

## make predictions
setwd("D:/Chicago_Grasslands/PREDICTIONS/GRIDS")

JDATE<-raster("JDATE.tif")
JHOUR<-raster("JHOUR.tif")

B1ngb<-raster("B1ngb.tif")
B2ngb<-raster("B2ngb.tif")
B3ngb<-raster("B3ngb.tif")
B4ngb<-raster("B4ngb.tif")
B5ngb<-raster("B5ngb.tif")
B6ngb<-raster("B6ngb.tif")
B7ngb<-raster("B7ngb.tif")

B1<-raster("B1.tif")
B2<-raster("B2.tif")
B3<-raster("B3.tif")
B4<-raster("B4.tif")
B5<-raster("B5.tif")
B6<-raster("B6.tif")
B7<-raster("B7.tif")

chic<-stack(B1,B2,B3,B4,B5,B6,B7,B1ngb,B2ngb,B3ngb,B4ngb,B5ngb,B6ngb,B7ngb,JDATE,JHOUR)

p<-predict(chic, spp.tc5.lr01, n.trees = spp.tc5.lr01$n.trees, type="response", progress="window", na.rm=TRUE)

writeRaster(p, paste("D:/Chicago_Grasslands/PREDICTIONS/", sppname, "_TM5.tif", sep=""))
     
#### NASS

     setwd("D:/Chicago_Grasslands/BIRD_DATA/BCN")
     sppname<-paste("easmea")
     
     library(mgcv)
     library(dismo)
     library(pROC)
     library(gbm)
     library(ROCR)
     library(rgdal)
     library(tcltk)
     
     mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_NASS_BRT.csv", sep=""), header=T)
     
     spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:28, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
     
     save(spp.tc5.lr01, file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_NASS_BRT", sep=""))
          
## make predictions
          
      setwd("D:/Chicago_Grasslands/PREDICTIONS/NASS_VARIABLES")
          
      JDATE<-raster("JDATE.tif")  
      JHOUR<-raster("JHOUR.tif")
      
          V12_100<-raster("V12_100.tif")  
          V12_500<-raster("V12_500.tif")
          
          dec12ngb<-raster("dec12ngb.tif")
          devmh12ngb<-raster("devmh12ngb.tif")
          devol12ngb<-raster("devol12ngb.tif")
          wat12ngb<-raster("wat12ngb.tif")
          wowe12ngb<-raster("wowe12ngb.tif")
          paal12ngb<-raster("paal12ngb.tif")
          hergr12ngb<-raster("hergr12ngb.tif")
          oth12ngb<-raster("oth12ngb.tif")
          
          decid12<-raster("decid12.tif")
          devmh12<-raster("devmh12.tif")
          devol12<-raster("devol12.tif")
          wat12<-raster("wat12.tif")
          wowe12<-raster("wowe12.tif")
          pasalf12<-raster("pasalf12.tif")
          hergr12<-raster("hergr12.tif")
          oth12<-raster("oth12.tif")
          
          chic<-stack(decid12,devmh12,devol12,wat12,wowe12,pasalf12,oth12,hergr12,dec12ngb,devmh12ngb,devol12ngb,wat12ngb,wowe12ngb,paal12ngb,oth12ngb,hergr12ngb,V12_100,V12_500,JDATE,JHOUR)
          
          p<-predict(chic, spp.tc5.lr01, n.trees = spp.tc5.lr01$n.trees, type="response", progress="window", na.rm=TRUE)
          
          writeRaster(p, paste("D:/Chicago_Grasslands/PREDICTIONS/", sppname, "_NASS.tif", sep=""))
          