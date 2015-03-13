
# Mean and SD

library(raster)
library(SDMTools)

ver <- '36'
the.dir <- paste('d:/chicago_grasslands/models/v',ver,'/',sep='')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

# Consolidate Tables
blank.table <- data.frame(rep=seq(1,20,1),de=rep(NA,20),cor=rep(NA,20))
test.eval <- list(blank.table,blank.table,blank.table,blank.table,blank.table)

for (i in 1:20)
{
	temp <- read.csv(paste(the.dir,'performance.v',ver,letters[i],'.csv',sep=''),header=TRUE,row.names=1)
	for (j in 1:5)
	{
		test.eval[[j]][i,'de'] <- temp[j,3]
		test.eval[[j]][i,'cor'] <- temp[j,4]
	}
}
save(test.eval,file=paste(the.dir,'all.performance.v',ver,'.rdata',sep=''))
# stop('cbw')

# Calculate mean & sd
for (i in 1)
{
	file.names <- paste(the.dir,spp.names[i],'.nass.v',ver,letters[1:20],'.tif',sep='')
	temp <- stack(file.names)
	
	weights <- test.eval[[i]]$cor
	
	# w.mean <- calc(temp,fun=weighted.mean, w=weights)
	# w.mean <- weighted.mean(temp,w=weights)
	# writeRaster(w.mean, paste(the.dir,spp.names[i],'.nass.v',ver,'w.mean.tif',sep=''))
	# stop('cbw')
	
	# cbw.weighted.sd <- function (x, wt, na.rm=FALSE) 
	# {
		# test <- sum(is.na(x))
		# if (test>0 & na.rm==FALSE) { return(NA) }
		# # s = which(is.finite(x + wt))
		# # wt = wt[s]
		# # x = x[s]
		# xbar = weighted.mean(x, w=wt)
		# return(sum(wt * (x - xbar)^2) * (sum(wt)/(sum(wt)^2 - sum(wt^2))))
	# }
	
	cbw.weighted.sd <- function (x, weights = NULL, normwt = FALSE, na.rm = TRUE) 
	{
		if (!length(weights)) {
			if (na.rm) 
				x <- x[!is.na(x)]
			return(var(x))
		}
		if (na.rm) {
			s <- !is.na(x + weights)
			x <- x[s]
			weights <- weights[s]
		}
		if (normwt) 
			weights <- weights * 1/sum(weights)
		sw <- sum(weights)
		xbar <- sum(weights * x)/sw
		output <- sum(weights * ((x - xbar)^2))/(sw - sum(weights^2)/sw)
		return(sqrt(output))
	}

	w.sd <- calc(temp, fun=cbw.weighted.sd, weights=weights, normwt=TRUE)
	writeRaster(w.sd, paste(the.dir,spp.names[i],'.nass.v',ver,'w.sd.tif',sep=''))
	
	# w.cv <- w.sd/w.mean
	# writeRaster(w.sd, paste(the.dir,spp.names[i],'.nass.v',ver,'w.cv.tif',sep=''))
	
	cat(spp.names[i],'\n')
}
