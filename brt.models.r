
# Build BRT models using NASS and Landsat Data.

library(dismo)
library(gbm)
library(tcltk2)
# library(pROC)
# library(ROCR)
# library(rgdal)
# library(mgcv)
# library(randomForest)

# source('settings.r')

# NASS models
if (do.nass=='y')
{
	nass.models <- list()
	nass.dev.exp.cv <- NA
	nass.dev.exp.test <- NA
	
	for (i in 1:length(nass.spp.data))
	{
		nass.rows[[i]] <- drop.test.rows(nass.rows[[i]], test.rows=test.rows)
		the.data <- nass.spp.data[[i]][nass.rows[[i]],]
		cat('\nnstart nass',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		nass.models[[i]] <- gbm.step(data=the.data, gbm.x=c(4:5,9:26), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		
		# Evaluate
		test <- predict.gbm(newdata=nass.spp.data[[i]][test.rows,c(4:5,9:26)], nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		plot(test ~ nass.spp.data[[i]][test.rows,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
		nass.dev.exp.cv[i] <- dsq(
			mean.null=nass.models[[i]]$self.statistics$mean.null, 
			validation=nass.models[[i]]$cv.statistics$deviance.mean
			)
		cat('deviance explained training data',nass.dev.exp.cv[i],'\n')
		# cat('null',calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),'test',calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), test, family='poisson'),'\n')
		nass.dev.exp.test[i] <- dsq(
			mean.null=calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),
			validation=calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), test, family='poisson')
			)
		cat('deviance explained test data',nass.dev.exp.test[i],'\n')
		cat('\nend nass',spp.names[i],'############################\n')
		# stop('cbw')
	}
}

# Landsat models
if (do.landsat=='y')
{
	landsat.models <- list()
	landsat.dev.exp.cv <- NA
	landsat.dev.exp.test <- NA
	
	for (i in 1:length(landsat.spp.data))
	{
		landsat.rows[[i]] <- drop.test.rows(landsat.rows[[i]], test.rows=test.rows)
		the.data <- landsat.spp.data[[i]][landsat.rows[[i]],]
		cat('\nstart landsat',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		landsat.models[[i]] <- gbm.step(data=the.data, gbm.x=c(4:5,9:20), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		
		# Evaluate
		test <- predict.gbm(newdata=landsat.spp.data[[i]][test.rows,c(4:5,9:20)], landsat.models[[i]], n.trees=landsat.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
		plot(test ~ landsat.spp.data[[i]][test.rows,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
		landsat.dev.exp.cv[i] <- dsq(
			mean.null=landsat.models[[i]]$self.statistics$mean.null, 
			validation=landsat.models[[i]]$cv.statistics$deviance.mean
			)
		cat('deviance explained training data',landsat.dev.exp.cv[i],'\n')
		# cat('null',calc.deviance(as.numeric(landsat.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),'test',calc.deviance(as.numeric(landsat.spp.data[[i]][test.rows,6]), test, family='poisson'),'\n')
		landsat.dev.exp.test[i] <- dsq(
			mean.null=calc.deviance(as.numeric(landsat.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),
			validation=calc.deviance(as.numeric(landsat.spp.data[[i]][test.rows,6]), test, family='poisson')
			)
		cat('deviance explained test data',landsat.dev.exp.test[i],'\n')
		cat('\nend landsat',spp.names[i],'############################\n')
		# stop('cbw')
	}
}

# Geographic Distance models
# Consider adding but appear to be for presence/absence models.

# test.nass.model <- gbm.step(data=test.nass, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)
# test.landsat.model <- gbm.step(data=test.landsat, gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=0.005, bag.fraction=0.5)

# ========================================================================
# Justin's original BRT code:
# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)
# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")


