
# Psuedocode
# Load species dbf
# Do math
# order()

library(foreign)

file_path <- 'C:/Chicago_Grasslands/'
species <- 'sedwre'
file_name <- '_final_v2.dbf'

# We no longer want to separate out by county, but instead look across entire CMAP region.
#counties <- c('Cook','DuPage','Kane','Kendall','Lake','McHenry','Will')

full_path <- paste(file_path,species,file_name,sep='')
spp <- read.dbf(full_path,as.is=TRUE)
#print(head(spp))
#stop('cmj')

# need to convert character data types to numeric
spp$bird_count<-as.numeric(spp$bird_count)
spp$Flood<-as.numeric(spp$Flood)
spp$Grndwtr<-as.numeric(spp$Grndwtr)
spp$WaterPur<-as.numeric(spp$WaterPur)
spp$CarbonStor<-as.numeric(spp$CarbonStor)
spp$Aggregate<-as.numeric(spp$Aggregate)
spp$acreage<-as.numeric(spp$acreage)

temp <- spp$protect * spp[,c('bird_count','Flood','Grndwtr','WaterPur','CarbonStor','Aggregate','acreage')]
spp <- cbind(spp,temp)
#stop('cmj')

temp <- spp$unprotect * spp[,c('bird_count','Flood','Grndwtr','WaterPur','CarbonStor','Aggregate','acreage')]
spp <- cbind(spp,temp)
#stop('cmj')

# keep only the columns you need and put in order you like
spp <- spp[,c(3:4,2,5:10,21,15:20,28,22:27)] # adds column suffix
#stop('cmj')

# rename columns
colnames(spp)[c(10:23)] <- c('acreage_Protected','bird_count_Protected','Flood_Protected','Grndwtr_Protected','WaterPur_Protected','CarbonStor_Protected','Aggregate_Protected','acreage_Unprotected','bird_count_Unprotected','Flood_Unprotected','Grndwtr_Unprotected','WaterPur_Unprotected','CarbonStor_Unprotected','Aggregate_Unprotected')
#stop('cmj')

# Order
spp <- spp[order(spp[,'acreage_Unprotected'],na.last=TRUE,decreasing=TRUE),]
#stop('cmj')
 
# Create 'Rank' column
spp$rank <- rank(-spp$acreage_Unprotected)
#stop('cmj')
 

  #Sum field
  #temp <- apply(X=cty_spp[,3:23],MARGIN=2,FUN=sum)
  #temp <- c(counties[i],NA,round(temp))
  #cty_spp <- rbind(temp,cty_spp)
  #stop('cmj')
  
# Subset top 50
sub_spp <- spp[1:51,]
colnames(sub_spp) <- c("county","patch_id","acreage","bird_count","Flood","Grndwtr","WaterPur","CarbonStor","Aggregate","acreage_p","bird_count_p","Flood_p","Grndwtr_p","WaterPur_p","CarbonStor_p","Aggregate_p","acreage_u","bird_count_u","Flood_u","Grndwtr_u","WaterPur_u","CarbonStor_u","Aggregate_u")
#stop('cmj')
 
write.csv(sub_spp,paste(file_path,'cmap_top50_rank_by_acreage_',species,'.csv',sep=''))
stop('cmj')
  
# Collate
# Build a new table by row
# Loop through a sequence of rbind commands pulling specific columns and rows
output <- data.frame(sub_spp[1,c(1:2,10:16)])
colnames(output) <- c("county","patch_id","acreage","bird_count","Flood","Grndwtr","WaterPur","CarbonStor","Aggregate") # final column names (no suffix)
#stop('cmj')

output2 <- data.frame(sub_spp[1,c(1:2,17:23)]) # unprotected totals??
colnames(output2) <- c("county","patch_id","acreage","bird_count","Flood","Grndwtr","WaterPur","CarbonStor","Aggregate")

output <- rbind(output,output2) # joining protected & unprotected totals
#output <- round(as.numeric(output)) 
#stop('cmj') 
 
for (i in 2:51)
{
  # print(as.numeric(sub_spp[i,c(10:16)]))
  output <- rbind(output,sub_spp[i,c(1:2,10:16)]) # protected
  output <- rbind(output,sub_spp[i,c(1:2,17:23)]) # unprotected    
}

#stop('cmj')

output <- data.frame(output[,c('county','patch_id')],status=rep(c('protected','unprotected'),51),output[,3:9])
#stop('cmj')
 
output$bird_percent <- output$bird_count/sum(spp$bird_count)
#stop('cmj')
colnames(output) <- c("County","Patch ID","Status","Acreage","Number of Birds","Flood Control","Groundwater Recharge","Water Purification","Carbon Sequestration","All Services","Percentage of Birds")
#stop('cmj')

output$species <- species

write.csv(output,paste(file_path,'cmap_top50_acreage_',species,'.csv',sep=''))

