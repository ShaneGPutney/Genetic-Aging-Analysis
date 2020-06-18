library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(magrittr)

protein_coding_parser <- function(tissue){
# Grab gene data  
gene_data <- genes(EnsDb.Hsapiens.v86)

# Filter for protein coding
pc_id <- which(gene_data$gene_biotype=="protein_coding")

# Grab all unique symbols
coding_genes <- unique(gene_data$symbol[pc_id])

coding_genes<-dplyr::intersect(colnames(tissue), coding_genes)

return(coding_genes)
}
