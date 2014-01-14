
library(raster)
library(rgdal)

source('settings.r')

for (i in 1:length(spp.names))
{
	# NASS
	temp <- raster(paste(output.path,spp.names[i],'.nass.tif',sep=''))
	print(temp)
	temp <- round(temp,3)
	writeRaster(temp,paste(output.path,spp.names[i],'.nass.r.tif',sep=''), overwrite=TRUE)
	cat('done',spp.names[i],'nass\n')
	
	# Landsat
	temp <- raster(paste(output.path,spp.names[i],'.landsat.tif',sep=''))
	print(temp)
	temp <- round(temp,3)
	writeRaster(temp,paste(output.path,spp.names[i],'.landsat.r.tif',sep=''), overwrite=TRUE)
	cat('done',spp.names[i],'landsat\n')
}
