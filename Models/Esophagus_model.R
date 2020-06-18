# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Esophagus_tissue <- tissue_parser(tpms, attributes, pheno, "Esophagus")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Esophagus_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Esophagus_tissue <- pc_subsetter(Esophagus_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Esophagus_split <- initial_split(Esophagus_tissue, prop = 9/10, strata = AGE)
#Esophagus_training <- training(Esophagus_split)
#Esophagus_test <- testing(Esophagus_split)

# Create our Esophagus_model
Esophagus_model<-age_tissue_guesser(Esophagus_tissue,
                   max_sample = 350,
                   v=6,
                   metric = "accuracy")

# See how it did
Esophagus_preds <- predict_age(Esophagus_model, Esophagus_tissue)
