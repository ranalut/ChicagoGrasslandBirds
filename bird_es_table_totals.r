
# Psuedocode
# Load species dbf
# Do math
# order()

library(foreign)

file_path <- 'C:/Chicago_Grasslands/'
species <- 'sedwre'
file_name <- '_final_v2.dbf'

counties <- c('Cook','DuPage','Kane','Kendall','Lake','McHenry','Will')

full_path <- paste(file_path,species,file_name,sep='')
spp <- read.dbf(full_path,as.is=TRUE)
#print(head(spp))
# stop('cmj')

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
spp <- spp[,c(3,5,2,13:18,29,23:28,36,30:35)] # adds column suffix
#stop('cmj')

# rename columns
colnames(spp)[c(10:23)] <- c('acreage_Protected','bird_count_Protected','Flood_Protected','Grndwtr_Protected','WaterPur_Protected','CarbonStor_Protected','Aggregate_Protected','acreage_Unprotected','bird_count_Unprotected','Flood_Unprotected','Grndwtr_Unprotected','WaterPur_Unprotected','CarbonStor_Unprotected','Aggregate_Unprotected')
#stop('cmj')

for (i in 1:length(counties))
{

  cty_spp <- spp[spp$county==counties[i],]
  
  # Order
  cty_spp <- cty_spp[order(cty_spp[,'acreage_Unprotected'],na.last=TRUE,decreasing=TRUE),]
 #stop('cmj')
 
  # Create 'Rank' column
 cty_spp$rank <- rank(-cty_spp$acreage_Unprotected)
 #stop('cmj')
 

  #Sum field
  temp <- apply(X=cty_spp[,3:23],MARGIN=2,FUN=sum)
  temp <- c(counties[i],NA,round(temp))
  cty_spp <- rbind(temp,cty_spp)
  #stop('cmj')
  
  # subset totals row
  sub_spp <- cty_spp[1,]
 stop('cmj')
 
  write.csv(sub_spp,paste(file_path,counties[i],'_top10results_rank_',species,'.csv',sep=''))
 #stop('cmj')
  
  # Collate
  # Build a new table by row
  # Loop through a sequence of rbind commands pulling specific columns and rows
  # Question: What is the 1 for next to the columns? Totals row? 
  output <- data.frame(sub_spp[1,c(2,10:16)]) # protected totals?
  colnames(output) <- c("patch_id","acreage","bird_count","Flood","Grndwtr","WaterPur","CarbonStor","Aggregate") # final column names (no suffix)

  output2 <- data.frame(sub_spp[1,c(2,17:23)]) # unprotected totals??
  colnames(output2) <- c("patch_id","acreage","bird_count","Flood","Grndwtr","WaterPur","CarbonStor","Aggregate")

  output <- rbind(output,output2) # joining protected & unprotected totals
  # output <- round(as.numeric(output)) 
  # stop('cmj') 
 
  for (j in 2:11)
  {
    # print(as.numeric(sub_spp[i,c(10:16)]))
    output <- rbind(output,round(as.numeric(sub_spp[j,c(2,10:16)]))) # protected
    output <- rbind(output,round(as.numeric(sub_spp[j,c(2,17:23)]))) # unprotected
    
  }
 # stop('cmj')
  output <- data.frame(county=rep(counties[i],22),output[,c('patch_id')],status=rep(c('protected','unprotected'),11),output[,2:8])
 #stop('cmj')
 
 colnames(output) <- c("County","Patch ID","Status","Acreage","Number of Birds","Flood Control","Groundwater Recharge","Water Purification","Carbon Sequestration","All Services")
 
 output$species <- species
  write.csv(output,paste(file_path,counties[i],'_top10results_',species,'.csv',sep=''))

}

