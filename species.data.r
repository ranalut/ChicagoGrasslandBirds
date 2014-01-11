library(rgdal)
library(sp)
source('rm.na.pts.r') # Loads a function used below.

output.path <- 'd:/chicago_grasslands/models/'
load(file=paste(output.path,'unique.point.data.v1.rdata',sep=''))

# Load all data
all.data <- read.csv("D:/Chicago_Grasslands/BIRD_DATA/BCN/31qryBreeding_JGS_version.csv", header=TRUE)
obs <- all.data[all.data$VALID==1 & 
				all.data$PROTOCOL_ID=="P21" & 
				all.data$DURATION_HRS==0.08 &
				all.data$ALL_OBS_REPORTED==1,c(1:2,4:13,21,30:31)]
print(dim(obs))

counts <- aggregate(VALID ~ SUB_ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)

# select observations for species of interest
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
years <- c(2007,2009)

nass.spp.data <- list()
landsat.spp.data <- list()

for (i in 1:length(spp.names))
{
	spp.obs <- obs[obs$SPECIES_CODE==spp.names[i],]
	print(dim(spp.obs))
	
	for (j in 1:length(years))
	{
		# Identify presence and absence counts
		counts.yr <- counts[counts$YEAR==years[j],]
		spp.obs.yr <- spp.obs[spp.obs$YEAR==years[j],c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE", "HOW_MANY_ATLEAST")]
		spp.obs.yr <- merge(spp.obs.yr, counts.yr, by=c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE"), all=T)
		test <- is.na(spp.obs.yr$HOW_MANY_ATLEAST)
		spp.obs.yr$HOW_MANY_ATLEAST[test==TRUE] <- 0
		# print(head(spp.obs.yr)); stop('cbw')
		
		# NASS
		if (j==1) { nass.spp.data[[i]] <- merge(spp.obs.yr, nass.data[[j]][,-c(1:6,9:10)], by=c('LATITUDE', 'LONGITUDE')) }
		else { nass.spp.data[[i]] <- rbind(nass.spp.data[[i]], merge(spp.obs.yr, nass.data[[j]][,-c(1:6,9:10)], by=c('LATITUDE', 'LONGITUDE'))) }
		
		# Landsat
		if (j==1) { landsat.spp.data[[i]] <- merge(spp.obs.yr, landsat.data[[j]][,-c(1:6,9:10)], by=c('LATITUDE', 'LONGITUDE')) }
		else { landsat.spp.data[[i]] <- rbind(landsat.spp.data[[i]], merge(spp.obs.yr, landsat.data[[j]][,-c(1:6,9:10)], by=c('LATITUDE', 'LONGITUDE'))) }
		# print(colnames(landsat.spp.data[[i]])); stop('cbw')
	}
	
	# NASS
	# nass.spp.data[[i]]$HOW_MANY_ATLEAST[is.na(nass.spp.data[[i]]$HOW_MANY_ATLEAST)==TRUE] <- 0
	n.col <- dim(nass.spp.data[[i]])[2]
	test <- apply(X=nass.spp.data[[i]][,(n.col-18):n.col],MAR=1,FUN=rm.na.pts)
	nass.spp.data[[i]] <- nass.spp.data[[i]][test==FALSE,]
	# print(colnames(nass.spp.data[[i]])) # ; print(dim(nass.spp.data[[i]])); stop('cbw')
	
	# Landsat
	# landsat.spp.data[[i]]$HOW_MANY_ATLEAST[is.na(landsat.spp.data[[i]]$HOW_MANY_ATLEAST)==TRUE] <- 0
	n.col <- dim(landsat.spp.data[[i]])[2]
	test <- apply(X=landsat.spp.data[[i]][,(n.col-14):n.col],MAR=1,FUN=rm.na.pts)
	landsat.spp.data[[i]] <- landsat.spp.data[[i]][test==FALSE,]
	# print(colnames(landsat.spp.data[[i]])); print(dim(landsat.spp.data[[i]])); stop('cbw')
	# stop('cbw')
}

save(nass.spp.data,landsat.spp.data,file=paste(output.path,'species.data.v1.rdata',sep=''))

# join to set of unique submissions
# spp_PA$HOW_MANY_ATLEAST[i]<-0
# spp_PA<-spp_PA[,-(6:9)]
# spp_PA<-spp_PA[,-(7:30)]

# write.csv(spp_PA,paste(sppname, "_PA.csv", sep=""), row.names=F)
