
library(dismo)
drive <- 'd' # 'z'
ver <- 36

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
nass.path <- paste(drive,':/chicago_grasslands/models/',sep='')

load(paste(nass.path,"nass.species.models.v34bbf.rdata",sep=''))

all.var <- NULL

for (i in 1:5)
{
	print(length(nass.models[[i]]$var.names))
	all.var <- c(all.var,nass.models[[i]]$var.names)
	png(paste(nass.path,spp.names[i],'.v34bbf.response.png',sep=''),width=960,height=1200)
	    gbm.plot(nass.models[[i]],write.title = F,plot.layout=c(4,4),cex=2)
	dev.off()
}

temp <- table(all.var)
print(temp[order(temp,decreasing=TRUE)])
