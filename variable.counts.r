
library(dismo)
drive <- 'd' # 'z'
ver <- 36

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
nass.path <- paste(drive,':/chicago_grasslands/models/',sep='')

load(paste(nass.path,"nass.species.models.v34bbf.rdata",sep=''))

all.var <- NA

for (i in 1:5)
{
	print(length(nass.models[[i]]$var.names))
	all.var <- c(all.var,nass.models[[i]]$var.names)
}

all.var <- all.var[-1]
temp <- table(all.var)
print(temp[order(temp,decreasing=TRUE)])
