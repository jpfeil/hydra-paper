library(M3C)
library(cluster)
library(factoextra)

setwd("/home/jpfeil/code/hydra-analysis/SFig4/")
pth <- 'data/TARGET-osteosarcoma-2019-02-02.tsv'
d <- read.table(pth, 
                sep='\t', 
                header=T, 
                row.names = 1)
d

res <- M3C(d, cores=8, seed=123)
res$scores

pth1 <- 'data/OSTEO-M3C-scores.tsv'
write.table(res$scores, file = pth1, sep='\t')

mads=apply(d,1,mad)
d2=d[rev(order(mads))[1:5000],]
d2 = sweep(d2,1, apply(d2, 1, median, na.rm=T))
dim(d2)

res2 <- M3C(d2, cores=8, seed=123, removeplots=TRUE)
res2$scores

pth2 <- 'data/OSTEO-M3C-MAD-5000-scores.tsv'
write.table(res2$scores, file = pth2, sep='\t')

# GAP statistic 
kgap <- clusGap(t(d2), FUN=kmeans, K.max=10, B=500)
fviz_gap_stat(kgap)
