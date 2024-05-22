# 获取beta.m和group_id
rm(list=ls())
setwd("/home/wtian/play_ground/plot/heatmap")
load("/home/wtian/play_ground/plot/datasets/gene_exp_mat_with_group.Rdata")
ls()

dat=beta.m
group_list=group_id$Group
dat[1:4,1:4] 
cg=names(tail(sort(apply(dat,1,sd)),50))#apply按行（'1'是按行取，'2'是按列取）取每一行的方差，从小到大排序，取最大的1000个

library(pheatmap)

n=t(scale(t(dat[cg,]))) # 'scale'可以对log-ratio数值进行归一化
n[n>2]=2 
n[n< -2]= -2
n[1:4,1:4]

ac=data.frame(group=group_list)
rownames(ac)=colnames(n)  
group_colors <- list(group = c("Group1" = "#102C57", "Group2" = "#E7B800"))  # group名称与ac列名一致

# 绘制热图，使用annotation_colors参数指定颜色
pheatmap(n, show_colnames = FALSE, show_rownames = FALSE,
         cluster_rows = FALSE,
         annotation_col = ac, 
         annotation_colors = group_colors,  # 指定颜色
         filename = '01_heatmap_top50_sd.png')
