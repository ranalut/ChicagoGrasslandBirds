library(raster)
# library(ncdf)

workspace <- nass.path
rasterOptions(tmpdir='C:/Users/cwilsey/AppData/Local/Temp/R_raster_cwilsey3/')

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
		r.temp <- raster(paste(workspace,years[i],'_nass_clip_30m.tif',sep=''))
		# r.temp <- crop(x=r.temp,y=extent(600000,650000,2050000,2100000)) # For testing/debugging
		# plot(r.temp)
		is.na(r.temp) <- 0 # Creates a temporary file
		
		for (j in 1:length(nass.var))
		{
			if (file.exists(paste(workspace,years[i],'_',nass.var[j],'_nass_30m_r',radius[n],'.tif',sep=''))==TRUE) 
			{
				cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
				next(j)
			}
			
			calc.focal.prop(nass.map=r.temp, class.vector=values[[j]], the.radius=radius[n], workspace=workspace, the.year=years[i], the.nass.var=nass.var[j])
			cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
			# stop('cbw')
		}
		
		# Remove all the temporary files for that year's calculations.  
		file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_cwilsey3',full.names=TRUE))
		# file.remove(dir('c:/users/cwilsey/appdata/local/temp/r_raster_tmp/cwilsey',full.names=TRUE))
		# stop('cbw')
	}
}