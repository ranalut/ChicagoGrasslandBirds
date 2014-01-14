
# Build BRT models using NASS and Landsat Data.

library(dismo)
library(gbm)
library(tcltk)
# library(randomForest)
# library(pROC)
# library(ROCR)
# library(rgdal)
# library(mgcv)

source('settings.r')

load(file=paste(output.path,'species.data.v1.rdata',sep=''))

# NASS models
nass.models <- list()
for (i in 1:length(nass.spp.data))
{
	cat('\n\n\n\n\nstart nass',spp.names[i],'########################\n')
	cat('points considered...',dim(nass.spp.data[[i]])[1],'\n')
	nass.models[[i]] <- gbm.step(data=nass.spp.data[[i]], gbm.x=c(4:5,9:26), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
	# nass.models[[i]] <- randomForest(x=nass.spp.data[[i]][,c(4:5,9:26)], y=nass.spp.data[[i]][,6], importance=TRUE)
	test <- predict.gbm(newdata=nass.spp.data[[i]][,c(4:5,9:26)], nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
	plot(test ~ nass.spp.data[[i]][,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
	print(table(round(test)))
	cat('end nass',spp.names[i],'############################\n')
	# stop('cbw')
}
# stop('cbw')

# Landsat models
landsat.models <- list()
for (i in 1:length(nass.spp.data))
{
	cat('\n\n\n\nstart landsat',spp.names[i],'########################\n')
	cat('points considered...',dim(nass.spp.data[[i]])[1],'\n')
	landsat.models[[i]] <- gbm.step(data=landsat.spp.data[[i]], gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
	# landsat.models[[i]] <- randomForest(x=landsat.spp.data[[i]][,c(4:5,9:22)], y=landsat.spp.data[[i]][,6], importance=TRUE)
	test <- predict.gbm(newdata=landsat.spp.data[[i]][,c(4:5,9:22)], landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
	plot(test ~ landsat.spp.data[[i]][,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
	print(table(round(test)))
	cat('end landsat',spp.names[i],'############################\n')
	# stop('cbw')
}

# Version 1 are full models
# Version 2 were RF models, but I suspect that I wrote over them.
# Version 3 are models w/o JDATE and JHOUR 
save(nass.models, landsat.models, file=paste(output.path,'species.models.v1.rdata',sep=''))

# ========================================================================
# Justin's original BRT code:
# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)
# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")


