
library(raster)
library(landsat)

workspace <- 'D:/Chicago_Grasslands/LANDSAT2/'
file.name <- 'lt50230312009156pac02'

atmos.cor <- function(workspace, file.name, sensor='TM5')
{
	# Loop through bands for atmospheric corrections and to remove clouds and cloud shadows.  

	radiances <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),numeric()),skip=121,nlines=14)
	radiances <- list(g=radiances[[3]][c(1:7)],b=radiances[[3]][c(8:14)])
	elevation <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),numeric()),skip=60,nlines=1)[[3]]
	the.date <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),character()),skip=21,nlines=1)[[3]]
	# azimuth <- scan(file=paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''),what=list(character(),character(),numeric()),skip=59,nlines=1)[[3]]
	e.sun <- list(TM5=c(1983,1795,1539,1028,219.8,NA,83.49),ETM=c(1997,1812,1533,1039,230.8,NA,84.9)) # ,EO1=c(1996,1807,1536,1145,235.1,82.38))
	e.sun <- e.sun[[sensor]]
	
	print(radiances); print(elevation); print(the.date) # print(azimuth)
	# stop('cbw')

	# metadata <- readLines(paste(workspace,file.name,'/',file.name,'_MTL.txt',sep=''))
	# radiances <- grep('RADIANCE', metadata, value=TRUE)[-c(1:16)]
	# print(radiances)
	# radiances <- gsub('.*= ([0-9]+).*','\\1',radiances)
	# gsub('.*-([0-9]+).*','\\1','Ab_Cd-001234.txt')

	bands <- seq(1,7,1)
	svh.cutoffs <- c(-Inf,55,75,95,115) # c(55,75,95,115,255)
	
	for (i in 1:length(bands))
	{
		if (bands[i]==6) { next(i) }
		
		tiff <- readGDAL(fname=paste(workspace,file.name,'/',file.name,'_b',bands[i],'.tif',sep=''))
		
		if (bands[i]==1)
		{
			SHV <- table(tiff@data[, 1])
			SHV <- min(as.numeric(names(SHV)[SHV > 1000]))
			cat('SHV',SHV,'\n')
			shv.col <- sum(SHV > svh.cutoffs)
			cat('SHV column',shv.col,'\n')
			tiff.DOS <- DOS(sat = ifelse(sensor=='TM5',5,7), SHV = SHV, SHV.band = 1, Grescale = radiances[['g']][i], Brescale = radiances[['b']][i], sunelev = elevation, edist = ESdist(the.date))
			tiff.DOS <- tiff.DOS[["DNfinal.mean"]]
			print(tiff.DOS)
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

atmos.cor(workspace=workspace, file.name=file.name, sensor='TM5')

	
# Band 1 is used to nd the SHV , here the lowest DN with at least 1000 pixels.
# R> SHV <- table(july1@data[, 1])
# R> SHV <- min(as.numeric(names(SHV)[SHV > 1000]))
# R> SHV
# [1] 69
# That SHV (69) is then used in DOS() to nd the corrected SHV values for the remaining
# bands (Chavez 1989).
# R> july.DOS <- DOS(sat = 7, SHV = SHV, SHV.band = 1, Grescale = 0.77569,
# + Brescale = -6.2, sunelev = 61.4, edist = ESdist("2002-07-20"))
# R> july.DOS <- july.DOS[["DNfinal.mean"]]
# R> july.DOS
# R> july.DOS <- july.DOS[, 2]
# R> july2.DOSrefl <- radiocorr(july2, Grescale = 0.79569, Brescale = -6.4,
# + sunelev = 61.4, edist = ESdist("2002-07-20"), Esun = 1812,
# + Lhaze = july.DOS[2], method = "DOS")
# R> july4.DOSrefl <- radiocorr(july4, Grescale = 0.63725, Brescale = -5.1,
# + sunelev = 61.4, edist = ESdist("2002-07-20"), Esun = 1039,
# + Lhaze = july.DOS[4], method = "DOS")
# R> july4.DOSrefl@data[!is.na(july.cloud@data[, 1]), 1] <- NA	

# atmos.tiff <- radiocorr(july4, Grescale = 0.63725, Brescale = -5.1, sunelev = 61.4, edist = ESdist("2002-07-20"), Esun = 1039, Lhaze = july.DOS[4], method = "DOS4")





