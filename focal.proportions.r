library(raster)
# library(ncdf)

workspace <- nass.path
# rasterOptions(tmpdir='C:/Users/cwilsey/AppData/Local/Temp/R_raster_cwilsey1/')
rasterOptions(tmpdir='D:/Chicago_Grasslands/Temp/')

# Load the Classes for NASS LULC
source('nass.lulc.classes.r')
	
cat('nass.var:',nass.var,'\nvalues:\n')
print(str(values))
# cat('values:',values,'\n')
cat('years:',years,'\n')
startTime <- Sys.time()

# stop('cbw')
for (n in 1:length(radius))
{
	for (i in 1:length(years))
	{
		# r.temp <- raster(paste(workspace,'CDL_',years[i],'_clip_20150129145939_195531972.tif',sep=''))
		# r.temp <- raster(paste(workspace,'CDL_',years[i],'_clip_20150202180847_618398852.tif',sep=''))
		# r.temp <- raster(paste(workspace,years[i],'_nass_clip_30m.tif',sep=''))
		# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
		# plot(r.temp)
		# is.na(r.temp) <- 0 # Creates a temporary file
		
		for (j in 1:length(nass.var))
		{
			if (file.exists(paste(workspace,years[i],'_',nass.var[j],'_nass_30m_r',radius[n],'.tif',sep=''))==TRUE) 
			{
				cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
				next(j)
			}
			stop('cbw')
			
			calc.focal.prop(nass.map=r.temp, class.vector=values[[j]], the.radius=radius[n], workspace=workspace, the.year=years[i], the.nass.var=nass.var[j])
			cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
			# stop('cbw')
		}
		
		# Remove all the temporary files for that year's calculations.  
		file.remove(dir('D:/Chicago_Grasslands/Temp/',full.names=TRUE))
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_cwilsey1',full.names=TRUE))
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
		# stop('cbw')
		
		file.names <- as.list(paste(workspace,years[i],'_',nass.var,'_nass_clump_30m.tif',sep=''))
		all.patch <- brick(file.names)
		sum.patch <- calc(all.patch,fun=sum,na.rm=TRUE)
		writeRaster(sum.patch, paste(workspace,years[i],'_nass_clump_30m.tif',sep=''),overwrite=TRUE)
		
	}
}
