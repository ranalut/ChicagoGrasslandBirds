


calc.patch <- function(nass.map, class.vector, workspace, the.year, the.nass.var)
{
	r.binary <- nass.map
	the.test <- r.binary %in% class.vector # Or, consider layerize.
	r.binary[the.test==FALSE] <- 0
	r.binary[the.test==TRUE] <- 1
	# plot(r.binary)
	patch <- clump(r.binary, directions=8, gaps=FALSE)
	# plot(patch, main=paste(the.year,the.nass.var))
	# Need to assign to each pixel the size of it's habitat patch.
	# table fxn
	# reassign
	# will need to merge all rasters to get a single map again.
	# writeRaster(focal.prop, paste(workspace,the.year,'_',the.nass.var,'_nass_clump_30m.tif',sep=''),overwrite=TRUE)
}

# # Single run
workspace <- 'z:/chicago_grasslands/gis/nass_layers/'
r.temp <- raster(paste(workspace,2010,'_nass_clip_30m.tif',sep=''))
is.na(r.temp) <- 0 # Creates a temporary file
calc.patch(nass.map=r.temp, class.vector=c(171,37,181), workspace=workspace, the.year=2010, the.nass.var='grass.hay')
