
library(foreign)
workspace <- 'Z:/Chicago_Grasslands/BIRD_DATA/Val/'

pts.ctap <- read.csv(paste(workspace,'pts.ctap_2007-11.csv',sep=''))
pts.lake <- read.csv(paste(workspace,'pts.lake.2007-11.csv',sep=''))
pts.will <- read.csv(paste(workspace,'pts.will.2007-11.csv',sep=''))

all.pts <- as.data.frame(rbind(pts.ctap[,c('LATITUDE','LONGITUDE')],pts.lake[,c('LATITUDE','LONGITUDE')],pts.will[,c('LATITUDE','LONGITUDE')]))

write.csv(all.pts,paste(workspace,'non_bcn_pts_lat_long.csv'),row.names=FALSE)
write.dbf(all.pts,paste(workspace,'non_bcn_pts.dbf'))

# I then loaded and projected the points in ArcGIS to utm 16n and albers equal area.
