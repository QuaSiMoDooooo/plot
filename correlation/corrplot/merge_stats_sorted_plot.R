suppressPackageStartupMessages(library(tidyverse))
library(corrplot)
setwd("/home/wtian/play_ground/plot/correlation/corrplot")

data = read.table("/home/wtian/play_ground/plot/datasets/others/merge_stats_sorted.tsv", header = T, sep = "\t")
head(data)
# 需要是所有对的数据，包括双向和自身结果

data = select(data,File1,File2,Merge_Rate)
head(data)
colnames(data) = c("tissue1","tissue2","Merge_Rate")

# 长数据变宽数据
data_wide = spread(data, tissue2, Merge_Rate)
data_wide
dim(data_wide)
rownames(data_wide) = data_wide$tissue1
data_wide = select(data_wide,-tissue1)
data_wide

mat = as.matrix(data_wide)
dim(mat)

# 画图
# pdf("corrplot.pdf", width = 8, height = 8)
png("merge_stats_sorted_heatmap.png", width = 800, height = 800)
corrplot(mat, method = c('color'), type = c('lower'), 
        outline = 'grey', #是否为图形添加外轮廓线，默认FLASE，可直接TRUE或指定颜色向量
        order = c('original'), #排序/聚类方式选择："original", "AOE", "FPC", "hclust", "alphabet"
        tl.cex = 1.5, #文本标签大小
        tl.col = 'black', #文本标签颜色
        addgrid.col= 'grey', #格子轮廓颜色
        addCoef.col = 'black', #在现有样式中添加相关性系数数字，并指定颜色
        number.cex = 1, #相关性系数数字标签大小
        cl.cex = 1.5, #颜色条标签大小
        col = colorRampPalette(c("#06a7cd", "white", "#e74a32"), alpha = TRUE)(100),
        diag = FALSE, #是否展示对角线结果，默认TRUE
        is.corr = FALSE  # important: is.corr=FALSE用于创建一个非相关性图，diag=FALSE用于删除图中的对角线。这将创建一个图例范围为标准正态分布的百分位数。
)
# 关闭设备，保存文件
dev.off()


