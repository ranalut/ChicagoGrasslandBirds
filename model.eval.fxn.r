
# Model evaluation

model.eval <- function(the.model, covariates, test.rows, obs, spp)
# model.eval <- function(the.model=nass.models[[i]], covariates=nass.spp.data[[i]][,c(4:5,9:26)], test.rows=test.rows, obs=nass.spp.data[[i]][,6], spp=spp.names[i])
{
	test <- predict.gbm(newdata=covariates[test.rows,], the.model, n.trees=the.model$n.trees, type='response', progress='window', na.rm=TRUE)
	plot(test ~ obs[test.rows], main=paste(spp,', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
	
	obs.pred <- as.data.frame(cbind(obs[test.rows],test))
	colnames(obs.pred) <- c('obs','pred')
	temp <- obs.pred[obs.pred$obs>0,]
	threshold <- min(temp$pred)
		
	dev.exp.cv <- dsq(
		mean.null=the.model$self.statistics$mean.null, 
		validation=the.model$cv.statistics$deviance.mean
		)
	cat('deviance explained training data',dev.exp.cv,'\n')
	cor.cv <- the.model$cv.statistics$correlation.mean
	
	dev.exp.test <- dsq(
		mean.null=calc.deviance(as.numeric(obs[test.rows]), rep(mean(as.numeric(obs[test.rows])),length(test)), family='poisson'),
		validation=calc.deviance(as.numeric(obs[test.rows]), test, family='poisson')
		)
	cat('deviance explained test data',dev.exp.test,'\n')
	cor.test <- cor(test,obs[test.rows])
	
	# stop('cbw')
	return(list(dev.exp.cv, dev.exp.test, cor.cv, cor.test, threshold))
}

# i <- 1
# temp <- model.eval(the.model=nass.models[[i]], covariates=nass.spp.data[[i]][,c(4:5,9:26)], test.rows=test.rows, obs=nass.spp.data[[i]][,6], spp=spp.names[i])
# print(temp)

# ============================================================
# Old code

# # Evaluate
# test <- predict.gbm(newdata=nass.spp.data[[i]][test.rows,c(4:5,9:26)], nass.models[[i]], n.trees=nass.models[[i]]$n.trees, type='response', progress='window', na.rm=TRUE)
# plot(test ~ nass.spp.data[[i]][test.rows,6], main=paste(spp.names[i],', fitted ~ obs',sep=''), xlab='counts', ylab='predicted')
# nass.dev.exp.cv[i] <- dsq(
	# mean.null=nass.models[[i]]$self.statistics$mean.null, 
	# validation=nass.models[[i]]$cv.statistics$deviance.mean
	# )
# cat('deviance explained training data',nass.dev.exp.cv[i],'\n')
# # cat('null',calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),'test',calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), test, family='poisson'),'\n')
# nass.dev.exp.test[i] <- dsq(
	# mean.null=calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), rep(1,length(test)), family='poisson'),
	# validation=calc.deviance(as.numeric(nass.spp.data[[i]][test.rows,6]), test, family='poisson')
	# )
# cat('deviance explained test data',nass.dev.exp.test[i],'\n')
# cat('\nend nass',spp.names[i],'############################\n')
# # stop('cbw')