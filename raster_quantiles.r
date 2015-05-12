
library(raster)

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
sink('D:/Chicago_Grasslands/MODELS/v36/quantiles.txt')
cat('Quantiles',c(0,0.02,0.05,0.25,0.5,0.75,0.95,0.98,1),'\n')
for (i in spp.names)
{
    file_name <- paste('D:/Chicago_Grasslands/MODELS/v36/',i,'.nass.v36w.mean.2.tif',sep='')
    r <- raster(file_name)
    output <- quantile(r,prob=c(0,0.02,0.05,0.25,0.5,0.75,0.95,0.98,1))
    cat(i,round(output,3),'\n')
}
sink()
