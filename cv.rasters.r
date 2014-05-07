
# Coefficient of variation for each grid cell.
library(raster)

drive <- 'z'
workspace <- paste(drive,':/chicago_grasslands/models/',sep='')
ver <- 10
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

for (i in spp.names)
{
	nass.tif <- raster(paste(workspace,i,'.nass.v',ver,'.tif',sep=''))
	landsat.tif <- raster(paste(workspace,i,'.landsat.v',ver,'.tif',sep=''))
	cat('files loaded...')
	landsat.tif <- projectRaster(from=landsat.tif, to=nass.tif, method="ngb")
	cat('re-project complete...')
	temp.stack <- stack(nass.tif, landsat.tif)
	cv.stack <- cv(temp.stack)
	writeRaster(cv.stack,paste(workspace,i,'.cv.v',ver,'.tif',sep=''), overwrite=TRUE)
	cat('file written\n')
	stop('cbw')
}
