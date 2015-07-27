file_path = 'Y:/Chicago_Grasslands/GIS/'
  
# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('Y:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_boboli/compiled_boboli.csv')
dat2 <- read.csv('Y:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_easmea/compiled_easmea.csv')
dat3 <- read.csv('Y:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_graspa/compiled_graspa.csv')
dat4 <- read.csv('Y:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_henspa/compiled_henspa.csv')
dat5 <- read.csv('Y:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_sedwre/compiled_sedwre.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5)
dat_merge <- dat_merge[,3:8]

dat_uniq <- unique(dat_merge)

write.csv(dat_uniq,paste(file_path,'compiled_allSpecies.csv',sep=''))