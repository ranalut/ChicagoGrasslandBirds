library(raster)
library(maptools)

setwd("D:/Chicago_Grasslands/PREDICTIONS")
tm5<-raster("mask_TM5aa.tif")

nass<-raster("mask_NASS.tif")
nass<-nass*0+1
writeRaster(nass,"mask_NASSa.tif")


extent(t)<-c(269085,512115,4514085,4732815)
t<-setExtent(tm5, sed, keepres=TRUE)
writeRaster(t,"test.tif")
x<-readShapePoly("D:/Chicago_Grasslands/GIS/Active_counties_TM5")

setwd("D:/Chicago_Grasslands/PREDICTIONS")

bob<-raster("boboli_TM5.tif")
bobout<-rasterize(x, bob, mask=T)
writeRaster(bobout, "boboli_TM5_clip.tif")

hen<-raster("henspa_TM5.tif")
henout<-rasterize(x, hen, mask=T)
writeRaster(henout, "henspa_TM5_clip.tif")

eas<-raster("easmea_TM5.tif")
bobout<-rasterize(x, eas, mask=T)
writeRaster(easout, "easmea_TM5_clip.tif")

sed<-raster("sedwre_TM5.tif")
sedout<-mask(sed, tm5)
writeRaster(sedout, "sedwre_TM5_clipa.tif")

gra<-raster("graspa_TM5.tif")
bobout<-rasterize(x, gra, mask=T)
writeRaster(graout, "graspa_TM5_clip.tif")

###

setwd("D:/Chicago_Grasslands/PREDICTIONS")
bob<-raster("boboli_NASS.tif")
bobout<-mask(bob,NASS)
writeRaster(bobout, "boboli_NASS_clip.tif")

hen<-raster("henspa_NASS.tif")
henout<-mask(hen,NASS)
writeRaster(henout, "henspa_NASS_clip.tif")

eas<-raster("easmea_NASS.tif")
easout<-mask(eas,NASS)
writeRaster(easout, "easmea_NASS_clip.tif")

sed<-raster("sedwre_NASS.tif")
sedout<-mask(sed,NASS)
writeRaster(sedout, "sedwre_NASS_clip.tif")

gra<-raster("graspa_NASS.tif")
graout<-mask(gra,NASS)
writeRaster(graout, "graspa_NASS_clip.tif")