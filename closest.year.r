# function switching to closest available year.

close.yr <- function(x,avail.yrs)
{
	if (x %in% avail.yrs) { return(x) }
	temp <- avail.yrs - x
	temp <- abs(temp)
	position <- match(min(temp),temp)
	# print(position)
	return(avail.yrs[position])
}

# Test code
# output <- close.yr(2007, avail.yrs=c(2003,2005,2009))
# output <- close.yr(1994, avail.yrs=2009)
# print(output)
