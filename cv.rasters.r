
# Coefficient of variation for each grid cell.
library(raster)

drive <- 'd'
workspace <- paste(drive,':/chicago_grasslands/models/',sep='')
ver <- 10
# spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
spp.names <- 'sedwre'
startTime <- Sys.time()

for (i in spp.names)
{
	nass.tif <- raster(paste(workspace,i,'.nass.v',ver,'.tif',sep=''))
	landsat.tif <- raster(paste(workspace,i,'.landsat.v',ver,'.tif',sep=''))
	cat('files loaded...',Sys.time()-startTime,'...')
	landsat.tif <- projectRaster(from=landsat.tif, to=nass.tif, method="ngb")
	cat('re-project complete...',Sys.time()-startTime,'...')
	temp.stack <- stack(nass.tif, landsat.tif)
	cv.stack <- cv(temp.stack)
	writeRaster(cv.stack,paste(workspace,i,'.cv.v',ver,'.tif',sep=''), overwrite=TRUE)
	cat('file written...',Sys.time()-startTime,'\n')
	# stop('cbw')
}

# (CellStatistics(["boboli.nass.v10.tif", "boboli.landsat.v10.tif"], "STD", "NODATA") / CellStatistics(["boboli.nass.v10.tif", "boboli.landsat.v10.tif"], "MEAN", "NODATA")) * 100

# (("dist10km_5may" / 100) + "mean_cv_v10") / 2