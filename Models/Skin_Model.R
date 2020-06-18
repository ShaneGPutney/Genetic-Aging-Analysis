# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Skin_tissue <- tissue_parser(tpms, attributes, pheno, "Skin")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Skin_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Skin_tissue <- pc_subsetter(Skin_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Skin_split <- initial_split(Skin_tissue, prop = 9/10, strata = AGE)
#Skin_training <- training(Skin_split)
#Skin_test <- testing(Skin_split)

# Create our Skin_model
Skin_model<-age_tissue_guesser(Skin_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Skin_preds <- predict_age(Skin_model, Skin_tissue)
