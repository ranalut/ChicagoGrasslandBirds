


calc.distances <- function(nass.map, class.vector, the.radius, workspace, the.year, the.nass.var)
# calc.focal.prop <- function(nass.map=r.temp, class.vector=values[[j]], the.radius=radius[n], workspace=workspace, the.year=years[i], the.nass.var=nass.var[j])
{
	# Proportions
	r.binary <- nass.map
	the.test <- r.binary %in% class.vector # Or, consider layerize.
	r.binary[the.test==FALSE] <- NA
	r.binary[the.test==TRUE] <- 1
	writeRaster(r.binary,paste('d:/chicago_grasslands/Temp/temp_dist.tif',sep=''),overwrite=TRUE)
	# plot(r.binary)
	# stop('cbw')
	# distances <- distance(r.binary, doEdge=FALSE) # , pad=TRUE, padValue=0)
	# plot(distances, main=paste(the.year,the.nass.var))
	
	if (the.year < 2010) { shell('C:/Python27/ArcGIS10.2/python.exe C:/users/cwilsey/documents/github/chicagograsslandbirds/euclid_dist_56m.py') }
	if (the.year >= 2010) { shell('C:/Python27/ArcGIS10.2/python.exe C:/users/cwilsey/documents/github/chicagograsslandbirds/euclid_dist_30m.py') }
	
	file.copy(
		from='D:/Chicago_Grasslands/Temp/temp_dist_4.tif',
		to=paste('d:/chicago_grasslands/nass2/updated_cdl_2014/',the.year,'_',the.nass.var,'_nass_dist.tif',sep=''),
		overwrite=TRUE
		)
	
	# writeRaster(distances, paste(workspace,the.year,'_',the.nass.var,'_nass_30m_dist.tif',sep=''),overwrite=TRUE)
}

# # Single run
# workspace <- 'z:/chicago_grasslands/gis/nass_layers/'
# r.temp <- raster(paste(workspace,2010,'_nass_clip_30m.tif',sep=''))
# is.na(r.temp) <- 0 # Creates a temporary file
# calc.focal.prop(nass.map=r.temp, class.vector=c(171,37,181), the.radius=1000, workspace=workspace, the.year=2010, the.nass.var='grass.hay')