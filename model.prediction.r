library(raster)
library(dismo)
library(gbm)
# library(randomForest)

# source('settings.r')

# Make predictions based on BRT models.

nass.pred <- list()
landsat.pred <- list()

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
	
	# # Landsat
	# if (do.landsat=='y')
	# {
		# startTime <- Sys.time()
		# landsat.pred[[i]] <- predict(landsat.pred.data, landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		# landsat.pred[[i]] <- round(landsat.pred[[i]],3)
		# writeRaster(landsat.pred[[i]],paste(output.path,spp.names[i],'.landsat.v',ver,'.tif',sep=''), overwrite=TRUE)
		# cat('end',spp.names[i],'time',Sys.time()-startTime,'\n')
	# }
	# stop('cbw')
}

# test.nass.pred <- predict(nass.pred.data, test.nass.model, n.trees=test.nass.model$n.trees, type='response', progress='window', na.rm=TRUE)
# writeRaster(test.nass.pred,paste(output.path,'test.nass.2009.tif',sep=''), overwrite=TRUE)

# test.landsat.pred <- predict(landsat.pred.data, test.landsat.model, n.trees=test.landsat.model$n.trees, type='response', progress='window', na.rm=TRUE)
# writeRaster(test.landsat.pred,paste(output.path,'test.landsat.2009.tif',sep=''), overwrite=TRUE)		

# ================================================================
# Justin's code
# p<-predict(chic, spp.tc5.lr01, n.trees = spp.tc5.lr01$n.trees, type="response", progress="window", na.rm=TRUE)




