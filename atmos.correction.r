
library(raster)
library(landsat)


atmos.cor <- function(workspace, file.name, sensor='TM5')
{
	# Loop through bands for atmospheric corrections and to remove clouds and cloud shadows.  

	radiances <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),numeric()),skip=121,nlines=14)
	radiances <- list(g=radiances[[3]][c(1:7)],b=radiances[[3]][c(8:14)])
	elevation <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),numeric()),skip=60,nlines=1)[[3]]
	the.date <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),character()),skip=21,nlines=1)[[3]]
	e.sun <- list(TM5=c(1983,1795,1539,1028,219.8,NA,83.49),ETM=c(1997,1812,1533,1039,230.8,NA,84.9)) # ,EO1=c(1996,1807,1536,1145,235.1,82.38))
	e.sun <- e.sun[[sensor]]
	
	# print(radiances); print(elevation); print(the.date) # print(azimuth)

	bands <- seq(1,7,1)
	svh.cutoffs <- c(-Inf,55,75,95,115) # c(55,75,95,115,255)
	
	for (i in 1:length(bands))
	{
		tiff <- readGDAL(fname=paste(workspace,file.name,'/',file.name,'_b',bands[i],'.tif',sep=''))
		
		if (bands[i]==6) 
		{
			thermal <- thermalband(tiff, band = 6)
			thermal <- raster(thermal)
			writeRaster(thermal, paste(workspace,file.name,'/atmos.',file.name,'_b',bands[i],'.tif',sep=''),overwrite=TRUE)
			next(i)
		}
		
		if (bands[i]==1)
		{
			SHV <- table(tiff@data[, 1])
			SHV <- min(as.numeric(names(SHV)[SHV > 1000]))
			cat('SHV',SHV,'\n')
			shv.col <- sum(SHV > svh.cutoffs)
			cat('SHV column',shv.col,'\n')
			tiff.DOS <- DOS(sat = ifelse(sensor=='TM5',5,7), SHV = SHV, SHV.band = 1, Grescale = radiances[['g']][i], Brescale = radiances[['b']][i], sunelev = elevation, edist = ESdist(the.date))
			tiff.DOS <- tiff.DOS[["DNfinal.mean"]]
			# print(tiff.DOS)
			tiff.DOS <- tiff.DOS[i,shv.col]
			print(tiff.DOS)
			# stop('cbw')
		}
		
		atmos.tiff <- radiocorr(tiff, Grescale = radiances[['g']][i], Brescale = radiances[['b']][i], sunelev = elevation, edist = ESdist(the.date), Esun = e.sun[i], Lhaze = tiff.DOS, method = "DOS4")
		# print(atmos.tiff); stop('cbw')
		atmos.tiff <- raster(atmos.tiff)
		writeRaster(atmos.tiff, paste(workspace,file.name,'/atmos.',file.name,'_b',bands[i],'.tif',sep=''),overwrite=TRUE)
		# stop('cbw')
	}
}	


