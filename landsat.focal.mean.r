library(raster)

workspace <- 'D:/Chicago_Grasslands/LANDSAT2/'

years <- c(2007,2009) # seq(2012,2006,-1)
days <- c(215,156)
code <- c('01','02')
bands <- seq(1,7,1)
folder.names <- paste('lt5023031',years,days,'PAC',code,sep='')
print(folder.names)
# stop('cbw')

radius <- c(100,500) # (meters)
startTime <- Sys.time()

# stop('cbw')
for (n in 1:length(radius))
{
	for (i in 1:length(folder.names))
	{
		for (j in 1:length(bands))
		{
			if (file.exists(paste(workspace,years[i],'_d',days[i],'_b',bands[j],'_r',radius[n],'.tif',sep=''))==TRUE)
			{
				# ===============================================
				# Turn these on to visualize maps in a plot window.
				# temp <- raster(paste(workspace,years[i],'_d',days[i],'_b',bands[j],'_r',radius[n],'.tif',sep=''))
				# plot(temp,main=paste(folder.names[i],'r',radius[n],'band',bands[j],sep=' '))
				# stop('cbw')
				# ===============================================
				cat('year',years[i],'day',days[i],'band',bands[j],Sys.time()-startTime,'\n')
				next(j)
			}
			
			r.temp <- raster(paste(workspace,folder.names[i],'/',folder.names[i],'_B',bands[j],'.tif',sep=''))
			# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
			# plot(r.temp)
			# stop('cbw')
			
			# =================================================================
			# Insert atmospheric correction here
			# =================================================================
			
			w.matrix <- focalWeight(x=r.temp, d=radius[n], type='circle')
			focal.prop <- focal(r.temp, w=w.matrix)
			# print(focal.prop)
			# plot(focal.prop, main=paste(years[i],bands[j]))
			writeRaster(focal.prop, paste(workspace,years[i],'_d',days[i],'_b',bands[j],'_r',radius[n],'.tif',sep=''),overwrite=TRUE)
			cat('year',years[i],'day',days[i],'band',bands[j],Sys.time()-startTime,'\n')
			# stop('cbw')
		}
		
		# Remove all the temporary files for that year's calculations.  
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
		file.remove(dir('c:/users/jschuetz/appdata/local/temp/r_raster_tmp/jschuetz',full.names=TRUE))
		# stop('cbw')
	}
}
