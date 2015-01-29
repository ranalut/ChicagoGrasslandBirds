
# Loading CTAP data
source('rm.na.pts.r')
source('julian.hour.r')
julian.table <- function(x) { julian(as.Date(x['DATE'],format="%m-%d-%Y"), origin = as.Date(paste(x['BYear'],"-01-01",sep=''))) }

workspace <- 'D:/Chicago_Grasslands/BIRD_DATA/Val/'
# workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"

new <- read.csv(paste(workspace,'ctap_recent_CW.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
new <- new[,c("SiteID","LatDD","LongDD","BYear","Minutes","Species","BMonth","BDay","BTime","Type","NumOfVisit","Num_Inds")] # no "BTime"

ctap <- new # as.data.frame(rbind(old,new))
print(dim(ctap))
print(table(ctap$BYear))
test <- apply(X=ctap,MARGIN=1,FUN=rm.na.pts) # Removes records without time stamp, among other things.
# print(sum(test))
# print(head(ctap[test==TRUE,]))
ctap <- ctap[test==FALSE,]
ctap <- ctap[
	ctap$BYear >= 2011 & ctap$BYear <= 2013 & 
	ctap$BMonth >=6 & ctap$BMonth <=7 & 
	ctap$Minutes <= 5 & ctap$Type=='PC',]
print(table(ctap$BYear))
print(dim(ctap))
# stop('cbw')

spp.counts <- aggregate(Num_Inds ~ SiteID + LatDD + LongDD + BDay + BMonth + BYear + BTime + Species, data = ctap, sum)
# stop('cbw')
unique.pts <- aggregate(Species ~ SiteID + LatDD + LongDD, spp.counts, length)
# print(unique.pts)
colnames(unique.pts) <- c('SiteID','LATITUDE','LONGITUDE','SPECIES_CODE')
write.csv(unique.pts, paste(workspace,'pts.ctap.2012.csv',sep=''))

lake.spp <- c('BOBO','EAME','GRSP','HESP','SEWR')
eBird.spp <- c('boboli','easmea','graspa','henspa','sedwre')

spp.counts <- spp.counts[spp.counts$Species %in% lake.spp,]
colnames(spp.counts) <- c("SiteID","LATITUDE","LONGITUDE","BDay","BMonth","BYear","BTime","SPECIES_CODE","HOW_MANY_ATLEAST")
for (i in 1:length(lake.spp))
{
  spp.counts$SPECIES_CODE <- gsub(pattern=lake.spp[i], replacement=eBird.spp[i], x=spp.counts$SPECIES_CODE)
}

# spp.counts$JHOUR <- apply(spp.counts, 1, julian.hour, col.name='BTime')
spp.counts$JHOUR <- 7.15 # median of the all 2007-11 points, used for all unknowns 
# median(obs$JHOUR[obs$JHOUR<15 & obs$JHOUR >3]) = 7.15

spp.counts$DATE <- paste(spp.counts$BMonth,spp.counts$BDay,spp.counts$BYear,sep='-')
spp.counts$JDATE <- apply(spp.counts, 1, julian.table)
spp.counts$YEAR <- spp.counts$BYear
write.csv(spp.counts, paste(workspace,'obs.ctap.2012.csv',sep=''))
