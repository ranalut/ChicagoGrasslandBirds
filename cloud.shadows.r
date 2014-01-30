
library(landsat)
library(raster)

cloud.shadow <- function(workspace, level, file.name, padx, pady, shiftx, shifty)
{
	cloud.tiff <- readGDAL(paste(workspace,file.name,'/clouds.',level,'.',file.name,'.tif',sep=''))
	shadows <- geoshift(cloud.tiff, padx=padx, pady=pady, shiftx=shiftx, shifty=shifty)
	cloud.tiff <- raster(cloud.tiff)
	shadows <- raster(shadows)
	shadows <- crop(shadows,cloud.tiff)
	cloud.tiff <- overlay(cloud.tiff,shadows,fun=fxn1)
	writeRaster(cloud.tiff, paste(workspace,file.name,'/clouds.shadows.',level,'.',file.name,'.tif',sep=''), overwrite=TRUE)
}

fxn1 <- function(x,y)
{
	value <- rep(1,length(x))
	test.x <- is.na(x)
	test.y <- is.na(y)
	test <- test.x + test.y
	value[test==2] <- NA 
	return(value)
}

fxn1(NA,1); fxn1(1,1); fxn1(NA,NA)



