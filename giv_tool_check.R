
library(foreign)

#spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
# species <- 'boboli'
# file_path <- 'D:/Chicago_Grasslands/GIS/'
# folder_name <- 'GIV_Tool_Outputs_'
# file_name <- 'C:/Chicago_Grasslands/McHenry_GIV.dbf'
# 
# 
# full_path <- paste(file_path,folder_name,species,'/',file_name,species,j,'.dbf',sep='')
temp <- read.dbf("C:/Chicago_Grasslands/McHenry_GIV_landscape.dbf",as.is=TRUE)