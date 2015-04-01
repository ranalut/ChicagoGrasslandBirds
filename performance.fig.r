
load("C:/Users/cwilsey/Box Sync/Grassland Bird Project/all.performance.v36.rdata")
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
medians.de <- NA
medians.cor <- NA

for (i in 1:5)
{
	medians.de[i] <- median(test.eval[[i]]$de)
	medians.cor[i] <- median(test.eval[[i]]$cor)
}

png("C:/Users/cwilsey/Box Sync/Grassland Bird Project/median.de.v36.png",width=960,height=960,pointsize=24)
	barplot(medians.de,main='MEDIAN % DEVIANCE EXPLAINED',names.arg=spp.names)
dev.off()
png("C:/Users/cwilsey/Box Sync/Grassland Bird Project/median.cor.v36.png",width=960,height=960,pointsize=24)
	barplot(medians.cor,main='MEDIAN CORRELATION',names.arg=spp.names)
dev.off()


