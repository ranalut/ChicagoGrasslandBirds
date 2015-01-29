library(raster)

# Must delete output files before re-running.  Set up to run from existing files.

workspace <- 'D:/Chicago_Grasslands/GIS/NDVI/polygonclip_1648261311/polygonclip_1648261311/NDVI_DATA_CACHE/'
file_names <- dir(workspace)
output_names <- substr(file_names,9,12)
# print(output_names); stop('cbw')

for (i in 1:length(file_names))
{
	temp <- raster(paste(workspace,file_names[i],sep=''))
	# print(temp)
	temp <- round(((temp-125)/125),3)
	print(temp)
	writeRaster(temp,paste(workspace,output_names[i],'_ndvi.tif',sep=''),overwrite=TRUE)
	# stop('cbw')
}
