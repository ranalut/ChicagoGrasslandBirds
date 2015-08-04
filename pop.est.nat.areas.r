
library(raster)
library(rgdal)

drive <- 'd' # 'z'
ver <- 36

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
nass.path <- paste(drive,':/chicago_grasslands/models/v',ver,'/',sep='')

# # nat_area <- raster(paste(drive,':/chicago_grasslands/gis/natural_areas.tif',sep=''))
# # cmap_p <- readOGR(dsn=paste(drive,':/chicago_grasslands/gis',sep=''),'cmap_counties')
# # cmap_p <- spTransform(cmap_p,CRS('+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs'))
# # cmap <- rasterize(cmap_p, nat_area, field='CNTY_FIPS',mask=TRUE)
# cmap <- raster(paste(drive,':/chicago_grasslands/gis/nat_area_cmap.tif',sep=''))
# cmap <- raster(paste(drive,':/chicago_grasslands/gis/patches_30acre_counties.tif',sep=''))
# cmap <- extend(cmap,temp)

# plot(cmap); stop('cbw')

output <- as.data.frame(matrix(NA,ncol=5,nrow=20))
colnames(output) <- spp.names

for (j in 1:20)
{
	for (i in 1:5)
	{
		# start <- Sys.time()
		temp <- raster(paste(nass.path,spp.names[i],'.nass.v',ver,letters[j],'.tif',sep=''))
        # plot(temp)                
        # Mask to natural Areas
        # temp <- mask(x=temp, mask=nat_area)
        # plot(temp)
        temp <- mask(x=temp, mask=cmap)
        # plot(temp)
        
		temp <- as.matrix(temp)
		# Set a minimum cutoff below which we ignore the value assigned to the grid cell.
		# temp[temp < 0.15] <- NA
		
        output[j,i] <- round(sum(temp,na.rm=TRUE) * 0.0509) # Could re-run this with 100m radius.
        # output[j,i] <- round(sum(temp,na.rm=TRUE)) # 
        
		print(output)
		# print(Sys.time()-start)
		# stop('cbw')
	}
}

write.csv(output,paste(nass.path,'pop.est.nass.v',ver,'.cut.cmap.30a.nat.areas.csv',sep=''))

# output <- read.csv(paste(nass.path,'pop.est.nass.v',ver,'.cut.cmap.30a.nat.areas.csv',sep=''),row.names=1)
# output <- read.csv(paste(nass.path,'pop.est.nass.v',ver,'.cut.nat.areas.csv',sep=''),row.names=1)
load(file=paste(nass.path,'all.performance.v',ver,'.rdata',sep=''))
library(Hmisc)
output2 <- as.data.frame(matrix(NA,ncol=5,nrow=4))
colnames(output2) <- spp.names
rownames(output2) <- c('wt.mean','low','high','cv')

for (i in 1:5)
{
	weights <- test.eval[[i]]$cor
	output2[1,i] <- round(wtd.mean(output[,i],weights=weights, na.rm=FALSE))
	output2[2:3,i] <- round(range(output[,i]))
    output2[4,i] <- round(100*sqrt(wtd.var(output[,i],weights=weights, na.rm=FALSE))/output2[1,i])
}

write.csv(output2,paste(nass.path,'median.pop.est.nass.v',ver,'.cut.cmap.30a.nat.areas.csv',sep=''))
# write.csv(output2,paste(nass.path,'median.pop.est.nass.v',ver,'.cut.nat.areas.csv',sep=''))

