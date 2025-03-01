suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(FactoMineR))
suppressPackageStartupMessages(library(factoextra))
suppressPackageStartupMessages(library(vroom))
suppressPackageStartupMessages(library(ggrepel))

rm(list=ls())
setwd("/home/wtian/project/HZAU_cohort_meth/01_methylation_identify/03_150_samples")
data = data.frame(vroom("03_150_sample_common_sites.tsv"))
dim(data)
# 行为样本，列为甲基化
data1 = as.data.frame(t(data[,seq(4,ncol(data))]))
colnames(data1) = paste(data$chr,data$start,data$end,sep="_")

# 读取表型信息
pheno = read.table("/home/wtian/project/HZAU_cohort_meth/pheno/150_samples/01_merged_pheno.tsv",
                    header=T,sep="\t",stringsAsFactors=F)
# pheno根据id列在data1的行名中的顺序排序
data1 = data1[match(pheno$id,rownames(data1)),]

# PCA
dat = data1
dat[1:4,1:4]
dat$group_list = ifelse(pheno$sex == "男","male","female")
dim(dat)
dat_pca <- PCA(dat[,-ncol(dat)], graph = FALSE)#画图仅需数值型数据，去掉最后一列的分组信息

p <- fviz_pca_ind(dat_pca,
                     geom.ind = "point", # 只显示点，不显示文字
                     pointsize = 3.5,
                     col.ind = dat$group_list, # 用不同颜色表示分组
                     # col.ind = group_list1,
                     palette = c("#D76119","#224E70","orange"),
                     addEllipses = T, # 是否圈起来，少于4个样圈不起来
                     legend.title = "Groups") + 
                     coord_cartesian(xlim = c(-800, 800), ylim = c(-400, 650))+
                     labs(title = element_blank()) +
                     theme_bw() +
                     theme(
                        axis.title = element_text(size = 18), # 放大坐标轴标题文字, # 放大坐标轴标题文字
                        axis.text = element_text(size = 16), # 放大坐标轴刻度文字
                        legend.title = element_text(size = 18), # 放大图例标题文字
                        legend.text = element_text(size = 16), # 放大图例文字
                        legend.position = c(0.85, 0.15)) # 右下角
                     # ggtitle("PCA plot of shared methylation sites") +
                     # theme(plot.title = element_text(size = 20, hjust = 0.5)
ggsave("04_common_sites_pca.pdf",p,width=6,height=6)
