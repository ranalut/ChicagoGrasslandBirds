
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



