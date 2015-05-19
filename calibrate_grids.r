
library(raster)
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
mult <- read.csv("D:/Chicago_Grasslands/MODELS/lm_max_sqrt_ms_raw_origin_0b_model_site_vs_site.csv",header=TRUE,stringsAsFactors=FALSE)
trunc <- read.table("D:/Chicago_Grasslands/MODELS/obs_quantiles.txt",stringsAsFactors=FALSE,skip=1)
colnames(trunc) <- c('spp','X0','X0.02','X0.05','X0.25','X0.5','X0.75','X0.95','X0.98','X1')
top <- trunc[,'X0.98']

for (i in 1:length(spp.names))
{
    pred <- raster(paste('d:/chicago_grasslands/models/v36/',spp.names[i],'.nass.v36w.mean.2.tif',sep=''))
    plot(pred,main=paste(spp.names[i],'starting map',sep=' '))
    temp <- pred
    temp[temp>top[i]] <- top[i] # Reset maximum value to the 98th percentile of observations.
    # plot(temp)
    temp <- temp * mult$slope[i] # Multiply by slope in calibration
    # plot(temp)
    temp <- temp + sqrt(3/8) # Transformation
    # plot(temp)
    temp <- temp^2 # Transformation
    # plot(temp)
    temp <- temp - 3/8 # Transformation
    # temp <- mask(temp,pred) # Mask to CW
    plot(temp,main=paste(spp.names[i],'end map',sep=' '))
    writeRaster(temp, paste('d:/chicago_grasslands/models/v36/',spp.names[i],'_nass_v36w_mean_2_cal.tif',sep='')) 
    # stop('cbw')
}



