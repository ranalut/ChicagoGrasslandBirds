
load("C:/Users/cwilsey/Box Sync/Grassland Bird Project/all.performance.v36.rdata")
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
medians.de <- NA
medians.cor <- NA

for (i in 1:5)
{
	medians.de[i] <- median(test.eval[[i]]$de)
	medians.cor[i] <- median(test.eval[[i]]$cor)
}

png("C:/Users/cwilsey/Box Sync/Grassland Bird Project/median.de.v36.png",width=960,height=960,pointsize=36)
	par(mar=c(2,3,2,0.5))
	barplot(medians.de,main='MEDIAN % DEVIANCE EXPLAINED',names.arg=spp.names)
dev.off()
png("C:/Users/cwilsey/Box Sync/Grassland Bird Project/median.cor.v36.png",width=960,height=960,pointsize=36)
	par(mar=c(2,3,2,0.5))
	barplot(medians.cor,main='MEDIAN CORRELATION',names.arg=spp.names)
dev.off()

png("C:/Users/cwilsey/Box Sync/Grassland Bird Project/median.prev.v36.png",width=960,height=960,pointsize=36)
	par(mar=c(4,4,2,0.5))
	plot(medians.cor~c(0.17,0.09,0.12,0.24,0.13),main='PERFORMANCE VS. PREVALENCE',ylab='MEDIAN CORRELATION',xlab='PREVALENCE',pch=19)
dev.off()

