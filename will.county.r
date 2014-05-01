# Will County Data

workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"

will.data <- read.csv(paste(workspace,'CW Grassland Data 2007-2011.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
stop('cbw')
will.data <- will.data[,c('SPECIES_CODE','HOW_MANY_ATLEAST','DATE','TIME','NAME','LATITUDE','LONGITUDE','COUNTY')]
print(dim(will.data)) # print(head(will.data$DATE))
temp <- as.Date(will.data$DATE, format="%m/%d/%Y")
# print(head(temp))
will.data$YEAR <- as.numeric(format(temp, format = "%Y")) 
# print(head(will.data$YEAR)); stop('cbw')
will.data <- will.data[will.data$YEAR %in% seq(2007,2011,1),]
print(dim(will.data))
# Times are not valid.  We will need to assign a time.
# Need to check the range of dates.  Are July dates okay?
# Four letter codes.

unique.will.pts <- aggregate(SPECIES_CODE ~ LATITUDE + LONGITUDE, will.data, length)
print(dim(unique.will.pts)) # print(unique.will.pts)

write.csv(unique.will.pts, paste(workspace,'pts.will.2007-11.csv',sep=''))

