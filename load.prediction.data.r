
library(raster)
library(rgdal)

source('build.similar.raster.r') # Function used below to build rasters with similar resolution/extent and fill in values.
# source('settings.r')

# ===========================================================
# NASS data
# Generate rasters for JDATE and JHOUR
JDATE <- build.similar(file.name=paste(nass.path,pred.year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
JHOUR <- build.similar(file.name=paste(nass.path,pred.year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=7,var.name='JHOUR')

# Load and rename layers
nass.file.names <- c(
	paste(nass.path,pred.year,'_',nass.var,'_nass_30m_r',radius[1],'.tif',sep=''),
	paste(nass.path,pred.year,'_',nass.var,'_nass_30m_r',radius[2],'.tif',sep='')
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
JDATE <- build.similar(file.name=paste(landsat.path,pred.year,'_d',pred.day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
JHOUR <- build.similar(file.name=paste(landsat.path,pred.year,'_d',pred.day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=7,var.name='JHOUR')

landsat.file.names <- c(
	paste(landsat.path,pred.year,'_d',pred.day,'_b',bands,'_r',radius[1],'.tif',sep=''),
	paste(landsat.path,pred.year,'_d',pred.day,'_b',bands,'_r',radius[2],'.tif',sep='')
	)
# print(landsat.file.names)
landsat.pred.data <- stack(landsat.file.names)
names(landsat.pred.data) <- c(paste('b',bands,'.',radius[1],sep=''),paste('b',bands,'.',radius[2],sep=''))
landsat.pred.data <- addLayer(landsat.pred.data, JDATE, JHOUR)
# print(landsat.pred.data)
landsat.pred.data <- crop(landsat.pred.data, study.area.2)
print(landsat.pred.data)

# nass.pred.data[is.na(nass.pred.data)==TRUE] <- 0
# landsat.pred.data[is.na(landsat.pred.data)==TRUE] <- 0


