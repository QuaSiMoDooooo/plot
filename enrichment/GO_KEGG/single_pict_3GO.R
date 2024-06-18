library("clusterProfiler")
library("org.Hs.eg.db")
library("enrichplot")
library("ggplot2")
library("GOplot")

results <-read.table('/home/wtian/tmp/hjx/GO_KEGG/example.input',sep = '\t',header = T)
results <-as.data.frame(results)
head(results)

# Get unique categories
categories <- unique(results$ONTOLOGY)

# Plotting for each category
for (category in categories) {
  subset <- results %>% filter(ONTOLOGY == category) %>% arrange(pvalue) %>% head(5)
  
  # Normalize the pvalues for color mapping
  subset$log_pvalue <- -log10(subset$pvalue)
  
  # Plotting with ggplot2
  p <- ggplot(subset, aes(x = Count, y = reorder(ID, Count), fill = log_pvalue)) +
    geom_bar(stat = "identity") +
    scale_fill_gradientn(colors = c("blue", "red"), name = "-log10(pvalue)") +
    labs(title = paste("Top 5 Enrichment Results for", category),
         x = "Count",
         y = "Enrichment Result ID") +
    theme_minimal() +
    theme(axis.text.y = element_text(size = 10))
  
#   Save the plot
  output_file <- paste('/home/wtian/tmp/hjx/GO_KEGG/example.', category, '.GO.Routput.png', sep = "")
  ggsave(output_file, plot = p, dpi = 300, width = 10, height = 6)
}