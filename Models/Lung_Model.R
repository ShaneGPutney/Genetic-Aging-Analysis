# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Lung_tissue <- tissue_parser(tpms, attributes, pheno, "Lung")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Lung_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Lung_tissue <- pc_subsetter(Lung_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Lung_split <- initial_split(Lung_tissue, prop = 9/10, strata = AGE)
#Lung_training <- training(Lung_split)
#Lung_test <- testing(Lung_split)

# Create our Lung_model
Lung_model<-age_tissue_guesser(Lung_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Lung_preds <- predict_age(Lung_model, Lung_tissue)
