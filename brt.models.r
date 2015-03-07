
# Build BRT models using NASS and Landsat Data.
library(dismo)
library(gbm)
library(tcltk2)

# source('settings.r')
# stop('cbw')

# NASS models
if (do.nass=='y')
{
	nass.models <- list()
	if (do.stepwise=='y') { nass.step <-list() }
	
	for (i in 1:length(nass.spp.data))
	{
		cat('test rows\n')
		print(test.rows[[i]])
		nass.rows[[i]] <- drop.test.rows(nass.rows[[i]], test.rows=test.rows[[i]])
		the.data <- nass.spp.data[[i]][nass.rows[[i]],]
		cat('\nnstart nass',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		if (do.final=='y') { indices <- nass.step[[i]]$pred.list[[drops[i]]] }
		else { indices <- match(model.var[[i]],colnames(the.data)) }
		nass.models[[i]] <- gbm.step(data=the.data, gbm.x=indices, gbm.y=9, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5) # ,site.weights=the.data$weight) 
		
		if (do.stepwise=='y')
		{
			nass.step[[i]] <- gbm.simplify(nass.models[[i]])
		}
		
		obs.pred <- as.data.frame(cbind(the.data[,9],nass.models[[i]]$fitted))
		colnames(obs.pred) <- c('obs','pred')
		temp <- obs.pred[obs.pred$obs>0,]
		threshold <- min(temp$pred)
		if (i==1) { sink(paste(output.path,'nass.thresh.v',ver,'.txt',sep='')) }
		else { sink(paste(output.path,'nass.thresh.v',ver,'.txt',sep=''),append=TRUE) }
			cat(spp.names[i],'threshold =',threshold,'\n')
		sink()
		
		# stop('cbw')
		cat('\nend nass',spp.names[i],'############################\n')
	}
}

# See settings, run.brt, model.var for variables used.
# c(7,8,12:15,17:26,28) w/o drain but w/ ndvi
# c(4:5,11:14,16:25), gbm.y=6, w/o drain ndvi 
# gbm.x=c(4:5,11:27) w/ drain & ndvi (2015) 
# gbm.x=c(4:5,9:36) original set (2014)
