
workspace <- 'D:/Chicago_Grasslands/LANDSAT2/'
file.name <- 'lt50230312009156pac02'

# Loop through bands for atmospheric corrections and to remove clouds and cloud shadows.  

band <- 1

	tiff <- readGDAL(fname=paste(workspace,file.name,'/',file.name,'_b',band,'.tif',sep=''))
	
	
	
	
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





