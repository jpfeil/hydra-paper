library(utils)
rforge <- "http://r-forge.r-project.org"
install.packages("estimate", repos=rforge, dependencies=TRUE)

library('estimate')

pth <- 'data/treehouse-synovial-log2TPM1-V9.tsv'
oth <- 'data/treehouse-synovial-log2TPM1-V9.estimate'

filterCommonGenes(input.f=pth,
                  output.f=oth,
                  id='GeneSymbol')

oth2 <- 'data/treehouse-synovial-log2TPM1-V9.estimate.gct'
df = estimateScore(oth, oth2, platform='illumina')

