library(raster)

drive <- 'z' # 'd' # 'z'

setwd(paste(drive,':/github/chicagograsslandbirds/',sep=''))

nass.path <- paste(drive,':/chicago_grasslands/gis/nass_layers/',sep='')
landsat.path <- paste(drive,':/chicago_grasslands/landsat2/',sep='')
output.path <- paste(drive,':/chicago_grasslands/models/',sep='')

do.data.proc <- 'n' # See processing settings below.  Remove clouds (landsat.processing.r) before running.
do.load.data <- 'n'
do.spp.data <- 	'y'
do.test.data <- 'n' # Be sure not to overwrite if you turn this on.
do.models <- 	'n'
do.prediction <-'n'
do.nass <-		'n'
do.landsat <-	'n'

# Define inputs and file paths
data.yrs <- c(2007,2008,2009,2010,2011) # 2006 # 2009 # c(2007, 2009)
days <- c(167,170,156,175,194) # 164 # 156 # c(215,156)
survey.yrs <- data.yrs # c(1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012) # c(2007,2009)
radius <- c(100,1000) # c(100,500,1000) # c(100, 1000) # c(100,500)
bands <- c(1:5,7) # c(7,5) # seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

# Processing
if (do.data.proc=='y')
{
	years <- 2008 # c(2006,2007,2009,2010,2011) # c(2007,2009) # seq(2012,2006,-1)
	days <- 170 # c(164,167,156,175,194) # c(215,156)
	code <- 'PAC01' # c('PAC01','PAC01','PAC02','EDC00','PAC01')
	# bands <- c(1:5,7) # seq(1,7,1)
	folder.names <- paste('lt5023031',years,days,code,sep='')
}

# Learning rates for BRTs
lr <- c(0.1,0.005,0.01,0.01,0.01)

# For prediction
pred.year <- data.yrs[length(data.yrs)]
pred.day <- days[length(days)]

study.area.1 <- extent(matrix(c(593000,707000,2043000,2199000),ncol=2,byrow=TRUE))
study.area.2 <- extent(matrix(c(345000,470000,4540000,4720000),ncol=2,byrow=TRUE))

# ===============================================================
# Data Processing 
if (do.data.proc=='y')
{
	# radius <- c(1000)
	# Processing NASS data layers to extract percent cover measures at multiple spatial scales:
	source('focal.proportions.r')
	
	# Processing Landsat data layers to extract mean band values at multiple spatial scales:
	# source('focal.mean.fxns.r')
	# source('landsat.focal.mean.r')
	
	# Atmospheric correction of landsat imagery and cloud extraction
	# Run this independently with a source command setting up this file to reflect your file structure/names.
	# # source('landsat.processing.r')
}
# =================================================================
# Load Data 
# Creates spatial points objects for the unique survey points in the BCN dataset
if (do.load.data=='y')
{
	source('load.data.r') 
	
	# Version 1: 2007 & 2009
	# Version 2: 2009 with all yrs
	# Version 3 2009, all yrs, radius 100 & 1000
	# Version 4: 2007:2011, 100, 500 radius, cloudless
	# Version 5: 2007:2011, 100, 1000 radius, cloudless
	save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v5.rdata',sep=''))
}
# ===============================================================
# Extract Species Data 
# Generate datasets for each individual species pulling data for each survey year.
if (do.spp.data=='y')
{
	load(file=paste(output.path,'unique.point.data.v5.rdata',sep='')) # Check Step 2 for versions.
	
	source('species.data.r') 
	
	# Version 1: 2007, 2009
	# Version 2: 2009 data with all survey years, radius 100, 500
	# Version 3: 2009 data with all survey years, radius 100, 1000
	# Version 4: 2007:2011, 100, 500 radius, cloudless
	# Version 5: 2007:2011, 100, 1000 radius, cloudless
	save(nass.spp.data,landsat.spp.data,nass.rows,landsat.rows,file=paste(output.path,'species.data.v5.rdata',sep='')) 
}
# ===============================================================
# Test Data
if (do.test.data=='y')
{
	source('train.test.data.r')
	load(file=paste(output.path,'species.data.v4.rdata',sep='')) # Could be any data
	create.test.data(row.numbers=landsat.rows[[1]], proportion=0.2, file.name=paste(output.path,'test.rows.v1.txt',sep=''))
}
# ===============================================================
# Build Models 
if (do.models=='y')
{
	# See above for versions.
	load(file=paste(output.path,'species.data.v4.rdata',sep=''))
	test.rows <- scan(file=paste(output.path,'test.rows.v1.txt',sep=''),what=numeric())
	
	source('train.test.data.r')
	source('deviance.explained.r')
	source('brt.models.r')
	
	# Version 2 are based on 2009 data
	# Version 4 based on 2009 data, 100 and 1000 radius
	# Version 5 2007:2011; 100, 500 radius; cloudless
	# Version 6 2007:2011; 100, 1000 radius; cloudless
	if (do.nass=='y') { save(nass.models, nass.dev.exp.cv, nass.dev.exp.test, file=paste(output.path,'nass.species.models.v5.rdata',sep='')); write.csv(data.frame(cv=nass.dev.exp.cv,test=nass.dev.exp.test),paste(output.path,'nass.performance.v5.csv',sep='')) } 
	if (do.landsat=='y') { save(landsat.models, landsat.dev.exp.cv, landsat.dev.exp.test, file=paste(output.path,'landsat.species.models.v5.rdata',sep='')); write.csv(data.frame(cv=landsat.dev.exp.cv,test=landsat.dev.exp.test),paste(output.path,'landsat.performance.v5.csv',sep='')) } 
}

# ================================================================
# Prediction 
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
