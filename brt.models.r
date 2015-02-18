
# Build BRT models using NASS and Landsat Data.
library(dismo)
library(gbm)
library(tcltk2)

# source('settings.r')

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
		indices <- match(model.var,colnames(the.data))
		nass.models[[i]] <- gbm.step(data=the.data, gbm.x=indices, gbm.y=9, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5) 
		# See settings, run.brt, model.var for variables used.
		# c(7,8,12:15,17:26,28) w/o drain but w/ ndvi
		# c(4:5,11:14,16:25), gbm.y=6, w/o drain ndvi 
		# gbm.x=c(4:5,11:27) w/ drain & ndvi (2015) 
		# gbm.x=c(4:5,9:36) original set (2014)
		# stop('cbw')
		cat('\nend nass',spp.names[i],'############################\n')
	}
}

# # Landsat models
# if (do.landsat=='y')
# {
	# landsat.models <- list()
	
	# for (i in 1:length(landsat.spp.data))
	# {
		# landsat.rows[[i]] <- drop.test.rows(landsat.rows[[i]], test.rows=test.rows)
		# the.data <- landsat.spp.data[[i]][landsat.rows[[i]],]
		# cat('\nstart landsat',spp.names[i],'\n')
		# cat('points considered...',dim(the.data)[1],'\n')
		# landsat.models[[i]] <- gbm.step(data=the.data, gbm.x=c(4:5,9:20), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		
		# cat('\nend landsat',spp.names[i],'############################\n')
	# }
# }

# =========================================================================
# Ideas
# Geographic Distance models
# Consider adding but appear to be for presence/absence models.

# test.nass.model <- gbm.step(data=test.nass, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)
# test.landsat.model <- gbm.step(data=test.landsat, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)

# ========================================================================
# Justin's original BRT code:
# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)
# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")


