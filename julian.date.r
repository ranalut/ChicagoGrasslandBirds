

julian.table <- function(x,col.name,origin.yr) 
{ 
	# print(x[col.name])
	temp <- as.Date(x[col.name],format="%m/%d/%Y")
	julian(temp, origin = as.Date(paste(origin.yr-1,"-12-31",sep=''))) 
}

