library(raster)
library(ncdf)

workspace <- 'D:/Chicago_Grasslands/GIS/nass_layers/'

# nass<-read.csv('d:/chicago_grasslands/gis/nass_file_lists.csv',header=T,stringsAsFactors=FALSE)
# variables <- colnames(nass)[-1]
# variables <- c(variables,)
# values <- as.numeric(nass[1,-1])
variables <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')
values <- list(
	111, # water
	195, # herbaceous wetlands
	c(171,37,181), # herbaceous grasslands, other hay / non alfalfa, pasture/hay, 
	c(36,58,60,61), # alfalfa, clover/wildflowers, switchgrass, fallow/idle cropland
	c(121,122), # developed open space, dev low
	c(123,124), # dev med, dev high
	141, # deciduous forest
	190, # woody wetland
	seq(0,300,1)[-c(111,195,171,37,181,36,58,60,61,121,122,123,124,141,190)] # everything else
	)

years <- c(2007,2009) # seq(2012,2006,-1)
cat('variables:',variables,'\nvalues:\n')
print(str(values)) 
# cat('values:',values,'\n')
cat('years:',years,'\n')
radius <- c(100,500) # (meters)
startTime <- Sys.time()

# stop('cbw')
for (n in 1:length(radius))
{
	for (i in 1:length(years))
	{
		r.temp <- raster(paste(workspace,years[i],'_nass_clip_30m.tif',sep=''))
		# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
		# plot(r.temp)
		is.na(r.temp) <- 0 # Creates a temporary file
		
		for (j in 1:length(variables))
		{
			if (file.exists(paste(workspace,years[i],'_',variables[j],'_nass_30m_r',radius[n],'.tif',sep=''))==TRUE) 
			{
				cat('year',years[i],'variable',variables[j],Sys.time()-startTime,'\n')
				next(j)
			}
			
			# Rescore to binary raster
			r.binary <- r.temp
			the.test <- r.binary %in% values[[j]]
			r.binary[the.test==FALSE] <- 0
			r.binary[the.test==TRUE] <- 1
			# plot(r.binary)
			w.matrix <- focalWeight(x=r.temp, d=radius[n], type='circle')
			focal.prop <- focal(r.binary, w=w.matrix) # , pad=TRUE, padValue=0)
			# plot(focal.prop, main=paste(years[i],variables[j]))
			writeRaster(focal.prop, paste(workspace,years[i],'_',variables[j],'_nass_30m_r',radius[n],'.tif',sep=''),overwrite=TRUE)
			cat('year',years[i],'variable',variables[j],Sys.time()-startTime,'\n')
			# stop('cbw')
		}
		
		# Remove all the temporary files for that year's calculations.  
		file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
		# stop('cbw')
	}
}