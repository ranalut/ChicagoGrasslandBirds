
# Correlations

# 2007-2013 Looking at 100m vs 1000m radius
load(file='d:/chicago_grasslands/models/unique.point.data.v10.rdata') # Check the version.
sink('d:/chicago_grasslands/models/cor.across.years.unique.point.data.v10.txt')

for (i in 1:5)
{
	n <- ifelse(i<5,i+1,1)
	temp <- cor(nass.data[[i]][,17:30],nass.data[[n]][,17:30], use='pair')
	temp <- round(temp,3)
	# temp[abs(temp)<0.5] <- NA
	colnames(temp) <- paste(letters[1:14],1000,sep='')
	cat('\n',2006+i,'\n')
	print(temp)
}
sink()
stop('cbw')


# 2011, looking at patch size.
load(file='d:/chicago_grasslands/models/unique.point.data.v11.rdata')

for (i in 1)
{
	temp <- cor(nass.data[[i]][,3:16],use='pair')
	temp <- round(temp,3)
	# temp[abs(temp)<0.5] <- NA
	colnames(temp) <- c(paste(letters[1:13],1000,sep=''),'patch.cells')
	print(temp)
	write.csv(temp,'d:/chicago_grasslands/models/correlations.unique.point.data.v11.csv')
}

# 2014
load(file='d:/chicago_grasslands/models/unique.point.data.v31.rdata')
model.var <- c("JHOUR","JDATE","lulc","ndvi","corn.dist","soy.dist","water.dist","herb.wetland.dist","grass.hay.dist","dev.low.dist", "dev.high.dist","corn.1000","soy.1000","water.1000","herb.wetland.1000","grass.hay.1000","dev.low.1000", "dev.high.1000","patch.cells","hydro") # v31b

for (i in 8)
{
	the.data <- nass.data[[i]]
	indices <- match(model.var,colnames(the.data))
	temp <- cor(the.data[,indices],use='pair')
	temp <- round(temp,3)
	# temp[abs(temp)<0.5] <- NA
	# colnames(temp) <- model.var # c(paste(letters[1:length(indices)],1000,sep=''),'patch.cells')
	print(temp)
	write.csv(temp,'d:/chicago_grasslands/models/correlations.unique.point.data.v31.csv')
}


