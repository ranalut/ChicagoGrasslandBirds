# Lake County Data

workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"
source('julian.hour.r')
julian.table <- function(x) { julian(as.Date(x['DATE'],format="%m/%d/%Y"), origin = as.Date(paste(x['YEAR'],"-01-01",sep=''))) }

lake.data <- read.csv(paste(workspace,'04302014_ExportForChad.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)

lake.data <- lake.data[,c('SPECIES_CODE','HOW_MANY_ATLEAST','DATE','TIME','NAME','LATITUDE','LONGITUDE','COUNTY')]
print(dim(lake.data)) # print(head(lake.data$DATE))
temp <- as.Date(lake.data$DATE, format="%m/%d/%Y")
lake.data$YEAR <- as.numeric(format(temp, format = "%Y")) 
lake.data$JDATE <- apply(lake.data, 1, julian.table)
lake.data$JHOUR <- apply(lake.data, 1, julian.hour) # rep(7,dim(lake.data)[1])
lake.data <- lake.data[lake.data$YEAR %in% seq(2007,2011,1),]
print(dim(lake.data))

lake.spp <- c('BOBO','EAME','GRSP','HESP','SEWR')
eBird.spp <- c('boboli','easmea','graspa','henspa','sedwre')
for (i in 1:length(lake.spp))
{
	lake.data$SPECIES_CODE <- gsub(pattern=lake.spp[i], replacement=eBird.spp[i], x=lake.data$SPECIES_CODE)
}

unique.lake.pts <- aggregate(SPECIES_CODE ~ LATITUDE + LONGITUDE, lake.data, length)
print(dim(unique.lake.pts)) # print(unique.lake.pts)

write.csv(unique.lake.pts, paste(workspace,'pts.lake.2007-11.csv',sep=''))

lake.data <- lake.data[lake.data$SPECIES_CODE %in% eBird.spp,]
print(dim(lake.data))
write.csv(lake.data, paste(workspace,'lake.county.2007-2011.csv',sep=''))
