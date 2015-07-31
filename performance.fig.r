
load("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/all.performance.v36.rdata")
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
medians.de <- NA
medians.cor <- NA
de.only <- list()
cor.only <- list()

for (i in 1:5)
{
	medians.de[i] <- median(test.eval[[i]]$de)
	medians.cor[i] <- median(test.eval[[i]]$cor)
  de.only[[i]] <- test.eval[[i]]$de
  cor.only[[i]] <- test.eval[[i]]$cor
}

png("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/median.de.v36.png",width=960,height=960,pointsize=36)
	par(mar=c(2,3,2,0.5))
	barplot(medians.de,main='MEDIAN % DEVIANCE EXPLAINED',names.arg=spp.names)
dev.off()

png("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/median.cor.v36.png",width=960,height=960,pointsize=36)
	par(mar=c(2,3,2,0.5))
	barplot(medians.cor,main='MEDIAN CORRELATION',names.arg=spp.names)
dev.off()

lm1 <- lm(medians.cor~c(0.17,0.09,0.12,0.24,0.13))
print(lm1)
print(summary(lm1))
# plot(lm1)

prev <- c(0.17, 0.09, 0.12, 0.24, 0.13)
prev2 <- rep(prev,each=20)

lm2 <- lm(unlist(cor.only)~prev2)
print(lm2)
print(summary(lm2))
# plot(lm2)

png("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/median.prev2.v36.png",width=960,height=960,pointsize=32)
	par(mar=c(4,4,0.5,0.25))
	plot(unlist(cor.only)~prev2,ylab='CORRELATION',xlab='PREVALENCE',pch=1) # main='PERFORMANCE VS. PREVALENCE',
  points(medians.cor~prev,pch=19)
  abline(coefficients(lm2)[1],coefficients(lm2)[2])
  text(x=c(0.17,0.09,0.13),y=medians.cor[c(1:2,5)],labels=spp.names[c(1:2,5)], pos=4, offset=0.3)
  text(x=c(0.12,0.24),y=medians.cor[3:4],labels=spp.names[3:4], pos=2, offset=0.3)
dev.off()

png("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boxplot.de.v36.png",width=960,height=960,pointsize=32)
par(mar=c(2,4,0.25,0.25))
boxplot(de.only,ylab='DEVIANCE EXPLAINED',names=spp.names)
dev.off()

png("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boxplot.cor.v36.png",width=960,height=960,pointsize=32)
par(mar=c(2,4,0.5,0.25))
boxplot(cor.only,ylab='CORRELATION',names=spp.names)
dev.off()


