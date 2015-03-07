
# Build BRT models using NASS and Landsat Data.
library(dismo)
library(gbm)
library(tcltk2)

# source('settings.r')

# NASS models

nass.dev.exp.cv <- NA
nass.dev.exp.test <- NA
nass.cor.cv <- NA
nass.cor.test <- NA

for (i in 1:length(nass.spp.data))
{
	if (do.final=='y') { indices <- nass.step[[i]]$pred.list[[drops[i]]] }
	else { indices <- match(model.var[[i]],colnames(the.data)) }
	evaluation <- model.eval(the.model=nass.models[[i]], covariates=nass.spp.data[[i]][,indices], test.rows=test.rows[[i]], obs=nass.spp.data[[i]][,9], spp=spp.names[i])
	
	nass.dev.exp.cv[i] <- evaluation[[1]]; nass.dev.exp.test[i] <- evaluation[[2]]
	nass.cor.cv[i] <- evaluation[[3]]; nass.cor.test[i] <- evaluation[[4]]
	sink(paste(output.path,'nass.thresh.v',ver,'.txt',sep=''),append=TRUE)
		cat(spp.names[i],'threshold =',evaluation[[5]],'\n')
	sink()
	cat('end nass',spp.names[i],'############################\n\n')
}
