
# Parallel

# Single line call for a loop through predicted models. Must comment out all ver <- XXX lines.
# for (n in letters[1:20]) { ver <- paste('35',n,sep=''); source('settings.r') }

library(raster)
library(dismo)
library(snowfall)
library(Hmisc)

mean.sd.call <- function(x)
{
	i <<- x
	source('mean.sd.r')
}

# set num cpus, i used 14 years, because there were 14 years to process
numCPUs = 5

# stop any existing clusters
sfStop()

# start clusters
sfInit(parallel=TRUE, cpus=numCPUs)
sfLibrary(snowfall)
sfExportAll()

# run the function in parallel
sfLapply(1:5, fun=mean.sd.call)
# sfClusterApplyLB(1:20, fun=settings.call) # Didn't work.

# stop cluster
sfStop()

