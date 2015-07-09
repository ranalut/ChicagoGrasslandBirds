file_path = 'C:/Chicago_Grasslands/'
  
# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('C:/Chicago_Grasslands/cmap_top50_acreage_boboli.csv')
dat2 <- read.csv('C:/Chicago_Grasslands/cmap_top50_acreage_easmea.csv')
dat3 <- read.csv('C:/Chicago_Grasslands/cmap_top50_acreage_graspa.csv')
dat4 <- read.csv('C:/Chicago_Grasslands/cmap_top50_acreage_henspa.csv')
dat5 <- read.csv('C:/Chicago_Grasslands/cmap_top50_acreage_sedwre.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5)

write.csv(dat_merge,paste(file_path,'CMAP_top50_allspecies.csv',sep=''))