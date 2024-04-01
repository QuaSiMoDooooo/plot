library(tidyverse)

setwd("/home/wtian/play_ground/plot/histogram")

# 15X
dat1 <- read.table("/home/wtian/play_ground/plot/datasets/others/15X_chromosome_depth_coverage.csv",header = TRUE,sep = ",")
spec_order <- c(paste0("chr",seq(1,22)),"chrX","chrY","chrM")
dat1$chromosome <- factor(dat1$chromosome, levels=spec_order)

col1 <- c(215,97,25)
col1_rgb <- col1/255
red <- col1_rgb[1]
green <- col1_rgb[2]
blue <- col1_rgb[3]

p1 <- ggplot(dat1, aes(x = chromosome, y = coverage)) +
  geom_bar(stat = "identity", fill = rgb(red, green, blue),
           position = position_dodge(width = 0.3), width = 0.8) +
  # xlab("Chromosome") +
  ylab("Coverage") +
  ggtitle("15X Sample") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  expand_limits(y = c(0)) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    panel.border = element_rect(color = "black", fill = NA),
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 24, margin = margin(r = 10)),
    axis.text.x = element_text(size=12,angle = 45, vjust = 0.5, hjust = 1, margin = margin(t = -10)),
    axis.text.y = element_text(size=12),
    plot.margin = unit(c(1,1,2,1),"lines")
  )
p1
# 

# 30X
dat2 <- read.table("/home/wtian/play_ground/plot/datasets/others/30X_chromosome_depth_coverage.csv",header = TRUE,sep = ",")
spec_order <- c(paste0("chr",seq(1,22)),"chrX","chrY","chrM")
dat2$chromosome <- factor(dat2$chromosome, levels=spec_order)

col2 <- c(13,138,114)
col2_rgb <- col2/255
red <- col2_rgb[1]
green <- col2_rgb[2]
blue <- col2_rgb[3]

p2 <- ggplot(dat2, aes(x = chromosome, y = coverage)) +
  geom_bar(stat = "identity", fill = rgb(red, green, blue),
           position = position_dodge(width = 0.3), width = 0.8) +
  # xlab("Chromosome") +
  ylab("Coverage") +
  ggtitle("30X Sample") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1)) +
  expand_limits(y = c(0)) +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    panel.border = element_rect(color = "black", fill = NA),
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 24, margin = margin(r = 10)),
    axis.text.x = element_text(size=12,angle = 45, vjust = 0.5, hjust = 1, margin = margin(t = -10)),
    axis.text.y = element_text(size=12),
    plot.margin = unit(c(1,1,2,1),"lines")
  )
p2

# 拼图保存p2
ggsave("01_30X_chromosome_depth_coverage.png",width = 10,height = 5,units = "in")
