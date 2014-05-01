# Lake County Data

workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"

lake.data <- read.csv(paste(workspace,'04302014_ExportForChad.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)

lake.data <- lake.data[,c('SPECIES_CODE','HOW_MANY_ATLEAST','DATE','TIME','NAME','LATITUDE','LONGITUDE','COUNTY')]
print(dim(lake.data)) # print(head(lake.data$DATE))
temp <- as.Date(lake.data$DATE, format="%m/%d/%Y")
# print(head(temp))
lake.data$YEAR <- as.numeric(format(temp, format = "%Y")) 
# print(head(lake.data$YEAR)); stop('cbw')
lake.data <- lake.data[lake.data$YEAR %in% seq(2007,2011,1),]
print(dim(lake.data))
# Times are not valid.  We will need to assign a time.
# Need to check the range of dates.  Are July dates okay?
# Four letter codes.

unique.lake.pts <- aggregate(SPECIES_CODE ~ LATITUDE + LONGITUDE, lake.data, length)
print(dim(unique.lake.pts)) # print(unique.lake.pts)

write.csv(unique.lake.pts, paste(workspace,'pts.lake.2007-11.csv',sep=''))

