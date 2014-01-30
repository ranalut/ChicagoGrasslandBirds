
fxn1 <- function(x,y)
{
	value <- rep(1,length(x))
	test.x <- is.na(x)
	test.y <- is.na(y)
	test <- test.x + test.y
	value[test==2] <- NA 
	return(value)
}

fxn1(NA,1); fxn1(1,1); fxn1(NA,NA)

fxn2 <- function(x,groups)
{
	value <- rep(1,length(x))
	test <- x %in% groups
	value[test==FALSE] <- NA
	return(value)
}

fxn2(2,groups=c(1,2,3))
fxn2(10,groups=c(1,2,3))

