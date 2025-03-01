rm(list=ls())
library(vroom)
library(tidyverse)
options(scipen = 999)
setwd("/home/wtian/project/HZAU_cohort_meth/01_methylation_identify/01_methylation_cohort_test")

data = vroom("01_sample_merge_result.tsv")
# dim(data)

# 使用共有位点
data_noNA = data[complete.cases(data),]
data_vec = as.numeric(unlist(matrix(data_noNA[,-c(1:3)])))
range(data_vec)
# 去除向量中的NA，ggplot2绘制值的分布直方图

hist用bar画法
# 每隔5计算一下百分比
# 定义分组breaks
breaks = seq(0, 100, by = 5)
groups = cut(data_vec, breaks = breaks, right = FALSE)
# 统计各分组的频数
freq <- table(groups)
# 计算各分组的占比
proportion <- freq / sum(freq)

df = data.frame(proportion.groups = as.factor(seq(0, 100, by = 5)), 
               proportion.Freq = c(round(proportion*100,2),0))
df
rownames(df) = NULL
dim(df)
df

# 绘制分布直方图
# hist用bar画法
source("https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/wdy_theme.r")
ggplot(df, aes(x = proportion.groups, y = proportion.Freq)) +
  geom_bar(stat = "identity", width = 1, fill = "#8ED0CA", color="black", position = position_nudge(x = 0.5)) +
  # "identity" 表示直接使用数据中的值作为柱子的高度，而不是对数据进行计数（默认情况下 geom_bar() 会对数据进行计数）。
  # position_nudge(x = 0.5) 表示将柱子向右移动0.5个比例单位
  # 在柱状图的每个柱子上添加数值标签
  geom_text(size=3,fontface="bold",aes(label = proportion.Freq),position = position_nudge(x = 0.5), vjust=-0.5)+
  # vjust=-0.5 表示将标签向上移动0.5个比例单位，使其位于柱子的顶部
  scale_y_continuous(limits = c(0,max(df$proportion.Freq)+5), expand = expansion(c(0,0))) +
    expand_limits(y=c(0))+
  # expansion(c(0,0)) 否则limits设置的最大刻度会膨胀
  labs(x = "% methylation per base", y = "Frequency") +
  wdy_theme() + 
  theme(panel.border = )

# pdf
ggsave("02_cohort_distribution_histogram.pdf", width = 8, height = 6)
# 后续ai调整
