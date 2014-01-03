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
	is.na(r.temp) <- 0 # Creates a temporary file
	
	for (j in 1:length(variables))
	{
		if (file.exists(paste(workspace,years[i],'_',variables[j],'_nass_30m_r',radius,'.tif',sep=''))==TRUE) 
		{
			cat('year',years[i],'variable',variables[j],Sys.time()-startTime,'\n')
			next(j)
		}
		
		# Rescore to binary raster
		r.binary <- r.temp
		r.binary[r.binary!=values[j]] <- 0 # Creates a temporary file
		r.binary[r.binary==values[j]] <- 1 # Creates a temporary file
		# plot(r.binary)
		w.matrix <- focalWeight(x=r.temp, d=radius, type='circle')
		focal.prop <- focal(r.binary, w=w.matrix) # , pad=TRUE, padValue=0)
		# print(focal.prop)
		# plot(focal.prop, main=paste(years[i],variables[j]))
		writeRaster(focal.prop, paste(workspace,years[i],'_',variables[j],'_nass_30m_r',radius,'.tif',sep=''),overwrite=TRUE)
		cat('year',years[i],'variable',variables[j],Sys.time()-startTime,'\n')
		# stop('cbw')
	}
	
	# Remove all the temporary files for that year's calculations.  
	file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
	# stop('cbw')
}
