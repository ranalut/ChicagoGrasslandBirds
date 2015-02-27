
library(raster)
library(rgdal)

source('build.similar.raster.r') # Function used below to build rasters with similar resolution/extent and fill in values.
# source('settings.r')
source('nass.lulc.classes.r')

# ===========================================================
# NASS data
# Generate rasters for JDATE and JHOUR
if (do.nass=='y')
{
	JDATE <- build.similar(file.name=paste(nass.path,pred.year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
	JHOUR <- build.similar(file.name=paste(nass.path,pred.year,'_',nass.var[1],'_nass_30m_r',radius[1],'.tif',sep=''),value=7.15,var.name='JHOUR')

	if (reclass.lulc==TRUE)
	{
		# Reclassify
		values <- c(values,list(seq(1,300,1)[-unlist(values)]))
		reps <-  unlist(lapply(values,length))
		subs.table <- data.frame(x=unlist(values),y=rep(seq(1,(length(nass.var)+1),1),times=reps))
		# print(subs.table); stop('cbw')
		file.name <- ifelse(pred.year==2014,paste(nass.path,'CDL_',pred.year,'_clip_20150202180847_618398852.tif',sep=''),paste(nass.path,'CDL_',pred.year,'_clip_20150129145939_195531972.tif',sep=''))
		temp <- raster(file.name)
		temp.s <- subs(x=temp,y=subs.table)
		writeRaster(temp.s,paste(nass.path,pred.year,'_nass_reclass.tif',sep=''))
		cat('substitution complete\n')
	}
	
	# Load and rename layers
	nass.file.names <- paste(nass.path,pred.year,'_',nass.var,'_nass_30m_r',rep(radius,each=length(nass.var)),'.tif',sep='')
	nass.file.names2 <- paste(nass.path,data.yrs[i],'_',nass.var,'_nass_dist.tif',sep='')
	nass.file.names <- c(
		paste(nass.path,pred.year,'_nass_reclass.tif',sep=''),
		nass.file.names,
		paste(nass.path,pred.year,'_nass_clump_30m.tif',sep=''),
		paste(soil.path,'hydro_class.tif',sep=''),
		paste(soil.path,'drain_class.tif',sep=''),
		paste(ndvi.path,pred.year,'_ndvi_30m.tif',sep=''),
		nass.file.names2
		)

	print(nass.file.names)
	nass.pred.data <- stack(nass.file.names)
	names(nass.pred.data) <- c('lulc',paste(nass.var,'.',rep(radius,each=length(nass.var)),sep=''),'patch.cells','hydro','drain','ndvi',paste(nass.var,'.dist',sep=''))
	nass.pred.data <- addLayer(nass.pred.data, JDATE, JHOUR)
	
	# nass.pred.data <- sapply(temp.data$lulc,FUN=assign.class,USE.NAMES=FALSE,values=values,nass.var=c(nass.var,'other'))
	# nass.pred.data[['hydro']] <- factor(nass.pred.data[['hydro']],levels=seq(1,7,1))
	# nass.pred.data[['drain']] <- factor(nass.pred.data[['drain']],levels=seq(1,7,1),ordered=TRUE)
	
	nass.pred.data <- crop(nass.pred.data, study.area.1)
	print(nass.pred.data)
	# stop('cbw')
}

# # ===========================================================
# # Landsat data
# # Generate rasters for JDATE and JHOUR
# if (do.landsat=='y')
# {
	# JDATE <- build.similar(file.name=paste(landsat.path,pred.year,'_clean_d',pred.day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=168,var.name='JDATE')
	# JHOUR <- build.similar(file.name=paste(landsat.path,pred.year,'_clean_d',pred.day,'_b',bands[1],'_r',radius[1],'.tif',sep=''),value=7,var.name='JHOUR')

	# landsat.file.names <- c(
		# paste(landsat.path,pred.year,'_clean_d',pred.day,'_b',bands,'_r',radius[1],'.tif',sep=''),
		# paste(landsat.path,pred.year,'_clean_d',pred.day,'_b',bands,'_r',radius[2],'.tif',sep='')
		# )
	# # print(landsat.file.names)
	# landsat.pred.data <- stack(landsat.file.names)
	# names(landsat.pred.data) <- c(paste('b',bands,'.',radius[1],sep=''),paste('b',bands,'.',radius[2],sep=''))
	# landsat.pred.data <- addLayer(landsat.pred.data, JDATE, JHOUR)
	# # print(landsat.pred.data)
	# landsat.pred.data <- crop(landsat.pred.data, study.area.2)
	# print(landsat.pred.data)
# }
# # nass.pred.data[is.na(nass.pred.data)==TRUE] <- 0
# # landsat.pred.data[is.na(landsat.pred.data)==TRUE] <- 0


