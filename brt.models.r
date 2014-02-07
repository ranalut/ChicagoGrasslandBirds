
# Build BRT models using NASS and Landsat Data.
library(dismo)
library(gbm)
library(tcltk2)

# source('settings.r')

# NASS models
if (do.nass=='y')
{
	nass.models <- list()
	nass.dev.exp.cv <- NA
	nass.dev.exp.test <- NA
	nass.cor.cv <- NA
	nass.cor.test <- NA
	
	for (i in 1:length(nass.spp.data))
	{
		nass.rows[[i]] <- drop.test.rows(nass.rows[[i]], test.rows=test.rows)
		the.data <- nass.spp.data[[i]][nass.rows[[i]],]
		cat('\nnstart nass',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		nass.models[[i]] <- gbm.step(data=the.data, gbm.x=c(4:5,9:26), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		
		evaluation <- model.eval(the.model=nass.models[[i]], covariates=nass.spp.data[[i]][,c(4:5,9:26)], test.rows=test.rows, obs=nass.spp.data[[i]][,6], spp=spp.names[i])
		
		nass.dev.exp.cv[i] <- evaluation[[1]]; nass.dev.exp.test[i] <- evaluation[[2]]
		nass.cor.cv[i] <- evaluation[[3]]; nass.cor.test[i] <- evaluation[[4]]
		cat('\nend nass',spp,'############################\n')
	}
}

# Landsat models
if (do.landsat=='y')
{
	landsat.models <- list()
	landsat.dev.exp.cv <- NA
	landsat.dev.exp.test <- NA
	landsat.cor.cv <- NA
	landsat.cor.test <- NA
	
	for (i in 1:length(landsat.spp.data))
	{
		landsat.rows[[i]] <- drop.test.rows(landsat.rows[[i]], test.rows=test.rows)
		the.data <- landsat.spp.data[[i]][landsat.rows[[i]],]
		cat('\nstart landsat',spp.names[i],'\n')
		cat('points considered...',dim(the.data)[1],'\n')
		landsat.models[[i]] <- gbm.step(data=the.data, gbm.x=c(4:5,9:20), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
		
		evaluation <- model.eval(the.model=landsat.models[[i]], covariates=landsat.spp.data[[i]][,c(4:5,9:20)], test.rows=test.rows, obs=landsat.spp.data[[i]][,6], spp=spp.names[i])
		
		landsat.dev.exp.cv[i] <- evaluation[[1]]; landsat.dev.exp.test[i] <- evaluation[[2]]
		landsat.cor.cv[i] <- evaluation[[3]]; landsat.cor.test[i] <- evaluation[[4]]
		cat('\nend landsat',spp,'############################\n')
	}
}

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


