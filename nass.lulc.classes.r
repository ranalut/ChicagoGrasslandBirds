
# NASS landcover classes

values <- list(
	c(1,225,226,237), # Corn
	c(5,26,241,254), # Soybean
	c(22:24), # Wheat
	c(2,3,4,6,10:14,21,25,27:35,36,38:39,41:57,58:61,204:210,213,214,216,217,219,222,224,227,229:236,238:240,242:250), # Other crops # c(36,58:61), # alfalfa, clover/wildflowers, switchgrass, fallow/idle cropland
	111, # water
	c(87,195), # herbaceous wetlands
	c(37,171,176,181), # herbaceous grasslands, other hay / non alfalfa, pasture/hay, 
	c(121,122), # developed open space, dev low
	c(123,124), # dev med, dev high
	141, # deciduous forest
	c(63,142,143,152), # other forest and shrub
	190 # woody wetland
	# seq(0,300,1)[-c(36,37,58,60,61,111,121,122,123,124,141,171,181,190,195)] # everything else
	)
# print(nass.var)

assign.class <- function(x,values,nass.var)
{
	if (is.na(x)==TRUE) { return(NA) }
	test <- FALSE
	t <- 1
	while (test==FALSE)
	{
		# print(t)
		test <- x%in%values[[t]]
		output <- nass.var[t]
		t <- t+1
	}
	# print(output)
	# stop('cbw')
	return(output)
}

# n <- assign.class(190,values=values,nass.var=nass.var)
# print(n)
