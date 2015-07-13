
library(raster)

drive <- 'd' # 'z'
ver <- 36

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
nass.path <- paste(drive,':/chicago_grasslands/models/v',ver,'/',sep='')

nat_area <- raster(paste(drive,':/chicago_grasslands/natural_areas.tif',sep=''))
# plot(nat_area); stop('cbw')

mult <- read.csv("D:/Chicago_Grasslands/MODELS/lm_max_sqrt_ms_raw_origin_0b_model_site_vs_site.csv",header=TRUE,stringsAsFactors=FALSE)
trunc <- read.table("D:/Chicago_Grasslands/MODELS/obs_quantiles.txt",stringsAsFactors=FALSE,skip=1)
colnames(trunc) <- c('spp','X0','X0.02','X0.05','X0.25','X0.5','X0.75','X0.95','X0.98','X1')
top <- trunc[,'X0.98']

output <- as.data.frame(matrix(NA,ncol=5,nrow=20))
colnames(output) <- spp.names

for (j in 1:20)
{
	for (i in 1:5)
	{
		# start <- Sys.time()
		temp <- raster(paste(nass.path,spp.names[i],'.nass.v',ver,letters[j],'.tif',sep=''))
                
        # Mask to natural Areas
        temp <- mask(temp, nat_area)
                
		temp <- as.matrix(temp)
		# Set a minimum cutoff below which we ignore the value assigned to the grid cell.
		# temp[temp < 0.15] <- NA
		
        temp[temp>top[i]] <- top[i] # Reset maximum value to the 98th percentile of observations.
        # plot(temp)
        temp <- temp * mult$slope[i] # Multiply by slope in calibration
        # plot(temp)
        temp <- temp + sqrt(3/8) # Transformation
        # plot(temp)
        temp <- temp^2 # Transformation
        # plot(temp)
        temp <- temp - 3/8
        
        # output[j,i] <- round(sum(temp,na.rm=TRUE) * 0.0509)
        output[j,i] <- round(sum(temp,na.rm=TRUE)) # 
        
		print(output)
		# print(Sys.time()-start)
		# stop('cbw')
	}
}

write.csv(output,paste(nass.path,'pop.est.nass.v',ver,'.cut.nat.areas.cal.csv',sep=''))

load(file=paste(nass.path,'all.performance.v',ver,'.rdata',sep=''))
library(Hmisc)
output2 <- as.data.frame(matrix(NA,ncol=5,nrow=3))
colnames(output2) <- spp.names
rownames(output2) <- c('wt.mean','low','high')

for (i in 1:5)
{
	weights <- test.eval[[i]]$cor
	output2[1,i] <- round(wtd.mean(output[,i],weights=weights, na.rm=FALSE))
	output2[2:3,i] <- round(range(output[,i]))
}

write.csv(output2,paste(nass.path,'median.pop.est.nass.v',ver,'.cut.nat.areas.cal.csv',sep=''))

