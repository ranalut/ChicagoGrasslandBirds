library(raster)
source('focal.mean.fxns.r')

workspace <- landsat.path 
rasterOptions(tmpdir='C:/Users/cwilsey/AppData/Local/Temp/R_raster_cwilsey2/')

startTime <- Sys.time()

# stop('cbw')
for (n in 1:length(radius))
{
	for (i in 1:length(folder.names))
	{
		for (j in 1:length(bands))
		{
			if (file.exists(paste(workspace,years[i],'_clean_d',days[i],'_b',bands[j],'_r',radius[n],'.tif',sep=''))==TRUE)
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
			
			r.temp <- raster(paste(workspace,folder.names[i],'/atmos.clean.',folder.names[i],'_B',bands[j],'.tif',sep=''))
			r.temp <- crop(r.temp,study.area.2) # For testing/debugging
			# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
			# plot(r.temp)
			# stop('cbw')
			
			w.matrix <- focalWeight(x=r.temp, d=radius[n], type='circle')
			w.matrix[w.matrix>0] <- 1
			# focal.prop <- focal(r.temp, w=w.matrix)
			focal.prop <- focal(r.temp, w=w.matrix, fun=mean.excl.na, the.weights=w.matrix)
			# print(focal.prop)
			# plot(focal.prop, main=paste(years[i],bands[j]))
			writeRaster(focal.prop, paste(workspace,years[i],'_clean_d',days[i],'_b',bands[j],'_r',radius[n],'.tif',sep=''),overwrite=TRUE)
			cat('year',years[i],'day',days[i],'band',bands[j],Sys.time()-startTime,'\n')
			# stop('cbw')
		}
		
		# Remove all the temporary files for that year's calculations.  
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_cwilsey2',full.names=TRUE))
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
		# file.remove(dir('c:/users/jschuetz/appdata/local/temp/r_raster_tmp/jschuetz',full.names=TRUE))
		# stop('cbw')
	}
}

# # Testing
# x <- raster(matrix(rep(c(seq(1,7,1),NA,NA),times=(100),each=1),ncol=30))
# a <- focal(x, w=matrix(1/9, ncol=3))
# # plot(x)
# plot(a)

# x <- raster(matrix(rep(c(seq(1,7,1),NA,NA),times=(100),each=1),ncol=30))
# a <- focal(x, w=matrix(1/9, ncol=3))
# # plot(x)
# plot(a)

# This seems to work. Hand calculations are equivalent.
# source('focal.mean.fxns.r')
# # x <- raster(matrix(rep(c(seq(1,8,1),NA),times=(100),each=1),ncol=30))
# x <- raster(matrix(sample(c(seq(1,9,1),NA),100,replace=TRUE),ncol=10))
# a <- focal(x, w=matrix(1, ncol=3, nrow=3),fun=mean.excl.na) # ,the.weights=matrix(1,ncol=3))
# plot(x)
# plot(a)

