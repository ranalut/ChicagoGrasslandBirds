
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
	evaluation <- model.eval(the.model=nass.models[[i]], covariates=nass.spp.data[[i]][,c(4:5,11:27)], test.rows=test.rows, obs=nass.spp.data[[i]][,6], spp=spp.names[i]) # c(4:5,9:36)
	
	nass.dev.exp.cv[i] <- evaluation[[1]]; nass.dev.exp.test[i] <- evaluation[[2]]
	nass.cor.cv[i] <- evaluation[[3]]; nass.cor.test[i] <- evaluation[[4]]
	cat('end nass',spp.names[i],'############################\n\n')
}

# Landsat models

# landsat.dev.exp.cv <- NA
# landsat.dev.exp.test <- NA
# landsat.cor.cv <- NA
# landsat.cor.test <- NA
	
# for (i in 1:length(landsat.spp.data))
# {
	# evaluation <- model.eval(the.model=landsat.models[[i]], covariates=landsat.spp.data[[i]][,c(4:5,9:20)], test.rows=test.rows, obs=landsat.spp.data[[i]][,6], spp=spp.names[i])
	
	# landsat.dev.exp.cv[i] <- evaluation[[1]]; landsat.dev.exp.test[i] <- evaluation[[2]]
	# landsat.cor.cv[i] <- evaluation[[3]]; landsat.cor.test[i] <- evaluation[[4]]
	# cat('end landsat',spp.names[i],'############################\n\n')
# }

