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
		# nass.pred[[i]] <- predict(nass.models[[i]], newdata=nass.pred.data, na.action=na.omit) # For RF, didn't work b/c of NAs.
		writeRaster(nass.pred[[i]],paste(output.path,spp.names[i],'.nass.tif',sep=''), overwrite=TRUE)
		cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
		stop('cbw')
	}
	
	# Landsat
	if (do.landsat=='y')
	{
		startTime <- Sys.time()
		landsat.pred[[i]] <- predict(landsat.pred.data, landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		# landsat.pred[[i]] <- predict(landsat.models[[i]], newdata=landsat.pred.data, na.action=na.omit) # For RF, didn't work b/c of NAs
		writeRaster(landsat.pred[[i]],paste(output.path,spp.names[i],'.landsat.rf.tif',sep=''), overwrite=TRUE)
		# landsat.pred.2[[i]] <- projectRaster(from=landsat.pred[[i]], to=landsat.pred.2[[i]])
		# writeRaster(landsat.pred.2[[i]],paste(output.path,spp.names[i],'.landsat.albers.tif',sep=''), overwrite=TRUE)
		cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
	}
	# stop('cbw')
}
# save(nass.pred, file=paste(output.path,'nass.pred.rdata',sep=''))
# save(landsat.pred, file=paste(output.path,'landsat.pred.rdata',sep=''))

# ================================================================
# Justin's code
# p<-predict(chic, spp.tc5.lr01, n.trees = spp.tc5.lr01$n.trees, type="response", progress="window", na.rm=TRUE)




