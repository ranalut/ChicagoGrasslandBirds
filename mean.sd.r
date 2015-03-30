
# Mean and SD

library(raster)
library(SDMTools)
library(Hmisc)
library(sp)

ver <- '36'
the.dir <- paste('d:/chicago_grasslands/models/v',ver,'/',sep='')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
i <- 1

load(file=paste(the.dir,'all.performance.v',ver,'.rdata',sep=''))

# Calculate mean & sd
# for (i in 1)
# {
	file.names <- paste(the.dir,spp.names[i],'.nass.v',ver,letters[1:20],'.tif',sep='')
	temp <- stack(file.names)
	# study.area.1 <- extent(matrix(c(582000,666000,2100000,2150000),ncol=2,byrow=TRUE))
	# temp <- crop(temp,study.area.1)
	pts <- data.frame(x=645252,y=2125772) # (x=646441,y=2120845) # (x=644451,y=2134040) # (x=643602,y=2133972)
	values <- extract(temp,pts)
	print(values)
	
	weights <- test.eval[[i]]$cor
	
	stop('cbw')
	
	# w.mean <- calc(temp,fun=weighted.mean, w=weights)
	# w.mean <- weighted.mean(temp,w=weights)
	w.mean <- wtd.mean(temp,weights=weights, na.rm=FALSE)
	writeRaster(w.mean, paste(the.dir,spp.names[i],'.nass.v',ver,'w.mean.2.tif',sep=''), overwrite=TRUE)
	# stop('cbw')
	
	# cbw.weighted.sd <- function (x, weights = NULL, normwt = FALSE, na.rm = TRUE) 
	# {
		# if (!length(weights)) {
			# if (na.rm) 
				# x <- x[!is.na(x)]
			# return(var(x))
		# }
		# if (na.rm) {
			# s <- !is.na(x + weights)
			# x <- x[s]
			# weights <- weights[s]
		# }
		# if (normwt) 
			# weights <- weights * 1/sum(weights)
		# sw <- sum(weights)
		# xbar <- sum(weights * x)/sw
		# output <- sum(weights * ((x - xbar)^2))/(sw - sum(weights^2)/sw)
		# return(sqrt(output))
	# }

	# w.sd <- calc(temp, fun=cbw.weighted.sd, weights=weights, normwt=TRUE)
	w.sd <- calc(temp, fun=wtd.var, weights=weights, normwt=TRUE, na.rm=FALSE)
	w.sd <- sqrt(w.sd)
	writeRaster(w.sd, paste(the.dir,spp.names[i],'.nass.v',ver,'w.sd.2.tif',sep=''), overwrite=TRUE)
	
	# w.mean <- raster(paste(the.dir,spp.names[i],'.nass.v',ver,'w.mean.tif',sep=''))
	
	w.cv <- w.sd/w.mean
	writeRaster(w.cv, paste(the.dir,spp.names[i],'.nass.v',ver,'w.cv.2.tif',sep=''), overwrite=TRUE)
	
	# low.pred <- min(temp)
	# writeRaster(low.pred, paste(the.dir,spp.names[i],'.nass.v',ver,'min.tif',sep=''))
	
	# high.pred <- max(temp)
	# writeRaster(high.pred, paste(the.dir,spp.names[i],'.nass.v',ver,'max.tif',sep=''))
	
	# range.pred <- range(temp)
	# writeRaster(range.pred, paste(the.dir,spp.names[i],'.nass.v',ver,'range.tif',sep=''))
	
	cat(spp.names[i],'\n')
# }
