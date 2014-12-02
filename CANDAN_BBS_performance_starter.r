######### load appropriate libraries

library(mgcv)
library(dismo)
library(pROC)
library(gbm)
library(ROCR)


######### load file containing names of species to be run

specieslist <- read.csv("D:/Climate_FINAL/CONS_BIO_supplementary_analyses/BBS_test_species.csv")

specieslist <- data.frame(specieslist[,1])

names(specieslist) <- "SPECIES"

######### start evaluation loop

for (i in 1: length(specieslist$SPECIES)) {
  
  species.i <- specieslist$SPECIES[i]
  
  ########## load BRT model*******************you will have to point to your models
  
  load(paste("D:/Climate_FINAL/CONS_BIO_supplementary_analyses/BBS_test_BRT_settings/", species.i,"/",species.i,"_BRT_tc3_lr001_bf_75.RData", sep=""))
  
    ######### uses GAM, BRT, and MAXENT models to predict to test data, evaluates model performance, and saves evaluation objects
  
  datafilename <- paste( "D:/BBS_Future/BBS_Data_Species/", species.i, ".csv", sep = "")
  data <- read.csv(file = datafilename, header = TRUE) 
  testdata <- data[data$YEAR>1979 & data$YEAR<2000, ]
  
  pBRT <- as.data.frame(predict.gbm(speciesBRT, testdata, n.trees = speciesBRT$n.trees, type = "response"))
  
  preds <- cbind(testdata$PA30, pBRT)
  preds<-as.data.frame(preds)
  names(preds) <- c("PA", "pBRT")
  
  a<-(preds$PA==0)
  p<-(preds$PA==1)
  
  evaluateBRT <- evaluate(preds$pBRT[p], preds$pBRT[a])
  
  ########## we can go into these evaluation objects and pull out threshold information...e.g.
  
  dev<-calc.deviance(preds$PA, preds$pBRT, calc.mean=T, family="bernoulli")  
  preds$mean<-mean(preds$PA)
  dev_null<-calc.deviance(preds$PA, preds$mean, calc.mean=T, family="bernoulli")  
  per_dev<-(dev_null-dev)/dev_null
  
  BRT_max_TPR_TNR<-evaluateBRT@t[which.max(evaluateBRT@TPR + evaluateBRT@TNR)]
  BRT_max_kappa<-evaluateBRT@t[which.max(evaluateBRT@kappa)]
  BRT_TPR_eq_TNR<-evaluateBRT@t[which.min(abs(evaluateBRT@TPR - (1-evaluateBRT@FPR)))]
  
  
  ########## uses pROC package to determine AUC and threshold (the threshold described below is the same as the max TPR+TNR rate above)
  
  BRT_roc <- roc(PA ~ pBRT, preds)
  BRT_AUC <- auc(BRT_roc)
  
  
  ########## writes p values AUC and threshold summary file
  
  specieslist$BRT_AUC[i] <- BRT_AUC
  specieslist$BRT_max_TPR_TNR[i] <- BRT_max_TPR_TNR
  specieslist$BRT_max_kappa[i] <- BRT_max_kappa
  specieslist$BRT_TPR_eq_TNR[i] <- BRT_TPR_eq_TNR
  specieslist$deviance_explained_in_test_data[i] <- per_dev
  
}

write.csv(specieslist, file="D:/Climate_FINAL/CONS_BIO_supplementary_analyses/BBS_test_BRT_settings/EvalObjects.csv", row.names=F)


