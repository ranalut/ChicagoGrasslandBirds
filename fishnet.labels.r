
library(foreign)

# Fishnet labels

the.table <- read.dbf('Z:/Chicago_Grasslands/MAPS/fishnet_5km.dbf')

the.letters <- paste(letters[1],letters[1],sep='')
for (i in 2:5) { the.letters <- c(the.letters, paste(letters[i],letters[i],sep='')) }
the.letters <- c(letters, the.letters)
print(the.letters)

the.labels <- paste(rep(seq(1,23,1),31),rev(the.letters),sep='')
print(the.labels)
stop('cbw')

write.dbf(the.table, 'Z:/Chicago_Grasslands/MAPS/fishnet_5km.dbf')