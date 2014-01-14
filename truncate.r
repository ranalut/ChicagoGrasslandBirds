
library(raster)
library(rgdal)

source('settings.r')

for (i in 1:length(spp.names))
{
	# NASS
	temp <- raster(paste(output.path,spp.names[i],'.nass.tif',sep=''))
	print(temp)
	# min.value <- minValue(temp)
	# if (min.value < 0) { temp[temp < 0] <- 0 }
	# writeRaster(temp,paste(output.path,spp.names[i],'.nass.zero.tif',sep=''), overwrite=TRUE)
	# cat('done',spp.names[i],'nass\n')
	# Landsat
	temp <- raster(paste(output.path,spp.names[i],'.landsat.tif',sep=''))
	print(temp)
	# min.value <- minValue(temp)
	# if (min.value < 0) { temp[temp < 0] <- 0 }
	# writeRaster(temp,paste(output.path,spp.names[i],'.landsat.albers.zero.tif',sep=''), overwrite=TRUE)
	# cat('done',spp.names[i],'landsat\n')
}
