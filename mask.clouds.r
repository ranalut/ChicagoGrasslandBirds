
mask.clouds <- function(workspace,file.name,level)
{
	clouds <- raster(paste(workspace,file.name,'/clouds.rm.shadows.',level,'.',file.name,'.tif',sep=''))
	# print(clouds) # ; plot(clouds)
	
	for (i in 1:7)
	{
		landsat <- raster(paste(workspace,file.name,'/atmos.',file.name,'_b',i,'.tif',sep=''))
		# print(landsat); stop('cbw')
		mask(landsat, clouds, inverse=TRUE, filename=paste(workspace,file.name,'/atmos.clean.',file.name,'_b',i,'.tif',sep=''), overwrite=TRUE)
	}
}

