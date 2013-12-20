setwd("D:/Chicago_Grasslands/GIS")

nass<-read.csv("NASS_file_lists.csv", header=T)

stop('cbw')

for (i in 1:length(nass$NASS)){
  
filename<-paste("NASS_layers/", nass$NASS[i], sep="")
r<-raster(filename)

v<-nass$open_water[i]

m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
rc <- reclassify(r, rclmat)

outname<-paste("covariates/water_", 2013-i, ".tif", sep="")

writeRaster(rc, outname)

}

setwd("D:/Chicago_Grasslands/GIS")

nass<-read.csv("NASS_file_lists.csv", header=T)



for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$pasture_grass[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/pasture_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$decid[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/decid_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}



for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$herb_grass[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/herb_grass_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$dev_open[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/dev_open_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$alfalfa[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/alfalfa_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$dev_hi[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/dev_hi_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$evergreen[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/evergreen_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}



for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$dev_med[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/dev_med_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$dev_lo[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/dev_lo_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}


for (i in 1:length(nass$NASS)){
  
  filename<-paste("NASS_layers/", nass$NASS[i], sep="")
  r<-raster(filename)
  
  v<-nass$wood_wet[i]
  
  m <- c(0, v-1, 0,  v-.1, v+0.1, 1,  v+.11, 255, 0)
  rclmat <- matrix(m, ncol=3, byrow=TRUE)
  rc <- reclassify(r, rclmat)
  
  outname<-paste("covariates/wood_wet_", 2013-i, ".tif", sep="")
  
  writeRaster(rc, outname)
  
}

###############combine layers

a<-raster("D:/Chicago_Grasslands/GIS/covariates/alfalfa_2012.tif")
p<-raster("D:/Chicago_Grasslands/GIS/covariates/pasture_2012.tif")
ap<-a+p
writeRaster(ap,"D:/Chicago_Grasslands/GIS/covariates/pasture_alfalfa_2012.tif")

do<-raster("D:/Chicago_Grasslands/GIS/covariates/dev_open_2012.tif")
dl<-raster("D:/Chicago_Grasslands/GIS/covariates/dev_lo_2012.tif")
d<-do+dl
writeRaster(d,"D:/Chicago_Grasslands/GIS/covariates/dev_open_low_2012a.tif")

dm<-raster("D:/Chicago_Grasslands/GIS/covariates/dev_med_2012.tif")
dh<-raster("D:/Chicago_Grasslands/GIS/covariates/dev_hi_2012.tif")
d<-dm+dh
writeRaster(d,"D:/Chicago_Grasslands/GIS/covariates/dev_med_hi_2012a.tif")

ww<-raster("D:/Chicago_Grasslands/GIS/covariates/wood_wet_2012.tif")
hg<-raster("D:/Chicago_Grasslands/GIS/covariates/herb_grass_2012.tif")
wa<-raster("D:/Chicago_Grasslands/GIS/covariates/water_2012.tif")
dec<-raster("D:/Chicago_Grasslands/GIS/covariates/decid_2012.tif")

other<-1-(a+p+do+dl+dm+dh+ww+hg+wa+dec)
writeRaster(other,"D:/Chicago_Grasslands/GIS/covariates/other_2012.tif")


###

r<-raster("D:/Chicago_Grasslands/PREDICTIONS/GRIDS/dec12.asc")
writeRaster(r, "D:/Chicago_Grasslands/PREDICTIONS/NASS_VARIABLES/JHOUR.tif")
r<-r*0+168

writeRaster(r, "D:/Chicago_Grasslands/PREDICTIONS/NASS_VARIABLES/JDATEa.tif")
