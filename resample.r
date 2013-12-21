
library(raster)
library(ncdf)

workspace <- 'D:/Chicago_Grasslands/GIS/nass_layers/'

nass<-read.csv('d:/chicago_grasslands/gis/nass_file_lists.csv',header=T,stringsAsFactors=FALSE)
nass.files <- nass$NASS
ref.grid <- raster(paste(workspace,nass.files[1],sep=''))
print(ref.grid)
all.rasters <- list()

for (i in 1:length(nass.files))
{
	temp <- raster(paste(workspace,nass.files[i],sep=''))
	if(res(temp)[1]==30) { all.rasters[[i]] <- temp }
	else { all.rasters[[i]] <- resample(x=temp,y=ref.grid,method='ngb') }
	writeRaster(all.rasters[[i]],paste(workspace,(2013-i),'_nass_clip_30m.tif',sep=''),overwrite=TRUE)
	cat('done w/',(2013-i),'\n')
	# stop('cbw')
}

all.nass.30m <- stack(all.rasters)

writeRaster(all.nass.30m, paste(workspace,'all_nass_clip_30m.nc',sep=''),varname='cdl', zname='years', zunit='year', overwrite=TRUE)

# test <- resample(x=raster(paste(workspace,'NASS_layers/',nass$NASS[4],sep='')),y=ref.grid,method='ngb',filename=paste(workspace,'NASS_layers/2009_nass_clip_30m.tif',sep=''))

# stop('cbw')




