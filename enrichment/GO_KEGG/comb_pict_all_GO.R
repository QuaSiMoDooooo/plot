library("clusterProfiler")
library("org.Hs.eg.db")
library("enrichplot")
library("ggplot2")
library("GOplot")
library("stringr")

results <-read.table('/home/wtian/tmp/hjx/GO_KEGG/example.input',sep = '\t',header = T)
results <-as.data.frame(results)
results$spec_gene_num <- str_split(results$GeneRatio,"\\/",simplify = T)[,1]
results$ind_gene_num <- str_split(results$GeneRatio,"\\/",simplify = T)[,2]
results$GeneRatio <- as.numeric(results$spec_gene_num) / as.numeric(results$ind_gene_num)

# results$fold_enrichment <- as.numeric(results$GeneRatio) / as.numeric(results$BgRatio)

subres1 <- results[results$ONTOLOGY=="BP",][c(1:5),]
subres2 <- results[results$ONTOLOGY=="CC",][c(1:5),]
subres3 <- results[results$ONTOLOGY=="MF",][c(1:5),]

subres <- rbind(subres1,subres2,subres3)


p <- ggplot(subres,aes(y=GeneRatio,x=Description,fill=pvalue)) + 
      geom_bar(stat="identity",position = "dodge") +
      scale_fill_gradientn(colors = c("red","blue"), name = "-log10(pvalue)")+
      facet_grid(ONTOLOGY~.,scales = "free",space = "free") + 
      coord_flip() + 
      theme_bw() +
      labs(title = paste("Top 5 Enrichment Results"),
         x = "Go Terms") +
      theme(plot.title = element_text(hjust = 0.5,size = 18),
            strip.text.y = element_text(size = 14),
            legend.position="right",
            legend.title = element_text(size=14),
            legend.text = element_text(size=14),
            axis.text.x = element_text(size=14),
            axis.text.y = element_text(size=14),
            axis.title.x = element_text(size=18),
            axis.title.y = element_text(size=18))
p
output_file <- paste('/home/wtian/tmp/hjx/GO_KEGG/example.','All.GO.Routput.png', sep = "")
ggsave(output_file, plot = p, dpi = 300, width = 10, height = 6)
