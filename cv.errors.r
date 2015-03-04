# cv.errors
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
ver <- 33
tables <- list()
dev.exp <- list()
correlate <- list()

for (i in 1:10)
{
	tables[[i]] <- read.csv(paste('d:/chicago_grasslands/models/performance.v',ver,'.',i,'.csv',sep=''),header=TRUE,row.names=1)[,3:4]
	
	for (j in 1:5)
	{
		if (i==1)
		{
			dev.exp[[j]] <- tables[[i]][j,1]
			correlate[[j]] <- tables[[i]][j,2]
		}
		dev.exp[[j]] <- c(dev.exp[[j]],tables[[i]][j,1])
		correlate[[j]] <- c(correlate[[j]],tables[[i]][j,2])
	}
}
names(dev.exp) <- spp.names
names(correlate) <- spp.names

png(paste('d:/chicago_grasslands/models/dev.exp.v',ver,'.png',sep=''))
	boxplot(dev.exp,main='DEVIANCE IN PREDICTED AND OBSERVED\nABUNDANCE EXPLAINED IN INDEPENDENT TEST DATA')
dev.off()
png(paste('d:/chicago_grasslands/models/corr.v',ver,'.png',sep=''))
	boxplot(correlate,main='CORRELATION BETWEEN PREDICTED AND OBSERVED\nABUNDANCE IN INDEPENDENT TEST DATA')
dev.off()
