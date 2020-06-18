# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Thyroid_tissue <- tissue_parser(tpms, attributes, pheno, "Thyroid")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Thyroid_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Thyroid_tissue <- pc_subsetter(Thyroid_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Thyroid_split <- initial_split(Thyroid_tissue, prop = 9/10, strata = AGE)
#Thyroid_training <- training(Thyroid_split)
#Thyroid_test <- testing(Thyroid_split)

# Create our Thyroid_model
Thyroid_model<-age_tissue_guesser(Thyroid_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Thyroid_preds <- predict_age(Thyroid_model, Thyroid_tissue)
