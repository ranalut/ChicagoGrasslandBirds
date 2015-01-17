
# Correlations
# load(file='z:/chicago_grasslands/models/unique.point.data.v10.rdata') # Check the version.

for (i in 1:5)
{
	temp <- cor(nass.data[[i]][,3:16],nass.data[[1]][,17:30], use='pair')
	temp <- round(temp,3)
	temp[abs(temp)<0.5] <- NA
	colnames(temp) <- paste(letters[1:14],1000,sep='')
	print(temp)
}




