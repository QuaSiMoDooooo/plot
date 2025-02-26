rm(list=ls())
setwd("/home/wtian/play_ground/plot/histogram")
load("/home/wtian/play_ground/plot/datasets/others/dm_annsum.Rdata")
ls()
dm_annsum

library(ggplot2)
p1 <- ggplot(dm_annsum, aes(x = annot.type , y = n, fill = cate)) +
  geom_bar(stat = "identity", # fill = rgb(red, green, blue),
           position = position_dodge(width = 0.3), width = 0.8) +
  # 在柱状图的每个柱子上添加数值标签
  geom_text(aes(label = n),position = position_dodge(width = 0.5),vjust=-0.5, size = 3)+
  xlab("Annotation") +
  ylab("Count") +
  ggtitle("methylation sites annotated") +
  #调整纵轴范围，使柱子底部“切齐”（无空白）；
  scale_y_continuous(expand=expansion(add = c(0, 1)), limits = c(0,max(dm_annsum$n)+3000000)) +
  # 0控制离横轴距离，1控制离纵轴单元间隔
  expand_limits(y = c(0)) +
  scale_fill_manual(values = c("cpg" = "#00215E", "gene" = "#FFC55A")) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    panel.border = element_rect(color = "black", size = 1, linetype = "solid"),
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 24, margin = margin(r = 10)),
    axis.text.x = element_text(size=10,angle = 45, vjust = 0.5, hjust = 1, margin = margin(t = -40)),  # 拉近横坐标标签和坐标距离
    axis.text.y = element_text(size=10),
    plot.margin = unit(c(1,1,3,1),"lines"),  # 增加图下边缘
    legend.text = element_text(size = 12)  # 调整图例字体大写
  )
p1

# 保存
ggsave("./03_multi_annot_cpg_gene.png",width = 8,height = 6,units = "in")
