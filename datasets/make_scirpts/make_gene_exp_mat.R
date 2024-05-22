# 设置随机数种子以获得可重现的结果
set.seed(123)
setwd("/home/wtian/play_ground/plot/datasets/make_scirpts")
# 构造模拟数据
# 假设我们有30个样本和100个变量
n_samples <- 30
n_variables <- 100

# 创建一个数据框，其中包含随机生成的数据
data <- data.frame(matrix(runif(n_samples * n_variables), ncol = n_variables))
colnames(data) <- paste("Variable", 1:n_variables, sep = "_")
rownames(data) <- paste("Sample", 1:n_samples, sep = "_")

# 打印数据框的前几行和列名
data[1:4,1:4]
beta.m = t(as.matrix(data))
beta.m[1:4,1:4]
dim(beta.m)

# 构造分组信息
# 假设我们有2个不同的组
group_id = data.frame(id=colnames(beta.m), Group=rep(c("Group1", "Group2"), each=15))
group_id

# 保存beta.m和group_id变量到Rdata文件
save(beta.m, group_id, file="../gene_exp_mat_with_group.Rdata")

# # 检查可用性
# dat = t(beta.m)
# group_list = group_id$Group
# library("FactoMineR")#画主成分分析图需要加载这两个包
# library("factoextra") 
# dat.pca <- PCA(dat , graph = FALSE)
# pdf("gene_exp_mat_with_group.pdf")
# fviz_pca_ind(dat.pca,
#              geom.ind = "point", # show points only (nbut not "text")
#              col.ind = group_list, # color by groups
#              palette = c("#102C57", "#E7B800"),
#              addEllipses = TRUE, # Concentration ellipses
#              legend.title = "Groups"
# )
# dev.off()
