
library(foreign)

spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
file_path <- 'D:/Chicago_Grasslands/GIS/'
folder_name <- 'GIV_Tool_Outputs_'
file_name <- 'ecosystemservice_summary_'

for (i in 1:length(spp.names))
{
    output <- data.frame(ID=NA,Flood=NA,Grndwtr=NA,WaterPur=NA,CarbonStor=NA,Aggregate=NA)
    # print(output)
    
    for (j in 1:2) # This should be 1 to the number of patches.
    {
        full_path <- paste(file_path,folder_name,spp.names[i],'/',file_name,spp.names[i],j,'.dbf',sep='')
        temp <- read.dbf(full_path,as.is=TRUE)
        print(temp)
        # stop('cbw')
        temp <- as.numeric(temp[1,c('Flood','Grndwtr','WaterPur','CarbonStor','Aggregate')])
        temp <- c(j,temp)
        output <- rbind(output,temp)
        # stop('cbw')
    }
    output <- output[-1,]
    write.csv(output,paste(file_path,folder_name,spp.names[i],'/compiled_',spp.names[i],'.csv',sep=''))
    # stop('cbw')
}

