if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("eisa")


library(eisa)

exp <- read.table("Fig3/data/target-high-risk-nbl-mycn-na-exp-2018-11-12.tsv",
                   sep='\t',
                   header=T,
                   row.names=1)



