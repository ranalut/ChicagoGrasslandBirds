

tb1 <- read.csv("C:/Users/cwilsey/Box Sync/2_Projects/Habitats/Grasslands/Grassland Bird Project/boboli_point_vs_point.csv",header=TRUE,stringsAsFactors=FALSE)

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
