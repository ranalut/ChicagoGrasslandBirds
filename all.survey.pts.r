
library(rgdal)
library(sp)

all.pts <- readOGR(dsn='D:/Chicago_Grasslands/BIRD_DATA/BCN',layer='all_records_jgs_version',encoding='ESRI Shapefile')
print(all.pts) # This works.

# trim observations to those meeting requirements
obs <- all.pts[all.pts$VALID==1 & 
				all.pts$PROTOCOL_I=="P21" & 
				all.pts$DURATION_H==0.08 &
				all.pts$ALL_OBS_RE==1,]

print(obs) # This works.  92898 records.

# test <- obs[1:10,]
# writeOGR(test,'D:/Chicago_Grasslands/BIRD_DATA/BCN','test_pts',driver='ESRI Shapefile') # This looks good.

unique.pts <- remove.duplicates(obs) # This takes a long time (30+ minutes).  ArcGIS is faster.
print(unique.pts)
writeOGR(unique.pts,'D:/Chicago_Grasslands/BIRD_DATA/BCN','unique_pts_wgs84',driver='ESRI Shapefile')

# ===================================================
# Will now reproject unique data points into an Albers equal area projection in ArcGIS.




# ===================================================
# Unused code

# Create unique list of count submissions per birder (SUB_ID).  The VALID field lists the number of species submitted for each unique count.  The output includes repeat (annual or more frequent) counts at the same point.
# counts <- aggregate(VALID ~ SUB_ID + JHOUR + JDATE + YEAR + LATITUDE + LONGITUDE, obs, length)
# hist(counts$YEAR, xlab="year", ylab="frequency", main="5-minute point counts by year")
# hist(counts$JDATE, xlab="julian day", ylab="frequency", main="5-minute point counts by day of year")

# Proj4 projection text
# +proj=longlat +ellps=WGS84 +no_defs
# +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs
# +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
# +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs


