library(raster)
library(ncdf)

prop.of.window <- function(x,value)
{
	output <- x[x==value] / length(x) # Think about what the output of focalWeight is.  Does in include all numbers in a square with corners as zero when you select type='circle'?
	return(output)
}

nass<-read.csv('d:/chicago_grasslands/gis/nass_file_lists.csv',header=T,stringsAsFactors=FALSE)
variables <- colnames(nass)[-1]
values <- as.numeric(nass[1,-1])
print(variables)
print(values)
# stop('cbw')

for (i in 1:dim(all.nass.30m)[3])
{
	focal.prop <- list()
	
	for (j in 1:length(variables))
	{
		focal.prop[[i]] <- focal(all.nass.30m[[1]], w=focalweight(x=all.nass.30m[[1]], d=250, type='circle'), fun=prop.of.window, value=values[j])
		writeRaster(focal.prop[[i]], paste(workspace,variables[j],'nass_clip_30m.tif',sep=''),overwrite=TRUE)
		stop('cbw')
	}
	# Build and write out raster stack here.
}
