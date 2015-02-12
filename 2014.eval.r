
source('settings.r') # Check to make sure nothing is turned on.
source('julian.hour.r')
source('julian.date.r')
source('deviance.explained.r')
library(dismo)

# Load the model predictions
# source('2014.data.sample.r')

# Observations
obs.2014 <- read.csv('D:/Chicago_Grasslands/BIRD_DATA/GrasslandBlitz2014Ebird/myebirddata13jan15b.csv',stringsAsFactors=FALSE,header=TRUE)

# From the next step... c("JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE","SPECIES_CODE","HOW_MANY_ATLEAST")

# target.columns <- c("SUB_ID","JHOUR","JDATE","YEAR","LATITUDE","LONGITUDE","SPECIES_CODE","HOW_MANY_ATLEAST","VALID")
obs.2014$JHOUR <- apply(obs.2014,1,julian.hour,col.name='TIME')
obs.2014$JDATE <- apply(obs.2014,1,julian.table,col.name='DATE',origin.yr=2014)
obs.2014$YEAR <- 2014

write.csv(obs.2014,'D:/Chicago_Grasslands/BIRD_DATA/GrasslandBlitz2014Ebird/myebirddata13jan15c.csv')
stop('cbw')

counts <- aggregate(VALID ~ Submission.ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs.2014, length)
# counts <- aggregate(VALID ~ SUB_ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs.2014, length)
# counts <- aggregate(VALID ~ JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)
print(dim(counts))

# colnames(counts) <- c('SUB_ID,JHOUR,JDATE,YEAR,LATITUDE,LONGITUDE,VALID')
spp.common.names <- c("Bobolink","Sedge Wren","Henslow's Sparrow","Eastern Meadowlark","Grasshopper Sparrow")

# NASS
cat('NASS models\n')
for (i in 1:length(spp.names))
{
	temp <- nass.blitz[[i]]
	# print(head(temp)); stop('cbw')
	temp.obs <- obs.2014[obs.2014$Common.Name==spp.common.names[i],]
	records <- dim(temp.obs)[1]
	# print(temp.obs[,c('Latitude','Longitude','Count')])
	temp <- merge(temp,temp.obs[,c('Latitude','Longitude','Count')],by=c('Latitude','Longitude'),all.x=TRUE)
	temp$Count[is.na(temp$Count)==TRUE] <- 0 # Assign zeros to points where none observed
	# print(head(temp))
	# print(temp[,c('pred','Count')]); stop('cbw')
	# print(temp[,c('Latitude','Longitude','Count','pred')])
	temp <- temp[is.na(temp$pred)==FALSE,]
	# temp$pred[temp$pred==0] <- 0.0001 # This inflates variability
	temp <- temp[temp$pred>0,] # predicted zeros can be dropped.
	# print(temp[,c('pred','Count')])
	
	# This was to understand where the Inf are coming from.
	# print(data.frame(temp$Count,temp$pred))
	# y_i <- temp$Count
	# u_i <- temp$pred
	# deviance.contribs <- ifelse(y_i == 0, 0, (y_i * log(y_i/u_i))) - (y_i - u_i)
    # deviance <- 2 * sum(deviance.contribs * 1)
	# print(deviance.contribs); print(deviance)
	
	mn <- calc.deviance(obs=temp$Count, pred=rep(mean(temp$Count),dim(temp)[1]), family="poisson")
	val <- calc.deviance(obs=temp$Count, pred=temp$pred, family="poisson")
	dev.exp.test <- dsq(mean.null=mn, validation=val)
	correlation <- cor(temp$Count,temp$pred)
	cat(spp.names[i],'presences',records,'deviance explained',dev.exp.test,'correlation',correlation,'\n')
	cat('mn',mn,'val',val,'\n')
	# stop('cbw')
}


# LANDSAT
cat('LandSat models\n')
for (i in 1:length(spp.names))
{
	temp <- landsat.blitz[[i]]
	# print(head(temp))
	temp.obs <- obs.2014[obs.2014$Common.Name==spp.common.names[i],]
	records <- dim(temp.obs)[1]
	# print(temp.obs[,c('Latitude','Longitude','Count')])
	temp <- merge(temp,temp.obs[,c('Latitude','Longitude','Count')],by=c('Latitude','Longitude'),all.x=TRUE)
	temp$Count[is.na(temp$Count)==TRUE] <- 0 # Assign zeros to points where none observed
	# print(head(temp))
	# print(temp[,c('Latitude','Longitude','Count','pred')])
	temp <- temp[is.na(temp$pred)==FALSE,]
	# print(temp[,c('pred','Count')])
	# temp$pred[temp$pred==0] <- 0.0001 # This inflates variability
	temp <- temp[temp$pred>0,]
	# print(temp[,c('pred','Count')])
	
	# print(data.frame(temp$Count,temp$pred))
	# y_i <- temp$Count
	# u_i <- temp$pred
	# deviance.contribs <- ifelse(y_i == 0, 0, (y_i * log(y_i/u_i))) - (y_i - u_i)
    # deviance <- 2 * sum(deviance.contribs * 1)
	# print(deviance.contribs); print(deviance)
	
	mn <- calc.deviance(obs=temp$Count, pred=rep(mean(temp$Count),dim(temp)[1]), family="poisson")
	val <- calc.deviance(obs=temp$Count, pred=temp$pred, family="poisson")
	dev.exp.test <- dsq(mean.null=mn, validation=val)
	correlation <- cor(temp$Count,temp$pred)
	cat(spp.names[i],'presences',records,'deviance explained',dev.exp.test,'correlation',correlation,'\n')
	cat('mn',mn,'val',val,'\n')
	# stop('cbw')
}

