library(raster)

drive <- 'd' # 'z'

# setwd(paste(drive,':/github/chicagograsslandbirds/',sep=''))

# nass.path <- paste(drive,':/chicago_grasslands/gis/nass_layers/',sep='')
nass.path <- paste(drive,':/chicago_grasslands/nass2/updated_cdl_2014/',sep='')
ndvi.path <- paste(drive,':/chicago_grasslands/ndvi/',sep='')
soil.path <- paste(drive,':/chicago_grasslands/soil/',sep='')
# landsat.path <- paste(drive,':/chicago_grasslands/landsat2/',sep='')
output.path <- paste(drive,':/chicago_grasslands/models/',sep='')

do.data.proc <- 'n' # See processing settings below.  Remove clouds (landsat.processing.r) before running.
do.load.data <- 'n'
do.spp.data <- 	'n'
do.test.data <- 'n' # DO NOT OVERWRITE. Change output name below if turned on.
do.models <- 	'n'
do.eval <- 		'n'
do.prediction <-'y'
do.nass <-		'y'
do.landsat <-	'n'
do.kd <- 		'n'

# Define inputs and file paths
radius <- 1000 # c(100,1000) # c(100,500,1000) # c(100, 1000) # c(100,500)
data.yrs <- c(2007,2008,2009,2010,2011,2012,2013,2014) # c(2012,2013) # c(2007,2008,2009,2010,2011) # c(2007,2008,2009,2010,2011) # 2006 # 2009 # c(2007, 2009)
# days <- c(167,170,156,175,194) # c(156,175,194) # c(167,170,156,175,194) # 164 # 156 # c(215,156)
survey.yrs <- data.yrs # c(1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012) # c(2007,2009)
# bands <- c(1:5,7) # c(7,5) # seq(1,7,1)
nass.var <- c('corn','soy','wheat','other.crops','water','herb.wetland','grass.hay','dev.low','dev.high','decid.wood','other.wood','wood.wetland') # ,'alfalfa.etc','other') # remove errant other class that included grasslands.
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

# For single year or single radius processing
if (do.data.proc=='y')
{
	years <- data.yrs # 2008 # c(2006,2007,2009,2010,2011) # c(2007,2009) # seq(2012,2006,-1)
	# days <- 170 # c(164,167,156,175,194) # c(215,156)
	# code <- 'PAC01' # c('PAC01','PAC01','PAC02','EDC00','PAC01')
	# bands <- c(1:5,7) # seq(1,7,1)
	# folder.names <- paste('lt5023031',years,days,code,sep='')
}

# Learning rates for BRTs
# lr <- c(0.1,0.005,0.01,0.01,0.01)
lr <- c(0.01,0.0005,0.001,0.01,0.0005)

# For prediction
# Prediction for Landcover is based on 2011.  Prediction for landsat is based on the 5-yr average ('XX').
pred.year <- 2014 # '20XX' # 2010 # data.yrs[length(data.yrs)] '20XX' is based on mean for all years.  '20YY' is based on mean for last 3 years (2009-11). 5-yr average makes the most sense (notes 2/19/14).
# pred.day <- 194 # 'XXX' # 'YYY' # '175' # days[length(days)]

study.area.1 <- extent(matrix(c(593000,707000,2043000,2199000),ncol=2,byrow=TRUE))
# study.area.2 <- extent(matrix(c(345000,470000,4540000,4720000),ncol=2,byrow=TRUE))

