# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Adipose_Tissue_tissue <- tissue_parser(tpms, attributes, pheno, "Adipose Tissue")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Adipose_Tissue_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Adipose_Tissue_tissue <- pc_subsetter(Adipose_Tissue_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Adipose_Tissue_split <- initial_split(Adipose_Tissue_tissue, prop = 9/10, strata = AGE)
#Adipose_Tissue_training <- training(Adipose_Tissue_split)
#Adipose_Tissue_test <- testing(Adipose_Tissue_split)

# Create our Adipose_Tissue_model
Adipose_Tissue_model<-age_tissue_guesser(Adipose_Tissue_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Adipose_Tissue_preds <- predict_age(Adipose_Tissue_model, Adipose_Tissue_tissue)

