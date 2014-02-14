library(raster)
library(rgdal)

source('settings.r')

ref.proj <- raster(paste(output.path,'boboli.nass.v6.tif',sep=''))
print(ref.proj)

for (i in 1:length(spp.names))
{
	temp <- raster(paste(output.path,spp.names[i],'.landsat.v6.tif',sep=''))
	print(temp)
	temp2 <- projectRaster(from=temp, to=ref.proj)
	print(temp2)
	writeRaster(temp2,paste(output.path,spp.names[i],'.landsat.v6.albers.tif',sep=''), overwrite=TRUE)
}

