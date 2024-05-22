# 获取beta.m和group_id
rm(list=ls())
setwd("/home/wtian/play_ground/plot/heatmap")
load("/home/wtian/play_ground/plot/datasets/gene_exp_mat_with_group.Rdata")
ls()

exprSet=beta.m
group_list=group_id$Group

# 组内的样本的相似性应该是要高于组间的！
colD=data.frame(group_list=group_list)
rownames(colD)=colnames(exprSet)

group_colors <- list(group_list = c("Group1" = "#102C57", "Group2" = "#E7B800"))  # group名称与ac列名一致
pheatmap::pheatmap(cor(exprSet),
                   annotation_col = colD,
                   annotation_colors = group_colors,  # 指定颜色
                   show_rownames = F,show_colnames = F,
                   filename = '02_cor_all.png')
