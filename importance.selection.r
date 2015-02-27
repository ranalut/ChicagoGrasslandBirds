# importance.selection
cat('Number of models in which variable importance > random\n')
for (k in 1:10)
{
	imp <- read.csv(paste('d:/chicago_grasslands/models/nass.models.importance.v32.',k,'.csv',sep=''),row.names=2)
	imp <- imp[,-c(1,7)]
	imp <- imp[order(rownames(imp)),]
	if (k==1) { output <- imp; output[output>0] <- 0 }
	ref <- imp['unif',]
	
	for (j in 1:dim(output)[1])
	{
		output[j,] <- output[j,] + as.numeric(imp[j,] > ref)
	}
	
	# print(output)
	# stop('cbw')
}

print(output)

var.in <- list()
for (i in 1:5)
{
	var.in[[i]] <- rownames(output)[output[,i] > 5]
}

print(var.in)
save(var.in,file='d:/chicago_grasslands/models/nass.models.var.v32.rdata')
