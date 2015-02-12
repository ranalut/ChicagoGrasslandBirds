library(geoR)
library(foreign)
source('rm.na.pts.r')

# pts.table <- read.dbf('d:/chicago_grasslands/bird_data/sedwre.pts.2007-14.albers.dbf',as.is=TRUE)
# dists <- dist(pts.table[,c('POINT_X','POINT_Y')])
# print(summary(dists))
# # stop('cbw')

# # breaks = seq(0, 50000, l = 20)
# breaks = c(0,100,250,500,1000,2500,5000,7500,10000,12500,15000,17500,20000,22500,25000,27500,30000,35000,40000,45000,50000)
# # breaks = seq(0, 50000, l = 20)
# v1 <- variog(coords = pts.table[,c('POINT_X','POINT_Y')], data = pts.table[,'HOW_MANY_A'], breaks = breaks)

# v1.summary <- cbind(breaks, v1$v, v1$n)
# colnames(v1.summary) <- c("lag", "semi-variance", "# of pairs")

# print(v1.summary)

# plot(v1, type = "b", main = "Variogram: SEDWRE")

# # Suggests that semi-variance increases until 30km.  So, 30km is a reasonable distance at which to consider points uncorrelated.  Yikes.  That's high.


# pts.table <- read.dbf('d:/chicago_grasslands/bird_data/sedwre.pts.2007-14.albers.dbf',as.is=TRUE)
# pts.table <- nass.data[[8]] # 2014 dataset, all unique pts.
# dists <- dist(pts.table[,c('POINT_X','POINT_Y')])
# print(summary(dists))
# stop('cbw')

test <- apply(X=pts.table,MAR=1,FUN=rm.na.pts)
pts.table <- pts.table[test==FALSE,]

# breaks = seq(0, 50000, l = 20)
breaks = c(0,500,1000,2500,5000,7500,10000,12500,15000,17500,20000,25000,30000,50000,75000,100000)

# "lulc" "corn.1000" "soy.1000" "wheat.1000" "other.crops.1000" "water.1000" "herb.wetland.1000" "grass.hay.1000"  "dev.low.1000" "dev.high.1000" "decid.wood.1000" "other.wood.1000" "wood.wetland.1000" "patch.cells" "hydro" "drain" "ndvi"
variable <- 'grass.hay.1000'
v1 <- variog(coords = pts.table[,c('POINT_X','POINT_Y')], data = pts.table[,variable], breaks = breaks)

v1.summary <- cbind(breaks[-1], v1$v, v1$n)
colnames(v1.summary) <- c("lag", "semi-variance", "# of pairs")

print(v1.summary)

plot(v1, type = "b", main = paste("Variogram: ",variable,sep=''))

# Suggests that semi-variance increases until 30km.  So, 30km is a reasonable distance at which to consider points uncorrelated.  Yikes.  That's high.


