
library(raster)
ver <- '36'
the.dir <- paste('d:/chicago_grasslands/models/v',ver,'/',sep='')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

for (i in 1:5)
{
	cat(spp.names[i],' ')
	for (j in 1:20)
	{
		cat(letters[j])
		if(file.exists(paste(the.dir,'PNGs/',spp.names[i],'.nass.v',ver,letters[j],'.png',sep=''))==TRUE) { next(j) }
		temp <- raster(paste(the.dir,spp.names[i],'.nass.v',ver,letters[j],'.tif',sep=''))
		png(paste(the.dir,'PNGs/',spp.names[i],'.nass.v',ver,letters[j],'.png',sep=''))
			plot(temp, main=paste('abundance',spp.names[i],ver,letters[j],sep=' '))
		dev.off()
	}
	cat('\n')
}
