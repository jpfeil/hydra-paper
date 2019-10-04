if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

library(GEOquery)

g34 <- getGEO("GSE40018")

g58 <- getGEO("GSE40021")

g34

write.table(pData(phenoData(g34)), 
            file='pdata-group-34.tsv', 
            sep='\t')

write.table(pData(phenoData(g58)), 
            file='pdata-group-58.tsv', 
            sep='\t')

typeof(group1)

m <- exprs(group1)
m

gsmplatforms <- lapply(GSMList(group1), 
                       function(x) {Meta(x)$platform_id})
