
setwd('d:/github/chicagograsslandbirds/')

# Define inputs and file paths
years <- c(2007, 2009)
radius <- c(100, 500)
days <- c(215,156)
bands <- seq(1,7,1)
nass.var <- c('water','herb.wetland','grass.hay','alfalfa.etc','dev.low','dev.high','decid.wood','wood.wetland','other')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')

nass.path <- 'd:/chicago_grasslands/gis/nass_layers/'
landsat.path <- 'd:/chicago_grasslands/landsat2/'
output.path <- 'd:/chicago_grasslands/models/'

# Learning rates for BRTs
lr <- c(0.01,0.005,0.01,0.01,0.01)

# For prediction
pred.year <- years[length(years)]
pred.day <- days[length(days)]

study.area.1 <- extent(matrix(c(594000,706500,2043700,2197500),ncol=2,byrow=TRUE)) # Could be wider.
study.area.2 <- extent(matrix(c(358000,459000,4558000,4712000),ncol=2,byrow=TRUE)) # Could be wider.

do.nass <- 'y'
do.landsat <- 'n'
