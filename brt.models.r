
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
	
	for (i in 1:length(nass.spp.data))
	{
		nass.rows[[i]] <- drop.test.rows(nass.rows[[i]], test.rows=test.rows)
		the.data <- nass.spp.data[[i]][nass.rows[[i]],]
		cat('\nnstart nass',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		indices <- match(model.var[[i]],colnames(the.data))
		nass.models[[i]] <- gbm.step(data=the.data, gbm.x=indices, gbm.y=9, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5) # ,site.weights=the.data$weight) 
		
		# stop('cbw')
		cat('\nend nass',spp.names[i],'############################\n')
	}
}

# See settings, run.brt, model.var for variables used.
# c(7,8,12:15,17:26,28) w/o drain but w/ ndvi
# c(4:5,11:14,16:25), gbm.y=6, w/o drain ndvi 
# gbm.x=c(4:5,11:27) w/ drain & ndvi (2015) 
# gbm.x=c(4:5,9:36) original set (2014)
