
library(raster)
library(SDMTools)

ver <- '36'
the.dir <- paste('d:/chicago_grasslands/models/v',ver,'/',sep='')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

# Consolidate Tables
blank.table <- data.frame(rep=seq(1,20,1),de=rep(NA,20),cor=rep(NA,20))
test.eval <- list(blank.table,blank.table,blank.table,blank.table,blank.table)

for (i in 1:20)
{
	temp <- read.csv(paste(the.dir,'performance.v',ver,letters[i],'.csv',sep=''),header=TRUE,row.names=1)
	for (j in 1:5)
	{
		test.eval[[j]][i,'de'] <- temp[j,3]
		test.eval[[j]][i,'cor'] <- temp[j,4]
	}
}
save(test.eval,file=paste(the.dir,'all.performance.v',ver,'.rdata',sep=''))
# stop('cbw')