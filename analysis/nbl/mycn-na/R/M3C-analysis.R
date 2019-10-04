#install.packages("factoextra")

library(M3C)
library(cluster)
library(factoextra)
library(NB)

set.seed(123)

pth <- 'data/target-high-risk-nbl-mycn-na-exp-2018-11-12.tsv'
d <- read.table(pth, 
                sep='\t', 
                header=T, 
                row.names = 1)
head(d)

res <- M3C(d, cores=8, seed=123)
res$scores

pth1 <- 'data/cluster-analysis/MYCN-NA-M3C.tsv'
write.table(res$scores, file = pth1, sep='\t')

mads=apply(d, 1, mad)

m3c <- function(thresh, k){
  filt = d[rev(order(mads))[1:thresh], ]
  filt = sweep(filt, 
               1, 
               apply(filt, 1, median, na.rm=T))
  res <- M3C(filt, cores=8, seed=123)
  write.table(res$scores, 
              file=paste('data/cluster-analysis/MYCN-NA-M3C-MAD-', thresh, '.tsv', sep = ''),
              sep='\t')
  write.table(res$realdataresults[[k]]$ordered_annotation,
              file=paste('data/cluster-analysis/MYCN-NA-M3C-MAD-', thresh, '-labels-', k, '.tsv', sep = ''),
              sep='\t')
  return(res)
}

gapstat <- function(thresh, k){
  set.seed(123)
  filt = d[rev(order(mads))[1:thresh], ]
  filt = sweep(filt, 
               1, 
               apply(filt, 1, median, na.rm=T))
  
  kgap <- clusGap(t(filt), FUN=kmeans, K.max=10)
  kmeans <- kmeans(t(filt), centers = k)
  write.table(kmeans$cluster,
              file=paste('data/cluster-analysis/MYCN-NA-GAP-MAD-', thresh, '-labels-', k, '.tsv', sep = ''),
              sep='\t')
  
  return(kgap)
}

### 5000 MAD ###
res5000 <- m3c(5000, 2) # Confirmed
res5000$scores

## GAP 5000 statistic ## 
kgap5000 <- gapstat(5000, 1) # Confirmed
fviz_gap_stat(kgap5000)

### 2500 MAD ###
res2500 <- m3c(2500, 2) # Confirmed
res2500$scores

## GAP 2500 statistic ## 
kgap2500 <- gapstat(2500, 2) # Confirmed
fviz_gap_stat(kgap2500)

### 1000 MAD ###
res1000 <- m3c(1000, 2) # Confirmed
res1000$scores

## GAP 1000 statistic ## 
kgap1000 <- gapstat(1000, 2) # Confirmed
fviz_gap_stat(kgap1000)

### 500 MAD Genes ###
res500 <- m3c(500, 3) # Confirmed
res500$scores

# GAP statistic 
kgap500 <- gapstat(500, 2) # Confirmed
fviz_gap_stat(kgap500)

### 100 MAD Genes ###
res100 <- m3c(100, 5) # Confirmed 
res100$scores

# GAP statistic 
kgap100 <- gapstat(100, 6) # Confirmed
fviz_gap_stat(kgap100)
