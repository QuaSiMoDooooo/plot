library(tidyverse)
library(data.table)
setwd("/home/wtian/play_ground/plot/histogram")
meth_counts= fread("/home/wtian/play_ground/plot/datasets/others/chr_counts_stats.tsv", 
            sep="\t")

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
ggsave("05_stack_chr_counts_stats.pdf", p, width = 12, height = 8)

