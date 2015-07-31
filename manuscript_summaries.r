
sink('d:/chicago_grasslands/models/train_test_counts_v36.txt')
cat(spp.names,'\n')
for (i in letters[1:20]) { load(file=paste('d:/chicago_grasslands/models/test.set.v36',i,'.rdata',sep='')); cat(unlist(lapply(test.set,length)),'\n') }
sink()

