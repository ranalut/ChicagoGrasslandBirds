
library(raster)
library(landsat)

# workspace <- 'D:/Chicago_Grasslands/LANDSAT2/'
# # file.name <- 'lt50230312009156pac02'
# file.name <- 'lt50230312007167pac01'


rm.clouds <- function(workspace, file.name, level)
{
	band1 <- readGDAL(fname=paste(workspace,file.name,'/atmos.',file.name,'_b1.tif',sep=''))
	band6 <- readGDAL(fname=paste(workspace,file.name,'/atmos.',file.name,'_b6.tif',sep=''))
	
	cloud.tiff <- clouds(band1,band6,level)
	cloud.tiff <- raster(cloud.tiff)
	writeRaster(cloud.tiff, paste(workspace,file.name,'/clouds.',level,'.',file.name,'.tif',sep=''), overwrite=TRUE)
}

# # level.seq <- seq(0.0014,0.0005,-0.0001)
# level.seq <- 0.0011

# for (i in level.seq)
# {
	# startTime <- Sys.time()
	# cat('start level value =',i,'\n')
	# rm.clouds(workspace=workspace, file.name=file.name, level=i)
	# cat('end level value =',i,Sys.time()-startTime,'\n')
# }

