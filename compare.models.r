
drive <- 'z' # 'd' # 'z'

setwd(paste(drive,':/github/chicagograsslandbirds/',sep=''))

nass.path <- paste(drive,':/chicago_grasslands/gis/nass_layers/',sep='')
landsat.path <- paste(drive,':/chicago_grasslands/landsat2/',sep='')
output.path <- paste(drive,':/chicago_grasslands/models/',sep='')

for (i in 6) # c(5,6,7)
{
	temp <- read.csv(paste(output.path,'performance.v',i,'.csv',sep=''),row.names=1)
	temp <- temp[,c(3,7)] # c(1,3,5,7)
	# print(colnames(temp)); stop('cbw')
	if (i==6) { compare <- temp; next(i) }
	compare <- cbind(compare,rep(NA,dim(compare)[1]))
	compare <- cbind(compare,temp)
	# print(compare)
}

print(compare)
compare <- t(compare)
barplot(compare,beside=TRUE,main='PERFORMANCE COMPARISON',ylim=c(0,0.7), names.arg=c('boboli','sedwre','henspa','easmea','graspa'),legend.text=c('Landcover','Landsat'),ylab='proportion of deviance explained')

# '\nNASS.CV, NASS.TEST, LANDSAT.CV, LANDSAT.TEST'
