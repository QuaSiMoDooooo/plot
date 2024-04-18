# https://mp.weixin.qq.com/s/g9IoL5H7EWypLOxRByVKEg
setwd("/home/wtian/play_ground/plot/scatter")

library(ggpubr)
library(gridExtra)

set.seed(14)
gene1 = rnorm(100,sd = 18)
gene2 = gene1 + runif(100,min = 10,max = 50)
dat <- data.frame(gene1 = gene1, 
                  gene2 = gene2)
head(dat)

p1 <- ggscatter( dat, x = "gene1", y = "gene2",
           add = "reg.line", conf.int = TRUE,
           add.params = list(color = "#B3C8CF", fill = "lightgray"))+
  stat_cor()+
  theme_bw()

p2 <- ggplot(dat, aes(gene1)) +
  geom_density(fill = "#BED7DC") +
  theme_void()

p3 <- ggplot(dat, aes(gene2)) +
  geom_density(fill = "#E5DDC5") +
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
# 保存
ggsave("01_cor_scatter_with_side_density.png", width = 8, height = 8)