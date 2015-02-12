

# load the models, datasets, and train/test
# load()

source('train.test.data.r')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

for (i in 1:5)
{
	train.rows <- drop.test.rows(nass.rows[[i]],test.rows=test.rows)
	temp <- nass.spp.data[[i]][train.rows,]
	temp <- data.frame(temp,residuals=nass.models[[i]]$residuals)
	
	breaks = c(0,500,1000,2500,5000,7500,10000,12500,15000,17500,20000,25000,30000,50000,75000,100000)
	variable <- 'residuals'
	v1 <- variog(coords = temp[,c('POINT_X','POINT_Y')], data = temp[,variable], breaks = breaks)

	v1.summary <- cbind(breaks, v1$v, v1$n)
	colnames(v1.summary) <- c("lag", "semi-variance", "# of pairs")
	print(v1.summary)
	plot(v1, type = "b", main = paste("Variogram: ",variable,' Species:',spp.names[i],sep=''))
	
	temp.s <- SpatialPointsDataFrame(coords=temp[,c('LATITUDE','LONGITUDE')],data=temp)
	# spplot(temp.s[,'residuals'],cuts=10, main=spp.names[i])
	# stop('cbw')
}


