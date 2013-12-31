library(raster)
library(ncdf)

workspace <- 'D:/Chicago_Grasslands/GIS/nass_layers/'

nass<-read.csv('d:/chicago_grasslands/gis/nass_file_lists.csv',header=T,stringsAsFactors=FALSE)
variables <- colnames(nass)[-1]
values <- as.numeric(nass[1,-1])
years <- seq(2012,2006,-1)
cat('variables:',variables,'\n')
cat('values:',values,'\n')
cat('years:',years,'\n')
radius <- 250 # (meters)
startTime <- Sys.time()

# stop('cbw')

for (i in 1:length(years))
{
	r.temp <- raster(paste(workspace,(2013-i),'_nass_clip_30m.tif',sep=''))
	# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
	# plot(r.temp)
	is.na(r.temp) <- 0
	
	for (j in 1:length(variables))
	{
		# Rescore to binary raster
		r.binary <- r.temp
		r.binary[r.binary!=values[j]] <- 0
		r.binary[r.binary==values[j]] <- 1
		# plot(r.binary)
		w.matrix <- focalWeight(x=raster.temp, d=radius, type='circle')
		focal.prop <- focal(r.binary, w=w.matrix) # , pad=TRUE, padValue=0)
		# print(focal.prop)
		# plot(focal.prop, main=paste(years[i],variables[j]))
		writeRaster(focal.prop, paste(workspace,years[i],'_',variables[j],'_nass_30m_r',radius,'.tif',sep=''),overwrite=TRUE)
		# stop('cbw')
		cat('year',years[i],'variable',variables[j],startTime-Sys.time(),'\n')
	}
	# stop('cbw')
}

