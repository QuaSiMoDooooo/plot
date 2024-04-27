# https://mp.weixin.qq.com/s/K_gS-o6mZTRys_f-ONkvFg

rm(list=ls())
library(tidyverse)

set.seed(123)

mat1 <- matrix(sample(1:10, 100, replace = TRUE), nrow = 10)
mat2 <- matrix(sample(1:10, 100, replace = TRUE), nrow = 10)

prot <- data.frame(mat1,row.names = paste0("Prot",seq(1,10)))
meta <- data.frame(mat2,row.names = paste0("Met",seq(1,10)))
samplesid <- paste0("sample",seq(1,10))
colnames(prot) <- samplesid
colnames(meta) <- samplesid

cor_mat <- cor(t(prot), t(meta))
cor_mat_df <- data.frame(cor_mat)
cor_mat_df$prot <- rownames(cor_mat_df)
cor_mat_df <- cor_mat_df %>% select(prot,everything())
rownames(cor_mat_df) <- NULL
# 宽列表转为长列表
cor_mat_long <- pivot_longer(cor_mat_df,
                             cols = paste0("Met",seq(1,10)),
                             names_to = "met",
                             values_to = "cor")

library(circlize)

col_fun <- colorRamp2(c(-1, 0, 1), c("blue", "white", "red"),transparency = 0.5)

pdf("01_chord_cor.pdf",width = 9.5,height = 8)

circos.clear()
circos.par(start.degree = 90)

chordDiagram(cor_mat_long,
             big.gap = 30,
             col = col_fun,
             annotationTrack = "grid",
             preAllocateTracks = list(
               track.height = max(strwidth(unlist(dimnames(cor_mat_long))))))

highlight.sector(cor_mat_long$prot, track.index = 1, col = "#fc82b2",
                 text = "Protein", cex = 1, text.col = "white",
                 niceFacing = TRUE, padding = c(-.3, 0, -.2, 0))

highlight.sector(cor_mat_long$met, track.index = 1, col = "#a3c6e7",
                 text = "Metabolite", cex = 1, text.col = "white",
                 niceFacing = TRUE, padding = c(-.3, 0, -.2, 0))

circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  if (startsWith(sector.name, "Gen")) {
    circos.text(mean(xlim), ylim[1] + 1, sector.name,
                facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5), cex=0.8,
                col = "#fc82b2")
  } else {
    circos.text(mean(xlim), ylim[1] + 1, sector.name,
                facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5), cex=0.8,
                col = "#a3c6e7")}
}, bg.border = NA)

library(ComplexHeatmap)

lgd_links = Legend(at = c(-1, -0.5, 0, 0.5, 1), col_fun = col_fun,
                   title_position = "topleft", title = "cor")

draw(lgd_links, x = unit(1, "npc") - unit(110, "mm"), y = unit(190, "mm"),
     just = c("right", "top"))

dev.off()







