
# Parallel

# Single line call for a loop through predicted models. Must comment out all ver <- XXX lines.
# for (n in letters[1:20]) { ver <- paste('35',n,sep=''); source('settings.r') }

library(raster)
library(dismo)
library(snowfall)

settings.call <- function(x)
{
	ver <<- paste('36',letters[x],sep='') # x
	# sfExportAll()
	source('settings.r')
}

# Load fxns
source('train.test.data.r')
source('deviance.explained.r')
source('model.eval.fxn.r')
	
# set num cpus, i used 14 years, because there were 14 years to process
numCPUs = 10

# stop any existing clusters
sfStop()

# start clusters
sfInit(parallel=TRUE, cpus=numCPUs)
sfLibrary(snowfall)
sfExportAll()

# run the function in parallel
# 'd','h','j','p','r','t' # re-running a few that didn't come out.
sfLapply(1:20, fun=settings.call)
# sfLapply(c(4,8,10,16,18,20), fun=settings.call)
# sfClusterApplyLB(1:20, fun=settings.call) # Didn't work.

# stop cluster
sfStop()

