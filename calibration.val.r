
source('~/GitHub/ChicagoGrasslandBirds/lm.and.offset.model.r')
spp.names <- c('boboli','sedwre','henspa','easmea','graspa')
output <- as.data.frame(matrix(NA,ncol=5,nrow=5))
colnames(output) <- c('species','intercept','slope','r2','p.value')

# =======================================================================
# Chad's model predicting the Val's max observed density within a grassland site, regression forced through origin.

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- sqrt(aggregate(max ~ site, tb, mean)$max + 3/8) - sqrt(3/8)
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean / 0.2295
    
    # write.csv(data.frame(val_site,chad_site),paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/",spp.names[i],"_sites.csv",sep=''))
    
    lm1 <- lm(val_site ~ 0 + chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(a=0,b=lm1[1][[1]])
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],0,round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['r.squared']),4),round(unlist(summary(lm1)['coefficients'])[4],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/lm_max_sqrt_ms_raw_origin_0b_model_site_vs_site.csv")
stop('cbw')

# =======================================================================
# Chad's model predicting the Val's max observed density within a grassland site, regression forced through origin.

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- sqrt(aggregate(max ~ site, tb, mean)$max)
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean / 0.2295
    
    # write.csv(data.frame(val_site,chad_site),paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/",spp.names[i],"_sites.csv",sep=''))
    
    lm1 <- lm(val_site ~ 0 + chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(a=0,b=lm1[1][[1]])
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],0,round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['r.squared']),4),round(unlist(summary(lm1)['coefficients'])[4],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/CalibrationOutputs/lm_max_sqrt_ms_raw_origin_0_model_site_vs_site.csv")
# stop('cbw')

# =========================================================
# =========================================================
# =========================================================


# =========================================================
# Chad's model predicting the Val's max observed density within a grassland site, force through origin
# This method didn't really work. I'm not sure about the offset approach.

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- sqrt(aggregate(max ~ site, tb, mean)$max)
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean / 0.2295
    
    models <- lm.and.offset.models(the.data=data.frame(chad_site,val_site))
    # lm1 <- lm(val_site ~ chad_site)
    
    # print(lm1)
    print(summary(models[[1]]))
    print(summary(models[[2]]))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(a=0,b=as.numeric(coef(models[[1]])))
    # abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(models[[1]])
    
    output[i,] <- c(spp.names[i],0,round(as.vector(models[[1]][1][[1]]),4),round(as.numeric(summary(models[[2]])['adj.r.squared']),4),round(anova(models[[2]])[1,5],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_sqrt_ms_raw_origin_model_site_vs_site.csv")
# stop('cbw')

# =========================================================
# Chad's model predicting the Val's max observed density within a grassland site

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- sqrt(aggregate(max ~ site, tb, mean)$max)
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean / 0.2295
    
    lm1 <- lm(val_site ~ chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_sqrt_ms_raw_model_site_vs_site.csv")
stop('cbw')

# =========================================================
# Chad's model predicting the Val's max observed density within a grassland site

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- aggregate(max ~ site, tb, mean)$max
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean / 0.2295
    
    lm1 <- lm(val_site ~ chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_ms_raw_model_site_vs_site.csv")
stop('cbw')

# =========================================================
# Chad's model predicting the Val's max observed density within a grassland site

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- aggregate(max ~ site, tb, mean)$max
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean
    
    lm1 <- lm(val_site ~ chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_ms_model_site_vs_site.csv")

# =========================================================
# Chad's model predicting the Val's max observed density within a grassland site

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    
    val_site <- sqrt(aggregate(max ~ site, tb, mean)$max)
    chad_site <- aggregate(chads_mean ~ site, tb, mean)$chads_mean
    
    lm1 <- lm(val_site ~ chad_site)
    
    # print(lm1)
    print(summary(lm1))
    plot(val_site ~ chad_site, main=paste(spp.names[i],' site vs site',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_sqrt_ms_model_site_vs_site.csv")
# stop('cbw')

# =========================================================
# Chad's model predicting the Val's max observed density points vs points...

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    lm1 <- lm(tb$max ~ tb$chads_mean)
    
    # print(lm1)
    print(summary(lm1))
    plot(tb$max ~ tb$chads_mean, main=paste(spp.names[i],' pt vs pt',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}
write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_ms_model_pt_vs_pt.csv")
# stop('cbw')

# =========================================================
# Chad's model predicting the Val's max observed density...

for (i in 1:length(spp.names))
{
    tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
    max_sqrt <- sqrt(tb$max)
    lm1 <- lm(max_sqrt ~ tb$chads_mean)
    
    # print(lm1)
    print(summary(lm1))
    plot(max_sqrt ~ tb$chads_mean, main=paste(spp.names[i],' pt vs pt',sep=''))
    abline(as.vector(lm1[1][[1]]))
    abline(a=0,b=1,lty=2)
    par(mfrow=c(2,2))
    plot(lm1)
    
    output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
    
}

write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_sqrt_ms_model_pt_vs_pt.csv")

# =========================================================
# Chad's model predicting the Val's max observed density...
# Log transformation

# for (i in 1:length(spp.names))
# {
#     tb <- read.csv(paste("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/",spp.names[i],"_point_vs_point.csv",sep=''),header=TRUE,stringsAsFactors=FALSE)
#     max_ln <- log(tb$max+1)
#     lm1 <- lm(max_ln ~ tb$chads_mean)
#     
#     # print(lm1)
#     print(summary(lm1))
#     plot(max_ln ~ tb$chads_mean, main=paste(spp.names[i],' pt vs pt',sep=''))
#     abline(as.vector(lm1[1][[1]]))
#     abline(a=0,b=1,lty=2)
#     par(mfrow=c(2,2))
#     plot(lm1)
#     
#     output[i,] <- c(spp.names[i],round(as.vector(lm1[1][[1]]),4),round(as.numeric(summary(lm1)['adj.r.squared']),4),round(unlist(summary(lm1)['coefficients'])[8],4))
#     
# }
# 
# write.csv(output,"C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/lm_max_ln_ms_model_pt_vs_pt.csv")

stop('cbw')

# ==================================================================================
# Exploratory analysis below...
# =================================================================================

tb1 <- read.csv("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boboli_point_vs_point.csv",header=TRUE,stringsAsFactors=FALSE)

lm1e <- lm(tb1$max ~ tb1$bobo_chads_mean)

print(lm1e)
print(summary(lm1e))
plot(tb1$max ~ tb1$bobo_chads_mean, main='Point vs point')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1e)

lm1f <- lm(tb1$max ~ sqrt(tb1$bobo_chads_mean))

print(lm1f)
print(summary(lm1f))
plot(tb1$max ~ sqrt(tb1$bobo_chads_mean), main='Point vs point')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1f)


sqrt_g <- sqrt((tb1$max+0.5))
lm1g <- lm(sqrt_g ~ tb1$bobo_chads_mean)

# print(lm1g)
print(summary(lm1g))
plot(sqrt_g ~ tb1$bobo_chads_mean, main='Point vs point')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1g)

stop('cbw')





lm1 <- lm(tb1$bobo_year_avg ~ tb1$bobo_chads_mean)

print(lm1)
print(summary(lm1))
plot(tb1$bobo_year_avg ~ tb1$bobo_chads_mean,main='Point vs point')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1)
# This output suggests that only at the point level is Chad's model a significant predictor of Val's density.

lm1b <- lm(sqrt(tb1$bobo_year_avg) ~ sqrt(tb1$bobo_chads_mean))

print(lm1b)
print(summary(lm1b))
plot(sqrt(tb1$bobo_year_avg) ~ sqrt(tb1$bobo_chads_mean),main='Point vs point')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1b)

# lm1c <- lm(sqrt(tb1$bobo_year_avg[-c(20,3,4)]) ~ sqrt(tb1$bobo_chads_mean[-c(20,3,4)]))
# 
# print(lm1c)
# print(summary(lm1c))
# plot(tb1$bobo_year_avg[-c(20,3,4)] ~ tb1$bobo_chads_mean[-c(20,3,4)],main='Point vs point')
# abline(a=0,b=1)
# par(mfrow=c(2,2))
# plot(lm1c)

cube <- tb1$bobo_chads_mean^(1/3)
# val_cube <- tb1$bobo_year_avg^(1/3)
lm1c <- lm(tb1$bobo_year_avg ~ cube)

print(lm1c)
print(summary(lm1c))
plot(tb1$bobo_year_avg ~ cube)
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1c)
# This gets messed up by all the zeros in Val's dataset.  There are many zeros (non-detection?)

cube <- tb1$bobo_chads_mean^(1/3)
val_cube <- tb1$bobo_year_avg^(1/3)
lm1d <- lm(val_cube ~ cube)

print(lm1d)
print(summary(lm1d))
plot(val_cube ~ cube)
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm1d)
# This gets messed up by all the zeros in Val's dataset.  There are many zeros (non-detection?)

stop('cbw')

# ===============================================================
# None of these models showed Chad's output as a signficant predictor of Val's density.

tb2 <- read.csv("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boboli_points_within_site_vs_site.csv",header=TRUE,stringsAsFactors=FALSE)

lm2 <- lm(tb2$vals_combined_avg ~ tb2$chads_avg)

print(lm2)
print(summary(lm2))
plot(tb2$vals_combined_avg ~ tb2$chads_avg, main='Points in sites')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm2)
# This output also suggests that at a site level the models don't do very well.

tb3 <- read.csv("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boboli_site_vs_site.csv",header=TRUE,stringsAsFactors=FALSE)

lm3 <- lm(tb3$vals_combined_avg ~ tb3$chads_model)

print(lm3)
print(summary(lm3))
plot(tb3$vals_combined_avg ~ tb3$chads_model,main='Site to site')
abline(a=0,b=1)
par(mfrow=c(2,2))
plot(lm3)
# This output also suggests that at a site level the models don't do very well.
stop('cbw')

lm3b <- lm(tb3$vals_combined_avg ~ sqrt(tb3$chads_model))

print(lm3b)
print(summary(lm3b))
plot(tb3$vals_combined_avg ~ sqrt(tb3$chads_model))
abline(a=0,b=1)

cube <- tb3$chads_model^(1/3)
lm3c <- lm(tb3$vals_combined_avg ~ cube)

print(lm3c)
print(summary(lm3c))
plot(tb3$vals_combined_avg ~ cube)
abline(a=0,b=1)

ln_trans <- log(1 + tb3$chads_model)
lm3d <- lm(tb3$vals_combined_avg ~ ln_trans)

print(lm3d)
print(summary(lm3d))
plot(tb3$vals_combined_avg ~ ln_trans)
abline(a=0,b=1)
