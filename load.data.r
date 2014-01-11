
library(rgdal)
library(raster)

# Define inputs and file paths
years <- c(2007, 2009)
radius <- c(100, 500)
days <- c(215,156)
bands <- seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')

nass.path <- 'd:/chicago_grasslands/gis/nass_layers/'
landsat.path <- 'd:/chicago_grasslands/landsat2/'
output.path <- 'd:/chicago_grasslands/models/'

nass.data <- list()
landsat.data <- list()

# Load the unique points for model building
# Albers equal area
unique.pts <- readOGR(dsn='D:/Chicago_Grasslands/BIRD_DATA/BCN',layer='unique_pts_albers_v2',encoding='ESRI Shapefile')
print(unique.pts)
unique.pts@data <- unique.pts@data[,30:39]
# UTM zone 16N
unique.pts.2 <- readOGR(dsn='D:/Chicago_Grasslands/BIRD_DATA/BCN',layer='unique_pts_utm16n_v2',encoding='ESRI Shapefile')
print(unique.pts.2)
unique.pts.2@data <- unique.pts.2@data[,30:39]

for (i in 1:length(years))
{
	nass.file.names <- c(
		paste(nass.path,years[i],'_',nass.var,'_nass_30m_r',radius[1],'.tif',sep=''),
		paste(nass.path,years[i],'_',nass.var,'_nass_30m_r',radius[2],'.tif',sep='')
		)
	# print(nass.file.names)
	temp <- stack(nass.file.names)
	# print(temp)
	nass.data[[i]] <- extract(temp,unique.pts)
	colnames(nass.data[[i]]) <- c(paste(nass.var,'.',radius[1],sep=''),paste(nass.var,'.',radius[2],sep=''))
	nass.data[[i]] <- data.frame(unique.pts@data,nass.data[[i]])
	
	write.csv(nass.data[[i]],paste(output.path,years[i],'.nass.extract.csv',sep=''))
	# stop('cbw')
	
	landsat.file.names <- c(
		paste(landsat.path,years[i],'_d',days[i],'_b',bands,'_r',radius[1],'.tif',sep=''),
		paste(landsat.path,years[i],'_d',days[i],'_b',bands,'_r',radius[2],'.tif',sep='')
		)
	# print(landsat.file.names)
	temp2 <- stack(landsat.file.names)
	# print(temp2)
	landsat.data[[i]] <- extract(temp2,unique.pts.2)
	colnames(landsat.data[[i]]) <- c(paste('b',bands,'.',radius[1],sep=''),paste('b',bands,'.',radius[2],sep=''))
	landsat.data[[i]] <- data.frame(unique.pts.2@data,landsat.data[[i]])
	write.csv(landsat.data[[i]],paste(output.path,years[i],'.landsat.extract.csv',sep=''))
	# stop('cbw')
}

save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v1.rdata',sep=''))
# stop('cbw')
