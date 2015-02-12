library(rgdal)
library(sp)

# source('settings.r')
source('rm.na.pts.r') # Loads a function used below.
source('closest.year.r')
source('nass.lulc.classes.r')
source('gridSample.max.r')
source('grid.sample.r')

# Load BCN data
target.columns <- c("SUB_ID","JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE","SPECIES_CODE","HOW_MANY_ATLEAST","VALID")
all.data <- read.csv(paste(drive,":/Chicago_Grasslands/BIRD_DATA/BCN/31qryBreeding_JGS_version.csv",sep=''), header=TRUE,stringsAsFactors=FALSE)
obs <- all.data[all.data$VALID==1 & 
				all.data$PROTOCOL_ID=="P21" & 
				all.data$DURATION_HRS==0.08 &
				all.data$ALL_OBS_REPORTED==1 &
				all.data$YEAR %in% survey.yrs,target.columns] # c(1:2,4:13,21,30:31)
print(dim(obs))

counts <- aggregate(VALID ~ SUB_ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)
# counts <- aggregate(VALID ~ JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)
print(dim(counts))

obs.2014 <- read.csv(paste(drive,':/Chicago_Grasslands/BIRD_DATA/GrasslandBlitz2014Ebird/myebirddata13jan15c.csv',sep=''),stringsAsFactors=FALSE,header=TRUE)

# Non-BCN data, load and format to match BCN.
target.columns <- c("JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE","SPECIES_CODE","HOW_MANY_ATLEAST")
ctap <- read.csv(paste(drive,":/Chicago_Grasslands/BIRD_DATA/Val/obs.ctap_2007-11.csv",sep=''), header=TRUE, stringsAsFactors=FALSE, row.names=1)
ctap2012 <- read.csv(paste(drive,":/Chicago_Grasslands/BIRD_DATA/Val/obs.ctap.2012.csv",sep=''), header=TRUE, stringsAsFactors=FALSE, row.names=1)
lake <- read.csv(paste(drive,":/Chicago_Grasslands/BIRD_DATA/Val/lake.county.2007-2013.csv",sep=''), header=TRUE, stringsAsFactors=FALSE, row.names=1)
will <- read.csv(paste(drive,":/Chicago_Grasslands/BIRD_DATA/Val/will.county.2007-2011.csv",sep=''), header=TRUE, stringsAsFactors=FALSE, row.names=1)
non.bcn.data <- as.data.frame(
						rbind(
						obs.2014[,target.columns],
						ctap[,target.columns],
						ctap2012[,target.columns],
						lake[,target.columns],
						will[,target.columns]
						))
non.bcn.data$VALID <- rep(1,dim(non.bcn.data)[1])
non.bcn.counts <- aggregate(VALID ~ JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, non.bcn.data, length)
non.bcn.counts$SUB_ID <- paste('N',seq(1,dim(non.bcn.counts)[1]),sep='')
non.bcn.data <- merge(non.bcn.data, non.bcn.counts[,c("JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE","SUB_ID")], all.x=TRUE)
print(dim(non.bcn.data))
print(dim(non.bcn.counts))
# stop('cbw')
# all.data

counts <- rbind(counts, non.bcn.counts) # 8723 # 7368 counts included (some are repeat counts at same site).
obs <- rbind(obs, non.bcn.data) # 52534 # 43448 species records (includes other spp).
print(dim(counts))
print(dim(obs))

write.csv(counts,paste(drive,':/Chicago_Grasslands/BIRD_DATA/all.counts.3feb14.csv',sep=''))
write.csv(obs,paste(drive,':/Chicago_Grasslands/BIRD_DATA/all.obs.3feb14.csv',sep=''))

# stop('cbw')

# select observations for species of interest
nass.spp.data <- list()
all.rows <- list()
nass.rows <- list()


