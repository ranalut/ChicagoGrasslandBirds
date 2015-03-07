library(raster)
library(dismo)
library(gbm)
# library(randomForest)

# source('settings.r')

# Make predictions based on BRT models.

nass.pred <- list()

for (i in 1:length(spp.names))
{
	# NASS
	if (do.nass=='y')
	{
		startTime <- Sys.time()
		nass.pred[[i]] <- predict(nass.pred.data, nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		nass.pred[[i]] <- round(nass.pred[[i]],3)
		writeRaster(nass.pred[[i]],paste(output.path,spp.names[i],'.nass.v',ver,'.tif',sep=''), overwrite=TRUE)
		cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
		# stop('cbw')
	}
}





