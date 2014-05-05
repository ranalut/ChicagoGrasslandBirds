
julian.hour <- function(x,col.name='TIME') 
{
	temp <- as.integer(strsplit(x[col.name],':')[[1]])
	# print(temp); stop('cbw')
	if(length(temp)<2) { return(24) } 
	else { return(temp[1]+temp[2]/60) }
}

julian.hour.2 <- function(x,col.name='TIME') 
{
	temp <- as.character(x[col.name])
	temp <- as.integer(strsplit(temp,'')[[1]])
	temp <- temp[is.na(temp)==FALSE]
	if (length(temp)<3) { return(24) } 
	if (length(temp)==3) 
	{ 
		return(temp[1] +
		as.integer(paste(temp[2],temp[3],sep=''))/60)
	}
	if (length(temp)==4)
	{
		return(
			as.integer(paste(temp[1],temp[2],sep='')) + 
			as.integer(paste(temp[3],temp[4],sep=''))/60
			)
	}
}
