library(data.table)
tissue_parser <- function(tpms, attributes, pheno, tissue){
  # Grab sample ID and Tissue Type from Attributes
  small_attr <- attributes %>%  
    select.(SAMPID, SMTS)
  
  # Grab sample ID list from tpm
  ID_tpms <- colnames(tpms)
  ID_tpms<-data.table(SAMPID = ID_tpms)
  
  # Create subset of IDs where tissue = tissue
  tissue_ID <- small_attr %>% 
    filter.(SMTS == tissue) %>% 
    merge(ID_tpms,by = "SAMPID", all = FALSE)
  
  # Select the tissue_IDs in the tpm and transpose them
  tissue_tpms <- tpms %>% 
    select.(c(tissue_ID$SAMPID)) %>% 
    data.table::transpose()
  
  # Give the tissue_tpms column names as gene descriptions
  colnames(tissue_tpms) <- c(tpms$Description)
  
  # Create new column containing the string of everything before the second hyphen
  id_extracter <- function(s) {str_extract(s, "([:alnum:]+-[:alnum:]+)")}
  
  pheno_ID <- data.frame(SUBJID = unname(sapply(tissue_ID$SAMPID, id_extracter)))
  
  # 
  tissue_pheno <- pheno %>% 
    merge(y=pheno_ID, by = "SUBJID", all.y = TRUE)
  
  return(cbind(tissue_ID ,tissue_pheno[,-1], tissue_tpms))
}