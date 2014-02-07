

calc.focal.prop <- function(nass.map, class.vector, the.radius, workspace, the.year, the.nass.var)
# calc.focal.prop <- function(nass.map=r.temp, class.vector=values[[j]], the.radius=radius[n], workspace=workspace, the.year=years[i], the.nass.var=nass.var[j])
{
	r.binary <- nass.map
	the.test <- r.binary %in% class.vector
	r.binary[the.test==FALSE] <- 0
	r.binary[the.test==TRUE] <- 1
	# plot(r.binary)
	w.matrix <- focalWeight(x=nass.map, d=the.radius, type='circle')
	focal.prop <- focal(r.binary, w=w.matrix) # , pad=TRUE, padValue=0)
	# plot(focal.prop, main=paste(the.year,the.nass.var))
	writeRaster(focal.prop, paste(workspace,the.year,'_',the.nass.var,'_nass_30m_r',the.radius,'.tif',sep=''),overwrite=TRUE)
}

# # Single run
# workspace <- 'z:/chicago_grasslands/gis/nass_layers/'
# r.temp <- raster(paste(workspace,2010,'_nass_clip_30m.tif',sep=''))
# is.na(r.temp) <- 0 # Creates a temporary file
# calc.focal.prop(nass.map=r.temp, class.vector=c(171,37,181), the.radius=1000, workspace=workspace, the.year=2010, the.nass.var='grass.hay')

# ==================================================================
# Original code
# # Rescore to binary raster
# r.binary <- r.temp
# the.test <- r.binary %in% values[[j]]
# r.binary[the.test==FALSE] <- 0
# r.binary[the.test==TRUE] <- 1
# # plot(r.binary)
# w.matrix <- focalWeight(x=r.temp, d=radius[n], type='circle')
# focal.prop <- focal(r.binary, w=w.matrix) # , pad=TRUE, padValue=0)
# # plot(focal.prop, main=paste(years[i],nass.var[j]))
# writeRaster(focal.prop, paste(workspace,years[i],'_',nass.var[j],'_nass_30m_r',radius[n],'.tif',sep=''),overwrite=TRUE)
# cat('year',years[i],'variable',nass.var[j],Sys.time()-startTime,'\n')
# # stop('cbw')