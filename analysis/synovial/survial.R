library(dplyr)
library(survival)
library(survminer)
library(glmnet)

p1 <- 'data/micro-34-survival-data.tsv'
d1 <- read.table(p1, sep='\t', header=T)
d1 <- as_tibble(d1)
head(d1)

f1 <- survfit(Surv(time, metastasis) ~ cluster, data=d1)
ggsurvplot(f1, conf.int=F, pval=T, risk.table=TRUE)


p2 <- 'data/micro-58-survival-data.tsv'
d2 <- read.table(p2, sep='\t', header=T)
d2 <- as_tibble(d2)
head(d2)

fit2 <- survfit(Surv(time, metastasis) ~ cluster, data=d2)
ggsurvplot(fit2, conf.int=F, pval=T, risk.table=TRUE)

d3 <- bind_rows(d1, d2)

d3

fit3 <- survfit(Surv(time, metastasis) ~ cluster, data=d3)
ggsurvplot(fit3, conf.int=F, pval=T, risk.table=TRUE)

