library(tidyverse)

setwd("/home/wtian/play_ground/plot/histogram")

dat <- read.table("/home/wtian/play_ground/plot/datasets/others/gaps_stats.csv",header = TRUE,sep = ",")
spec_order <- c(paste0("Chr",seq(1,22)),"ChrX","ChrY","ChrM")
dat$assignment <- factor(dat$assignment, levels=spec_order)

col1 <- c(128,179,106)
col1_rgb <- col1/255
red <- col1_rgb[1]
green <- col1_rgb[2]
blue <- col1_rgb[3]

p1 <- ggplot(dat, aes(x = assignment, y = gaps)) +
  geom_bar(stat = "identity", fill = rgb(red, green, blue),
           position = position_dodge(width = 0.3), width = 0.8) +
  # 在柱状图的每个柱子上添加数值标签
  geom_text(aes(label = gaps),position = position_dodge(width = 0.5),vjust=-0.5)+
  # xlab("Chromosome") +
  ylab("number of gaps") +
  ggtitle("Assembly situation") +
  #调整纵轴范围，使柱子底部“切齐”（无空白）；
  scale_y_continuous(limits = c(0, 14), breaks = seq(0, 14, by = 1),
                     expand=expansion(add = c(0, 1))) +
                     # 0控制离横轴距离，1控制离纵轴单元间隔
  expand_limits(y = c(0)) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    panel.border = element_rect(color = "black", size = 1, linetype = "solid"),
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 24, margin = margin(r = 10)),
    axis.text.x = element_text(size=12,angle = 45, vjust = 0.5, hjust = 1, margin = margin(t = -10)),
    axis.text.y = element_text(size=12),
    plot.margin = unit(c(1,1,2,1),"lines")
  )
p1

# 保存
ggsave("01_02_gaps_stats.png",width = 10,height = 5,units = "in")
