
# Loading CTAP data
source('rm.na.pts.r')
source('julian.hour.r')
julian.table <- function(x) { julian(as.Date(x['DATE'],format="%m-%d-%Y"), origin = as.Date(paste(x['BYear'],"-01-01",sep=''))) }


# workspace <- 'Z:/Chicago_Grasslands/BIRD_DATA/Val/'
workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"

old <- read.csv(paste(workspace,'ctap_1997-2010.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
old <- old[,c("SiteID","LatDD","LongDD","County","Habitat","CTAPcomm","BYear","Type","Minutes","Species","BMonth","BDay","BTime","NumOfVisit")]
# new <- read.csv(paste(workspace,'ctap_newer_CW.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
# new <- new[,c("SiteID","Latdegr","Longdegr","County","Habitat","CTAPcomm","BYear","Type","Minutes","Species","BMonth","BDay","NumOfVisit")] # LatDD LongDD
ctap <- old # as.data.frame(rbind(old,new))
print(dim(ctap))
print(table(ctap$BYear))
test <- apply(X=ctap[,c(2:3,7,9:13)],MARGIN=1,FUN=rm.na.pts)
# print(sum(test))
# print(head(ctap[test==TRUE,]))
ctap <- ctap[test==FALSE,]
ctap <- ctap[ctap$BYear >= 2007 & ctap$BYear <= 2011 & ctap$BMonth >=6 & ctap$BMonth <=7 & ctap$Minutes <= 5,]
ctap$Count <- rep(1,dim(ctap)[1])
print(table(ctap$BYear))
print(dim(ctap))
# stop('cbw')

spp.counts <- aggregate(Count ~ SiteID + LatDD + LongDD + Habitat + BDay + BMonth + BYear + BTime +  Species, ctap, length)
# print(spp.counts)

unique.pts <- aggregate(Species ~ SiteID + LatDD + LongDD, spp.counts, length)
# print(unique.pts)
write.csv(unique.pts, paste(workspace,'pts.ctap_2007-11.csv',sep=''))


lake.spp <- c('BOBO','EAME','GRSP','HESP','SEWR')
eBird.spp <- c('boboli','easmea','graspa','henspa','sedwre')

spp.counts <- spp.counts[spp.counts$Species %in% lake.spp,]
colnames(spp.counts) <- c("SiteID","LatDD","LongDD","Habitat","BDay","BMonth","BYear","BTime","SPECIES_CODE","Count")
for (i in 1:length(lake.spp))
{
  spp.counts$SPECIES_CODE <- gsub(pattern=lake.spp[i], replacement=eBird.spp[i], x=spp.counts$SPECIES_CODE)
}

spp.counts$JHOUR <- apply(spp.counts, 1, julian.hour, col.name='BTime')

spp.counts$DATE <- paste(spp.counts$BMonth,spp.counts$BDay,spp.counts$BYear,sep='-')
spp.counts$JDATE <- apply(spp.counts, 1, julian.table)
write.csv(spp.counts, paste(workspace,'obs.ctap_2007-11.csv',sep=''))
