# 获取beta.m和group_id
rm(list=ls())
setwd("/home/wtian/play_ground/plot/PCA")
load("/home/wtian/play_ground/plot/datasets/gene_exp_mat_with_group.Rdata")
ls()

dat = t(beta.m)
group_list = group_id$Group
library("FactoMineR")#画主成分分析图需要加载这两个包
library("factoextra") 
dat.pca <- PCA(dat , graph = FALSE)
pdf("01_pca.pdf")
fviz_pca_ind(dat.pca,
             geom.ind = "point", # show points only (nbut not "text")
             col.ind = group_list, # color by groups
             palette = c("#102C57", "#E7B800"),
             addEllipses = TRUE, # Concentration ellipses
             legend.title = "Groups"
)
dev.off()
