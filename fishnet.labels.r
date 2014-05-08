
library(foreign)

# Fishnet labels

the.table <- read.dbf('Z:/Chicago_Grasslands/MAPS/fishnet_5km.dbf')

the.letters <- LETTERS[1:23]

the.labels <- paste(rep(the.letters,31),rev(rep(seq(1,31,1),each=23)),sep='')
print(the.labels)
#stop('cbw')
the.table$LABELS <- the.labels
write.dbf(the.table, 'Z:/Chicago_Grasslands/MAPS/fishnet_5km.dbf')