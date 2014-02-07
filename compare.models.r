
drive <- 'z' # 'd' # 'z'

setwd(paste(drive,':/github/chicagograsslandbirds/',sep=''))

nass.path <- paste(drive,':/chicago_grasslands/gis/nass_layers/',sep='')
landsat.path <- paste(drive,':/chicago_grasslands/landsat2/',sep='')
output.path <- paste(drive,':/chicago_grasslands/models/',sep='')

for (i in c(5,6,7))
{
	nass <- read.csv(paste(output.path,'nass.performance.v',i,'.csv',sep=''),row.names=1)
	landsat <- read.csv(paste(output.path,'landsat.performance.v',i,'.csv',sep=''),row.names=1)

	compare <- cbind(nass,landsat)
	colnames(compare) <- paste(c('nass','nass','landsat','landsat'),colnames(compare),sep='.')
	
	print(compare)
}

