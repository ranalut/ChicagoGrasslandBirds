

q.temp <- function(the.data)
{
	temp <- the.data$HOW_MANY_ATLEAST
	temp <- c(0,temp[temp!=0])
	print(temp)
	q.temp <- quantile(temp,prob=seq(0,1,0.05))
	print(q.temp)
}

# q.temp(the.data=landsat.spp.data[[1]])

# Version none is with raw data
# Version 2 is with numbers rounded to 1 decimal place
# Version 3 is with numbers rounded to 2 decimal places

sink(paste(output.path,'pred.quant.v3.txt',sep=''))
cat('output quantiles for each of the prediction rasters\n')
for (i in 1:5)
{
	cat('##############',spp.names[i],'##############\n')
	cat('##### NASS ####\n')

	pred <- raster(paste(output.path,spp.names[i],'.nass.v6.tif',sep=''))
	pred <- round(pred,2)
	print(quantile(pred,prob=seq(0,1,0.05),ncells=50000))
	
	cat('##### LandSat ####\n')
	pred <- raster(paste(output.path,spp.names[i],'.landsat.v6b.tif',sep=''))
	pred <- round(pred,2)
	print(quantile(pred,prob=seq(0,1,0.05),ncells=50000))
	# stop('cbw')
}
sink()