for (i in 1:length(spp.names))
{
	spp.obs <- obs[obs$SPECIES_CODE==spp.names[i],]
	# print(dim(spp.obs))
	
	
	for (j in 1:length(survey.yrs))
	{
		# Identify presence and absence counts
		counts.yr <- counts[counts$YEAR==survey.yrs[j],]
		spp.obs.yr <- spp.obs[spp.obs$YEAR==survey.yrs[j],c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE", "HOW_MANY_ATLEAST")]
		spp.obs.yr <- merge(spp.obs.yr, counts.yr, by=c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE"), all=T)
		test <- is.na(spp.obs.yr$HOW_MANY_ATLEAST)
		spp.obs.yr$HOW_MANY_ATLEAST[test==TRUE] <- 0 # Assign zero's to absence years.
		# print(head(spp.obs.yr)); print(dim(spp.obs.yr)); stop('cbw')
		
		sink(paste(output.path,count.file,sep=''),append=TRUE)
			cat(spp.names[i],' ')
			cat(survey.yrs[j],' ')
			temp <- spp.obs.yr$HOW_MANY_ATLEAST == 0
			cat(as.numeric(table(temp)),'\n')
		sink()
		
		# Assign data yr
		data.yr <- close.yr(x=survey.yrs[j],avail.yrs=data.yrs)
		# print(data.yr); stop('cbw')
		position <- match(data.yr, data.yrs)
		
		# NASS
		# "Field1","SUB_ID","JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE", "VALID","POINT_X","POINT_Y"
		temp.data <- nass.data[[position]]
		drop.indices <- match(c("Field1","SUB_ID","JHOUR","JDATE","YEAR","VALID"),colnames(temp.data))
		temp.data <- temp.data[,-drop.indices]
		values <- c(values,list(seq(1,300,1)[-unlist(values)]))
		nass.var <- c(nass.var,'other')
		temp.data$lulc <- sapply(temp.data$lulc,FUN=assign.class,USE.NAMES=FALSE,values=values,nass.var=nass.var)
		temp.data$lulc <- factor(temp.data$lulc,levels=nass.var)
		temp.data$hydro <- factor(temp.data$hydro,levels=seq(1,7,1))
		temp.data$drain <- factor(temp.data$drain,levels=seq(1,7,1),ordered=TRUE)		
		if (j==1) { nass.spp.data[[i]] <- merge(spp.obs.yr, temp.data, by=c('LATITUDE', 'LONGITUDE')) }
		else { nass.spp.data[[i]] <- rbind(nass.spp.data[[i]], merge(spp.obs.yr, temp.data, by=c('LATITUDE', 'LONGITUDE'))) }
		# if (j==1) { nass.spp.data[[i]] <- spp.obs.yr }
		# else { nass.spp.data[[i]] <- rbind(nass.spp.data[[i]], spp.obs.yr) }
	}
	
	all.rows[[i]] <- seq(1,dim(nass.spp.data[[i]])[1],1)
	cat('all data points...',length(all.rows[[i]]),'\n')
	# stop('cbw')
	
	# NASS
	n.col <- dim(nass.spp.data[[i]])[2]
	test <- apply(X=nass.spp.data[[i]],MAR=1,FUN=rm.na.pts)
	# temp <- cbind(test,nass.spp.data[[i]])
	# write.csv(temp,paste(output.path,'nass.test.csv',sep=''))
	# stop('cbw')
	# nass.spp.data[[i]] <- nass.spp.data[[i]][test==FALSE,]
	# print(dim(nass.spp.data[[i]])) # print(colnames(nass.spp.data[[i]])); stop('cbw')
	
	nass.rows[[i]] <- all.rows[[i]][test==FALSE]
	cat('nass data points...',length(nass.rows[[i]]),'\n')
	
	# nass.spp.data <- gridSample.wrap(data,rows,FUN)
	# temp <- nass.spp.data[[i]]
	# temp <- temp[nass.rows[[i]],]
	
}

# ========================================================
# Test Code
# test.nass <- nass.spp.data[[1]]
# test.nass$HOW_MANY_ATLEAST <- rep(0,dim(test.nass)[1])
# suitable.pts <- dim(test.nass[test.nass$grass.hay.500 > 0.5 & test.nass$grass.hay.100 > 0.5,])[1]
# test.nass$HOW_MANY_ATLEAST[test.nass$grass.hay.500 > 0.5 & test.nass$grass.hay.100 > 0.5] <- sample(seq(1,5,1),size=length(suitable.pts))

# test.landsat <- landsat.spp.data[[1]]
# test.landsat$HOW_MANY_ATLEAST <- test.nass$HOW_MANY_ATLEAST

# =====================================================
# Justin's original code
# join to set of unique submissions
# spp_PA$HOW_MANY_ATLEAST[i]<-0
# spp_PA<-spp_PA[,-(6:9)]
# spp_PA<-spp_PA[,-(7:30)]

# write.csv(spp_PA,paste(sppname, "_PA.csv", sep=""), row.names=F)
