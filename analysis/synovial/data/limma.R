if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("limma")
BiocManager::install("affy")
BiocManager::install("hgug4112a.db")

library(limma)
library(affy)
library(hgug4112a.db)
library(clusterProfiler)

g34 <- read.maimages(list.files('data/GSE40025/G34', full.names=T), 
                     source='agilent',
                     green.only = T)

g58 <- read.maimages(list.files('data/GSE40025/G58', full.names=T), 
                     source='agilent',
                     green.only = T)


# https://www.biostars.org/p/287206/
g34bgc <- backgroundCorrect(g34, 
                            method="normexp",
                            normexp.method='rma')

g58bgc <- backgroundCorrect(g58, 
                            method="normexp",
                            normexp.method='rma')

g34norm <-normalizeBetweenArrays(g34bgc,
                                 method="quantile")

g58norm <-normalizeBetweenArrays(g58bgc,
                                 method="quantile")


g34ave <- avereps(g34norm, 
                  ID=g34norm$genes$ProbeName)

g58ave <- avereps(g58norm,
                  ID=g58norm$genes$ProbeName)

# https://www.biostars.org/p/153519/
g34c <- g34ave$genes$ControlType==1
g58c <- g58ave$genes$ControlType==1

g34t <-g34ave[!g34c,]
g58t <-g58ave[!g58c,]

g34g <-g34t$genes$ProbeName
g58g <-g58t$genes$ProbeName

g34s <- bitr(g34g, 
             fromType = "PROBEID",
             toType = "SYMBOL",
             OrgDb = hgug4112a.db,
             drop = FALSE)

g58s <- bitr(g58g, 
             fromType = "PROBEID",
             toType = "SYMBOL",
             OrgDb = hgug4112a.db,
             drop = FALSE)


g34t$genes<-cbind(g34t$genes, g34s)
g58t$genes<-cbind(g58t$genes, g58s)

g34t$genes<-g34t$genes[,c("PROBEID","SYMBOL")]
g58t$genes<-g58t$genes[,c("PROBEID","SYMBOL")]

no_symbol_34 <-is.na(g34t$genes$SYMBOL)
g34t <- g34t[!no_symbol_34,]

no_symbol_58 <-is.na(g58t$genes$SYMBOL)
g58t <- g58t[!no_symbol_58,]


rownames(g34t$E)<-g34t$genes$SYMBOL
write.table(g34t$E, 
            file="SYNOVIAL-ARRAY-GROUP-34.tsv", 
            sep='\t')

rownames(g58t$E)<-g58t$genes$SYMBOL
write.table(g58t$E, 
            file="SYNOVIAL-ARRAY-GROUP-58.tsv", 
            sep='\t')

