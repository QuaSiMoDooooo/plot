# https://zhuanlan.zhihu.com/p/451974211

rm(list=ls())

genes <- c(rep(paste0("sweet","11"),4), rep(paste0("sweet","12"),4),rep(paste0("sweet","15"),4))
time_h <- rep(c(0,8,12,24), 3)
exp_mean <- runif(12, min = 1, max = 10)
se <- runif(12, 0, 1)

exp_mean[c(7,8)] <- runif(2, min = 120, max = 150)

dt <- data.frame(Gene=genes, Time_h = time_h, Exp_mean = exp_mean, SE = se)

library("ggplot2")
library("ggbreak")
#使用ggplot2绘制柱状图；
#factor()用于将数据从连续型转为离散型（或者称为“因子型”、“分类变量”）;
#"dodge"使组内的柱子“肩并肩”显示；
p<-ggplot(dt,aes(x=Gene,y=Exp_mean,fill=factor(Time_h)))
p1 <- p+geom_bar(position = "dodge",stat = "identity")
p1

#上图柱子间没有间隙,这里将利用position_dodge()增加柱子间隙，
#width参数可更改柱子宽度，dodge()的数值比宽度稍大一点就有了空隙;
#添加误差线，position_dodge(0.6)的数值要与上一步一致，以保持相对于柱子居中;
p2 <- p+geom_bar(position =position_dodge(0.7),
                 width = 0.6,stat = "identity")+
  geom_errorbar(aes(ymin=Exp_mean-SE,ymax=Exp_mean+SE),
                position=position_dodge(0.7),width=0.3,
                colour="gray20",size=0.3)+
  labs(fill = "Time(h)", x = "",
       y = "Expression level(fold change)")
p2

#自定义半透明颜色；
#调整纵轴范围，使柱子底部“切齐”（无空白）；
mycolor <- c("#FF99CC","#99CC00","#FF9999","#FF9900")
p3 <- p2 + scale_fill_manual(values=ggplot2::alpha(mycolor,0.9))+
  scale_y_continuous(limits = c(0, 150),
                     expand=expansion(add = c(0, 5)))  # 0控制离横轴距离，5控制离纵轴单元间隔
p3

#自定义图表主题，对图表主题做精细调整；
top.mar=0.2
right.mar=0.2
bottom.mar=0.2
left.mar=0.2
#设置图例的位置、大小和样式，并对字体样式、坐标轴的粗细、颜色、刻度长度等进行限定；
##这里通过legend.position将图例置于绘图区域的左上方；
mytheme<-theme_classic()+
  theme(text=element_text(family = "sans",colour ="gray30",size = 12),
        legend.text=element_text(colour ="gray30",size = 8),
        legend.title=element_text(colour ="gray30",size = 10),
        legend.key.size=unit(4,units = "mm"),
        legend.position=c(0.10,0.88),
        axis.line = element_line(size = 0.4,colour = "gray30"),
        axis.ticks = element_line(size = 0.4,colour = "gray30"),
        axis.ticks.length = unit(1.5,units = "mm"),
        plot.margin=unit(x=c(top.mar,right.mar,bottom.mar,left.mar),
                         units="inches"))
#应用自定义主题；
p4 <- p3+mytheme
p4

# 添加截断
#这里为y轴添加“break”；
#注意，这里scale_y_break的expand参数数值会影响“断点”的位置；（前面为了：使柱子底部“切齐”，无空白）
p5 <- p2 + scale_y_break(c(15, 110),scales = "fixed",
                         expand=expansion(add = c(0, 5)))
p5

#令scales = "free"或1，使上下两半部分高度相同；
#使用scale_y_continuous定义“断点”之前的标签；
#使用ticklabels参数自定义“断点”之后的标签；
p6 <- p2 + 
  scale_y_continuous(limits = c(0, 150),
                              breaks = c(0,2.5,5,7.5,10,12.5,15),
                              label = c("0","2.5","5","7.5","10","12.5","15"))+
  scale_y_break(c(15, 110),scales = "free",
                ticklabels=c(110,120,130,140,150),
                expand=expansion(add = c(0, 0)))
p6

#应用自定义颜色和主题；
#可以发现图例仍保持在默认的位置，不支持将图例置于绘图区域；
# 干脆取消移动legend

mytheme<-theme_classic()+
  theme(text=element_text(family = "sans",colour ="gray30",size = 12),
        legend.text=element_text(colour ="gray30",size = 8),
        legend.title=element_text(colour ="gray30",size = 10),
        legend.key.size=unit(4,units = "mm"),
        # legend.position=c(0.10,0.88),
        axis.line = element_line(size = 0.4,colour = "gray30"),
        axis.ticks = element_line(size = 0.4,colour = "gray30"),
        axis.ticks.length = unit(1.5,units = "mm"),
        plot.margin=unit(x=c(top.mar,right.mar,bottom.mar,left.mar),
                         units="inches"))

p7 <- p6+scale_fill_manual(values=ggplot2::alpha(mycolor,0.9))+mytheme+
  # 取消右纵坐标元素
  theme(axis.text.y.right = element_blank(),
        axis.line.y.right = element_blank(),
        axis.ticks.y.right = element_blank())
p7

# 保存
ggsave("04_histogram_with_break.png")

# 导出图片为PDF格式的矢量图
ggsave("04_histogram_with_break.pdf")

# 导出图片为PDF格式的矢量图，使用Ai(Adobe illustrator)进行更多细节的调整，比如移动重叠刻度标签的位置，拉长断点处刻度线的长度（也可旋转一定角度），移动图例的位置、将基因名称改为斜体等