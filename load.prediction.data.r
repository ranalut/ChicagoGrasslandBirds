
library(raster)
library(rgdal)

source('build.similar.raster.r') # Function used below to build rasters with similar resolution/extent and fill in values.

setwd('d:/github/chicagograsslandbirds/')
nass.path <- 'd:/chicago_grasslands/gis/nass_layers/'
landsat.path <- 'd:/chicago_grasslands/landsat2/'
output.path <- 'd:/chicago_grasslands/models/'

bands <- seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')
radius <- c(100,500)
year <- 2009
day <- 156

study.area.1 <- extent(matrix(c(594000,706500,2043700,2197500),ncol=2,byrow=TRUE))
study.area.2 <- extent(matrix(c(358000,459000,4558000,4712000),ncol=2,byrow=TRUE))

# ===========================================================
# NASS data
# Generate rasters for JDATE and JHOUR
JDATE <- build.similar(file.name=paste(nass.path,year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
JHOUR <- build.similar(file.name=paste(nass.path,year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=7,var.name='JHOUR')

# Load and rename layers
nass.file.names <- c(
	paste(nass.path,year,'_',nass.var,'_nass_30m_r',radius[1],'.tif',sep=''),
	paste(nass.path,year,'_',nass.var,'_nass_30m_r',radius[2],'.tif',sep='')
	)
# print(nass.file.names)
nass.pred.data <- stack(nass.file.names)
names(nass.pred.data) <- c(paste(nass.var,'.',radius[1],sep=''),paste(nass.var,'.',radius[2],sep=''))
nass.pred.data <- addLayer(nass.pred.data, JDATE, JHOUR)
# print(nass.pred.data)
nass.pred.data <- crop(nass.pred.data, study.area.1)
print(nass.pred.data)
# stop('cbw')

# ===========================================================
# Landsat data
# Generate rasters for JDATE and JHOUR
JDATE <- build.similar(file.name=paste(landsat.path,year,'_d',day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
JHOUR <- build.similar(file.name=paste(landsat.path,year,'_d',day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=7,var.name='JHOUR')

landsat.file.names <- c(
	paste(landsat.path,year,'_d',day,'_b',bands,'_r',radius[1],'.tif',sep=''),
	paste(landsat.path,year,'_d',day,'_b',bands,'_r',radius[2],'.tif',sep='')
	)
# print(landsat.file.names)
landsat.pred.data <- stack(landsat.file.names)
names(landsat.pred.data) <- c(paste('b',bands,'.',radius[1],sep=''),paste('b',bands,'.',radius[2],sep=''))
landsat.pred.data <- addLayer(landsat.pred.data, JDATE, JHOUR)
# print(landsat.pred.data)
landsat.pred.data <- crop(landsat.pred.data, study.area.2)
print(landsat.pred.data)

save(nass.pred.data, landsat.pred.data, file=paste(output.path,'pred.data.v2.rdata',sep=''))

