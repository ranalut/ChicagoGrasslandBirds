library(raster)

setwd('d:/github/chicagograsslandbirds/')

do.data.proc <- 'n' # See processing settings below
do.load.data <- 'n'
do.spp.data <- 	'n'
do.models <- 	'n'
do.prediction <-'y'
do.nass <-		'y'
do.landsat <-	'y'

# Define inputs and file paths
data.yrs <- 2009 # c(2007, 2009)
days <- 156 # c(215,156)
survey.yrs <- c(1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012) # c(2007,2009)
radius <- c(100,500) # c(100, 1000) # c(100,500)
bands <- seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

nass.path <- 'd:/chicago_grasslands/gis/nass_layers/'
landsat.path <- 'd:/chicago_grasslands/landsat2/'
output.path <- 'd:/chicago_grasslands/models/'

# Processing
if (do.data.proc=='y')
{
	years <- c(2007,2009) # seq(2012,2006,-1)
	days <- c(215,156)
	code <- c('01','02')
	bands <- seq(1,7,1)
	folder.names <- paste('lt5023031',years,days,'PAC',code,sep='')
}

# Learning rates for BRTs
lr <- c(0.1,0.1,0.1,0.1,0.1)

# For prediction
pred.year <- data.yrs[length(data.yrs)]
pred.day <- days[length(days)]

study.area.1 <- extent(matrix(c(593000,707000,2043000,2199000),ncol=2,byrow=TRUE)) # Could be wider.
study.area.2 <- extent(matrix(c(350000,461000,4556000,4714000),ncol=2,byrow=TRUE)) # Could be wider.

# ===============================================================
# Step 1: Data Processing 
if (do.data.proc=='y')
{
	radius <- 1000
	# Processing NASS data layers to extract percent cover measures at multiple spatial scales:
	source('focal.proportions.r')
	
	# Processing Landsat data layers to extract mean band values at multiple spatial scales:
	source('landsat.focal.mean.r')
	
	# Atmospheric correction of landsat imagery and cloud extraction
	# source('landsat.processing.r')
}
# =================================================================
# Step 2: Load Data 
# Creates spatial points objects for the unique survey points in the BCN dataset and extracts data from the nass and landsat datasets, assembled a raster stacks.  Output is saves as .csv files in /Models/ folder and as an R workspace.
if (do.load.data=='y')
{
	source('load.data.r') 
	
	# save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v1.rdata',sep='')) # 2007 & 2009
	# save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v2.rdata',sep='')) # 2009
	save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v3.rdata',sep='')) # 2009 radius 100 & 1000
}
# ===============================================================
# Step 3: Extract Species Data 
# Generate datasets for each individual species pulling data for each survey from it's respective year in the multi-year dataset.
if (do.spp.data=='y')
{
	# load(file=paste(output.path,'unique.point.data.v3.rdata',sep='')) # Check Step 2 for versions.
	
	source('species.data.r') 
	
	# Version 1: 2007, 2009
	# Version 2: 2009 data with all survey years, radius 100, 500
	# Version 3: 2009 data with all survey years, radius 100, 1000
	save(nass.spp.data,landsat.spp.data,file=paste(output.path,'species.data.v3.rdata',sep='')) 
}
# ===============================================================
# Step 4: Build Models 
# Now, we will build BRT models for individual species...
if (do.models=='y')
{
	# load(file=paste(output.path,'species.data.v1.rdata',sep='')) # 2007 and 2009
	# load(file=paste(output.path,'species.data.v2.rdata',sep='')) # 2009
	load(file=paste(output.path,'species.data.v3.rdata',sep='')) # 2009, radius 100, 1000
	
	source('brt.models.r')
	
	# save(nass.models, landsat.models, file=paste(output.path,'species.models.v2.rdata',sep='')) # Version 1 are full models with 2007 & 2009 data
	# save(nass.models, landsat.models, file=paste(output.path,'species.models.v3.rdata',sep='')) # Version 3 are models w/o JDATE and JHOUR 
	
	# Version 2 are based on 2009 data
	# Version 4 based on 2009 data, 100 and 1000 radius
	if (do.nass=='y') { save(nass.models, file=paste(output.path,'nass.species.models.v4.rdata',sep='')) } 
	if (do.landsat=='y') { save(landsat.models, file=paste(output.path,'landsat.species.models.v4.rdata',sep='')) } 
}

# ================================================================

# All this is set up to fix my mistake from last week.  Reprinting outputs that I accidently overwrote.

# Step 5: Prediction 
if (do.prediction=='y')
{
	source('load.prediction.data.r')
	# Version 1 is uncropped, Version 2 is cropped, Version 3 is larger
	# Version 4 is larger for Landsat, extends further west.
	save(nass.pred.data, landsat.pred.data, file=paste(output.path,'pred.data.v3.rdata',sep='')) # This may reference temporary files and thus may not really be savable.
	# stop('cbw')

	# Load models - each object is a list of models, one for each species.
	# load(file=paste(output.path,'pred.data.v3.rdata',sep='')) # Check version above under Build Models
	if (do.nass=='y') { load(file=paste(output.path,'nass.species.models.v2.rdata',sep='')) } 
	if (do.landsat=='y') { load(file=paste(output.path,'landsat.species.models.v2.rdata',sep='')) }
	
	source('model.prediction.r') # Be sure to change the file output names
	
	# Version 2 is all survey years, 2009 imagery, 100, 500 radius
	# Version 3 is all survey years, 2009 imagery, 100, 1000 radius
	if (do.nass=='y') { save(nass.pred, file=paste(output.path,'nass.pred.v2.rdata',sep='')) } # All survey yrs, 2009 imagery
	if (do.landsat=='y') { save(landsat.pred, file=paste(output.path,'landsat.pred.v2.rdata',sep='')) } # All survey yrs, 2009 imagery
}
