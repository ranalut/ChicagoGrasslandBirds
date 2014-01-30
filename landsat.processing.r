
library(raster)
library(landsat)

source('remove.clouds.r')
source('atmos.correction.r')
source('cloud.shadows.r')
source('overlay.fxns.r')
source('mask.clouds.r')

do.atmos <- 	'n'
do.clouds <- 	'n'
do.clean <- 	'y'
do.shadows <- 	'y'
do.mask <- 		'n'

workspace <- 'D:/Chicago_Grasslands/LANDSAT2/'
# workspace <- 'Z:/Chicago_Grasslands/LANDSAT2/'
file.names <- c('lt50230312006164pac01','lt50230312007167pac01','lt50230312009156pac02','lt50230312010175EDC00','lt50230312011194pac01')

cloud.shifts <- c(
2006,-15,-14, # Looks good.
2007,-31,-27, # Tuned to study area.
# 2008,NA,NA,
2009,-23,-21, # Tuned to clouds within the study area.
2010,-20,-13, # This is tuned to the clouds within the study area near downtown Chicago.  There are a couple of clouds west of downtown that are lower and the offset isn't quite right, but these are only a handful and do not overlap with points.
2011,-15,-12  # Looks good.
)
shifts <- data.frame(matrix(cloud.shifts,byrow=TRUE,ncol=3))
colnames(shifts) <- c('year','x.shift','y.shift')

min.cloud <- 56

# for (n in 1:5)
for (n in 1)
{
	if (do.atmos=='y')
	{
		atmos.cor(workspace=workspace, file.name=file.names[n], sensor='TM5')
	}
	
	if (do.clouds=='y')
	{
		level.seq <- seq(0.0012,0.0008,-0.0001) # default = 0.0014
		# level.seq <- 0.0011

		for (i in level.seq)
		{
			startTime <- Sys.time()
			cat('start level value =',i,'\n')
			rm.clouds(workspace=workspace, file.name=file.names[n], level=i)
			cat('end level value =',i,Sys.time()-startTime,'\n')
		}
	}
	
	if (do.clean=='y')
	{
		startTime <- Sys.time()
		cat('start level value =',i,'\n')
		test <- clean.up.clouds(workspace=workspace, file.name=file.names[n], level=0.0009, threshold=min.cloud)
		cat('end level value =',i,Sys.time()-startTime,'\n')
	}
	
	if (do.shadows=='y')
	{
		cloud.shadow(workspace=workspace, level=0.0009, file.name=file.names[n], padx=abs(shifts[n,'x.shift']), pady=abs(shifts[n,'y.shift']), shiftx=shifts[n,'x.shift'], shifty=shifts[n,'y.shift'])
	}
	
	if (do.mask=='y')
	{
		mask.clouds(workspace=workspace, file.name=file.names[n], level=0.0009)
	}
}
