
julian.hour <- function(x,col.name='TIME') 
{
	temp <- as.integer(strsplit(x[col.name],':')[[1]])
	# print(temp); stop('cbw')
	if(length(temp)<2) { return(24) } 
	else { return(temp[1]+temp[2]/60) }
}
