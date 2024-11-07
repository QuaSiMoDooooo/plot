library(tidyverse)
library(data.table)

# 过滤前
meth_df= fread("/home/wtian/project/HZAU_cohort_meth/01_methylation_identify/03_150_samples/01_150_sample_merge_result_noSci.tsv", 
            sep="\t")
meth_df[1:4,1:4]
dim(meth_df)

# 过滤后
meth_flt = fread("02_sites_MissRate_0.1_flt_meth.tsv", sep="\t")
meth_flt[1:4,1:4]
dim(meth_flt)

# 统计过滤前后每条染色体上的位点数量
meth_df_counts = meth_df %>% 
  group_by(chr) %>% 
  summarise(n=n())
meth_flt_counts = meth_flt %>%
  group_by(chr) %>% 
  summarise(n=n())

# 指定染色体顺序
ind_chr = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY","chrM")
meth_df_counts = meth_df_counts[match(ind_chr, meth_df_counts$chr),]
meth_flt_counts = meth_flt_counts[match(ind_chr, meth_flt_counts$chr),]
# 按照染色体顺序合并
meth_counts = left_join(meth_df_counts, meth_flt_counts, by="chr")
meth_counts = as.data.frame(meth_counts)
meth_counts
# NA填为0
meth_counts[is.na(meth_counts)] = 0
colnames(meth_counts) = c("chr","all","flt")
write.table(meth_counts, "04_chr_counts_stats.tsv", sep="\t", quote=F, row.names=F)

# 计算一列被过滤的位点数量
meth_counts$drp = meth_counts$all - meth_counts$flt
meth_counts

data = meth_counts %>% select(chr, flt, drp)
colnames(data) = c("chr", "pass", "drop")
data
# 宽数据转长数据
data_long = data %>% pivot_longer(cols = -chr, names_to = "type", values_to = "count")
data_long
data_long$chr = factor(data_long$chr, levels = ind_chr)
# 绘制堆积柱形图
p = ggplot(data = data_long, aes(x=chr,y=count,fill=type))+
    geom_bar(stat = "identity",position = "stack") +
    labs(x = NULL, y = "Number of methylation sites",fill = "Type",) +
    scale_y_continuous(limits = c(0, 2500000),expand = c(0, 0)) + # 设置y轴的扩展为0，去除空白
    theme_bw() +
    theme(
    panel.grid = element_blank(),  # 去除主要网格线
    axis.title.y = element_text(size = 20),  # 设置y轴标题大小
    axis.text.x = element_text(size = 14, angle = 45, hjust = 1),   # 设置x轴标签大小
    axis.text.y = element_text(size = 16),   # 设置y轴标签大小
    legend.title = element_text(size = 18),  # 设置图例标题大小
    legend.text = element_text(size = 16),    # 设置图例文字大小
    plot.margin = margin(t = 20, r = 10, b = 10, l = 10, unit = "pt")  # 设置边距
  )

# 保存
ggsave("04_chr_counts_stats.pdf", p, width = 12, height = 8)

