library(xlsx)
# Loading CTAP data
source('rm.na.pts.r')

# workspace <- 'Z:/Chicago_Grasslands/BIRD_DATA/Val/'
workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"

old <- read.csv(paste(workspace,'ctap_older_CW.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
old <- old[,c("SiteID","Latdegr","Longdegr","County","Habitat","CTAPcomm","BYear","Type","Minutes","Species","BMonth","BDay","NumOfVisit")] # LatDD LongDD
new <- read.csv(paste(workspace,'ctap_newer_CW.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
new <- new[,c("SiteID","Latdegr","Longdegr","County","Habitat","CTAPcomm","BYear","Type","Minutes","Species","BMonth","BDay","NumOfVisit")] # LatDD LongDD
ctap <- as.data.frame(rbind(old,new))
print(dim(ctap))
print(table(ctap$BYear))
test <- apply(X=ctap[,c(2:3,7,9:12)],MARGIN=1,FUN=rm.na.pts)
# print(sum(test))
# print(head(ctap[test==TRUE,]))
ctap <- ctap[test==FALSE,]
ctap <- ctap[ctap$BYear >= 2007 & ctap$BYear <= 2011 & ctap$BMonth >=6 & ctap$BMonth <=7 & ctap$Minutes <= 5,]
ctap$Count <- rep(1,dim(ctap)[1])
print(table(ctap$BYear))
print(dim(ctap))
stop('cbw')

spp.counts <- aggregate(Count ~ SiteID + LatDD + LongDD + Habitat + BDay + BMonth + BYear +  Species, ctap, length)
print(spp.counts)

unique.pts <- aggregate(Species ~ SiteID + LatDD + LongDD, spp.counts, length)
print(unique.pts)

write.csv(unique.pts, paste(workspace,'pts.ctap_2007-11.csv',sep=''))
