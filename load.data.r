
library(rgdal)
library(raster)

# source('settings.r')

nass.data <- list()
landsat.data <- list()

# Load the unique points for model building
# Albers equal area
unique.pts <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA/Val',sep=''),layer='all_unique_5may14_albers',encoding='ESRI Shapefile')
print(unique.pts)
# unique.pts@data <- unique.pts@data[,30:39]

# UTM zone 16N
unique.pts.2 <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA/Val',sep=''),layer='all_unique_5may14_utm16n',encoding='ESRI Shapefile')
print(unique.pts.2)
# unique.pts.2@data <- unique.pts.2@data[,30:39]
# stop('cbw')

for (i in 1:length(data.yrs))
{
	nass.file.names <- paste(nass.path,data.yrs[i],'_',nass.var,'_nass_30m_r',rep(radius,each=length(nass.var)),'.tif',sep='')
	# print(nass.file.names)
	temp <- stack(nass.file.names)
	# print(temp)
	nass.data[[i]] <- extract(temp,unique.pts)
	colnames(nass.data[[i]]) <- paste(nass.var,'.',rep(radius,each=length(nass.var)),sep='')
	nass.data[[i]] <- data.frame(unique.pts@data,nass.data[[i]])
	# write.csv(nass.data[[i]],paste(output.path,data.yrs[i],'.nass.extract.csv',sep=''))
	# stop('cbw')
	
	landsat.file.names <- paste(landsat.path,data.yrs[i],'_clean_d',days[i],'_b',bands,'_r',rep(radius,each=length(bands)),'.tif',sep='')
	# print(landsat.file.names)
	temp2 <- stack(landsat.file.names)
	# print(temp2)
	landsat.data[[i]] <- extract(temp2,unique.pts.2)
	colnames(landsat.data[[i]]) <- paste('b',bands,'.',rep(radius,each=length(bands)),sep='')
	landsat.data[[i]] <- data.frame(unique.pts.2@data,landsat.data[[i]])
	# write.csv(landsat.data[[i]],paste(output.path,data.yrs[i],'.landsat.extract.csv',sep=''))
	# stop('cbw')
	cat(data.yrs[i],'\n')
}
