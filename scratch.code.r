library(raster)

output.path <- 'd:/chicago_grasslands/models/'
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

load(paste(output.path,'nass.pred.v2.rdata',sep=''))
load(paste(output.path,'landsat.pred.v2.rdata',sep=''))

for (i in 1:2)
{
	temp1 <- raster(nass.pred[[i]])
	temp2 <- raster(landsat.pred[[i]])
	writeRaster(nass.pred[[i]],paste(output.path,spp.names[i],'.nass.2009.tif',sep=''), overwrite=TRUE)
	writeRaster(landsat.pred[[i]],paste(output.path,spp.names[i],'.landsat.2009.tif',sep=''), overwrite=TRUE)
}
