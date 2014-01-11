
# Build BRT models using NASS and Landsat Data.

library(dismo)
library(gbm)
# library(pROC)
# library(ROCR)
# library(rgdal)
# library(tcltk)
# library(mgcv)

setwd('d:/github/chicagograsslandbirds/')
output.path <- 'd:/chicago_grasslands/models/'

# Step 1 ============================================
# Creates spatial points objects for the unique survey points in the BCN dataset and extracts data from the nass and landsat datasets, assembled a raster stacks.  Output is saves as .csv files in /Models/ folder and as an R workspace.

# source('load.data.r') 

# Step 2 ============================================
# Generate datasets for each individual species pulling data for each survey from it's respective year in the multi-year dataset.

# source('species.data.r') 

# Step 3 ===========================================
# Now, we will build BRT models for individual species...
load(file=paste(output.path,'species.data.v1.rdata',sep=''))

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
years <- c(2007,2009)
lr <- c(0.01,0.005,0.01,0.01,0.01)

# NASS models
nass.models <- list()
for (i in 1:length(nass.spp.data))
{
	cat('\n\n\n\n\nstart nass',spp.names[i],'########################\n')
	nass.models[[i]] <- gbm.step(data=nass.spp.data[[i]], gbm.x=c(4:5,9:26), gbm.y=6, family="poisson", 
	tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
	cat('end nass',spp.names[i],'############################\n')
	# stop('cbw')
}
# stop('cbw')

# Landsat models
landsat.models <- list()
for (i in 1:length(nass.spp.data))
{
	cat('\n\n\n\nstart landsat',spp.names[i],'########################\n')
	landsat.models[[i]] <- gbm.step(data=landsat.spp.data[[i]], gbm.x=c(4:5,9:22), gbm.y=6, family="poisson", tree.complexity=5, learning.rate=lr[i], bag.fraction=0.5)
	cat('end landsat',spp.names[i],'############################\n')
	# stop('cbw')
}

save(nass.models, landsat.models, file=paste(output.path,'species.models.v1.rdata',sep=''))

# ========================================================================
# Justin's original BRT code:
# mydata<-read.csv(paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_PA_for_BRT.csv", sep=""), header=T)
# spp.tc5.lr01<-gbm.step(data=mydata, gbm.x=9:24, gbm.y=4, family="poisson", tree.complexity=5, learning.rate=0.01, bag.fraction=0.5)
# save(spp.tc5.lr01,file=paste("D:/Chicago_Grasslands/BIRD_DATA/BCN/", sppname, "_BRT", sep="")

