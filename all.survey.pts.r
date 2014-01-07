
# This version didn't work.  I wasn't able to export a shapefile created in the sp package so that it lined up with the same points in the ESRI shapefile.  This is something I've struggled with before and will need to figure out eventually.

# Instead, I removed duplicates with the 'delete identical' command in ArcGIS.  This left me with 2117 points.  I then reprojected that file from WGS84 to Albers Equal Area to match the CDL tiffs.  Will work with that points file below...

library(rgdal)
library(raster)
library(sp)

all.data <- read.csv("D:/Chicago_Grasslands/BIRD_DATA/BCN/31qryBreeding_JGS_version.csv", header=TRUE)

# trim observations to those meeting requirements
obs <- all.data[all.data$VALID==1 & 
				all.data$PROTOCOL_ID=="P21" & 
				all.data$DURATION_HRS==0.08 &
				all.data$ALL_OBS_REPORTED==1,]

# Create unique list of count submissions per birder (SUB_ID).  The VALID field lists the number of species submitted for each unique count.  The output includes repeat (annual or more frequent) counts at the same point.
# counts <- aggregate(VALID ~ SUB_ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)
# hist(counts$YEAR, xlab="year", ylab="frequency", main="5-minute point counts by year")
# hist(counts$JDATE, xlab="julian day", ylab="frequency", main="5-minute point counts by day of year")

obs.pts <- SpatialPointsDataFrame(obs,coords=obs[,c('LATITUDE','LONGITUDE')],proj4string=CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'))
test <- obs.pts[1:10,]
writeOGR(obs.pts,'D:/Chicago_Grasslands/BIRD_DATA/BCN','test_unique_pts',driver='ESRI Shapefile') # ,overwrite_layer=TRUE)
stop('cbw')

# +proj=longlat +ellps=WGS84 +no_defs
# +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs
# +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
# +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs

print(dim(obs.pts))
obs.pts <- remove.duplicates(obs.pts) # This takes a long time (30+ minutes)
print(dim(obs.pts))

writeOGR(obs.pts,'D:/Chicago_Grasslands/BIRD_DATA/BCN','unique_pts2',driver='ESRI Shapefile') # ,overwrite_layer=TRUE)

stop('cbw')
