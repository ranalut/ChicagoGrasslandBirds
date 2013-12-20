library(raster)
library(dismo)
library(proj4)

setwd("W:/Chicago_Grasslands/LANDSAT/")

L7name<-"LT50230312009140PAC01_"

band_1<-raster(paste(L7name, "B1.tif", sep=""))
band_2<-raster(paste(L7name, "B2.tif", sep=""))
band_3<-raster(paste(L7name, "B3.tif", sep=""))
band_4<-raster(paste(L7name, "B4.tif", sep=""))
band_5<-raster(paste(L7name, "B5.tif", sep=""))
band_6<-raster(paste(L7name, "B6.tif", sep=""))
band_7<-raster(paste(L7name, "B7.tif", sep=""))

band_1
band_2
band_3
band_4
band_5
band_6
band_7