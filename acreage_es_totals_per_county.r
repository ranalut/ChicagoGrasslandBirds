library(plyr)

file_path <- 'C:/Chicago_Grasslands/'

data <- read.csv('C:/Chicago_Grasslands/acreage_totals_per_county2.csv')

data <- data[,c(2,4:16)]
colnames(data)[c(2:14)] <- c('county','acreage_p','acreage_u','flood_p','flood_u','grndwtr_p','grndwtr_u','waterpur_p','waterpur_u','carbonstor_p','carbonstor_u','aggregate_p','aggregate_u')

counties <- c('Cook','DuPage','Kane','Kendall','Lake','McHenry','Will')

for (i in 1:length(counties))
{
  cty_data <- data[data$county==counties[i],]

  cdata <- ddply(cty_data, c("county"), summarise,
                 acre_p_sum = sum(acreage_p),
                 acre_u_sum = sum(acreage_u),
                 flood_p_sum = sum(flood_p),
                 flood_u_sum = sum(flood_u),
                 grndwtr_p_sum = sum(grndwtr_p),
                 grndwtr_u_sum = sum(grndwtr_u),
                 waterpur_p_sum = sum(waterpur_p),
                 waterpur_u_sum = sum(waterpur_u),
                 carbonstor_p_sum = sum(carbonstor_p),
                 carbonstor_u_sum = sum(carbonstor_u),
                 aggregate_p_sum = sum(aggregate_p),
                 aggregate_u_sum = sum(aggregate_u)
                 )
  
  write.csv(cdata,paste(file_path,counties[i],'_total_ac_es.csv',sep=''))

}

# combine all counties into one master csv so that you can easily join to feature class
dat1 <- read.csv('C:/Chicago_Grasslands/Cook_total_ac_es.csv')
dat2 <- read.csv('C:/Chicago_Grasslands/DuPage_total_ac_es.csv')
dat3 <- read.csv('C:/Chicago_Grasslands/Kane_total_ac_es.csv')
dat4 <- read.csv('C:/Chicago_Grasslands/Kendall_total_ac_es.csv')
dat5 <- read.csv('C:/Chicago_Grasslands/Lake_total_ac_es.csv')
dat6 <- read.csv('C:/Chicago_Grasslands/McHenry_total_ac_es.csv')
dat7 <- read.csv('C:/Chicago_Grasslands/Will_total_ac_es.csv')

dat_merge <- rbind(dat1,dat2,dat3,dat4,dat5,dat6,dat7)

write.csv(dat_merge,paste(file_path,'CMAP_totals_ac_es.csv',sep=''))

