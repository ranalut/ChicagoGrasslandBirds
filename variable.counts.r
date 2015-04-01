
load("C:/Users/cwilsey/Box Sync/Grassland Bird Project/nass.species.models.v34bbf.rdata")

all.var <- NA

for (i in 1:5)
{
	all.var <- c(all.var,nass.models[[i]]$predictor.names)
}

all.var <- all.var[-1]

print(table(all.var))
