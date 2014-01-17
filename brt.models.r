
# Build BRT models using NASS and Landsat Data.

library(dismo)
library(gbm)
library(tcltk)
# library(randomForest)
# library(pROC)
# library(ROCR)
# library(rgdal)
# library(mgcv)

# source('settings.r')

# NASS models
if (do.nass=='y')
{
	nass.models <- list()
	for (i in 1:length(nass.spp.data))
	{
		cat('\n\n\n\n\nstart nass',spp.names[i],'########################\n')
		cat('points considered...',dim(nass.spp.data[[i]])[1],'\n')
		nass.models[[i]] <- gbm.step(data=nass.spp.data[[i]], gbm.x=c(4:5,9:26), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		test <- predict.gbm(newdata=nass.spp.data[[i]][,c(4:5,9:26)], nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		plot(test ~ nass.spp.data[[i]][,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
		print(table(round(test)))
		cat('end nass',spp.names[i],'############################\n')
		# stop('cbw')
	}
}

# Landsat models
if (do.landsat=='y')
{
	landsat.models <- list()
	for (i in 1:length(landsat.spp.data))
	{
		cat('\n\n\n\nstart landsat',spp.names[i],'########################\n')
		cat('points considered...',dim(landsat.spp.data[[i]])[1],'\n')
		landsat.models[[i]] <- gbm.step(data=landsat.spp.data[[i]], gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		test <- predict.gbm(newdata=landsat.spp.data[[i]][,c(4:5,9:22)], landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		plot(test ~ landsat.spp.data[[i]][,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
		print(table(round(test)))
		cat('end landsat',spp.names[i],'############################\n')
		# stop('cbw')
	}
}

test.nass.model <- gbm.step(data=test.nass, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)
test.landsat.model <- gbm.step(data=test.landsat, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)

# ========================================================================
# Justin's original BRT code:
# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)
# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")


