# https://mp.weixin.qq.com/s/iLFne1yAFv5Udj9dCNsUHw

library(trackViewer)

# 棒棒糖图
features <- GRanges("chr1", IRanges(c(1, 501, 1001), 
                                    width=c(120, 400, 405),
                                    names=paste0("block", 1:3)),
                    fill = c("#FF8833", "#51C6E6", "#DFA32D"),
                    height = c(0.02, 0.05, 0.08))

SNP <- c(10, 100, 105, 108, 400, 410, 420, 600, 700, 805, 840, 1400, 1402)
sample.gr <- GRanges("chr1", IRanges(SNP, width=1, names=paste0("snp", SNP)),
                     color = sample.int(6, length(SNP), replace=TRUE),
                     score = sample.int(5, length(SNP), replace = TRUE))

lolliplot(sample.gr, features)
# 保存
dev.copy(png, filename = "01_lolliplot.png", width = 800, height = 600)
dev.off()



# 蒲公英图
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(org.Hs.eg.db)

# methy <- import(system.file("extdata","methy.bed",pack="trackViewer"), "BED")
methy <- read.table("/home/wtian/R/x86_64-pc-linux-gnu-library/4.3/trackViewer/extdata/methy.bed",header = FALSE,sep = "\t",
                    col.names = c("chr","start","end","name","score","strand","start1","end1"))
methy_gr <- GRanges(seqnames = methy$chr,
                    ranges = IRanges(methy$start, width = 1),
                    strand = methy$strand,
                    score = methy$score)

gr <- GRanges("chr22", IRanges(50968014, 50970514, names="TYMP"))
trs <- geneModelFromTxdb(TxDb.Hsapiens.UCSC.hg19.knownGene,
                         org.Hs.eg.db,
                         gr=gr)
features <- c(range(trs[[1]]$dat), range(trs[[5]]$dat))
names(features) <- c(trs[[1]]$name, trs[[5]]$name)
features$fill <- c("lightblue", "mistyrose")
features$height <- c(.02, .04)
dandelion.plot(methy_gr, features, ranges=gr, type="pin")
dev.copy(png, filename = "01_dandelion.png", width = 800, height = 600)
dev.off()
