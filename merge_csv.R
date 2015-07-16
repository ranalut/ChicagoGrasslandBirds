file_path = 'C:/Chicago_Grasslands/'
  
# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('C:/Chicago_Grasslands/CMAP_totalsNEW_boboli.csv')
dat2 <- read.csv('C:/Chicago_Grasslands/CMAP_totalsNEW_easmea.csv')
dat3 <- read.csv('C:/Chicago_Grasslands/CMAP_totalsNEW_graspa.csv')
dat4 <- read.csv('C:/Chicago_Grasslands/CMAP_totalsNEW_henspa.csv')
dat5 <- read.csv('C:/Chicago_Grasslands/CMAP_totalsNEW_sedwre.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5)

write.csv(dat_merge,paste(file_path,'CMAP_totals_allSpecies.csv',sep=''))