
library(rgdal)
library(raster)

# source('settings.r')

nass.data <- list()

# Load the unique points for model building
# Albers equal area
unique.pts <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA',sep=''),layer='all_unique_3feb15_albers',encoding='ESRI Shapefile') # 1434 points # 2202 point locations (this included years < 2007).
print(unique.pts)
# unique.pts@data <- unique.pts@data[,30:39]

# density adjustment
# temp <- raster(paste(nass.path,'pt_dens_56m_3feb15.tif',sep=''))
# temp <- 1 - (temp / ceiling(maxValue(temp)))
# writeRaster(temp,paste(nass.path,'pt_weight_56m_3feb15.tif',sep=''),overwrite=TRUE)

# temp <- raster(paste(nass.path,'pt_dens_30m_3feb15.tif',sep=''))
# temp <- 1 - (temp / ceiling(maxValue(temp)))
# writeRaster(temp,paste(nass.path,'pt_weight_30m_3feb15.tif',sep=''),overwrite=TRUE)

for (i in 1:length(data.yrs))
{
	if (data.yrs[i] < 2010)
	{
	nass.file.names <- paste(nass.path,data.yrs[i],'_',nass.var,'_nass_30m_r',rep(radius,each=length(nass.var)),'.tif',sep='')
	nass.file.names <- c(
		paste(nass.path,'CDL_',data.yrs[i],'_clip_20150129145939_195531972.tif',sep=''),
		nass.file.names,
		paste(nass.path,data.yrs[i],'_nass_clump_30m.tif',sep=''),
		paste(soil.path,'hydro_class_2.tif',sep=''),
		paste(soil.path,'drain_class_2.tif',sep=''),
		paste(ndvi.path,data.yrs[i],'_ndvi_56m_2.tif',sep=''),
		paste(nass.path,'pt_weight_56m_3feb15.tif',sep='')
		)
	}
	else
	{
	nass.file.names <- paste(nass.path,data.yrs[i],'_',nass.var,'_nass_30m_r',rep(radius,each=length(nass.var)),'.tif',sep='')
	nass.file.names <- c(
		ifelse(data.yrs[i]==2014,paste(nass.path,'CDL_',data.yrs[i],'_clip_20150202180847_618398852.tif',sep=''),paste(nass.path,'CDL_',data.yrs[i],'_clip_20150129145939_195531972.tif',sep='')),
		nass.file.names,
		paste(nass.path,data.yrs[i],'_nass_clump_30m.tif',sep=''),
		paste(soil.path,'hydro_class.tif',sep=''),
		paste(soil.path,'drain_class.tif',sep=''),
		paste(ndvi.path,data.yrs[i],'_ndvi_30m.tif',sep=''),
		paste(nass.path,'pt_weight_30m_3feb15.tif',sep='')
		)
	}
	print(nass.file.names)
	temp <- stack(nass.file.names)
	print(temp)
	
	# Distance data
	nass.file.names2 <- paste(nass.path,data.yrs[i],'_',nass.var,'_nass_dist.tif',sep='')
	print(nass.file.names2)
	temp2 <- stack(nass.file.names2)
	print(temp2)
	# temp2[temp2>1000] <- 1000
	temp <- stack(temp,temp2)
	# print(temp)
	#stop('cbw')
	
	# Extract to points.
	nass.data[[i]] <- extract(temp,unique.pts)
	colnames(nass.data[[i]]) <- c('lulc',paste(nass.var,'.',rep(radius,each=length(nass.var)),sep=''),'patch.cells','hydro','drain','ndvi','weight',paste(nass.var,'.dist',sep=''))
	
	nass.data[[i]] <- data.frame(unique.pts@data,nass.data[[i]])
	# write.csv(nass.data[[i]],paste(output.path,data.yrs[i],'.nass.extract.csv',sep=''))
	# stop('cbw')
	
}
