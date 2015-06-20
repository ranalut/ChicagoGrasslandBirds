

# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/Cook_top15results_rank_henspa.csv')
dat2 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/DuPage_top15results_rank_henspa.csv')
dat3 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/Kane_top15results_rank_henspa.csv')
dat4 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/Kendall_top15results_rank_henspa.csv')
dat5 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/Lake_top15results_rank_henspa.csv')
dat6 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/McHenry_top15results_rank_henspa.csv')
dat7 <- read.csv('C:/Chicago_Grasslands/Species_per_patch/Will_top15results_rank_henspa.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5,dat6,dat7)

write.csv(dat_merge,paste(file_path,'all_counties_top15rank_henspa.csv',sep=''))