# ===============================================================
# Data Processing 
if (do.data.proc=='y')
{
	radius <- 1000
	# Processing NASS data layers to extract percent cover measures at multiple spatial scales:
	# source('calc.focal.prop.r')
	# source('focal.proportions.r')
	
	source('calc.distances.r')
	source('distances.r')
	
	# source('calc.patch.r')
	# source('patch.size.r')
	
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
	# Process other data types
	# source('ctap.data.r')
	# source('lake.county.r')
	# source('will.county.r')
	# Use ArcGIS to merge and export unique points to albers equal area and utm z16n projections.
	
	source('load.data.r') 
	
	# Version 1: 2007 & 2009
	# Version 2: 2009 with all yrs
	# Version 3 2009, all yrs, radius 100 & 1000
	# Version 4: 2007:2011, 100, 500 radius, cloudless
	# Version 5: 2007:2011, 100, 1000 radius, cloudless
	# Version 6: 2007:2011, 500, 1000 radius, cloudless
	# Version 10: 2007:2011, 100, 1000 radius, cloudless, non-BCN data added
	# Version 11: 2011, 1000, LULC only
	# Version 20: 2007:2014, LULC, Soils, Patch, NDVI
	# Version 30: 2007:2014, LULC, Soils, Patch, NDVI, distance
	# Version 31: 2007:2014, LULC, Soils, Patch, NDVI, distance <1000m
	# save(nass.data,landsat.data,file=paste(output.path,'unique.point.data.v10.rdata',sep=''))
	save(nass.data,file=paste(output.path,'unique.point.data.v31.rdata',sep=''))
}
# ===============================================================
# Extract Species Data 
# Generate datasets for each individual species pulling data for each survey year.
if (do.spp.data=='y')
{
	load(file=paste(output.path,'unique.point.data.v31.rdata',sep='')) # Check above for versions.
	
	count.file <- 'spp.pres.abs.v31.txt'
	source('species.data.r') 
	
	# Version 1: 2007, 2009
	# Version 2: 2009 data with all survey years, radius 100, 500
	# Version 3: 2009 data with all survey years, radius 100, 1000
	# Version 4: 2007:2011, 100, 500 radius, cloudless
	# Version 5: 2007:2011, 100, 1000 radius, cloudless
	# Version 6: 2007:2011, 500, 1000 radius, cloudless
	# Version 10: 2007:2011, 100, 1000 radius, cloudless, non-BCN data added
	# Version 20: 2007:2014, LULC, Soils, Patch, NDVI
	# Version 21: 2007:2014, LULC, Soils, Patch, NDVI, max obs per 56m cell
	# Version 30: 2007:2014, LULC, Soils, Patch, NDVI, distance, max obs per 56m cell
	# Version 31: 2007:2014, LULC, Soils, Patch, NDVI, distance <1000m, max obs per 56m cell (31b) add uninformative variable (e) matches with model letter below.
	# save(nass.spp.data,landsat.spp.data,nass.rows,landsat.rows,file=paste(output.path, 'species.data.v10.rdata',sep='')) 
	save(nass.spp.data,nass.rows,file=paste(output.path,'species.data.v31e.rdata',sep=''))
}
# ===============================================================
# Test Data
if (do.test.data=='y')
{
	source('train.test.data.r')
	source('gridSample.max.r')
	load(file=paste(output.path,'species.data.v31e.rdata',sep='')) # Could be any data
	# create.test.data(row.numbers=nass.rows[[1]], proportion=0.2, file.name=paste(output.path,'test.rows.v21.txt',sep=''))
		
	# source('train.test.data.r')
	# load(file=paste(output.path,'species.data.v21.rdata',sep='')) # Could be any data
	grid.5010 <- raster('d:/chicago_grasslands/nass2/updated_cdl_2014/grid.5010m.tif')
	# stop('cbw')
	temp <- nass.spp.data[[1]][,-match('cell',colnames(nass.spp.data[[1]]))]
	gridded.pts <- gridSample.max(xy=temp[,c('POINT_X','POINT_Y')],r=grid.5010,n=5000,chess='',all.data=temp[,-match(c('POINT_X','POINT_Y'),colnames(temp))])
	test.set <- grid.train.test(rows=nass.rows[[1]], cells=gridded.pts$cell, k=10)
	# temp <- SpatialPoints(gridded.pts[,1:2])
	# for (i in 1:5) { plot(temp[test.set[[i]],]) 
	save(test.set,file=paste(output.path,'test.set.v33.rdata',sep=''))
}
# ===============================================================
# Build Models 
if (do.models=='y')
{
	# See above for versions.
	load(file=paste(output.path,'species.data.v31e.rdata',sep='')) # see above label description
	load(file=paste(output.path,'test.set.v33.rdata',sep='')) # version test/train for this model set (below).
	load(file=paste(output.path,'nass.models.var.v32.rdata',sep='')) # identifies the model variables based on previous set
	# test.rows <- scan(file=paste(output.path,'test.rows.v21.txt',sep=''),what=numeric())
	# v21b model.var <- c("JHOUR","JDATE","lulc","corn.1000","soy.1000","water.1000","herb.wetland.1000","grass.hay.1000","dev.low.1000", "dev.high.1000","patch.cells","hydro")
	# model.var <- c("JHOUR","JDATE","lulc","patch.cells","hydro") # v21c
	# model.var <- c("JHOUR","JDATE","lulc","ndvi","corn.dist","soy.dist","water.dist","herb.wetland.dist","grass.hay.dist", "dev.low.dist", "dev.high.dist","patch.cells","hydro") # v30/31 
	# model.var <- c("JHOUR","JDATE","lulc","ndvi","corn.dist","soy.dist","water.dist","herb.wetland.dist", "grass.hay.dist","dev.low.dist", "dev.high.dist","corn.1000","soy.1000","water.1000","herb.wetland.1000", "grass.hay.1000","dev.low.1000", "dev.high.1000","patch.cells","hydro") # v31b
	# model.var <- list(
		# c("JHOUR","grass.hay.1000","patch.cells","dev.high.1000","soy.1000","hydro"),
		# c("JHOUR","grass.hay.1000","water.1000","herb.wetland.1000","dev.low.dist","corn.1000"),
		# c("JHOUR","grass.hay.1000","patch.cells","lulc","soy.1000","grass.hay.dist"),
		# c("JHOUR","grass.hay.1000","lulc","patch.cells","corn.1000","dev.high.1000"),
		# c("JHOUR","grass.hay.1000","lulc","soy.1000","patch.cells","hydro")
		# ) # v31c & d
	# model.var <- c("JHOUR","JDATE","lulc","ndvi","corn.dist","soy.dist","water.dist","herb.wetland.dist", "grass.hay.dist","dev.low.dist", "dev.high.dist","corn.1000","soy.1000","water.1000","herb.wetland.1000", "grass.hay.1000","dev.low.1000", "dev.high.1000","patch.cells","hydro","unif"); model.var <- list(model.var, model.var, model.var, model.var, model.var) # v32 (1-5) add uninformative variable for model selection.
	model.var <- var.in
	
	source('train.test.data.r')
	source('deviance.explained.r')
	
	for (k in 6:10)
	{
		test.rows <- test.set[[k]]
		source('brt.models.r')
	
		# Version 2 are based on 2009 data
		# Version 4 based on 2009 data, 100 and 1000 radius
		# Version 5 2007:2011; 100, 500 radius; cloudless
		# Version 6 2007:2011; 100, 1000 radius; cloudless
		# Version 7 2007:2011; 500, 1000 radius; cloudless
		# Version 10: 2007:2011, 100, 1000 radius, cloudless, non-BCN data added
		# Version 20: 2007:2014, LULC, Soils, Patch, NDVI
		# Version 20b: 2007:2014, LULC, Soils, Patch
		# Version 21: 2007:2014, LULC, proportions, Soils, Patch, NDVI, max obs per 56m cell, random cells train/test.
		# Version 21b: 2007:2014, LULC, Soils, Patch, max obs per 56m cell, random cells train/test 
		# Version 21c: 2007:2014, proportion 1000 radius, LULC, Soils, Patch, max obs per 56m cell, random cells train/test
		# Version 30: 2007:2014, LULC, Soils, Patch, NDVI, distance, max obs per 56m cell, random cells train/test
		# Version 31: 2007:2014, LULC, Soils, Patch, NDVI, distance <1000m, max obs per 56m cell, random cells train/test, weights
		# Version 31b: 2007:2014, LULC, Soils, Patch, NDVI, prop & distance <1000m, max obs per 56m cell, random cells train/test, weights
		# Version 31c: 2007:2014, top 5 variables by importance for ea spp., no weights. (d) with weights.
		# Version 32: Set of 10 models with all variables and a random variable.
		# Version 33: final set of 10 models to estimate model performance.
		save(nass.models, file=paste(output.path,'nass.species.models.v33.',k,'.rdata',sep=''))
		ver <- paste('33.',k,sep='')
		source('variable.importance.r')
	}
}
# ================================================================
if (do.eval=='y')
{
	load(file=paste(output.path,'species.data.v31e.rdata',sep=''))
	# test.rows <- scan(file=paste(output.path,'test.rows.v21.txt',sep=''),what=numeric())
	load(file=paste(output.path,'test.set.v33.rdata',sep=''))
	
	for (k in 6:10)
	{
		ver <- paste('33.',k,sep='') # Version
		load(file=paste(output.path,'nass.species.models.v',ver,'.rdata',sep=''))
		# load(file=paste(output.path,'landsat.species.models.v',ver,'.rdata',sep=''))
		test.rows <- test.set[[k]]
		
		source('deviance.explained.r')
		source('model.eval.fxn.r')
		source('model.evaluation.r')
		
		# eval.table <- data.frame(nass.dev.exp.cv,nass.cor.cv,nass.dev.exp.test,nass.cor.test,landsat.dev.exp.cv,landsat.cor.cv,landsat.dev.exp.test,landsat.cor.test)
		eval.table <- data.frame(nass.dev.exp.cv,nass.cor.cv,nass.dev.exp.test,nass.cor.test)
		write.csv(eval.table,paste(output.path,'performance.v',ver,'.csv',sep=''))
	}
}
# ================================================================
# Prediction 
if (do.prediction=='y')
{
	ver <- '33a'
	# load(file=paste(output.path,'species.data.v31e.rdata',sep='')) # see above label description
	# test.rows <- list(NA,NA,NA,NA,NA) 
	# load(file=paste(output.path,'nass.models.var.v32.rdata',sep='')) # identifies the model variables based on previous set
	# model.var <- var.in
	
	# lr <- c(0.01,0.005,0.01,0.01,0.01)
	# source('brt.models.r')
	# save(nass.models, file=paste(output.path,'nass.species.models.v',ver,'.rdata',sep=''))
	
	# study.area.1 <- extent(matrix(c(582000,666000,2100000,2150000),ncol=2,byrow=TRUE))
	study.area.1 <- NA
	
	radius <- 1000
	reclass.lulc <- FALSE
	source('load.prediction.data.r')
	
	if (do.nass=='y') { load(file=paste(output.path,'nass.species.models.v',ver,'.rdata',sep='')) } 
	source('model.prediction.r') # Be sure to change the file output names
	if (do.nass=='y') { save(nass.pred, file=paste(output.path,'nass.pred.v',ver,'.rdata',sep='')) }

	# Zero cutoff on maps should be based on the minimum modeled abundance from a presence point.
}
# ====================================================================
# Kernel Density
if (do.kd=='y')
{
	the.radius <- 2000
	load(file=paste(output.path,'species.data.v6.rdata',sep=''))
	ref.raster <- raster(paste(output.path,'boboli.nass.v7.tif',sep=''))
	unique.pts <- readOGR(dsn=paste(drive,':/Chicago_Grasslands/BIRD_DATA/BCN',sep=''),layer='unique_pts_albers_v2',encoding='ESRI Shapefile')
	coords.crosswalk <- data.frame(coordinates(unique.pts),unique.pts@data[,c('LATITUDE', 'LONGITUDE')])
	colnames(coords.crosswalk) <- c('x.coord','y.coord','LATITUDE','LONGITUDE')
	# print(head(coords.crosswalk))
	
	source('kernel.density.r')
	
	for (i in 1:5)
	{
		presences <- nass.spp.data[[i]]
		presences <- presences[presences$HOW_MANY_ATLEAST!=0,]
		presences <- merge(presences, coords.crosswalk)
		# print(str(presences)); stop('cbw')
		presences <- SpatialPointsDataFrame(coords=presences[,c('x.coord','y.coord')], data=data.frame(presences$HOW_MANY_ATLEAST), proj4string=unique.pts@proj4string, bbox=bbox(ref.raster))
		# print(str(presences)); stop('cbw')
		temp <- kd(presence.pts=presences, ref.raster=ref.raster, the.radius=the.radius, file.name=paste(output.path,spp.names[i],'.kd.',the.radius,'.tif',sep=''))
		# stop('cbw')
	}
}
