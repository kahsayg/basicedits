#!/usr/bin/Rscript

file='groupingscript/data.txt'
ngroups=6
column2group=2
columnsampleid=1
outname='groupingscript/test'

createGroups <- function(file,ngroups,column2group,columnsampleid,outname){
  dat <- read.table(paste(file),header=T)
  groupids <- as.vector(unique(dat[,column2group]))
  groupids <- groupids[!is.na(groupids)]
  for(s in 1:length(groupids)){
    idanim <- data.frame(ID=dat[which(dat[,column2group]==groupids[s]),columnsampleid])
    idanim$grpNr <- rep(1:ngroups,length.out=nrow(idanim))
    idanim$grpID <- groupids[s]
    if(s==1){groupscreated <- idanim} else {groupscreated <- rbind.data.frame(groupscreated,idanim,stringsAsFactors=F)}
  }
  write.table(groupscreated,paste(outname,'.txt',sep=''),quote=F,row.names=F)
  return(groupscreated)
}


newgrp <- createGroups(file,ngroups,column2group,columnsampleid,outname)

