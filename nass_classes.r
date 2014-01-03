
# This showed that there are likely some deprecated classes that are not removed until 2012.  However, it seems that most of those classes do not actually appear in the tiff files we are using.  So, this wasn't as helpful as I'd hoped.

workspace <- 'D:/Chicago_Grasslands/GIS/NASS_layers/'

nass.codes <- list()
years <- seq(2012,2006,-1) # c(2012,2007,2006)
for (i in 1:length(years))
{
	# nass.codes[[i]] <- paste(workspace,'NASS_',years[i],'_classes.csv',sep='')
	nass.codes[[i]] <- read.csv(paste(workspace,'NASS_',years[i],'_classes.csv',sep=''),header=TRUE,stringsAsFactors=FALSE)
	nass.codes[[i]] <- nass.codes[[i]][,c('VALUE','CLASS_NAME')]
	nass.codes[[i]] <- nass.codes[[i]][nass.codes[[i]]$CLASS_NAME!='',]
	colnames(nass.codes[[i]]) <- c(paste('VALUE',years[i],sep=''),'CLASS_NAME')
}

nass2 <- nass.codes[[1]]$CLASS_NAME
for (i in 2:length(years)) { nass2 <- c(nass2, nass.codes[[i]]$CLASS_NAME) }
nass2 <- unique(nass2)
nass2 <- nass2[order(nass2)]
print(nass2)
nass2 <- data.frame(CLASS_NAME=nass2)
for (i in 1:length(years)) { nass2 <- merge(nass2, nass.codes[[i]], by='CLASS_NAME', all=TRUE) }

to.remove <- duplicated(nass2$CLASS_NAME)
nass2 <- nass2[to.remove==FALSE,]
print(nass2)

