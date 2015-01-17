
# load('z:/chicago_grasslands/models/nass.species.models.v10.rdata')
# load('z:/chicago_grasslands/models/landsat.species.models.v10.rdata')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

# NASS
nass.imp <- as.data.frame(nass.models[[1]][32])
for (i in 2:5)
{
	nass.imp <- merge(nass.imp, as.data.frame(nass.models[[i]][32]), by='contributions.var')
}

colnames(nass.imp) <- c('variable',spp.names)
nass.imp$mean <- apply(nass.imp[,2:6],1,mean)
nass.imp <- nass.imp[order(nass.imp$mean),]

print(nass.imp)
write.csv(nass.imp,'z:/chicago_grasslands/models/nass.models.importance.v10.csv')

# Landsat
landsat.imp <- as.data.frame(landsat.models[[1]][32])
for (i in 2:5)
{
	landsat.imp <- merge(landsat.imp, as.data.frame(landsat.models[[i]][32]), by='contributions.var')
}

colnames(landsat.imp) <- c('variable',spp.names)
landsat.imp$mean <- apply(landsat.imp[,2:6],1,mean)
landsat.imp <- landsat.imp[order(landsat.imp$mean),]

print(landsat.imp)
write.csv(landsat.imp,'z:/chicago_grasslands/models/landsat.models.importance.v10.csv')
