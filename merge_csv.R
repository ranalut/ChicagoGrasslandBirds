file_path = 'C:/Chicago_Grasslands/Top 10 Patches/'
  
# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_boboli.csv')
dat2 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_easmea.csv')
dat3 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_graspa.csv')
dat4 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_henspa.csv')
dat5 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_sedwre.csv')
# dat6 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_rank_sedwre.csv')
# dat7 <- read.csv('C:/Chicago_Grasslands/Top 10 Patches/McHenry_top10results_rank_sedwre.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5)

write.csv(dat_merge,paste(file_path,'McHenry_top10_allspecies.csv',sep=''))