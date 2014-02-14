
# Currently does not do kernel smoothing around the observation, just maps it to a larger area.

kd <- function(presence.pts, ref.raster, the.radius, file.name=NA)
{
	the.r <- rasterize(presence.pts,ref.raster,field='presences.HOW_MANY_ATLEAST')
	# plot(the.r,main='rasterized abundance locations')
	# print(the.r)
	the.r[is.na(the.r)==TRUE] <- 0
	w.matrix <- focalWeight(x=ref.raster, d=the.radius, type='circle')
	output <- focal(the.r, w=w.matrix) # This is slow.
	output <- output * (pi*(the.radius^2))/10000 # Convert to hectares.
	plot(output,'smoothed abundance')
	if (is.na(file.name)==FALSE) { writeRaster(output, file.name, overwrite=TRUE) }
	return(output)
}


