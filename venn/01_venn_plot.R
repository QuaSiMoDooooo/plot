suppressPackageStartupMessages(library(tidyverse))

setwd("/home/wtian/project/HZAU_cohort_meth/01_methylation_annot/01_map_probe_id/01_methylation_cohort_test/02_map_id")


# data1 = seq(1, 898707)
# data2 = c(seq(1, 894050), rep(0, 29732277-894050))
# length(data1)
# length(data2)
# table(data2 %in% data1)

29732277-894050
898707-894050

library(eulerr)
dat = c(500,1,99)
dat
names(dat) = c("First", "Second", "First&Second")
dat
plot(euler(dat))

plot(euler(dat),
     fills = list(fill=c("#EBB08C","#90A6B7","#867E7D"))
    #  quantities = c(28838227, 4657, 894050)
     )

# 保存为pdf
pdf("02_venn_raw_plot.pdf", width = 6, height = 6)
plot(euler(dat),
     fills = list(fill=c("#EBB08C","#90A6B7","#867E7D"))
     )
dev.off()

# 后续ai调整
