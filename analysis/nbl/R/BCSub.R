install.packages('BCSub')

library(BCSub)
library(data.table)

pth <- 'hydra-analysis/paper/Fig3/data/target-high-risk-nbl-mycn-na-exp-2018-11-12.tsv'
exp <- read.table(pth, sep='\t', header=T, row.names=1)
texp <- transpose(exp)

ev = eigen(cor(texp))
ap = parallel(subject=nrow(texp),
              var=ncol(texp),
              rep=100,
              cent=0.05)
nS = nScree(x=ev$values,
            aparallel=ap$eigen$qevpea)
M = nS$Components[1,3]
M
