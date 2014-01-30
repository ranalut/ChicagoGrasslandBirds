
library(landsat)
library(raster)
source('overlay.fxns.r')

cloud.shadow <- function(workspace, level, file.name, padx, pady, shiftx, shifty)
{
	cloud.tiff <- readGDAL(paste(workspace,file.name,'/clouds.rm.',level,'.',file.name,'.tif',sep=''))
	shadows <- geoshift(cloud.tiff, padx=padx, pady=pady, shiftx=shiftx, shifty=shifty)
	cloud.tiff <- raster(cloud.tiff)
	shadows <- raster(shadows)
	shadows <- crop(shadows,cloud.tiff)
	cloud.tiff <- overlay(cloud.tiff,shadows,fun=fxn1)
	writeRaster(cloud.tiff, paste(workspace,file.name,'/clouds.rm.shadows.',level,'.',file.name,'.tif',sep=''), overwrite=TRUE)
}


