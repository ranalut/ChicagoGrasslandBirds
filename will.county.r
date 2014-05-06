# Will County Data

# workspace <- "C:/Users/cwilsey/Dropbox/Grassland Bird Project/"
workspace <- 'z:/chicago_grasslands/bird_data/val/'

source('julian.hour.r')
to.dd <- function(x) { return(x[1] + x[2]/60 + x[3]/3600) }
julian.table <- function(x) { julian(as.Date(x['DATE2']), origin = as.Date(paste(x['YEAR'],"-01-01",sep=''))) }

will.pts <- read.csv(paste(workspace,"pts CW 2007-2011 Bird Data_with survey times.csv",sep=''),header=TRUE, stringsAsFactors=FALSE)
will.pts$LATITUDE <- apply(will.pts[,4:6],1,to.dd)
will.pts$LONGITUDE <- -1*apply(will.pts[,7:9],1,to.dd)

will.data <- read.csv(paste(workspace,'CW 2007-2011 Bird Data_with survey times.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
will.data <- merge(will.data,will.pts[,c('POINT','LATITUDE','LONGITUDE')])
print(dim(will.data))
# print(colnames(will.data)); print(head(will.data)); stop('cbw')

will.data.2 <- data.frame(matrix(rep(NA,9),ncol=9))
colnames(will.data.2) <- c('POINT','SITE','DATE','YEAR','TIME','LATITUDE','LONGITUDE','SPECIES_CODE','HOW_MANY_ATLEAST')
ebird.names <- c('boboli','easmea','graspa','henspa','sedwre')
will.names <- c('BOBO','EAME','GRSP','HESP','SEWR')

for (i in seq(1,dim(will.data)[1],1))
{
	for (j in 1:5)
	{
		temp <- c(will.data[i,c('POINT','SITE','DATE','YEAR','TIME','LATITUDE','LONGITUDE')],ebird.names[j],will.data[i,will.names[j]]); print(temp)
		names(temp) <- c('POINT','SITE','DATE','YEAR','TIME','LATITUDE','LONGITUDE','SPECIES_CODE','HOW_MANY_ATLEAST')
		will.data.2 <- rbind(will.data.2,temp)
	}
	# print(will.data.2); stop('cbw')
}
will.data.2 <- will.data.2[-1,]
will.data.2$DATE2 <- paste(0,will.data.2$DATE,will.data.2$YEAR,sep='')
will.data.2$DATE2 <- as.Date(will.data.2$DATE2,format="%m%d%Y")
will.data.2$JDATE <- apply(will.data.2, 1, julian.table)
will.data.2$JHOUR <- round(apply(will.data.2, 1, julian.hour.2),2) # rep(7,dim(lake.data)[1])
print(dim(will.data.2))
print(head(will.data.2))
write.csv(will.data.2, paste(workspace,'will.county.2007-2011.csv',sep=''))
# stop('cbw')

unique.will.pts <- aggregate(SPECIES_CODE ~ LATITUDE + LONGITUDE, will.data.2, length)
print(dim(unique.will.pts)) # print(unique.will.pts)
write.csv(unique.will.pts, paste(workspace,'pts.will.2007-11.csv',sep=''))

