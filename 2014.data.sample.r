
library(rgdal)
library(raster)

source('settings.r')

nass.blitz <- list()
landsat.blitz <- list()

# Load the unique points 
# Albers equal area
unique.pts <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA/GrasslandBlitz2014Ebird',sep=''),layer='unique_pts_2014b_albers',encoding='ESRI Shapefile')
print(unique.pts)

# UTM zone 16N
unique.pts.2 <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA/GrasslandBlitz2014Ebird',sep=''),layer='unique_pts_2014b_utm',encoding='ESRI Shapefile')
print(unique.pts.2)
# unique.pts.2@data <- unique.pts.2@data[,30:39]
# stop('cbw')

# Extract the predictions for NASS and Landsat models
for (i in 1:length(spp.names))
{
	nass.file.names <- paste(drive,':/Chicago_Grasslands/models/',spp.names[i],'.nass.v10.tif',sep='')
	# print(nass.file.names)
	temp <- raster(nass.file.names)
	# print(temp)
	nass.blitz[[i]] <- extract(temp,unique.pts)
	# names(nass.blitz[[i]]) <- spp.names[i]
	nass.blitz[[i]] <- data.frame(unique.pts@data,pred=nass.blitz[[i]])
	# write.csv(nass.blitz[[i]],paste(output.path,data.yrs[i],'.nass.extract.csv',sep=''))
	# stop('cbw')
	
	landsat.file.names <- paste(drive,':/Chicago_Grasslands/models/',spp.names[i],'.landsat.v10.tif',sep='')
	# print(landsat.file.names)
	temp2 <- raster(landsat.file.names)
	# print(temp2)
	landsat.blitz[[i]] <- extract(temp2,unique.pts.2)
	# names(landsat.blitz[[i]]) <- spp.names[i]
	landsat.blitz[[i]] <- data.frame(unique.pts.2@data,pred=landsat.blitz[[i]])
	# write.csv(landsat.blitz[[i]],paste(output.path,data.yrs[i],'.landsat.extract.csv',sep=''))
	# stop('cbw')
	cat(spp.names[i],'\n')
}

