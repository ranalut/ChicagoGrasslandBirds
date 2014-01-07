
# Will create raster stacks for all variables (multiple spatial scales) within the same year. Then, will sample all stacks with the points.  Then, will select which year's data stack to use based on individual points and records.

years <- c(2007, 2009)
radius <- c(100, 500)
days <- c(215,156)
bands <- seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')

nass.data <- list()
landsat.data <- list()
point.data <- list()

for (i in 1:length(years))
{
	nass.file.names <- c(paste(years[i],'_',nass.var,'_nass_30m_r',radius[1],'.tif',sep=''),paste(years[i],'_',nass.var,'_nass_30m_r',radius[2],'.tif',sep=''))
	print(nass.file.names)
	nass.data[[i]] <- stack(nass.file.names)
	
	landsat.file.names <- c(paste(years[i],'_d',days[i],'_b',bands,'_r',radius[1],'.tif',sep=''),paste(years[i],'_d',days[i],'_b',bands,'_r',radius[2],'.tif',sep=''))
	print(landsat.file.names)
	landsat.data[[i]] <- stack(landsat.file.names)
	# stop('cbw')
}
stop('cbw')



## select observations for species of interest
sppname<-paste("graspa")
spp<-obs[obs$SPECIES_CODE==sppname,]

## join to set of unique submissions

spp_PA<-merge(spp, counts, by=c("SUB_ID", "JHOUR", "JDATE", "LATITUDE", "LONGITUDE"), all=T)
i<-is.na(spp_PA$HOW_MANY_ATLEAST)
spp_PA$HOW_MANY_ATLEAST[i]<-0
spp_PA<-spp_PA[,-(6:9)]
spp_PA<-spp_PA[,-(7:30)]

write.csv(spp_PA,paste(sppname, "_PA.csv", sep=""), row.names=F)
