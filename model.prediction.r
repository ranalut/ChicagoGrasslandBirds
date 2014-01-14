library(raster)
library(dismo)
library(gbm)
library(randomForest)

source('settings.r')

# Make predictions based on BRT models.

# Load models - each object is a list of models, one for each species.
load(file=paste(output.path,'pred.data.v2.rdata',sep='')) # Version 2 includes smaller area similar to "Active Counties".
load(file=paste(output.path,'species.models.v3.rdata',sep=''))

nass.pred <- list()
landsat.pred <- list()
landsat.pred.2 <- list()

for (i in 1:length(spp.names))
{
	# NASS
	if (do.nass=='y')
	{
		startTime <- Sys.time()
		nass.pred[[i]] <- predict(nass.pred.data, nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		nass.pred[[i]] <- round(nass.pred[[i]],3)
		writeRaster(nass.pred[[i]],paste(output.path,spp.names[i],'.nass.tif',sep=''), overwrite=TRUE)
		cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
		stop('cbw')
	}
	
	# Landsat
	if (do.landsat=='y')
	{
		startTime <- Sys.time()
		landsat.pred[[i]] <- predict(landsat.pred.data, landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		landsat.pred[[i]] <- round(landsat.pred[[i]],3)
		writeRaster(landsat.pred[[i]],paste(output.path,spp.names[i],'.landsat.tif',sep=''), overwrite=TRUE)
		cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
	}
	# stop('cbw')
}

save(nass.pred, file=paste(output.path,'nass.pred.rdata',sep=''))
save(landsat.pred, file=paste(output.path,'landsat.pred.rdata',sep=''))

# ================================================================
# Justin's code
# p<-predict(chic, spp.tc5.lr01, n.trees = spp.tc5.lr01$n.trees, type="response", progress="window", na.rm=TRUE)




