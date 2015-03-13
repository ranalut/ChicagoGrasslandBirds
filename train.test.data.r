
# Identify Test Data Records

create.test.data <- function(row.numbers, proportion, file.name)
{
	n <- ceiling(proportion * length(row.numbers))
	test.rows <- sample(row.numbers,size=n)
	write(test.rows, file=file.name)
	# return(test.rows)
}

# Drop test rows from full row list
drop.test.rows <- function(row.numbers, test.rows)
{
	temp <- row.numbers %in% test.rows
	output <- row.numbers[temp==FALSE]
	return(output)
}

grid.train.test <- function(rows, cells, k)
{
	# print(class(rows)); print(class(cells))
	prop <- 1/k
	output <- list()
	all.cells <- unique(cells)
	# print(all.cells)
	target <- floor(prop * length(rows))
	
	for (i in 1:k)
	{
		set <- NA
		while (length(set)<target & length(all.cells)>1)
		{
			pick <- sample(all.cells,1)
			set <- c(set,rows[cells==pick])
			all.cells <- all.cells[-match(pick,all.cells)]
			# cat(length(all.cells),'\n')
		}
		output[[i]] <- set[-1]
		# return(output)
		# print(output[[i]])
	}
	return(output)
}

psuedo.prev <- function(x)
{
	x[x>0] <- 1
	return(mean(x))
}

grid.train.test.prev <- function(rows, cells, prop, counts)
{
	# print(class(rows)); print(class(cells))
	all.prev <- psuedo.prev(counts)
	train.prev <- all.prev
	cat('prevalence =',all.prev,'\n')
	test <- 1
	
	# while (test > train.prev | test < (train.prev-0.025))
	while (test > (train.prev+0.02) | test < (train.prev-0.02))
	{
		all.cells <- unique(cells)
		cell.prev <- NA
		for (i in 1:length(all.cells))
		{
			cell.prev[i] <- psuedo.prev(counts[all.cells==all.cells[i]])
		}
		# print(cell.prev)
		# weights <- 1 - (abs(cell.prev-all.prev)) # weighting cells by how closely their prevalence is to the dataset's prevalence. Would pull cells with a mix if habitat.
		# # weights <- weights/max(weights)
		# print(all.cells); print(weights)
		target <- floor(prop * length(rows))
		
		set <- NA
		while (length(set)<target & length(all.cells)>1)
		{
			pick <- sample(all.cells,1) # ,prob=weights)
			set <- c(set,rows[cells==pick])
			# weights <- weights[-match(pick,all.cells)]
			all.cells <- all.cells[-match(pick,all.cells)]
			# cat(length(all.cells),length(weights),'\n')
		}
		output <- set[-1]
		test <- psuedo.prev(counts[output])
		train.prev <- psuedo.prev(counts[-output])
		# cat('test prevalence =',test,'\n')
	}
	cat('train prevalence =',train.prev,'test prevalence =',test,'\n')
	# print(output[[i]])
	return(output)
}


