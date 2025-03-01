library(dplyr)
library(data.table)
setwd("/home/wtian/project/HZAU_cohort_meth/05_extra_database/methbank/01_comp_CRMs/")

crm_path = "/home/wtian/data/meth/methbank4.0/whole_blood_850K.txt.gz"
crm_df = fread(crm_path, data.table = F, header = T, sep = "\t")
dim(crm_df)  # [1] 866836   1099
crm_df[1:4,1:4]
# 计算所有样本平均值
crm_df$average_level = rowMeans(crm_df[,2:ncol(crm_df)], na.rm = T)
head(crm_df$average_level)
# 按照 0.3 0.7 划分等级水平
crm_df$level = ifelse(crm_df$average_level > 0.7, "high", ifelse(crm_df$average_level < 0.3, "low", "medium"))
crm_level = crm_df[,c("probe","average_level","level")]
head(crm_level)
colnames(crm_level) = c("probe_id","crm_average_level","crm_level")

data = fread("meth_cpg_148.tsv",data.table = F, header = T, sep = "\t")
data[1:4,1:4]
data$average_level = rowMeans(data[,2:ncol(data)], na.rm = T)
data$level = ifelse(data$average_level > 0.7, "high", ifelse(data$average_level < 0.3, "low", "medium"))
data = data[,c("methid","average_level","level")]
head(data)

methloc = fread("methloc.tsv",data.table = F, header = T, sep = "\t")
methloc[1:4,]
methloc$meth = paste(methloc$chr, methloc$right, sep = ":")
# 根据mnethid获得meth
merge_df = left_join(data, methloc[,c("methid","meth")], by = "methid")
head(merge_df)

meth2cpg = fread("merge_manifest.hg38.tsv",data.table = F, header = T, sep = "\t")
meth2cpg[1:4,]
meth2cpg$meth = paste(meth2cpg$chr, meth2cpg$hg38_start, sep = ":")
meth2cpg = meth2cpg[,c("meth","probe_id")]
# 根据meth获得probe
merge_df = merge_df %>% left_join(meth2cpg, by = "meth")
head(merge_df)
table(merge_df$level)
#   high    low medium 
# 237162  96201  45250 

# 检查
table(is.na(merge_df$probe_id))
table(is.na(merge_df$meth))

# 保存
fwrite(crm_level, "01_crm_cpg_average_level.tsv", sep = "\t", quote = F, row.names = F)
fwrite(merge_df, "01_hzau_cpg_average_level.tsv", sep = "\t", quote = F, row.names = F)

# 读取
crm_level = fread("01_crm_cpg_average_level.tsv",data.table = F, header = T, sep = "\t")
merge_df = fread("01_hzau_cpg_average_level.tsv",data.table = F, header = T, sep = "\t")

# 根据probe_id和crm比较
merge_df2 = merge_df %>% left_join(crm_level, by = "probe_id")
head(merge_df2)
table(merge_df2$crm_level)
#   high    low medium 
# 143000 111398 112760 
# 较平均
table(merge_df2$level)
#   high    low medium 
# 237162  96201  45250 
# 偏向高甲基化 和globalpattern 一致


# 一致性绘图

source('https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/wdy_theme.r')
# 散点图
library(ggpubr)
library(gridExtra)
library(tidyverse)
p1 <- ggscatter( merge_df2, x = "average_level", y = "crm_average_level",
           add = "reg.line", conf.int = TRUE,
           size = 2, alpha = 0.03, shape = 16, stroke = 0, # 设置点的形状为圆形，边框宽度为0
           add.params = list(color = "#B3C8CF", fill = "black"))+
  stat_cor(size = 3.6)+ # 增大注释文字大小
  wdy_theme() +
  theme(
    axis.title.x = element_text(size = 14), # 增大横坐标标签文字大小
    axis.title.y = element_text(size = 14), # 增大纵坐标标签文字大小
    axis.text = element_text(size = 14, face = "bold"), # 增大坐标轴刻度文字大小
  ) + 
  labs(x = "Methylation level of the cohort", y = "Methylation level of the CRMs") # 设置横纵坐标标签
p2 <- ggplot(merge_df2, aes(average_level)) +
  geom_density(fill = "#EBB08C") +
  theme_void()
p3 <- ggplot(merge_df2, aes(crm_average_level)) +
  geom_density(fill = "#90A6B7") +
  coord_flip() +
  theme_void()
library(patchwork)
empty_plot <- plot_spacer()
f = c("AAAAD
       BBBBC
       BBBBC
       BBBBC
       BBBBC")
p2+p1+p3+ empty_plot + plot_layout(design = f)
# 保存为pdf
ggsave("01_cor_scatter.pdf", width = 10, height = 10, units = "cm")
# 和ai里面的尺寸一致
# 字符设置size为14



ggplot(merge_df2, aes(x=average_level, y=crm_average_level) ) +
  stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
  scale_fill_distiller(palette= "Spectral", direction=-1) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(
    legend.position='none'
  )