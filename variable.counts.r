
library(dismo)
drive <- 'd' # 'z'
ver <- 36

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
nass.path <- paste(drive,':/chicago_grasslands/models/',sep='')

load(paste(nass.path,"nass.species.models.v34bbf.rdata",sep=''))
source('~/github/chicagograsslandbirds/gbm.plot.cbw2.r')
nass_names <- read.csv('D:/Chicago_Grasslands/nass_classes_lookup.csv',
    stringsAsFactors = FALSE
    )
hydro_names <- read.csv('D:/Chicago_Grasslands/hydro_classes_lookup.csv',
    stringsAsFactors = FALSE
    )

all.var <- NULL

for (i in 1:5)
{
	print(length(nass.models[[i]]$var.names))
	all.var <- c(all.var,nass.models[[i]]$var.names)
	png(paste(nass.path,spp.names[i],'.plot2.v34bbf.response.png',sep=''),width=960,height=1200)
	    # gbm.plot(nass.models[[i]],write.title = F,plot.layout=c(4,4),cex=2)
	    gbm.plot.cbw2(
            gbm.object=nass.models[[i]],
            n.plots=16,
            plot.layout=c(4,4),
            write.title=FALSE,
            cat_var_lookup = list(lulc=nass_names,hydro=hydro_names)
        )
	dev.off()
}

temp <- table(all.var)
print(temp[order(temp,decreasing=TRUE)])
