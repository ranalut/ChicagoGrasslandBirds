library(raster)
# library(ncdf)

workspace <- nass.path
# rasterOptions(tmpdir='C:/Users/cwilsey/AppData/Local/Temp/R_raster_cwilsey1/')
rasterOptions(tmpdir='D:/Chicago_Grasslands/Temp/')

values <- list(
	c(1,225,226,237), # Corn
	c(5,26,241,254), # Soybean
	c(22:24), # Wheat
	c(2,3,4,6,10:14,21,25,27:35,38:39,41:57,204:210,213,214,216,217,219,222,224,227,229:236,238:240,242:250), # Other row crops
	111, # water
	c(87,195), # herbaceous wetlands
	c(37,171,176,181), # herbaceous grasslands, other hay / non alfalfa, pasture/hay, 
	c(36,58:61), # alfalfa, clover/wildflowers, switchgrass, fallow/idle cropland
	c(121,122), # developed open space, dev low
	c(123,124), # dev med, dev high
	141, # deciduous forest
	c(63,142,143,152), # other forest and shrub
	190 # woody wetland
	# seq(0,300,1)[-c(36,37,58,60,61,111,121,122,123,124,141,171,181,190,195)] # everything else
	)
values <- c(values,list(seq(0,300,1)[-unlist(values)]))
	
cat('nass.var:',nass.var,'\nvalues:\n')
print(str(values))
# cat('values:',values,'\n')
cat('years:',years,'\n')
startTime <- Sys.time()

# stop('cbw')

for (i in 1:length(years))
{
	r.temp <- raster(paste(workspace,years[i],'_nass_clip_30m.tif',sep=''))
	# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
	# plot(r.temp)
	is.na(r.temp) <- 0 # Creates a temporary file
	
	for (j in 1:length(nass.var))
	{
		if (file.exists(paste(workspace,years[i],'_',nass.var[j],'_nass_clump_30m.tif',sep=''))==TRUE) 
		{
			cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
			next(j)
		}
		
		calc.patch(nass.map=r.temp, class.vector=values[[j]], workspace=workspace, the.year=years[i], the.nass.var=nass.var[j])
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


