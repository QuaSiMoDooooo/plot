rm(list=ls())
library(vroom)
library(ggplot2)
options(scipen = 999)
setwd("/home/wtian/project/HZAU_cohort_meth/01_methylation_identify/01_methylation_cohort_test")
data = vroom("01_sample_merge_result.tsv")
dim(data)

data_noNA = data[complete.cases(data),]
dim(data_noNA)
write.table(data_noNA,"/home/wtian/project/HZAU_cohort_meth/01_methylation_identify/02_common_meth_sites/01_sample_merge_sites_common.tsv",col.names = TRUE,row.names = FALSE,sep = "\t",quote = FALSE)


sites_common = data_noNA[,c(1,2,3)]
write.table(data_noNA,"./sites_common.bed",col.names = FALSE,row.names = FALSE,sep = "\t",quote = FALSE)


data_vec = as.numeric(unlist(matrix(data_noNA[,-c(1:3)])))
# 去除向量中的NA，ggplot2绘制值的分布直方图

df = data.frame(values = data_vec)
# 绘制分布直方图
# hist 统计 非bar
ggplot(df, aes(x = values)) +
  geom_histogram(binwidth = 2,fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  expand_limits(y=c(0))+
  scale_y_continuous(limits = c(0, 20000000),breaks = seq(0, 20000000, by=5000000), expand = expansion(c(0,0))) +
  # expansion(c(0,0)) 否则limits设置的最大刻度会膨胀
  scale_x_continuous(breaks = seq(0,100,by=20)) +
  labs(x = "% methylation per base", y = "Frequency") +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    # 去除标题
    plot.title = element_blank(),
    # 放大 x 轴和 y 轴的标题字体大小
    axis.title.x = element_text(size = 20),
    axis.title.y = element_text(size = 20),
    # 放大 x 轴和 y 轴的刻度标签字体大小
    axis.text.x = element_text(size = 18),
    axis.text.y = element_text(size = 18)
  )
# 保存
ggsave("02_cohort_distribution_histogram.png", width = 8, height = 6)
# pdf
ggsave("02_cohort_distribution_histogram.pdf", width = 8, height = 6)
