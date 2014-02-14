
# Create an average year for landsat prediction

library(raster)
source('settings.r')

for (i in 1:length(bands))
{
	for (j in 1:length(radius))
	{
		landsat.file.names <- paste(landsat.path,data.yrs,'_clean_d',days,'_b',bands[i],'_r',rep(radius[j],each=length(data.yrs)),'.tif',sep='')
		# print(landsat.file.names); stop('cbw')
		temp <- stack(landsat.file.names)
		temp <- crop(temp, study.area.2)
		print(temp)
		the.mean <- calc(temp, fun=mean, na.rm=TRUE, filename=paste(landsat.path,'20XX','_clean_d','XXX','_b',bands[i],'_r',radius[j],'.tif',sep=''),overwrite=TRUE)
		print(the.mean)
		# stop('cbw')
	}
}

# Another idea would be to take the last year, unless it's a cloud and then take the previous cloud-free year.