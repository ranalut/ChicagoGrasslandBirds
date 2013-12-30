library(raster)
library(ncdf)

prop.of.window <- function(x,value,w.matrix,...)
{
	cat('value:',value,'\n')
	print(w.matrix)
	print(x)
	stop('cbw')
	x <- na.omit(x)
	# ifelse(sum(is.na(x))>0,return(NA),x <- x[x!=0])
	print(x)
	output <- length(x[x==value]) / length(weights[weights>0])
	return(output)
}

workspace <- 'D:/Chicago_Grasslands/GIS/nass_layers/'

nass<-read.csv('d:/chicago_grasslands/gis/nass_file_lists.csv',header=T,stringsAsFactors=FALSE)
variables <- colnames(nass)[-1]
values <- as.numeric(nass[1,-1])
years <- seq(2012,2006,-1)
cat('variables:',variables,'\n')
cat('values:',values,'\n')
cat('years:',years,'\n')

# stop('cbw')

for (i in 1:length(years))
{
	for (j in 1:length(variables))
	{
		raster.temp <- raster(paste(workspace,(2013-i),'_nass_clip_30m.tif',sep=''))
		# Testing/debugging code
			# print(raster.temp)
			raster.temp <- crop(x=raster.temp,y=extent(600000,650000,2050000,2100000))
			print(raster.temp)
			# print(is.na(raster.temp))
			# plot(raster.temp)
			# print(focalWeight(x=raster.temp, d=90, type='circle')) # Cells not in circle are weighted zero.
			# stop('cbw')
		
		w.matrix <- focalWeight(x=raster.temp, d=90, type='circle')
		focal.prop <- focal(raster.temp, w=w.matrix, fun=prop.of.window, pad=TRUE, padValue=NA, value=values[j], w.matrix=w.matrix) # d=250
		stop('cbw')
		writeRaster(focal.prop, paste(workspace,years[i],'_',variables[j],'_nass_clip_30m.tif',sep=''),overwrite=TRUE)
		stop('cbw')
	}
	# Build and write out raster stack here.
}
